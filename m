Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B38FCDB488
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344838AbjJRVhj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235339AbjJRVgw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140B3D78
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:36:03 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B08C433C7;
        Wed, 18 Oct 2023 21:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664962;
        bh=RUGuro+hTjl8H8VViHkIILdEm+syk/3TMKXnSgNo2rU=;
        h=Date:To:From:Subject:From;
        b=aZLlR+tClcQehHv/zvsz2O91EHKBDN9eiQWdZMcX+ZeQQN9d+mEFpGFpThC2IvO/d
         yv+ZiiekB39aRIB6j8+KEZqSz1i2ZKoHV2HD6/ltzDFNJaxfnLTzlEhuQ6ETRReF4n
         GV4FdAzRkVyFQNWPV4RbzVDJ118pr0pXwznGFDLo=
Date:   Wed, 18 Oct 2023 14:36:02 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        vbabka@suse.cz, Liam.Howlett@oracle.com, brauner@kernel.org,
        lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-vma_policy-and-anon_vma_name-decls-to-mm_typesh.patch removed from -mm tree
Message-Id: <20231018213602.A1B08C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: move vma_policy() and anon_vma_name() decls to mm_types.h
has been removed from the -mm tree.  Its filename was
     mm-move-vma_policy-and-anon_vma_name-decls-to-mm_typesh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -222,8 +220,6 @@ mpol_shared_policy_lookup(struct shared_
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


