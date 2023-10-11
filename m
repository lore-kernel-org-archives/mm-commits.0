Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DB7ACDB472
	for <mm-commits@archiver.kernel.org>; Wed, 11 Oct 2023 17:55:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbjJKRz6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Oct 2023 13:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232952AbjJKRz4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Oct 2023 13:55:56 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F2FA4
        for <mm-commits@vger.kernel.org>; Wed, 11 Oct 2023 10:55:54 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E4FC433C7;
        Wed, 11 Oct 2023 17:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697046954;
        bh=Z/ESexuk20cSH27azAa9rq0yKWOT/junC/ZpvXkfwTM=;
        h=Date:To:From:Subject:From;
        b=yHdIspvPcFplX4UFaPUZ4RxxtsHBfWXxfVEe4zPn/Oy/dsOftWBhMV4EYgmvw0Vc/
         XJucTl3iIx/jSnyxX4X3FHIQ2v6PC6bXHMYcgrJ4U+8g4K7UZQQCeSHxaMVVe8dX/w
         pcJrTpksOsi93Z2CeZas8t7piTYdm9OGrqe9C1vc=
Date:   Wed, 11 Oct 2023 10:55:40 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        vbabka@suse.cz, Liam.Howlett@oracle.com, brauner@kernel.org,
        lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-vma_policy-and-anon_vma_name-decls-to-mm_typesh.patch added to mm-unstable branch
Message-Id: <20231011175548.36E4FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move vma_policy() and anon_vma_name() decls to mm_types.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-vma_policy-and-anon_vma_name-decls-to-mm_typesh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-vma_policy-and-anon_vma_name-decls-to-mm_typesh.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm: move vma_policy() and anon_vma_name() decls to mm_types.h
Date: Wed, 11 Oct 2023 18:04:27 +0100

Patch series "Abstract vma_merge() and split_vma()", v4.

The vma_merge() interface is very confusing and its implementation has led
to numerous bugs as a result of that confusion.

In addition there is duplication both in invocation of vma_merge(), but
also in the common mprotect()-style pattern of attempting a merge, then if
this fails, splitting the portion of a VMA about to have its attributes
changed.

This pattern has been copy/pasted around the kernel in each instance where
such an operation has been required, each very slightly modified from the
last to make it even harder to decipher what is going on.

Simplify the whole thing by dividing the actual uses of vma_merge() and
split_vma() into specific and abstracted functions and de-duplicate the
vma_merge()/split_vma() pattern altogether.

Doing so also opens the door to changing how vma_merge() is implemented -
by knowing precisely what cases a caller is invoking rather than having a
central interface where anything might happen we can untangle the brittle
and confusing vma_merge() implementation into something more workable.

For mprotect()-like cases we introduce vma_modify() which performs the
vma_merge()/split_vma() pattern, returning a pointer to either the merged
or split VMA or an ERR_PTR(err) if the splits fail.

We provide a number of inline helper functions to make things even clearer:-

* vma_modify_flags()      - Prepare to modify the VMA's flags.
* vma_modify_flags_name() - Prepare to modify the VMA's flags/anon_vma_name
* vma_modify_policy()     - Prepare to modify the VMA's mempolicy.
* vma_modify_flags_uffd() - Prepare to modify the VMA's flags/uffd context.

For cases where a new VMA is attempted to be merged with adjacent VMAs we
add:-

* vma_merge_new_vma() - Prepare to merge a new VMA.
* vma_merge_extend()  - Prepare to extend the end of a new VMA.


This patch (of 5):

The vma_policy() define is a helper specifically for a VMA field so it
makes sense to host it in the memory management types header.

The anon_vma_name(), anon_vma_name_alloc() and anon_vma_name_free()
functions are a little out of place in mm_inline.h as they define external
functions, and so it makes sense to locate them in mm_types.h.

The purpose of these relocations is to make it possible to abstract static
inline wrappers which invoke both of these helpers.

Link: https://lkml.kernel.org/r/cover.1697043508.git.lstoakes@gmail.com
Link: https://lkml.kernel.org/r/24bfc6c9e382fffbcb0ea8d424392c27d56cc8ca.1697043508.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    4 ----
 include/linux/mm_inline.h |   20 +-------------------
 include/linux/mm_types.h  |   27 +++++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 23 deletions(-)

--- a/include/linux/mempolicy.h~mm-move-vma_policy-and-anon_vma_name-decls-to-mm_typesh
+++ a/include/linux/mempolicy.h
@@ -89,8 +89,6 @@ static inline struct mempolicy *mpol_dup
 	return pol;
 }
 
-#define vma_policy(vma) ((vma)->vm_policy)
-
 static inline void mpol_get(struct mempolicy *pol)
 {
 	if (pol)
@@ -222,8 +220,6 @@ static inline struct mempolicy *get_vma_
 	return NULL;
 }
 
-#define vma_policy(vma) NULL
-
 static inline int
 vma_dup_policy(struct vm_area_struct *src, struct vm_area_struct *dst)
 {
--- a/include/linux/mm_inline.h~mm-move-vma_policy-and-anon_vma_name-decls-to-mm_typesh
+++ a/include/linux/mm_inline.h
@@ -4,6 +4,7 @@
 
 #include <linux/atomic.h>
 #include <linux/huge_mm.h>
+#include <linux/mm_types.h>
 #include <linux/swap.h>
 #include <linux/string.h>
 #include <linux/userfaultfd_k.h>
@@ -352,15 +353,6 @@ void lruvec_del_folio(struct lruvec *lru
 }
 
 #ifdef CONFIG_ANON_VMA_NAME
-/*
- * mmap_lock should be read-locked when calling anon_vma_name(). Caller should
- * either keep holding the lock while using the returned pointer or it should
- * raise anon_vma_name refcount before releasing the lock.
- */
-extern struct anon_vma_name *anon_vma_name(struct vm_area_struct *vma);
-extern struct anon_vma_name *anon_vma_name_alloc(const char *name);
-extern void anon_vma_name_free(struct kref *kref);
-
 /* mmap_lock should be read-locked */
 static inline void anon_vma_name_get(struct anon_vma_name *anon_name)
 {
@@ -415,16 +407,6 @@ static inline bool anon_vma_name_eq(stru
 }
 
 #else /* CONFIG_ANON_VMA_NAME */
-static inline struct anon_vma_name *anon_vma_name(struct vm_area_struct *vma)
-{
-	return NULL;
-}
-
-static inline struct anon_vma_name *anon_vma_name_alloc(const char *name)
-{
-	return NULL;
-}
-
 static inline void anon_vma_name_get(struct anon_vma_name *anon_name) {}
 static inline void anon_vma_name_put(struct anon_vma_name *anon_name) {}
 static inline void dup_anon_vma_name(struct vm_area_struct *orig_vma,
--- a/include/linux/mm_types.h~mm-move-vma_policy-and-anon_vma_name-decls-to-mm_typesh
+++ a/include/linux/mm_types.h
@@ -546,6 +546,27 @@ struct anon_vma_name {
 	char name[];
 };
 
+#ifdef CONFIG_ANON_VMA_NAME
+/*
+ * mmap_lock should be read-locked when calling anon_vma_name(). Caller should
+ * either keep holding the lock while using the returned pointer or it should
+ * raise anon_vma_name refcount before releasing the lock.
+ */
+struct anon_vma_name *anon_vma_name(struct vm_area_struct *vma);
+struct anon_vma_name *anon_vma_name_alloc(const char *name);
+void anon_vma_name_free(struct kref *kref);
+#else /* CONFIG_ANON_VMA_NAME */
+static inline struct anon_vma_name *anon_vma_name(struct vm_area_struct *vma)
+{
+	return NULL;
+}
+
+static inline struct anon_vma_name *anon_vma_name_alloc(const char *name)
+{
+	return NULL;
+}
+#endif
+
 struct vma_lock {
 	struct rw_semaphore lock;
 };
@@ -662,6 +683,12 @@ struct vm_area_struct {
 	struct vm_userfaultfd_ctx vm_userfaultfd_ctx;
 } __randomize_layout;
 
+#ifdef CONFIG_NUMA
+#define vma_policy(vma) ((vma)->vm_policy)
+#else
+#define vma_policy(vma) NULL
+#endif
+
 #ifdef CONFIG_SCHED_MM_CID
 struct mm_cid {
 	u64 time;
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case.patch
mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case-fix.patch
mm-make-__access_remote_vm-static.patch
mm-gup-explicitly-define-and-check-internal-gup-flags-disallow-foll_touch.patch
mm-gup-make-failure-to-pin-an-error-if-foll_nowait-not-specified.patch
mm-gup-adapt-get_user_page_vma_remote-to-never-return-null.patch
mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch
mm-update-memfd-seal-write-check-to-include-f_seal_write.patch
mm-enforce-the-mapping_map_writable-check-after-call_mmap.patch
mm-mprotect-allow-unfaulted-vmas-to-be-unaccounted-on-mprotect.patch
mm-move-vma_policy-and-anon_vma_name-decls-to-mm_typesh.patch
mm-abstract-the-vma_merge-split_vma-pattern-for-mprotect-et-al.patch
mm-make-vma_merge-and-split_vma-internal.patch
mm-abstract-merge-for-new-vmas-into-vma_merge_new_vma.patch
mm-abstract-vma-merge-and-extend-into-vma_merge_extend-helper.patch

