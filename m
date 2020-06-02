From: akpm@linux-foundation.org
Subject: [merged]
 include-linux-pagemaph-introduce-attach-detach_page_private.patch removed
 from -mm tree
Date: Tue, 02 Jun 2020 14:39:20 -0700
Message-ID: <20200602213920.vyv6sLMug%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgFBVjX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:39:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adilger@dilger.ca, agruenba@redhat.com, akpm@linux-foundation.org, anton@tuxera.com, bigeasy@linutronix.de, chao@kernel.org, clm@fb.com, darrick.wong@oracle.com, david@fromorbit.com, dsterba@suse.com, guoqing.jiang@cloud.ionos.com, guro@fb.com, hch@infradead.org, hubcap@omnibond.com, jaegeuk@kernel.org, josef@toxicpanda.com, kirill.shutemov@linux.intel.com, laoar.shao@gmail.com, martin@omnibond.com, mm-commits@vger.kernel.org, song@kernel.org, tglx@linutronix.de, viro@zeniv.linux.org.uk, william.kucharski@oracle.com, willy@infradead.org, yang.shi@linux.alibaba.com, yuchao0@huawei.com


The patch titled
     Subject: include/linux/pagemap.h: introduce attach/detach_page_private
has been removed from the -mm tree.  Its filename was
     include-linux-pagemaph-introduce-attach-detach_page_private.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: include/linux/pagemap.h: introduce attach/detach_page_private

Patch series "Introduce attach/detach_page_private to cleanup code".


This patch (of 10):

The logic in attach_page_buffers and __clear_page_buffers are quite
paired, but

1. they are located in different files.

2. attach_page_buffers is implemented in buffer_head.h, so it could be
   used by other files. But __clear_page_buffers is static function in
   buffer.c and other potential users can't call the function, md-bitmap
   even copied the function.

So, introduce the new attach/detach_page_private to replace them.  With
the new pair of function, we will remove the usage of attach_page_buffers
and __clear_page_buffers in next patches.  Thanks for suggestions about
the function name from Alexander Viro, Andreas Gr=C3=BCnbacher, Christoph
Hellwig and Matthew Wilcox.

Link: http://lkml.kernel.org/r/20200517214718.468-1-guoqing.jiang@cloud.ion=
os.com
Link: http://lkml.kernel.org/r/20200517214718.468-2-guoqing.jiang@cloud.ion=
os.com
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Song Liu <song@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Chao Yu <chao@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: Mike Marshall <hubcap@omnibond.com>
Cc: Martin Brandenburg <martin@omnibond.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Roman Gushchin <guro@fb.com>
Cc: Andreas Dilger <adilger@dilger.ca>
Cc: Chao Yu <yuchao0@huawei.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

--- a/include/linux/pagemap.h~include-linux-pagemaph-introduce-attach-detac=
h_page_private
+++ a/include/linux/pagemap.h
@@ -208,6 +208,43 @@ static inline int page_cache_add_specula
 	return __page_cache_add_speculative(page, count);
 }
=20
+/**
+ * attach_page_private - Attach private data to a page.
+ * @page: Page to attach data to.
+ * @data: Data to attach to page.
+ *
+ * Attaching private data to a page increments the page's reference count.
+ * The data must be detached before the page will be freed.
+ */
+static inline void attach_page_private(struct page *page, void *data)
+{
+	get_page(page);
+	set_page_private(page, (unsigned long)data);
+	SetPagePrivate(page);
+}
+
+/**
+ * detach_page_private - Detach private data from a page.
+ * @page: Page to detach data from.
+ *
+ * Removes the data that was previously attached to the page and decrements
+ * the refcount on the page.
+ *
+ * Return: Data that was attached to the page.
+ */
+static inline void *detach_page_private(struct page *page)
+{
+	void *data =3D (void *)page_private(page);
+
+	if (!PagePrivate(page))
+		return NULL;
+	ClearPagePrivate(page);
+	set_page_private(page, 0);
+	put_page(page);
+
+	return data;
+}
+
 #ifdef CONFIG_NUMA
 extern struct page *__page_cache_alloc(gfp_t gfp);
 #else
_

Patches currently in -mm which might be from guoqing.jiang@cloud.ionos.com =
are
