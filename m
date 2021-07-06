Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D469C07E9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1689661C97
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhGFTVI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:21:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231822AbhGFTVI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:21:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD03161C7A;
        Tue,  6 Jul 2021 19:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599109;
        bh=CkHnf3jpkW53ZiURDR8WXcCRy39jpDABAbDaNInhQG8=;
        h=Date:From:To:Subject:From;
        b=blELL93TCLI86yVZgE9AHwljjrkN8qASypd6IYvdH84duCqPct8HeH36ADDZI208f
         UQBx3R0VQRfZBntZObdUQbrZsm13BkLOpasp7HFNbJC24XWZoaPlIB0kSEHB/sIFBw
         /tN9tUWZltw015bOGYX+MLtDBESqTzZ0vDU4vSeY=
Date:   Tue, 06 Jul 2021 12:18:28 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, alex.shi@linux.alibaba.com, david@redhat.com,
        guro@fb.com, haiyangz@microsoft.com, jasowang@redhat.com,
        jbohac@suse.cz, kys@microsoft.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        mst@redhat.com, naoya.horiguchi@nec.com, osalvador@suse.de,
        rppt@linux.ibm.com, steven.price@arm.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, willy@infradead.org, yaoaili@kingsoft.com
Subject:  [merged]
 =?US-ASCII?Q?mm-introduce-page=5Foffline=5Fbeginendfreezethaw-to-synch?=
 =?US-ASCII?Q?ronize-setting-pageoffline.patch?= removed from -mm tree
Message-ID: <20210706191828.eTlH7y7jB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce page_offline_(begin|end|freeze|thaw) to synchronize setting PageOffline()
has been removed from the -mm tree.  Its filename was
     mm-introduce-page_offline_beginendfreezethaw-to-synchronize-setting-pageoffline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from david@redhat.com are

memory-hotplugrst-complete-admin-guide-overhaul.patch

