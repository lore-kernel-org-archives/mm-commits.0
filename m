Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AE630F803
	for <mm-commits@vger.kernel.org>; Wed, 17 Sep 2025 22:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758148486; cv=none; b=ilnaK+r4eHW9SzLznxWy+XKUQaanS8pwFKdKHNorN1P0LikxUF3XLFltuC4OGI7xhtDok9di/qE8eTEWT6VOJnRJmYWJ2cM+hecdGvYuQmRp8DEIGtO4hU6hcDgNrzVekR/Dy+tczOY2bo3ncsjxbzTW/Vv1ID9Oqifi+GhU4Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758148486; c=relaxed/simple;
	bh=t7OSa73FEigxvir2eQc3WYi1Rz1aVWNms+kPUdJfC/c=;
	h=Date:To:From:Subject:Message-Id; b=kqqKAhKnO0PLISG/jMwMWEBpxGw8Izh+wve4HhydcEpjcqWmWm8CdAPCIDJAWcQ3DncXB47Qkizn9Gn4Hxk1r4llyB9BlMdTy20JNb9Bow4LXDgbyWyF1P4sTb7TTYWWoF7NOvakCYUh2GLwedL797dcuv6UJw6aonJBnr9yYnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MQxOQTbj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MQxOQTbj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB92C4CEE7;
	Wed, 17 Sep 2025 22:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758148486;
	bh=t7OSa73FEigxvir2eQc3WYi1Rz1aVWNms+kPUdJfC/c=;
	h=Date:To:From:Subject:From;
	b=MQxOQTbj4/7nOgwZ4PMrYyTIcx4cr7h5Rn7QV7GG9kIn+dTsyFyUP09hhmKdzJwRF
	 bJRczw0jPvN2U8hN4oPAAAPajcs+oQtL78WnkwQvJG/zf+Y42tPszuKLxytaXFmrjb
	 vriBPbyvw8vumLPv0XNNoFTpwxA4ghThz8TjlH3U=
Date: Wed, 17 Sep 2025 15:34:45 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,jgg@nvidia.com,graf@amazon.com,chrisl@kernel.org,changyuanl@google.com,bhe@redhat.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-make-sure-page-being-restored-is-actually-from-kho.patch added to mm-new branch
Message-Id: <20250917223446.1FB92C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: make sure page being restored is actually from KHO
has been added to the -mm mm-new branch.  Its filename is
     kho-make-sure-page-being-restored-is-actually-from-kho.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-make-sure-page-being-restored-is-actually-from-kho.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Pratyush Yadav <pratyush@kernel.org>
Subject: kho: make sure page being restored is actually from KHO
Date: Wed, 17 Sep 2025 14:56:54 +0200

When restoring a page, no sanity checks are done to make sure the page
actually came from a kexec handover.  The caller is trusted to pass in the
right address.  If the caller has a bug and passes in a wrong address, an
in-use page might be "restored" and returned, causing all sorts of memory
corruption.

Harden the page restore logic by stashing in a magic number in
page->private along with the order.  If the magic number does not match,
the page won't be touched.  page->private is an unsigned long.  The union
kho_page_info splits it into two parts, with one holding the order and the
other holding the magic number.

Link: https://lkml.kernel.org/r/20250917125725.665-2-pratyush@kernel.org
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |   41 +++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

--- a/kernel/kexec_handover.c~kho-make-sure-page-being-restored-is-actually-from-kho
+++ a/kernel/kexec_handover.c
@@ -33,6 +33,22 @@
 #define PROP_PRESERVED_MEMORY_MAP "preserved-memory-map"
 #define PROP_SUB_FDT "fdt"
 
+#define KHO_PAGE_MAGIC 0x4b484f50U /* ASCII for 'KHOP' */
+
+/*
+ * KHO uses page->private, which is an unsigned long, to store page metadata.
+ * Use it to store both the magic and the order.
+ */
+union kho_page_info {
+	unsigned long page_private;
+	struct {
+		unsigned int order;
+		unsigned int magic;
+	};
+};
+
+static_assert(sizeof(union kho_page_info) == sizeof(((struct page *)0)->private));
+
 static bool kho_enable __ro_after_init;
 
 bool kho_is_enabled(void)
@@ -213,16 +229,24 @@ static int __kho_preserve_order(struct k
 static struct page *kho_restore_page(phys_addr_t phys)
 {
 	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
-	unsigned int nr_pages, order;
+	union kho_page_info info;
+	unsigned int nr_pages;
 
 	if (!page)
 		return NULL;
 
-	order = page->private;
-	if (order > MAX_PAGE_ORDER)
+	info.page_private = page->private;
+	/*
+	 * deserialize_bitmap() only sets the magic on the head page. This magic
+	 * check also implicitly makes sure phys is order-aligned since for
+	 * non-order-aligned phys addresses, magic will never be set.
+	 */
+	if (WARN_ON_ONCE(info.magic != KHO_PAGE_MAGIC || info.order > MAX_PAGE_ORDER))
 		return NULL;
-	nr_pages = (1 << order);
+	nr_pages = (1 << info.order);
 
+	/* Clear private to make sure later restores on this page error out. */
+	page->private = 0;
 	/* Head page gets refcount of 1. */
 	set_page_count(page, 1);
 
@@ -230,8 +254,8 @@ static struct page *kho_restore_page(phy
 	for (unsigned int i = 1; i < nr_pages; i++)
 		set_page_count(page + i, 0);
 
-	if (order > 0)
-		prep_compound_page(page, order);
+	if (info.order > 0)
+		prep_compound_page(page, info.order);
 
 	adjust_managed_page_count(page, nr_pages);
 	return page;
@@ -368,10 +392,13 @@ static void __init deserialize_bitmap(un
 		phys_addr_t phys =
 			elm->phys_start + (bit << (order + PAGE_SHIFT));
 		struct page *page = phys_to_page(phys);
+		union kho_page_info info;
 
 		memblock_reserve(phys, sz);
 		memblock_reserved_mark_noinit(phys, sz);
-		page->private = order;
+		info.magic = KHO_PAGE_MAGIC;
+		info.order = order;
+		page->private = info.page_private;
 	}
 }
 
_

Patches currently in -mm which might be from pratyush@kernel.org are

kho-move-sanity-checks-to-kho_restore_page.patch
kho-make-sure-page-being-restored-is-actually-from-kho.patch

