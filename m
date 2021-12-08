Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10528C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Dec 2021 00:11:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbhLHAPJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Dec 2021 19:15:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233913AbhLHAPJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2021 19:15:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF53C061574
        for <mm-commits@vger.kernel.org>; Tue,  7 Dec 2021 16:11:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8929B81EBA
        for <mm-commits@vger.kernel.org>; Wed,  8 Dec 2021 00:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A9FC341C5;
        Wed,  8 Dec 2021 00:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638922295;
        bh=zOJe4aLlx4/rpMYGD197oxCWprMjrUZEI+fDTdisUw8=;
        h=Date:From:To:Subject:From;
        b=TQGGql1fOLlSlVzJuZrFc3ebsl53QW1T9hoMqyOGgqcznoQXPYV/48a5HPvHNinLd
         clGVaNtHb4sriv3RYMRlyRCRrGlc5rmzAb2KNPnfitSfdMpmWSGxUyX0N8H41LSUEd
         LghbJ2A4An0X87eJBvQBRSZ5C0U1sCQJNynJBfRA=
Date:   Tue, 07 Dec 2021 16:11:34 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, ccross@google.com, ebiederm@xmission.com,
        keescook@chromium.org, mm-commits@vger.kernel.org,
        peterx@redhat.com, peterz@infradead.org, sfr@canb.auug.org.au,
        surenb@google.com, vbabka@suse.cz, viro@zeniv.linux.org.uk,
        willy@infradead.org, yuzhao@google.com
Subject:  + mm-move-anon_vma-declarations-to-linux-mm_inlineh.patch
 added to -mm tree
Message-ID: <20211208001134.Ki-xRAxki%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move anon_vma declarations to linux/mm_inline.h
has been added to the -mm tree.  Its filename is
     mm-move-anon_vma-declarations-to-linux-mm_inlineh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-move-anon_vma-declarations-to-linux-mm_inlineh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-move-anon_vma-declarations-to-linux-mm_inlineh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: move anon_vma declarations to linux/mm_inline.h

The patch to add anonymous vma names causes a build failure in some
configurations:

include/linux/mm_types.h: In function 'is_same_vma_anon_name':
include/linux/mm_types.h:924:37: error: implicit declaration of function 'strcmp' [-Werror=implicit-function-declaration]
  924 |         return name && vma_name && !strcmp(name, vma_name);
      |                                     ^~~~~~
include/linux/mm_types.h:22:1: note: 'strcmp' is defined in header '<string.h>'; did you forget to '#include <string.h>'?

This should not really be part of linux/mm_types.h in the first place, as
that header is meant to only contain structure defintions and need a
minimum set of indirect includes itself.  While the header clearly
includes more than it should at this point, let's not make it worse by
including string.h as well, which would pull in the expensive
(compile-speed wise) fortify-string logic.

Move the new functions into a separate header that only needs to be
included in a couple of locations.

Link: https://lkml.kernel.org/r/20211207125710.2503446-1-arnd@kernel.org
Fixes: "mm: add a field to store names for private anonymous memory"
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Colin Cross <ccross@google.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c        |    1 
 fs/userfaultfd.c          |    1 
 include/linux/mm_inline.h |   50 ++++++++++++++++++++++++++++++++++++
 include/linux/mm_types.h  |   48 ----------------------------------
 kernel/fork.c             |    1 
 mm/madvise.c              |    1 
 mm/mmap.c                 |    1 
 7 files changed, 55 insertions(+), 48 deletions(-)

--- a/fs/proc/task_mmu.c~mm-move-anon_vma-declarations-to-linux-mm_inlineh
+++ a/fs/proc/task_mmu.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/pagewalk.h>
 #include <linux/vmacache.h>
+#include <linux/mm_inline.h>
 #include <linux/hugetlb.h>
 #include <linux/huge_mm.h>
 #include <linux/mount.h>
--- a/fs/userfaultfd.c~mm-move-anon_vma-declarations-to-linux-mm_inlineh
+++ a/fs/userfaultfd.c
@@ -15,6 +15,7 @@
 #include <linux/sched/signal.h>
 #include <linux/sched/mm.h>
 #include <linux/mm.h>
+#include <linux/mm_inline.h>
 #include <linux/mmu_notifier.h>
 #include <linux/poll.h>
 #include <linux/slab.h>
--- a/include/linux/mm_inline.h~mm-move-anon_vma-declarations-to-linux-mm_inlineh
+++ a/include/linux/mm_inline.h
@@ -4,6 +4,7 @@
 
 #include <linux/huge_mm.h>
 #include <linux/swap.h>
+#include <linux/string.h>
 
 /**
  * folio_is_file_lru - Should the folio be on a file LRU or anon LRU?
@@ -135,4 +136,53 @@ static __always_inline void del_page_fro
 {
 	lruvec_del_folio(lruvec, page_folio(page));
 }
+
+#ifdef CONFIG_ANON_VMA_NAME
+/*
+ * mmap_lock should be read-locked when calling vma_anon_name() and while using
+ * the returned pointer.
+ */
+extern const char *vma_anon_name(struct vm_area_struct *vma);
+
+/*
+ * mmap_lock should be read-locked for orig_vma->vm_mm.
+ * mmap_lock should be write-locked for new_vma->vm_mm or new_vma should be
+ * isolated.
+ */
+extern void dup_vma_anon_name(struct vm_area_struct *orig_vma,
+			      struct vm_area_struct *new_vma);
+
+/*
+ * mmap_lock should be write-locked or vma should have been isolated under
+ * write-locked mmap_lock protection.
+ */
+extern void free_vma_anon_name(struct vm_area_struct *vma);
+
+/* mmap_lock should be read-locked */
+static inline bool is_same_vma_anon_name(struct vm_area_struct *vma,
+					 const char *name)
+{
+	const char *vma_name = vma_anon_name(vma);
+
+	/* either both NULL, or pointers to same string */
+	if (vma_name == name)
+		return true;
+
+	return name && vma_name && !strcmp(name, vma_name);
+}
+#else /* CONFIG_ANON_VMA_NAME */
+static inline const char *vma_anon_name(struct vm_area_struct *vma)
+{
+	return NULL;
+}
+static inline void dup_vma_anon_name(struct vm_area_struct *orig_vma,
+			      struct vm_area_struct *new_vma) {}
+static inline void free_vma_anon_name(struct vm_area_struct *vma) {}
+static inline bool is_same_vma_anon_name(struct vm_area_struct *vma,
+					 const char *name)
+{
+	return true;
+}
+#endif  /* CONFIG_ANON_VMA_NAME */
+
 #endif
--- a/include/linux/mm_types.h~mm-move-anon_vma-declarations-to-linux-mm_inlineh
+++ a/include/linux/mm_types.h
@@ -890,52 +890,4 @@ typedef struct {
 	unsigned long val;
 } swp_entry_t;
 
-#ifdef CONFIG_ANON_VMA_NAME
-/*
- * mmap_lock should be read-locked when calling vma_anon_name() and while using
- * the returned pointer.
- */
-extern const char *vma_anon_name(struct vm_area_struct *vma);
-
-/*
- * mmap_lock should be read-locked for orig_vma->vm_mm.
- * mmap_lock should be write-locked for new_vma->vm_mm or new_vma should be
- * isolated.
- */
-extern void dup_vma_anon_name(struct vm_area_struct *orig_vma,
-			      struct vm_area_struct *new_vma);
-
-/*
- * mmap_lock should be write-locked or vma should have been isolated under
- * write-locked mmap_lock protection.
- */
-extern void free_vma_anon_name(struct vm_area_struct *vma);
-
-/* mmap_lock should be read-locked */
-static inline bool is_same_vma_anon_name(struct vm_area_struct *vma,
-					 const char *name)
-{
-	const char *vma_name = vma_anon_name(vma);
-
-	/* either both NULL, or pointers to same string */
-	if (vma_name == name)
-		return true;
-
-	return name && vma_name && !strcmp(name, vma_name);
-}
-#else /* CONFIG_ANON_VMA_NAME */
-static inline const char *vma_anon_name(struct vm_area_struct *vma)
-{
-	return NULL;
-}
-static inline void dup_vma_anon_name(struct vm_area_struct *orig_vma,
-			      struct vm_area_struct *new_vma) {}
-static inline void free_vma_anon_name(struct vm_area_struct *vma) {}
-static inline bool is_same_vma_anon_name(struct vm_area_struct *vma,
-					 const char *name)
-{
-	return true;
-}
-#endif  /* CONFIG_ANON_VMA_NAME */
-
 #endif /* _LINUX_MM_TYPES_H */
--- a/kernel/fork.c~mm-move-anon_vma-declarations-to-linux-mm_inlineh
+++ a/kernel/fork.c
@@ -42,6 +42,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/mm_inline.h>
 #include <linux/vmacache.h>
 #include <linux/nsproxy.h>
 #include <linux/capability.h>
--- a/mm/madvise.c~mm-move-anon_vma-declarations-to-linux-mm_inlineh
+++ a/mm/madvise.c
@@ -18,6 +18,7 @@
 #include <linux/fadvise.h>
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
+#include <linux/mm_inline.h>
 #include <linux/string.h>
 #include <linux/uio.h>
 #include <linux/ksm.h>
--- a/mm/mmap.c~mm-move-anon_vma-declarations-to-linux-mm_inlineh
+++ a/mm/mmap.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/backing-dev.h>
 #include <linux/mm.h>
+#include <linux/mm_inline.h>
 #include <linux/vmacache.h>
 #include <linux/shm.h>
 #include <linux/mman.h>
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-move-anon_vma-declarations-to-linux-mm_inlineh.patch
mm-move-tlb_flush_pending-inline-helpers-to-mm_inlineh.patch
fs-move-inode-sysctls-to-its-own-file-fix.patch
fs-move-dcache-sysctls-to-its-own-file-fix-2.patch

