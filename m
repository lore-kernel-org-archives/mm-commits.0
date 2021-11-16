Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48F6DC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 05:19:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2844D63219
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 05:19:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233518AbhKPFWk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 Nov 2021 00:22:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:42470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232563AbhKPFWb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Nov 2021 00:22:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3172961A6C;
        Tue, 16 Nov 2021 05:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637039973;
        bh=NjHZhVbe4gt21t7aQ3iyk70NivaUFRim+P2V4Ilmn4A=;
        h=Date:From:To:Subject:From;
        b=DH1cuhdcV+Zjr5GlRvu6L7MNzQqhp81Nkd/oHN+HVMHF6LmlZBfOWVFETS9QJSktt
         xih0ElxdtW7mP5vggR0TeI4+/y3pvBn8uj0Y5O19viw+rrOUCj3dJSy0J4srU+jcaL
         60C4V2LnlJWt+kSV0BQ25rK/5ceWsuXN5UdNUZyY=
Date:   Mon, 15 Nov 2021 21:19:32 -0800
From:   akpm@linux-foundation.org
To:     ccross@google.com, dave.hansen@intel.com, ebiederm@xmission.com,
        gorcunov@openvz.org, hannes@cmpxchg.org, hughd@google.com,
        jan.glauber@gmail.com, john.stultz@linaro.org,
        keescook@chromium.org, mgorman@suse.de, minchan@kernel.org,
        mingo@kernel.org, mm-commits@vger.kernel.org, oleg@redhat.com,
        penberg@kernel.org, peterz@infradead.org, rientjes@google.com,
        rob@landley.net, serge.hallyn@ubuntu.com, shli@fusionio.com,
        surenb@google.com, viro@zeniv.linux.org.uk
Subject:  + mm-add-anonymous-vma-name-refcounting.patch added to
 -mm tree
Message-ID: <20211116051932.wUQpt2j4_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add anonymous vma name refcounting
has been added to the -mm tree.  Its filename is
     mm-add-anonymous-vma-name-refcounting.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-add-anonymous-vma-name-refcounting.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-add-anonymous-vma-name-refcounting.patch

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
Subject: mm: add anonymous vma name refcounting

While forking a process with high number (64K) of named anonymous vmas the
overhead caused by strdup() is noticeable.  Experiments with ARM64 Android
device show up to 40% performance regression when forking a process with
64k unpopulated anonymous vmas using the max name lengths vs the same
process with the same number of anonymous vmas having no name.

Introduce anon_vma_name refcounted structure to avoid the overhead of
copying vma names during fork() and when splitting named anonymous vmas. 
When a vma is duplicated, instead of copying the name we increment the
refcount of this structure.  Multiple vmas can point to the same
anon_vma_name as long as they increment the refcount.  The name member of
anon_vma_name structure is assigned at structure allocation time and is
never changed.  If vma name changes then the refcount of the original
structure is dropped, a new anon_vma_name structure is allocated to hold
the new name and the vma pointer is updated to point to the new structure.

With this approach the fork() performance regressions is reduced 3-4x
times and with usecases using more reasonable number of VMAs (a few
thousand) the regressions is not measurable.

Link: https://lkml.kernel.org/r/20211019215511.3771969-3-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Colin Cross <ccross@google.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jan Glauber <jan.glauber@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rob Landley <rob@landley.net>
Cc: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
Cc: Shaohua Li <shli@fusionio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    9 +++++++
 mm/madvise.c             |   42 +++++++++++++++++++++++++++++++------
 2 files changed, 44 insertions(+), 7 deletions(-)

--- a/include/linux/mm_types.h~mm-add-anonymous-vma-name-refcounting
+++ a/include/linux/mm_types.h
@@ -5,6 +5,7 @@
 #include <linux/mm_types_task.h>
 
 #include <linux/auxvec.h>
+#include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/rbtree.h>
@@ -375,6 +376,12 @@ struct vm_userfaultfd_ctx {
 struct vm_userfaultfd_ctx {};
 #endif /* CONFIG_USERFAULTFD */
 
+struct anon_vma_name {
+	struct kref kref;
+	/* The name needs to be at the end because it is dynamically sized. */
+	char name[];
+};
+
 /*
  * This struct describes a virtual memory area. There is one of these
  * per VM-area/task. A VM area is any part of the process virtual memory
@@ -426,7 +433,7 @@ struct vm_area_struct {
 			unsigned long rb_subtree_last;
 		} shared;
 		/* Serialized by mmap_sem. */
-		char *anon_name;
+		struct anon_vma_name *anon_name;
 	};
 
 	/*
--- a/mm/madvise.c~mm-add-anonymous-vma-name-refcounting
+++ a/mm/madvise.c
@@ -64,6 +64,29 @@ static int madvise_need_mmap_write(int b
 }
 
 #ifdef CONFIG_ANON_VMA_NAME
+static struct anon_vma_name *anon_vma_name_alloc(const char *name)
+{
+	struct anon_vma_name *anon_name;
+	size_t count;
+
+	/* Add 1 for NUL terminator at the end of the anon_name->name */
+	count = strlen(name) + 1;
+	anon_name = kmalloc(struct_size(anon_name, name, count), GFP_KERNEL);
+	if (anon_name) {
+		kref_init(&anon_name->kref);
+		memcpy(anon_name->name, name, count);
+	}
+
+	return anon_name;
+}
+
+static void vma_anon_name_free(struct kref *kref)
+{
+	struct anon_vma_name *anon_name =
+			container_of(kref, struct anon_vma_name, kref);
+	kfree(anon_name);
+}
+
 static inline bool has_vma_anon_name(struct vm_area_struct *vma)
 {
 	return !vma->vm_file && vma->anon_name;
@@ -76,7 +99,7 @@ const char *vma_anon_name(struct vm_area
 
 	mmap_assert_locked(vma->vm_mm);
 
-	return vma->anon_name;
+	return vma->anon_name->name;
 }
 
 void dup_vma_anon_name(struct vm_area_struct *orig_vma,
@@ -85,34 +108,41 @@ void dup_vma_anon_name(struct vm_area_st
 	if (!has_vma_anon_name(orig_vma))
 		return;
 
-	new_vma->anon_name = kstrdup(orig_vma->anon_name, GFP_KERNEL);
+	kref_get(&orig_vma->anon_name->kref);
+	new_vma->anon_name = orig_vma->anon_name;
 }
 
 void free_vma_anon_name(struct vm_area_struct *vma)
 {
+	struct anon_vma_name *anon_name;
+
 	if (!has_vma_anon_name(vma))
 		return;
 
-	kfree(vma->anon_name);
+	anon_name = vma->anon_name;
 	vma->anon_name = NULL;
+	kref_put(&anon_name->kref, vma_anon_name_free);
 }
 
 /* mmap_lock should be write-locked */
 static int replace_vma_anon_name(struct vm_area_struct *vma, const char *name)
 {
+	const char *anon_name;
+
 	if (!name) {
 		free_vma_anon_name(vma);
 		return 0;
 	}
 
-	if (vma->anon_name) {
+	anon_name = vma_anon_name(vma);
+	if (anon_name) {
 		/* Same name, nothing to do here */
-		if (!strcmp(name, vma->anon_name))
+		if (!strcmp(name, anon_name))
 			return 0;
 
 		free_vma_anon_name(vma);
 	}
-	vma->anon_name = kstrdup(name, GFP_KERNEL);
+	vma->anon_name = anon_vma_name_alloc(name);
 	if (!vma->anon_name)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from surenb@google.com are

mm-add-anonymous-vma-name-refcounting.patch

