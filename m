Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EB28C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38CAC61477
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238436AbhGABwq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:52:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238384AbhGABwp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:52:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBD4361469;
        Thu,  1 Jul 2021 01:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104215;
        bh=kXAnhwZPo/GQsexU8Xv3wlLS01pcQsizPtnTqNthHxk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ERWrvNB85R3RrAZnRKzYbgKnXr1Ql92N/00QiUJMqJG1G3nRELtdRx4NnP5WO6H66
         2SqTn32FL4EmYIt7JX4CcoRfqJU93KzkdCBkxj5Ora++1d7YdAeAjiGQXalrfHX+o/
         /Z2lG8w01sWHo+KSDD2OMOnw1NL1/xOBSuXUAVCk=
Date:   Wed, 30 Jun 2021 18:50:14 -0700
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
Subject:  [patch 057/192] mm: introduce
 page_offline_(begin|end|freeze|thaw) to synchronize setting PageOffline()
Message-ID: <20210701015014.kKUZ9uEOa%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm: introduce page_offline_(begin|end|freeze|thaw) to synchronize setting PageOffline()

A driver might set a page logically offline -- PageOffline() -- and turn
the page inaccessible in the hypervisor; after that, access to page
content can be fatal.  One example is virtio-mem; while unplugged memory
-- marked as PageOffline() can currently be read in the hypervisor, this
will no longer be the case in the future; for example, when having a
virtio-mem device backed by huge pages in the hypervisor.

Some special PFN walkers -- i.e., /proc/kcore -- read content of random
pages after checking PageOffline(); however, these PFN walkers can race
with drivers that set PageOffline().

Let's introduce page_offline_(begin|end|freeze|thaw) for synchronizing.

page_offline_freeze()/page_offline_thaw() allows for a subsystem to
synchronize with such drivers, achieving that a page cannot be set
PageOffline() while frozen.

page_offline_begin()/page_offline_end() is used by drivers that care about
such races when setting a page PageOffline().

For simplicity, use a rwsem for now; neither drivers nor users are
performance sensitive.

Link: https://lkml.kernel.org/r/20210526093041.8800-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Aili Yao <yaoaili@kingsoft.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   10 ++++++++
 mm/util.c                  |   40 +++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

--- a/include/linux/page-flags.h~mm-introduce-page_offline_beginendfreezethaw-to-synchronize-setting-pageoffline
+++ a/include/linux/page-flags.h
@@ -769,9 +769,19 @@ PAGE_TYPE_OPS(Buddy, buddy)
  * relies on this feature is aware that re-onlining the memory block will
  * require to re-set the pages PageOffline() and not giving them to the
  * buddy via online_page_callback_t.
+ *
+ * There are drivers that mark a page PageOffline() and expect there won't be
+ * any further access to page content. PFN walkers that read content of random
+ * pages should check PageOffline() and synchronize with such drivers using
+ * page_offline_freeze()/page_offline_thaw().
  */
 PAGE_TYPE_OPS(Offline, offline)
 
+extern void page_offline_freeze(void);
+extern void page_offline_thaw(void);
+extern void page_offline_begin(void);
+extern void page_offline_end(void);
+
 /*
  * Marks pages in use as page tables.
  */
--- a/mm/util.c~mm-introduce-page_offline_beginendfreezethaw-to-synchronize-setting-pageoffline
+++ a/mm/util.c
@@ -1010,3 +1010,43 @@ void mem_dump_obj(void *object)
 }
 EXPORT_SYMBOL_GPL(mem_dump_obj);
 #endif
+
+/*
+ * A driver might set a page logically offline -- PageOffline() -- and
+ * turn the page inaccessible in the hypervisor; after that, access to page
+ * content can be fatal.
+ *
+ * Some special PFN walkers -- i.e., /proc/kcore -- read content of random
+ * pages after checking PageOffline(); however, these PFN walkers can race
+ * with drivers that set PageOffline().
+ *
+ * page_offline_freeze()/page_offline_thaw() allows for a subsystem to
+ * synchronize with such drivers, achieving that a page cannot be set
+ * PageOffline() while frozen.
+ *
+ * page_offline_begin()/page_offline_end() is used by drivers that care about
+ * such races when setting a page PageOffline().
+ */
+static DECLARE_RWSEM(page_offline_rwsem);
+
+void page_offline_freeze(void)
+{
+	down_read(&page_offline_rwsem);
+}
+
+void page_offline_thaw(void)
+{
+	up_read(&page_offline_rwsem);
+}
+
+void page_offline_begin(void)
+{
+	down_write(&page_offline_rwsem);
+}
+EXPORT_SYMBOL(page_offline_begin);
+
+void page_offline_end(void)
+{
+	up_write(&page_offline_rwsem);
+}
+EXPORT_SYMBOL(page_offline_end);
_
