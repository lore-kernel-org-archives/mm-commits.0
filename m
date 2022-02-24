Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F032C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 24 Feb 2022 04:31:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiBXEbg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Feb 2022 23:31:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiBXEbg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Feb 2022 23:31:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792E7253BFB
        for <mm-commits@vger.kernel.org>; Wed, 23 Feb 2022 20:31:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11D3961772
        for <mm-commits@vger.kernel.org>; Thu, 24 Feb 2022 04:31:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56294C340E9;
        Thu, 24 Feb 2022 04:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645677065;
        bh=p9t26Kuba8Q6G4rfoGNuoTg6qdCwq3v/E12xg92Pi20=;
        h=Date:To:From:Subject:From;
        b=faLFyDKLqooR1mIU5wP0+Y3KNvZdkhAPB2mFBYbTMQfwuIUhDybqx1Tgw5rTWKYyj
         BvP3L60Nyd9pNHvGoymZhpT1rzxHjWNkpMxtKc/9aoi0ai0GMBvS8lRYOre4+Yetrr
         1j3rN92lKtSCqGZHwlev3lw9T3UDCDc2z+4FspAY=
Date:   Wed, 23 Feb 2022 20:31:04 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        sumit.semwal@linaro.org, sashal@kernel.org, pcc@google.com,
        mhocko@suse.com, legion@kernel.org,
        kirill.shutemov@linux.intel.com, keescook@chromium.org,
        hannes@cmpxchg.org, gorcunov@gmail.com, ebiederm@xmission.com,
        david@redhat.com, dave@stgolabs.net, dave.hansen@intel.com,
        chris.hyser@oracle.com, ccross@google.com, caoxiaofeng@yulong.com,
        brauner@kernel.org, surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-refactor-vm_area_struct-anon_vma_name-usage-code.patch added to -mm tree
Message-Id: <20220224043105.56294C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: refactor vm_area_struct::anon_vma_name usage code
has been added to the -mm tree.  Its filename is
     mm-refactor-vm_area_struct-anon_vma_name-usage-code.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-refactor-vm_area_struct-anon_vma_name-usage-code.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-refactor-vm_area_struct-anon_vma_name-usage-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: refactor vm_area_struct::anon_vma_name usage code

Avoid mixing strings and their anon_vma_name referenced pointers by using
struct anon_vma_name whenever possible.  This simplifies the code and
allows easier sharing of anon_vma_name structures when they represent the
same name.

Link: https://lkml.kernel.org/r/20220223153613.835563-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Suggested-by: Michal Hocko <mhocko@suse.com>
Cc: Colin Cross <ccross@google.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
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

 fs/proc/task_mmu.c        |    6 +-
 fs/userfaultfd.c          |    6 +-
 include/linux/mm.h        |    7 +-
 include/linux/mm_inline.h |   87 ++++++++++++++++++++++++------------
 include/linux/mm_types.h  |    5 +-
 kernel/fork.c             |    4 -
 kernel/sys.c              |   19 ++++---
 mm/madvise.c              |   87 ++++++++++++------------------------
 mm/mempolicy.c            |    2 
 mm/mlock.c                |    2 
 mm/mmap.c                 |   12 ++--
 mm/mprotect.c             |    2 
 12 files changed, 125 insertions(+), 114 deletions(-)

--- a/fs/proc/task_mmu.c~mm-refactor-vm_area_struct-anon_vma_name-usage-code
+++ a/fs/proc/task_mmu.c
@@ -309,7 +309,7 @@ show_map_vma(struct seq_file *m, struct
 
 	name = arch_vma_name(vma);
 	if (!name) {
-		const char *anon_name;
+		struct anon_vma_name *anon_name;
 
 		if (!mm) {
 			name = "[vdso]";
@@ -327,10 +327,10 @@ show_map_vma(struct seq_file *m, struct
 			goto done;
 		}
 
-		anon_name = vma_anon_name(vma);
+		anon_name = anon_vma_name(vma);
 		if (anon_name) {
 			seq_pad(m, ' ');
-			seq_printf(m, "[anon:%s]", anon_name);
+			seq_printf(m, "[anon:%s]", anon_name->name);
 		}
 	}
 
--- a/fs/userfaultfd.c~mm-refactor-vm_area_struct-anon_vma_name-usage-code
+++ a/fs/userfaultfd.c
@@ -878,7 +878,7 @@ static int userfaultfd_release(struct in
 				 new_flags, vma->anon_vma,
 				 vma->vm_file, vma->vm_pgoff,
 				 vma_policy(vma),
-				 NULL_VM_UFFD_CTX, vma_anon_name(vma));
+				 NULL_VM_UFFD_CTX, anon_vma_name(vma));
 		if (prev)
 			vma = prev;
 		else
@@ -1438,7 +1438,7 @@ static int userfaultfd_register(struct u
 				 vma->anon_vma, vma->vm_file, vma->vm_pgoff,
 				 vma_policy(vma),
 				 ((struct vm_userfaultfd_ctx){ ctx }),
-				 vma_anon_name(vma));
+				 anon_vma_name(vma));
 		if (prev) {
 			vma = prev;
 			goto next;
@@ -1615,7 +1615,7 @@ static int userfaultfd_unregister(struct
 		prev = vma_merge(mm, prev, start, vma_end, new_flags,
 				 vma->anon_vma, vma->vm_file, vma->vm_pgoff,
 				 vma_policy(vma),
-				 NULL_VM_UFFD_CTX, vma_anon_name(vma));
+				 NULL_VM_UFFD_CTX, anon_vma_name(vma));
 		if (prev) {
 			vma = prev;
 			goto next;
--- a/include/linux/mm.h~mm-refactor-vm_area_struct-anon_vma_name-usage-code
+++ a/include/linux/mm.h
@@ -2626,7 +2626,7 @@ static inline int vma_adjust(struct vm_a
 extern struct vm_area_struct *vma_merge(struct mm_struct *,
 	struct vm_area_struct *prev, unsigned long addr, unsigned long end,
 	unsigned long vm_flags, struct anon_vma *, struct file *, pgoff_t,
-	struct mempolicy *, struct vm_userfaultfd_ctx, const char *);
+	struct mempolicy *, struct vm_userfaultfd_ctx, struct anon_vma_name *);
 extern struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *);
 extern int __split_vma(struct mm_struct *, struct vm_area_struct *,
 	unsigned long addr, int new_below);
@@ -3372,11 +3372,12 @@ static inline int seal_check_future_writ
 
 #ifdef CONFIG_ANON_VMA_NAME
 int madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
-			  unsigned long len_in, const char *name);
+			  unsigned long len_in,
+			  struct anon_vma_name *anon_name);
 #else
 static inline int
 madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
-		      unsigned long len_in, const char *name) {
+		      unsigned long len_in, struct anon_vma_name *anon_name) {
 	return 0;
 }
 #endif
--- a/include/linux/mm_inline.h~mm-refactor-vm_area_struct-anon_vma_name-usage-code
+++ a/include/linux/mm_inline.h
@@ -140,50 +140,81 @@ static __always_inline void del_page_fro
 
 #ifdef CONFIG_ANON_VMA_NAME
 /*
- * mmap_lock should be read-locked when calling vma_anon_name() and while using
- * the returned pointer.
+ * mmap_lock should be read-locked when calling anon_vma_name(). Caller should
+ * either keep holding the lock while using the returned pointer or it should
+ * raise anon_vma_name refcount before releasing the lock.
  */
-extern const char *vma_anon_name(struct vm_area_struct *vma);
+extern struct anon_vma_name *anon_vma_name(struct vm_area_struct *vma);
+extern struct anon_vma_name *anon_vma_name_alloc(const char *name);
+extern void anon_vma_name_free(struct kref *kref);
 
-/*
- * mmap_lock should be read-locked for orig_vma->vm_mm.
- * mmap_lock should be write-locked for new_vma->vm_mm or new_vma should be
- * isolated.
- */
-extern void dup_vma_anon_name(struct vm_area_struct *orig_vma,
-			      struct vm_area_struct *new_vma);
+/* mmap_lock should be read-locked */
+static inline void anon_vma_name_get(struct anon_vma_name *anon_name)
+{
+	if (anon_name)
+		kref_get(&anon_name->kref);
+}
 
-/*
- * mmap_lock should be write-locked or vma should have been isolated under
- * write-locked mmap_lock protection.
- */
-extern void free_vma_anon_name(struct vm_area_struct *vma);
+static inline void anon_vma_name_put(struct anon_vma_name *anon_name)
+{
+	if (anon_name)
+		kref_put(&anon_name->kref, anon_vma_name_free);
+}
 
-/* mmap_lock should be read-locked */
-static inline bool is_same_vma_anon_name(struct vm_area_struct *vma,
-					 const char *name)
+static inline void dup_anon_vma_name(struct vm_area_struct *orig_vma,
+				     struct vm_area_struct *new_vma)
+{
+	struct anon_vma_name *anon_name = anon_vma_name(orig_vma);
+
+	if (anon_name) {
+		anon_vma_name_get(anon_name);
+		new_vma->anon_name = anon_name;
+	}
+}
+
+static inline void free_anon_vma_name(struct vm_area_struct *vma)
 {
-	const char *vma_name = vma_anon_name(vma);
+	/*
+	 * Not using anon_vma_name because it generates a warning if vma->vm_mm
+	 * is not held, which might be the case here.
+	 */
+	if (!vma->vm_file)
+		anon_vma_name_put(vma->anon_name);
+}
 
-	/* either both NULL, or pointers to same string */
-	if (vma_name == name)
+static inline bool anon_vma_name_eq(struct anon_vma_name *anon_name1,
+				    struct anon_vma_name *anon_name2)
+{
+	if (anon_name1 == anon_name2)
 		return true;
 
-	return name && vma_name && !strcmp(name, vma_name);
+	return anon_name1 && anon_name2 &&
+		!strcmp(anon_name1->name, anon_name2->name);
 }
+
 #else /* CONFIG_ANON_VMA_NAME */
-static inline const char *vma_anon_name(struct vm_area_struct *vma)
+static inline struct anon_vma_name *anon_vma_name(struct vm_area_struct *vma)
+{
+	return NULL;
+}
+
+static inline struct anon_vma_name *anon_vma_name_alloc(const char *name)
 {
 	return NULL;
 }
-static inline void dup_vma_anon_name(struct vm_area_struct *orig_vma,
-			      struct vm_area_struct *new_vma) {}
-static inline void free_vma_anon_name(struct vm_area_struct *vma) {}
-static inline bool is_same_vma_anon_name(struct vm_area_struct *vma,
-					 const char *name)
+
+static inline void anon_vma_name_get(struct anon_vma_name *anon_name) {}
+static inline void anon_vma_name_put(struct anon_vma_name *anon_name) {}
+static inline void dup_anon_vma_name(struct vm_area_struct *orig_vma,
+				     struct vm_area_struct *new_vma) {}
+static inline void free_anon_vma_name(struct vm_area_struct *vma) {}
+
+static inline bool anon_vma_name_eq(struct anon_vma_name *anon_name1,
+				    struct anon_vma_name *anon_name2)
 {
 	return true;
 }
+
 #endif  /* CONFIG_ANON_VMA_NAME */
 
 static inline void init_tlb_flush_pending(struct mm_struct *mm)
--- a/include/linux/mm_types.h~mm-refactor-vm_area_struct-anon_vma_name-usage-code
+++ a/include/linux/mm_types.h
@@ -416,7 +416,10 @@ struct vm_area_struct {
 			struct rb_node rb;
 			unsigned long rb_subtree_last;
 		} shared;
-		/* Serialized by mmap_sem. */
+		/*
+		 * Serialized by mmap_sem. Never use directly because it is
+		 * valid only when vm_file is NULL. Use anon_vma_name instead.
+		 */
 		struct anon_vma_name *anon_name;
 	};
 
--- a/kernel/fork.c~mm-refactor-vm_area_struct-anon_vma_name-usage-code
+++ a/kernel/fork.c
@@ -366,14 +366,14 @@ struct vm_area_struct *vm_area_dup(struc
 		*new = data_race(*orig);
 		INIT_LIST_HEAD(&new->anon_vma_chain);
 		new->vm_next = new->vm_prev = NULL;
-		dup_vma_anon_name(orig, new);
+		dup_anon_vma_name(orig, new);
 	}
 	return new;
 }
 
 void vm_area_free(struct vm_area_struct *vma)
 {
-	free_vma_anon_name(vma);
+	free_anon_vma_name(vma);
 	kmem_cache_free(vm_area_cachep, vma);
 }
 
--- a/kernel/sys.c~mm-refactor-vm_area_struct-anon_vma_name-usage-code
+++ a/kernel/sys.c
@@ -7,6 +7,7 @@
 
 #include <linux/export.h>
 #include <linux/mm.h>
+#include <linux/mm_inline.h>
 #include <linux/utsname.h>
 #include <linux/mman.h>
 #include <linux/reboot.h>
@@ -2286,15 +2287,16 @@ static int prctl_set_vma(unsigned long o
 {
 	struct mm_struct *mm = current->mm;
 	const char __user *uname;
-	char *name, *pch;
+	struct anon_vma_name *anon_name = NULL;
 	int error;
 
 	switch (opt) {
 	case PR_SET_VMA_ANON_NAME:
 		uname = (const char __user *)arg;
 		if (uname) {
-			name = strndup_user(uname, ANON_VMA_NAME_MAX_LEN);
+			char *name, *pch;
 
+			name = strndup_user(uname, ANON_VMA_NAME_MAX_LEN);
 			if (IS_ERR(name))
 				return PTR_ERR(name);
 
@@ -2304,15 +2306,18 @@ static int prctl_set_vma(unsigned long o
 					return -EINVAL;
 				}
 			}
-		} else {
-			/* Reset the name */
-			name = NULL;
+			/* anon_vma has its own copy */
+			anon_name = anon_vma_name_alloc(name);
+			kfree(name);
+			if (!anon_name)
+				return -ENOMEM;
+
 		}
 
 		mmap_write_lock(mm);
-		error = madvise_set_anon_name(mm, addr, size, name);
+		error = madvise_set_anon_name(mm, addr, size, anon_name);
 		mmap_write_unlock(mm);
-		kfree(name);
+		anon_vma_name_put(anon_name);
 		break;
 	default:
 		error = -EINVAL;
--- a/mm/madvise.c~mm-refactor-vm_area_struct-anon_vma_name-usage-code
+++ a/mm/madvise.c
@@ -65,7 +65,7 @@ static int madvise_need_mmap_write(int b
 }
 
 #ifdef CONFIG_ANON_VMA_NAME
-static struct anon_vma_name *anon_vma_name_alloc(const char *name)
+struct anon_vma_name *anon_vma_name_alloc(const char *name)
 {
 	struct anon_vma_name *anon_name;
 	size_t count;
@@ -81,78 +81,49 @@ static struct anon_vma_name *anon_vma_na
 	return anon_name;
 }
 
-static void vma_anon_name_free(struct kref *kref)
+void anon_vma_name_free(struct kref *kref)
 {
 	struct anon_vma_name *anon_name =
 			container_of(kref, struct anon_vma_name, kref);
 	kfree(anon_name);
 }
 
-static inline bool has_vma_anon_name(struct vm_area_struct *vma)
+struct anon_vma_name *anon_vma_name(struct vm_area_struct *vma)
 {
-	return !vma->vm_file && vma->anon_name;
-}
-
-const char *vma_anon_name(struct vm_area_struct *vma)
-{
-	if (!has_vma_anon_name(vma))
-		return NULL;
-
 	mmap_assert_locked(vma->vm_mm);
 
-	return vma->anon_name->name;
-}
-
-void dup_vma_anon_name(struct vm_area_struct *orig_vma,
-		       struct vm_area_struct *new_vma)
-{
-	if (!has_vma_anon_name(orig_vma))
-		return;
-
-	kref_get(&orig_vma->anon_name->kref);
-	new_vma->anon_name = orig_vma->anon_name;
-}
-
-void free_vma_anon_name(struct vm_area_struct *vma)
-{
-	struct anon_vma_name *anon_name;
-
-	if (!has_vma_anon_name(vma))
-		return;
+	if (vma->vm_file)
+		return NULL;
 
-	anon_name = vma->anon_name;
-	vma->anon_name = NULL;
-	kref_put(&anon_name->kref, vma_anon_name_free);
+	return vma->anon_name;
 }
 
 /* mmap_lock should be write-locked */
-static int replace_vma_anon_name(struct vm_area_struct *vma, const char *name)
+static int replace_anon_vma_name(struct vm_area_struct *vma,
+				 struct anon_vma_name *anon_name)
 {
-	const char *anon_name;
+	struct anon_vma_name *orig_name = anon_vma_name(vma);
 
-	if (!name) {
-		free_vma_anon_name(vma);
+	if (!anon_name) {
+		vma->anon_name = NULL;
+		anon_vma_name_put(orig_name);
 		return 0;
 	}
 
-	anon_name = vma_anon_name(vma);
-	if (anon_name) {
-		/* Same name, nothing to do here */
-		if (!strcmp(name, anon_name))
-			return 0;
+	if (anon_vma_name_eq(orig_name, anon_name))
+		return 0;
 
-		free_vma_anon_name(vma);
-	}
-	vma->anon_name = anon_vma_name_alloc(name);
-	if (!vma->anon_name)
-		return -ENOMEM;
+	anon_vma_name_get(anon_name);
+	vma->anon_name = anon_name;
+	anon_vma_name_put(orig_name);
 
 	return 0;
 }
 #else /* CONFIG_ANON_VMA_NAME */
-static int replace_vma_anon_name(struct vm_area_struct *vma, const char *name)
+static int replace_anon_vma_name(struct vm_area_struct *vma,
+				 struct anon_vma_name *anon_name)
 {
-	if (name)
+	if (anon_name)
 		return -EINVAL;
 
 	return 0;
@@ -165,13 +136,13 @@ static int replace_vma_anon_name(struct
 static int madvise_update_vma(struct vm_area_struct *vma,
 			      struct vm_area_struct **prev, unsigned long start,
 			      unsigned long end, unsigned long new_flags,
-			      const char *name)
+			      struct anon_vma_name *anon_name)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	int error;
 	pgoff_t pgoff;
 
-	if (new_flags == vma->vm_flags && is_same_vma_anon_name(vma, name)) {
+	if (new_flags == vma->vm_flags && anon_vma_name_eq(anon_vma_name(vma), anon_name)) {
 		*prev = vma;
 		return 0;
 	}
@@ -179,7 +150,7 @@ static int madvise_update_vma(struct vm_
 	pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
 	*prev = vma_merge(mm, *prev, start, end, new_flags, vma->anon_vma,
 			  vma->vm_file, pgoff, vma_policy(vma),
-			  vma->vm_userfaultfd_ctx, name);
+			  vma->vm_userfaultfd_ctx, anon_name);
 	if (*prev) {
 		vma = *prev;
 		goto success;
@@ -209,7 +180,7 @@ success:
 	 */
 	vma->vm_flags = new_flags;
 	if (!vma->vm_file) {
-		error = replace_vma_anon_name(vma, name);
+		error = replace_anon_vma_name(vma, anon_name);
 		if (error)
 			return error;
 	}
@@ -1041,7 +1012,7 @@ static int madvise_vma_behavior(struct v
 	}
 
 	error = madvise_update_vma(vma, prev, start, end, new_flags,
-				   vma_anon_name(vma));
+				   anon_vma_name(vma));
 
 out:
 	/*
@@ -1225,7 +1196,7 @@ int madvise_walk_vmas(struct mm_struct *
 static int madvise_vma_anon_name(struct vm_area_struct *vma,
 				 struct vm_area_struct **prev,
 				 unsigned long start, unsigned long end,
-				 unsigned long name)
+				 unsigned long anon_name)
 {
 	int error;
 
@@ -1234,7 +1205,7 @@ static int madvise_vma_anon_name(struct
 		return -EBADF;
 
 	error = madvise_update_vma(vma, prev, start, end, vma->vm_flags,
-				   (const char *)name);
+				   (struct anon_vma_name *)anon_name);
 
 	/*
 	 * madvise() returns EAGAIN if kernel resources, such as
@@ -1246,7 +1217,7 @@ static int madvise_vma_anon_name(struct
 }
 
 int madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
-			  unsigned long len_in, const char *name)
+			  unsigned long len_in, struct anon_vma_name *anon_name)
 {
 	unsigned long end;
 	unsigned long len;
@@ -1266,7 +1237,7 @@ int madvise_set_anon_name(struct mm_stru
 	if (end == start)
 		return 0;
 
-	return madvise_walk_vmas(mm, start, end, (unsigned long)name,
+	return madvise_walk_vmas(mm, start, end, (unsigned long)anon_name,
 				 madvise_vma_anon_name);
 }
 #endif /* CONFIG_ANON_VMA_NAME */
--- a/mm/mempolicy.c~mm-refactor-vm_area_struct-anon_vma_name-usage-code
+++ a/mm/mempolicy.c
@@ -814,7 +814,7 @@ static int mbind_range(struct mm_struct
 		prev = vma_merge(mm, prev, vmstart, vmend, vma->vm_flags,
 				 vma->anon_vma, vma->vm_file, pgoff,
 				 new_pol, vma->vm_userfaultfd_ctx,
-				 vma_anon_name(vma));
+				 anon_vma_name(vma));
 		if (prev) {
 			vma = prev;
 			next = vma->vm_next;
--- a/mm/mlock.c~mm-refactor-vm_area_struct-anon_vma_name-usage-code
+++ a/mm/mlock.c
@@ -512,7 +512,7 @@ static int mlock_fixup(struct vm_area_st
 	pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
 	*prev = vma_merge(mm, *prev, start, end, newflags, vma->anon_vma,
 			  vma->vm_file, pgoff, vma_policy(vma),
-			  vma->vm_userfaultfd_ctx, vma_anon_name(vma));
+			  vma->vm_userfaultfd_ctx, anon_vma_name(vma));
 	if (*prev) {
 		vma = *prev;
 		goto success;
--- a/mm/mmap.c~mm-refactor-vm_area_struct-anon_vma_name-usage-code
+++ a/mm/mmap.c
@@ -1031,7 +1031,7 @@ again:
 static inline int is_mergeable_vma(struct vm_area_struct *vma,
 				struct file *file, unsigned long vm_flags,
 				struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
-				const char *anon_name)
+				struct anon_vma_name *anon_name)
 {
 	/*
 	 * VM_SOFTDIRTY should not prevent from VMA merging, if we
@@ -1049,7 +1049,7 @@ static inline int is_mergeable_vma(struc
 		return 0;
 	if (!is_mergeable_vm_userfaultfd_ctx(vma, vm_userfaultfd_ctx))
 		return 0;
-	if (!is_same_vma_anon_name(vma, anon_name))
+	if (!anon_vma_name_eq(anon_vma_name(vma), anon_name))
 		return 0;
 	return 1;
 }
@@ -1084,7 +1084,7 @@ can_vma_merge_before(struct vm_area_stru
 		     struct anon_vma *anon_vma, struct file *file,
 		     pgoff_t vm_pgoff,
 		     struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
-		     const char *anon_name)
+		     struct anon_vma_name *anon_name)
 {
 	if (is_mergeable_vma(vma, file, vm_flags, vm_userfaultfd_ctx, anon_name) &&
 	    is_mergeable_anon_vma(anon_vma, vma->anon_vma, vma)) {
@@ -1106,7 +1106,7 @@ can_vma_merge_after(struct vm_area_struc
 		    struct anon_vma *anon_vma, struct file *file,
 		    pgoff_t vm_pgoff,
 		    struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
-		    const char *anon_name)
+		    struct anon_vma_name *anon_name)
 {
 	if (is_mergeable_vma(vma, file, vm_flags, vm_userfaultfd_ctx, anon_name) &&
 	    is_mergeable_anon_vma(anon_vma, vma->anon_vma, vma)) {
@@ -1167,7 +1167,7 @@ struct vm_area_struct *vma_merge(struct
 			struct anon_vma *anon_vma, struct file *file,
 			pgoff_t pgoff, struct mempolicy *policy,
 			struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
-			const char *anon_name)
+			struct anon_vma_name *anon_name)
 {
 	pgoff_t pglen = (end - addr) >> PAGE_SHIFT;
 	struct vm_area_struct *area, *next;
@@ -3256,7 +3256,7 @@ struct vm_area_struct *copy_vma(struct v
 		return NULL;	/* should never get here */
 	new_vma = vma_merge(mm, prev, addr, addr + len, vma->vm_flags,
 			    vma->anon_vma, vma->vm_file, pgoff, vma_policy(vma),
-			    vma->vm_userfaultfd_ctx, vma_anon_name(vma));
+			    vma->vm_userfaultfd_ctx, anon_vma_name(vma));
 	if (new_vma) {
 		/*
 		 * Source vma may have been merged into new_vma
--- a/mm/mprotect.c~mm-refactor-vm_area_struct-anon_vma_name-usage-code
+++ a/mm/mprotect.c
@@ -464,7 +464,7 @@ mprotect_fixup(struct vm_area_struct *vm
 	pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
 	*pprev = vma_merge(mm, *pprev, start, end, newflags,
 			   vma->anon_vma, vma->vm_file, pgoff, vma_policy(vma),
-			   vma->vm_userfaultfd_ctx, vma_anon_name(vma));
+			   vma->vm_userfaultfd_ctx, anon_vma_name(vma));
 	if (*pprev) {
 		vma = *pprev;
 		VM_WARN_ON((vma->vm_flags ^ newflags) & ~VM_SOFTDIRTY);
_

Patches currently in -mm which might be from surenb@google.com are

mm-fix-use-after-free-bug-when-mm-mmap-is-reused-after-being-freed.patch
mm-refactor-vm_area_struct-anon_vma_name-usage-code.patch
mm-prevent-vm_area_struct-anon_name-refcount-saturation.patch
mm-fix-use-after-free-when-anon-vma-name-is-used-after-vma-is-freed.patch
mm-count-time-in-drain_all_pages-during-direct-reclaim-as-memory-pressure.patch

