Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96FBBC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 24 Feb 2022 04:28:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiBXE2u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Feb 2022 23:28:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiBXE2r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Feb 2022 23:28:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C2919D77F
        for <mm-commits@vger.kernel.org>; Wed, 23 Feb 2022 20:28:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2578F6176A
        for <mm-commits@vger.kernel.org>; Thu, 24 Feb 2022 04:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792CDC340E9;
        Thu, 24 Feb 2022 04:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645676897;
        bh=H3yKNCvrJ5sFmoGnkZDFNvypsN1K7kNA7gLVx2kWR+g=;
        h=Date:To:From:Subject:From;
        b=Vzaj8GTY+bA0YHg8rzBD7Nc9IqeBjK9AkmHrGRdis5FDksmJHYU+M3ntllOGFsWqI
         XgMRXWuelYd1tktW9Tgmb8SklsGnzx/TRoaXGtZ3W4eY6BGeZJlGH9wSFIKK5bUr8Z
         YX9/3LY3LrfpvJkXhkV2oanW5PFrkOZSpBksDlN0=
Date:   Wed, 23 Feb 2022 20:28:16 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        sumit.semwal@linaro.org, sashal@kernel.org, pcc@google.com,
        mhocko@suse.com, legion@kernel.org,
        kirill.shutemov@linux.intel.com, keescook@chromium.org,
        hannes@cmpxchg.org, gorcunov@gmail.com, ebiederm@xmission.com,
        david@redhat.com, dave@stgolabs.net, dave.hansen@intel.com,
        chris.hyser@oracle.com, ccross@google.com, caoxiaofeng@yulong.com,
        brauner@kernel.org, surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-fix-use-after-free-when-anon-vma-name-is-used-after-vma-is-freed.patch removed from -mm tree
Message-Id: <20220224042817.792CDC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix use-after-free when anon vma name is used after vma is freed
has been removed from the -mm tree.  Its filename was
     mm-fix-use-after-free-when-anon-vma-name-is-used-after-vma-is-freed.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: fix use-after-free when anon vma name is used after vma is freed

When adjacent vmas are being merged it can result in the vma that was
originally passed to madvise_update_vma being destroyed.  In the current
implementation, the name parameter passed to madvise_update_vma points
directly to vma->anon_name->name and it is used after the call to
vma_merge.  In the cases when vma_merge merges the original vma and
destroys it, this will result in use-after-free bug as shown below:

madvise_vma_behavior << passes vma->anon_name->name as name param
  madvise_update_vma(name)
    vma_merge
      __vma_adjust
        vm_area_free <-- frees the vma
    replace_vma_anon_name(name) <-- UAF

Fix this by raising the name refcount and stabilizing it. Introduce
vma_anon_name_{get/put} API for this purpose.

Link: https://lkml.kernel.org/r/20220211013032.623763-1-surenb@google.com
Fixes: 9a10064f5625 ("mm: add a field to store names for private anonymous memory")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: syzbot+aa7b3d4b35f9dc46a366@syzkaller.appspotmail.com
Cc: Colin Cross <ccross@google.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Alexey Gladkov <legion@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Chris Hyser <chris.hyser@oracle.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Xiaofeng Cao <caoxiaofeng@yulong.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   13 ++++++
 mm/madvise.c              |   67 ++++++++++++++++++++++++++----------
 2 files changed, 63 insertions(+), 17 deletions(-)

--- a/include/linux/mm_inline.h~mm-fix-use-after-free-when-anon-vma-name-is-used-after-vma-is-freed
+++ a/include/linux/mm_inline.h
@@ -145,6 +145,11 @@ static __always_inline void del_page_fro
  */
 extern const char *vma_anon_name(struct vm_area_struct *vma);
 
+/* mmap_lock should be read-locked */
+extern struct anon_vma_name *vma_anon_name_get(struct vm_area_struct *vma);
+
+extern void vma_anon_name_put(struct anon_vma_name *anon_name);
+
 /*
  * mmap_lock should be read-locked for orig_vma->vm_mm.
  * mmap_lock should be write-locked for new_vma->vm_mm or new_vma should be
@@ -176,6 +181,14 @@ static inline const char *vma_anon_name(
 {
 	return NULL;
 }
+
+static inline
+struct anon_vma_name *vma_anon_name_get(struct vm_area_struct *vma)
+{
+	return NULL;
+}
+
+static inline void vma_anon_name_put(struct anon_vma_name *anon_name) {}
 static inline void dup_vma_anon_name(struct vm_area_struct *orig_vma,
 			      struct vm_area_struct *new_vma) {}
 static inline void free_vma_anon_name(struct vm_area_struct *vma) {}
--- a/mm/madvise.c~mm-fix-use-after-free-when-anon-vma-name-is-used-after-vma-is-freed
+++ a/mm/madvise.c
@@ -70,6 +70,9 @@ static struct anon_vma_name *anon_vma_na
 	struct anon_vma_name *anon_name;
 	size_t count;
 
+	if (!name)
+		return NULL;
+
 	/* Add 1 for NUL terminator at the end of the anon_name->name */
 	count = strlen(name) + 1;
 	anon_name = kmalloc(struct_size(anon_name, name, count), GFP_KERNEL);
@@ -103,6 +106,23 @@ const char *vma_anon_name(struct vm_area
 	return vma->anon_name->name;
 }
 
+struct anon_vma_name *vma_anon_name_get(struct vm_area_struct *vma)
+{
+	if (!has_vma_anon_name(vma))
+		return NULL;
+
+	mmap_assert_locked(vma->vm_mm);
+
+	kref_get(&vma->anon_name->kref);
+	return vma->anon_name;
+}
+
+void vma_anon_name_put(struct anon_vma_name *anon_name)
+{
+	if (anon_name)
+		kref_put(&anon_name->kref, vma_anon_name_free);
+}
+
 void dup_vma_anon_name(struct vm_area_struct *orig_vma,
 		       struct vm_area_struct *new_vma)
 {
@@ -126,33 +146,34 @@ void free_vma_anon_name(struct vm_area_s
 }
 
 /* mmap_lock should be write-locked */
-static int replace_vma_anon_name(struct vm_area_struct *vma, const char *name)
+static int replace_vma_anon_name(struct vm_area_struct *vma,
+				 struct anon_vma_name *anon_name)
 {
-	const char *anon_name;
+	const char *orig_name;
 
-	if (!name) {
+	if (!anon_name) {
 		free_vma_anon_name(vma);
 		return 0;
 	}
 
-	anon_name = vma_anon_name(vma);
-	if (anon_name) {
+	orig_name = vma_anon_name(vma);
+	if (orig_name) {
 		/* Same name, nothing to do here */
-		if (!strcmp(name, anon_name))
+		if (!strcmp(anon_name->name, orig_name))
 			return 0;
 
 		free_vma_anon_name(vma);
 	}
-	vma->anon_name = anon_vma_name_alloc(name);
-	if (!vma->anon_name)
-		return -ENOMEM;
+	kref_get(&anon_name->kref);
+	vma->anon_name = anon_name;
 
 	return 0;
 }
 #else /* CONFIG_ANON_VMA_NAME */
-static int replace_vma_anon_name(struct vm_area_struct *vma, const char *name)
+static int replace_vma_anon_name(struct vm_area_struct *vma,
+				 struct anon_vma_name *anon_name)
 {
-	if (name)
+	if (anon_name)
 		return -EINVAL;
 
 	return 0;
@@ -161,12 +182,15 @@ static int replace_vma_anon_name(struct
 /*
  * Update the vm_flags on region of a vma, splitting it or merging it as
  * necessary.  Must be called with mmap_sem held for writing;
+ * Caller should ensure anon_name stability by raising its refcount even when
+ * anon_name belongs to a valid vma because this function might free that vma.
  */
 static int madvise_update_vma(struct vm_area_struct *vma,
 			      struct vm_area_struct **prev, unsigned long start,
 			      unsigned long end, unsigned long new_flags,
-			      const char *name)
+			      struct anon_vma_name *anon_name)
 {
+	const char *name = anon_name ? anon_name->name : NULL;
 	struct mm_struct *mm = vma->vm_mm;
 	int error;
 	pgoff_t pgoff;
@@ -209,7 +233,7 @@ success:
 	 */
 	vma->vm_flags = new_flags;
 	if (!vma->vm_file) {
-		error = replace_vma_anon_name(vma, name);
+		error = replace_vma_anon_name(vma, anon_name);
 		if (error)
 			return error;
 	}
@@ -976,6 +1000,7 @@ static int madvise_vma_behavior(struct v
 {
 	int error;
 	unsigned long new_flags = vma->vm_flags;
+	struct anon_vma_name *anon_name;
 
 	switch (behavior) {
 	case MADV_REMOVE:
@@ -1040,8 +1065,10 @@ static int madvise_vma_behavior(struct v
 		break;
 	}
 
+	anon_name = vma_anon_name_get(vma);
 	error = madvise_update_vma(vma, prev, start, end, new_flags,
-				   vma_anon_name(vma));
+				   anon_name);
+	vma_anon_name_put(anon_name);
 
 out:
 	/*
@@ -1225,7 +1252,7 @@ int madvise_walk_vmas(struct mm_struct *
 static int madvise_vma_anon_name(struct vm_area_struct *vma,
 				 struct vm_area_struct **prev,
 				 unsigned long start, unsigned long end,
-				 unsigned long name)
+				 unsigned long anon_name)
 {
 	int error;
 
@@ -1234,7 +1261,7 @@ static int madvise_vma_anon_name(struct
 		return -EBADF;
 
 	error = madvise_update_vma(vma, prev, start, end, vma->vm_flags,
-				   (const char *)name);
+				   (struct anon_vma_name *)anon_name);
 
 	/*
 	 * madvise() returns EAGAIN if kernel resources, such as
@@ -1248,8 +1275,10 @@ static int madvise_vma_anon_name(struct
 int madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
 			  unsigned long len_in, const char *name)
 {
+	struct anon_vma_name *anon_name;
 	unsigned long end;
 	unsigned long len;
+	int ret;
 
 	if (start & ~PAGE_MASK)
 		return -EINVAL;
@@ -1266,8 +1295,12 @@ int madvise_set_anon_name(struct mm_stru
 	if (end == start)
 		return 0;
 
-	return madvise_walk_vmas(mm, start, end, (unsigned long)name,
+	anon_name = anon_vma_name_alloc(name);
+	ret = madvise_walk_vmas(mm, start, end, (unsigned long)anon_name,
 				 madvise_vma_anon_name);
+	vma_anon_name_put(anon_name);
+
+	return ret;
 }
 #endif /* CONFIG_ANON_VMA_NAME */
 /*
_

Patches currently in -mm which might be from surenb@google.com are

mm-fix-use-after-free-bug-when-mm-mmap-is-reused-after-being-freed.patch
mm-count-time-in-drain_all_pages-during-direct-reclaim-as-memory-pressure.patch
mm-refactor-vm_area_struct-anon_vma_name-usage-code.patch
mm-prevent-vm_area_struct-anon_name-refcount-saturation.patch

