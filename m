Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2079C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D812C61468
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:50:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238437AbhGABwt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:52:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238384AbhGABwt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:52:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63C366147D;
        Thu,  1 Jul 2021 01:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104219;
        bh=QeVHaLFTs9qKXUbknKXET0E5BhAvOeThhD4tDDWPTUU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PHz5T58UpENwTsa9qdnQgp0T/SHro782+7pp6u8Be9Q+Bs+T0QFro43Y7ysikKJR1
         yqv/Nb5sPv/9MHQsKloJTYW3JcMttk5I0sUuLZsygtQfIxJdZ7Gj7NitQe+1LuWAzC
         DhbwzqjXi1eDAhtVRBbUgyKxgjAqMECGlPf6rnLs=
Date:   Wed, 30 Jun 2021 18:50:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        alex.shi@linux.alibaba.com, david@redhat.com, guro@fb.com,
        haiyangz@microsoft.com, jasowang@redhat.com, jbohac@suse.cz,
        kys@microsoft.com, linux-mm@kvack.org, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        mst@redhat.com, naoya.horiguchi@nec.com, osalvador@suse.de,
        rppt@linux.ibm.com, steven.price@arm.com, sthemmin@microsoft.com,
        torvalds@linux-foundation.org, wei.liu@kernel.org,
        willy@infradead.org, yaoaili@kingsoft.com
Subject:  [patch 058/192] virtio-mem: use page_offline_(start|end)
 when setting PageOffline()
Message-ID: <20210701015018.qXPlnv3P5%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: virtio-mem: use page_offline_(start|end) when setting PageOffline()

Let's properly use page_offline_(start|end) to synchronize setting
PageOffline(), so we won't have valid page access to unplugged memory
regions from /proc/kcore.

Existing balloon implementations usually allow reading inflated memory;
doing so might result in unnecessary overhead in the hypervisor, which is
currently the case with virtio-mem.

For future virtio-mem use cases, it will be different when using shmem,
huge pages, !anonymous private mappings, ...  as backing storage for a VM.
virtio-mem unplugged memory must no longer be accessed and access might
result in undefined behavior.  There will be a virtio spec extension to
document this change, including a new feature flag indicating the changed
behavior.  We really don't want to race against PFN walkers reading random
page content.

Link: https://lkml.kernel.org/r/20210526093041.8800-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Aili Yao <yaoaili@kingsoft.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_mem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/virtio/virtio_mem.c~virtio-mem-use-page_offline_startend-when-setting-pageoffline
+++ a/drivers/virtio/virtio_mem.c
@@ -1065,6 +1065,7 @@ static int virtio_mem_memory_notifier_cb
 static void virtio_mem_set_fake_offline(unsigned long pfn,
 					unsigned long nr_pages, bool onlined)
 {
+	page_offline_begin();
 	for (; nr_pages--; pfn++) {
 		struct page *page = pfn_to_page(pfn);
 
@@ -1075,6 +1076,7 @@ static void virtio_mem_set_fake_offline(
 			ClearPageReserved(page);
 		}
 	}
+	page_offline_end();
 }
 
 /*
_
