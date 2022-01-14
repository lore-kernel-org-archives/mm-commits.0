Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F0FC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbiANWGE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiANWGD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:06:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5275BC061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:06:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE216B82A26
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D997AC36AE9;
        Fri, 14 Jan 2022 22:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197960;
        bh=JPAyqrfaYfQNRLLxBfQSNOG6BDBDtSN9wd+KLPmQOP0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xvCivqOkMCF/ccdagD+gFODyvtxe/drRLwhSeCBNl5YA/2oO+/BKKmSh2SoKLL4ze
         1Sh27bkbNmSvdxSEb9BXil5UvVv5wcM893VWam0qTDttqyBlaUvTigv6fxpBvFUv0G
         3zFQTt6mv9T34Po5v+dHmq/ucTTmd9rZHaiRAx2Y=
Date:   Fri, 14 Jan 2022 14:05:59 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ccross@google.com,
        dave.hansen@intel.com, ebiederm@xmission.com, gorcunov@openvz.org,
        hannes@cmpxchg.org, hughd@google.com, jan.glauber@gmail.com,
        john.stultz@linaro.org, keescook@chromium.org, linux-mm@kvack.org,
        mgorman@suse.de, minchan@kernel.org, mingo@kernel.org,
        mm-commits@vger.kernel.org, oleg@redhat.com, penberg@kernel.org,
        peterz@infradead.org, rientjes@google.com, rob@landley.net,
        serge.hallyn@ubuntu.com, sfr@canb.auug.org.au, shli@fusionio.com,
        surenb@google.com, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 057/146] mm: add a field to store names for
 private anonymous memory
Message-ID: <20220114220559.Ctv1K5aWW%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Colin Cross <ccross@google.com>
Subject: mm: add a field to store names for private anonymous memory

In many userspace applications, and especially in VM based applications
like Android uses heavily, there are multiple different allocators in use.
At a minimum there is libc malloc and the stack, and in many cases there
are libc malloc, the stack, direct syscalls to mmap anonymous memory, and
multiple VM heaps (one for small objects, one for big objects, etc.). 
Each of these layers usually has its own tools to inspect its usage;
malloc by compiling a debug version, the VM through heap inspection tools,
and for direct syscalls there is usually no way to track them.

On Android we heavily use a set of tools that use an extended version of
the logic covered in Documentation/vm/pagemap.txt to walk all pages mapped
in userspace and slice their usage by process, shared (COW) vs.  unique
mappings, backing, etc.  This can account for real physical memory usage
even in cases like fork without exec (which Android uses heavily to share
as many private COW pages as possible between processes), Kernel SamePage
Merging, and clean zero pages.  It produces a measurement of the pages
that only exist in that process (USS, for unique), and a measurement of
the physical memory usage of that process with the cost of shared pages
being evenly split between processes that share them (PSS).

If all anonymous memory is indistinguishable then figuring out the real
physical memory usage (PSS) of each heap requires either a pagemap walking
tool that can understand the heap debugging of every layer, or for every
layer's heap debugging tools to implement the pagemap walking logic, in
which case it is hard to get a consistent view of memory across the whole
system.

Tracking the information in userspace leads to all sorts of problems.  It
either needs to be stored inside the process, which means every process
has to have an API to export its current heap information upon request, or
it has to be stored externally in a filesystem that somebody needs to
clean up on crashes.  It needs to be readable while the process is still
running, so it has to have some sort of synchronization with every layer
of userspace.  Efficiently tracking the ranges requires reimplementing
something like the kernel vma trees, and linking to it from every layer of
userspace.  It requires more memory, more syscalls, more runtime cost, and
more complexity to separately track regions that the kernel is already
tracking.

This patch adds a field to /proc/pid/maps and /proc/pid/smaps to show a
userspace-provided name for anonymous vmas.  The names of named anonymous
vmas are shown in /proc/pid/maps and /proc/pid/smaps as [anon:<name>].

Userspace can set the name for a region of memory by calling
prctl(PR_SET_VMA, PR_SET_VMA_ANON_NAME, start, len, (unsigned long)name);
Setting the name to NULL clears it.  The name length limit is 80 bytes
including NUL-terminator and is checked to contain only printable ascii
characters (including space), except '[',']','\','$' and '`'.  Ascii
strings are being used to have a descriptive identifiers for vmas, which
can be understood by the users reading /proc/pid/maps or /proc/pid/smaps. 
Names can be standardized for a given system and they can include some
variable parts such as the name of the allocator or a library, tid of the
thread using it, etc.

The name is stored in a pointer in the shared union in vm_area_struct that
points to a null terminated string.  Anonymous vmas with the same name
(equivalent strings) and are otherwise mergeable will be merged.  The name
pointers are not shared between vmas even if they contain the same name. 
The name pointer is stored in a union with fields that are only used on
file-backed mappings, so it does not increase memory usage.

CONFIG_ANON_VMA_NAME kernel configuration is introduced to enable this
feature.  It keeps the feature disabled by default to prevent any
additional memory overhead and to avoid confusing procfs parsers on
systems which are not ready to support named anonymous vmas.

The patch is based on the original patch developed by Colin Cross, more
specifically on its latest version [1] posted upstream by Sumit Semwal. 
It used a userspace pointer to store vma names.  In that design, name
pointers could be shared between vmas.  However during the last
upstreaming attempt, Kees Cook raised concerns [2] about this approach and
suggested to copy the name into kernel memory space, perform validity
checks [3] and store as a string referenced from vm_area_struct.  One big
concern is about fork() performance which would need to strdup anonymous
vma names.  Dave Hansen suggested experimenting with worst-case scenario
of forking a process with 64k vmas having longest possible names [4].  I
ran this experiment on an ARM64 Android device and recorded a worst-case
regression of almost 40% when forking such a process.  This regression is
addressed in the followup patch which replaces the pointer to a name with
a refcounted structure that allows sharing the name pointer between vmas
of the same name.  Instead of duplicating the string during fork() or when
splitting a vma it increments the refcount.

[1] https://lore.kernel.org/linux-mm/20200901161459.11772-4-sumit.semwal@linaro.org/
[2] https://lore.kernel.org/linux-mm/202009031031.D32EF57ED@keescook/
[3] https://lore.kernel.org/linux-mm/202009031022.3834F692@keescook/
[4] https://lore.kernel.org/linux-mm/5d0358ab-8c47-2f5f-8e43-23b89d6a8e95@intel.com/

Changes for prctl(2) manual page (in the options section):

PR_SET_VMA
	Sets an attribute specified in arg2 for virtual memory areas
	starting from the address specified in arg3 and spanning the
	size specified	in arg4. arg5 specifies the value of the attribute
	to be set. Note that assigning an attribute to a virtual memory
	area might prevent it from being merged with adjacent virtual
	memory areas due to the difference in that attribute's value.

	Currently, arg2 must be one of:

	PR_SET_VMA_ANON_NAME
		Set a name for anonymous virtual memory areas. arg5 should
		be a pointer to a null-terminated string containing the
		name. The name length including null byte cannot exceed
		80 bytes. If arg5 is NULL, the name of the appropriate
		anonymous virtual memory areas will be reset. The name
		can contain only printable ascii characters (including
                space), except '[',']','\','$' and '`'.

                This feature is available only if the kernel is built with
                the CONFIG_ANON_VMA_NAME option enabled.

[surenb@google.com: docs: proc.rst: /proc/PID/maps: fix malformed table]
  Link: https://lkml.kernel.org/r/20211123185928.2513763-1-surenb@google.com
[surenb: rebased over v5.15-rc6, replaced userpointer with a kernel copy,
 added input sanitization and CONFIG_ANON_VMA_NAME config. The bulk of the
 work here was done by Colin Cross, therefore, with his permission, keeping
 him as the author]
Link: https://lkml.kernel.org/r/20211019215511.3771969-2-surenb@google.com
Signed-off-by: Colin Cross <ccross@google.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@zeniv.linux.org.uk>
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

 Documentation/filesystems/proc.rst |    6 -
 fs/proc/task_mmu.c                 |   12 ++
 fs/userfaultfd.c                   |    7 -
 include/linux/mm.h                 |   13 ++
 include/linux/mm_types.h           |   64 ++++++++++++-
 include/uapi/linux/prctl.h         |    3 
 kernel/fork.c                      |    2 
 kernel/sys.c                       |   63 +++++++++++++
 mm/Kconfig                         |   14 ++
 mm/madvise.c                       |  129 ++++++++++++++++++++++++++-
 mm/mempolicy.c                     |    3 
 mm/mlock.c                         |    2 
 mm/mmap.c                          |   38 ++++---
 mm/mprotect.c                      |    2 
 14 files changed, 324 insertions(+), 34 deletions(-)

--- a/Documentation/filesystems/proc.rst~mm-add-a-field-to-store-names-for-private-anonymous-memory
+++ a/Documentation/filesystems/proc.rst
@@ -426,12 +426,14 @@ with the memory region, as the case woul
 The "pathname" shows the name associated file for this mapping.  If the mapping
 is not associated with a file:
 
- =======                    ====================================
+ =============              ====================================
  [heap]                     the heap of the program
  [stack]                    the stack of the main process
  [vdso]                     the "virtual dynamic shared object",
                             the kernel system call handler
- =======                    ====================================
+ [anon:<name>]              an anonymous mapping that has been
+                            named by userspace
+ =============              ====================================
 
  or if empty, the mapping is anonymous.
 
--- a/fs/proc/task_mmu.c~mm-add-a-field-to-store-names-for-private-anonymous-memory
+++ a/fs/proc/task_mmu.c
@@ -308,6 +308,8 @@ show_map_vma(struct seq_file *m, struct
 
 	name = arch_vma_name(vma);
 	if (!name) {
+		const char *anon_name;
+
 		if (!mm) {
 			name = "[vdso]";
 			goto done;
@@ -319,8 +321,16 @@ show_map_vma(struct seq_file *m, struct
 			goto done;
 		}
 
-		if (is_stack(vma))
+		if (is_stack(vma)) {
 			name = "[stack]";
+			goto done;
+		}
+
+		anon_name = vma_anon_name(vma);
+		if (anon_name) {
+			seq_pad(m, ' ');
+			seq_printf(m, "[anon:%s]", anon_name);
+		}
 	}
 
 done:
--- a/fs/userfaultfd.c~mm-add-a-field-to-store-names-for-private-anonymous-memory
+++ a/fs/userfaultfd.c
@@ -877,7 +877,7 @@ static int userfaultfd_release(struct in
 				 new_flags, vma->anon_vma,
 				 vma->vm_file, vma->vm_pgoff,
 				 vma_policy(vma),
-				 NULL_VM_UFFD_CTX);
+				 NULL_VM_UFFD_CTX, vma_anon_name(vma));
 		if (prev)
 			vma = prev;
 		else
@@ -1436,7 +1436,8 @@ static int userfaultfd_register(struct u
 		prev = vma_merge(mm, prev, start, vma_end, new_flags,
 				 vma->anon_vma, vma->vm_file, vma->vm_pgoff,
 				 vma_policy(vma),
-				 ((struct vm_userfaultfd_ctx){ ctx }));
+				 ((struct vm_userfaultfd_ctx){ ctx }),
+				 vma_anon_name(vma));
 		if (prev) {
 			vma = prev;
 			goto next;
@@ -1613,7 +1614,7 @@ static int userfaultfd_unregister(struct
 		prev = vma_merge(mm, prev, start, vma_end, new_flags,
 				 vma->anon_vma, vma->vm_file, vma->vm_pgoff,
 				 vma_policy(vma),
-				 NULL_VM_UFFD_CTX);
+				 NULL_VM_UFFD_CTX, vma_anon_name(vma));
 		if (prev) {
 			vma = prev;
 			goto next;
--- a/include/linux/mm.h~mm-add-a-field-to-store-names-for-private-anonymous-memory
+++ a/include/linux/mm.h
@@ -2658,7 +2658,7 @@ static inline int vma_adjust(struct vm_a
 extern struct vm_area_struct *vma_merge(struct mm_struct *,
 	struct vm_area_struct *prev, unsigned long addr, unsigned long end,
 	unsigned long vm_flags, struct anon_vma *, struct file *, pgoff_t,
-	struct mempolicy *, struct vm_userfaultfd_ctx);
+	struct mempolicy *, struct vm_userfaultfd_ctx, const char *);
 extern struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *);
 extern int __split_vma(struct mm_struct *, struct vm_area_struct *,
 	unsigned long addr, int new_below);
@@ -3391,5 +3391,16 @@ static inline int seal_check_future_writ
 	return 0;
 }
 
+#ifdef CONFIG_ANON_VMA_NAME
+int madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
+			  unsigned long len_in, const char *name);
+#else
+static inline int
+madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
+		      unsigned long len_in, const char *name) {
+	return 0;
+}
+#endif
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
--- a/include/linux/mm_types.h~mm-add-a-field-to-store-names-for-private-anonymous-memory
+++ a/include/linux/mm_types.h
@@ -426,11 +426,19 @@ struct vm_area_struct {
 	/*
 	 * For areas with an address space and backing store,
 	 * linkage into the address_space->i_mmap interval tree.
+	 *
+	 * For private anonymous mappings, a pointer to a null terminated string
+	 * containing the name given to the vma, or NULL if unnamed.
 	 */
-	struct {
-		struct rb_node rb;
-		unsigned long rb_subtree_last;
-	} shared;
+
+	union {
+		struct {
+			struct rb_node rb;
+			unsigned long rb_subtree_last;
+		} shared;
+		/* Serialized by mmap_sem. */
+		char *anon_name;
+	};
 
 	/*
 	 * A file's MAP_PRIVATE vma can be in both i_mmap tree and anon_vma
@@ -875,4 +883,52 @@ typedef struct {
 	unsigned long val;
 } swp_entry_t;
 
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
 #endif /* _LINUX_MM_TYPES_H */
--- a/include/uapi/linux/prctl.h~mm-add-a-field-to-store-names-for-private-anonymous-memory
+++ a/include/uapi/linux/prctl.h
@@ -272,4 +272,7 @@ struct prctl_mm_map {
 # define PR_SCHED_CORE_SCOPE_THREAD_GROUP	1
 # define PR_SCHED_CORE_SCOPE_PROCESS_GROUP	2
 
+#define PR_SET_VMA		0x53564d41
+# define PR_SET_VMA_ANON_NAME		0
+
 #endif /* _LINUX_PRCTL_H */
--- a/kernel/fork.c~mm-add-a-field-to-store-names-for-private-anonymous-memory
+++ a/kernel/fork.c
@@ -365,12 +365,14 @@ struct vm_area_struct *vm_area_dup(struc
 		*new = data_race(*orig);
 		INIT_LIST_HEAD(&new->anon_vma_chain);
 		new->vm_next = new->vm_prev = NULL;
+		dup_vma_anon_name(orig, new);
 	}
 	return new;
 }
 
 void vm_area_free(struct vm_area_struct *vma)
 {
+	free_vma_anon_name(vma);
 	kmem_cache_free(vm_area_cachep, vma);
 }
 
--- a/kernel/sys.c~mm-add-a-field-to-store-names-for-private-anonymous-memory
+++ a/kernel/sys.c
@@ -2261,6 +2261,66 @@ int __weak arch_prctl_spec_ctrl_set(stru
 
 #define PR_IO_FLUSHER (PF_MEMALLOC_NOIO | PF_LOCAL_THROTTLE)
 
+#ifdef CONFIG_ANON_VMA_NAME
+
+#define ANON_VMA_NAME_MAX_LEN		80
+#define ANON_VMA_NAME_INVALID_CHARS	"\\`$[]"
+
+static inline bool is_valid_name_char(char ch)
+{
+	/* printable ascii characters, excluding ANON_VMA_NAME_INVALID_CHARS */
+	return ch > 0x1f && ch < 0x7f &&
+		!strchr(ANON_VMA_NAME_INVALID_CHARS, ch);
+}
+
+static int prctl_set_vma(unsigned long opt, unsigned long addr,
+			 unsigned long size, unsigned long arg)
+{
+	struct mm_struct *mm = current->mm;
+	const char __user *uname;
+	char *name, *pch;
+	int error;
+
+	switch (opt) {
+	case PR_SET_VMA_ANON_NAME:
+		uname = (const char __user *)arg;
+		if (uname) {
+			name = strndup_user(uname, ANON_VMA_NAME_MAX_LEN);
+
+			if (IS_ERR(name))
+				return PTR_ERR(name);
+
+			for (pch = name; *pch != '\0'; pch++) {
+				if (!is_valid_name_char(*pch)) {
+					kfree(name);
+					return -EINVAL;
+				}
+			}
+		} else {
+			/* Reset the name */
+			name = NULL;
+		}
+
+		mmap_write_lock(mm);
+		error = madvise_set_anon_name(mm, addr, size, name);
+		mmap_write_unlock(mm);
+		kfree(name);
+		break;
+	default:
+		error = -EINVAL;
+	}
+
+	return error;
+}
+
+#else /* CONFIG_ANON_VMA_NAME */
+static int prctl_set_vma(unsigned long opt, unsigned long start,
+			 unsigned long size, unsigned long arg)
+{
+	return -EINVAL;
+}
+#endif /* CONFIG_ANON_VMA_NAME */
+
 SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		unsigned long, arg4, unsigned long, arg5)
 {
@@ -2530,6 +2590,9 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 		error = sched_core_share_pid(arg2, arg3, arg4, arg5);
 		break;
 #endif
+	case PR_SET_VMA:
+		error = prctl_set_vma(arg2, arg3, arg4, arg5);
+		break;
 	default:
 		error = -EINVAL;
 		break;
--- a/mm/Kconfig~mm-add-a-field-to-store-names-for-private-anonymous-memory
+++ a/mm/Kconfig
@@ -900,6 +900,20 @@ config IO_MAPPING
 config SECRETMEM
 	def_bool ARCH_HAS_SET_DIRECT_MAP && !EMBEDDED
 
+config ANON_VMA_NAME
+	bool "Anonymous VMA name support"
+	depends on PROC_FS && ADVISE_SYSCALLS && MMU
+
+	help
+	  Allow naming anonymous virtual memory areas.
+
+	  This feature allows assigning names to virtual memory areas. Assigned
+	  names can be later retrieved from /proc/pid/maps and /proc/pid/smaps
+	  and help identifying individual anonymous memory areas.
+	  Assigning a name to anonymous virtual memory area might prevent that
+	  area from being merged with adjacent virtual memory areas due to the
+	  difference in their name.
+
 source "mm/damon/Kconfig"
 
 endmenu
--- a/mm/madvise.c~mm-add-a-field-to-store-names-for-private-anonymous-memory
+++ a/mm/madvise.c
@@ -18,6 +18,7 @@
 #include <linux/fadvise.h>
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
+#include <linux/string.h>
 #include <linux/uio.h>
 #include <linux/ksm.h>
 #include <linux/fs.h>
@@ -62,19 +63,84 @@ static int madvise_need_mmap_write(int b
 	}
 }
 
+#ifdef CONFIG_ANON_VMA_NAME
+static inline bool has_vma_anon_name(struct vm_area_struct *vma)
+{
+	return !vma->vm_file && vma->anon_name;
+}
+
+const char *vma_anon_name(struct vm_area_struct *vma)
+{
+	if (!has_vma_anon_name(vma))
+		return NULL;
+
+	mmap_assert_locked(vma->vm_mm);
+
+	return vma->anon_name;
+}
+
+void dup_vma_anon_name(struct vm_area_struct *orig_vma,
+		       struct vm_area_struct *new_vma)
+{
+	if (!has_vma_anon_name(orig_vma))
+		return;
+
+	new_vma->anon_name = kstrdup(orig_vma->anon_name, GFP_KERNEL);
+}
+
+void free_vma_anon_name(struct vm_area_struct *vma)
+{
+	if (!has_vma_anon_name(vma))
+		return;
+
+	kfree(vma->anon_name);
+	vma->anon_name = NULL;
+}
+
+/* mmap_lock should be write-locked */
+static int replace_vma_anon_name(struct vm_area_struct *vma, const char *name)
+{
+	if (!name) {
+		free_vma_anon_name(vma);
+		return 0;
+	}
+
+	if (vma->anon_name) {
+		/* Same name, nothing to do here */
+		if (!strcmp(name, vma->anon_name))
+			return 0;
+
+		free_vma_anon_name(vma);
+	}
+	vma->anon_name = kstrdup(name, GFP_KERNEL);
+	if (!vma->anon_name)
+		return -ENOMEM;
+
+	return 0;
+}
+#else /* CONFIG_ANON_VMA_NAME */
+static int replace_vma_anon_name(struct vm_area_struct *vma, const char *name)
+{
+	if (name)
+		return -EINVAL;
+
+	return 0;
+}
+#endif /* CONFIG_ANON_VMA_NAME */
 /*
  * Update the vm_flags on region of a vma, splitting it or merging it as
  * necessary.  Must be called with mmap_sem held for writing;
  */
 static int madvise_update_vma(struct vm_area_struct *vma,
 			      struct vm_area_struct **prev, unsigned long start,
-			      unsigned long end, unsigned long new_flags)
+			      unsigned long end, unsigned long new_flags,
+			      const char *name)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	int error;
 	pgoff_t pgoff;
 
-	if (new_flags == vma->vm_flags) {
+	if (new_flags == vma->vm_flags && is_same_vma_anon_name(vma, name)) {
 		*prev = vma;
 		return 0;
 	}
@@ -82,7 +148,7 @@ static int madvise_update_vma(struct vm_
 	pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
 	*prev = vma_merge(mm, *prev, start, end, new_flags, vma->anon_vma,
 			  vma->vm_file, pgoff, vma_policy(vma),
-			  vma->vm_userfaultfd_ctx);
+			  vma->vm_userfaultfd_ctx, name);
 	if (*prev) {
 		vma = *prev;
 		goto success;
@@ -111,6 +177,11 @@ success:
 	 * vm_flags is protected by the mmap_lock held in write mode.
 	 */
 	vma->vm_flags = new_flags;
+	if (!vma->vm_file) {
+		error = replace_vma_anon_name(vma, name);
+		if (error)
+			return error;
+	}
 
 	return 0;
 }
@@ -938,7 +1009,8 @@ static int madvise_vma_behavior(struct v
 		break;
 	}
 
-	error = madvise_update_vma(vma, prev, start, end, new_flags);
+	error = madvise_update_vma(vma, prev, start, end, new_flags,
+				   vma_anon_name(vma));
 
 out:
 	/*
@@ -1118,6 +1190,55 @@ int madvise_walk_vmas(struct mm_struct *
 	return unmapped_error;
 }
 
+#ifdef CONFIG_ANON_VMA_NAME
+static int madvise_vma_anon_name(struct vm_area_struct *vma,
+				 struct vm_area_struct **prev,
+				 unsigned long start, unsigned long end,
+				 unsigned long name)
+{
+	int error;
+
+	/* Only anonymous mappings can be named */
+	if (vma->vm_file)
+		return -EBADF;
+
+	error = madvise_update_vma(vma, prev, start, end, vma->vm_flags,
+				   (const char *)name);
+
+	/*
+	 * madvise() returns EAGAIN if kernel resources, such as
+	 * slab, are temporarily unavailable.
+	 */
+	if (error == -ENOMEM)
+		error = -EAGAIN;
+	return error;
+}
+
+int madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
+			  unsigned long len_in, const char *name)
+{
+	unsigned long end;
+	unsigned long len;
+
+	if (start & ~PAGE_MASK)
+		return -EINVAL;
+	len = (len_in + ~PAGE_MASK) & PAGE_MASK;
+
+	/* Check to see whether len was rounded up from small -ve to zero */
+	if (len_in && !len)
+		return -EINVAL;
+
+	end = start + len;
+	if (end < start)
+		return -EINVAL;
+
+	if (end == start)
+		return 0;
+
+	return madvise_walk_vmas(mm, start, end, (unsigned long)name,
+				 madvise_vma_anon_name);
+}
+#endif /* CONFIG_ANON_VMA_NAME */
 /*
  * The madvise(2) system call.
  *
--- a/mm/mempolicy.c~mm-add-a-field-to-store-names-for-private-anonymous-memory
+++ a/mm/mempolicy.c
@@ -810,7 +810,8 @@ static int mbind_range(struct mm_struct
 			((vmstart - vma->vm_start) >> PAGE_SHIFT);
 		prev = vma_merge(mm, prev, vmstart, vmend, vma->vm_flags,
 				 vma->anon_vma, vma->vm_file, pgoff,
-				 new_pol, vma->vm_userfaultfd_ctx);
+				 new_pol, vma->vm_userfaultfd_ctx,
+				 vma_anon_name(vma));
 		if (prev) {
 			vma = prev;
 			next = vma->vm_next;
--- a/mm/mlock.c~mm-add-a-field-to-store-names-for-private-anonymous-memory
+++ a/mm/mlock.c
@@ -512,7 +512,7 @@ static int mlock_fixup(struct vm_area_st
 	pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
 	*prev = vma_merge(mm, *prev, start, end, newflags, vma->anon_vma,
 			  vma->vm_file, pgoff, vma_policy(vma),
-			  vma->vm_userfaultfd_ctx);
+			  vma->vm_userfaultfd_ctx, vma_anon_name(vma));
 	if (*prev) {
 		vma = *prev;
 		goto success;
--- a/mm/mmap.c~mm-add-a-field-to-store-names-for-private-anonymous-memory
+++ a/mm/mmap.c
@@ -1029,7 +1029,8 @@ again:
  */
 static inline int is_mergeable_vma(struct vm_area_struct *vma,
 				struct file *file, unsigned long vm_flags,
-				struct vm_userfaultfd_ctx vm_userfaultfd_ctx)
+				struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
+				const char *anon_name)
 {
 	/*
 	 * VM_SOFTDIRTY should not prevent from VMA merging, if we
@@ -1047,6 +1048,8 @@ static inline int is_mergeable_vma(struc
 		return 0;
 	if (!is_mergeable_vm_userfaultfd_ctx(vma, vm_userfaultfd_ctx))
 		return 0;
+	if (!is_same_vma_anon_name(vma, anon_name))
+		return 0;
 	return 1;
 }
 
@@ -1079,9 +1082,10 @@ static int
 can_vma_merge_before(struct vm_area_struct *vma, unsigned long vm_flags,
 		     struct anon_vma *anon_vma, struct file *file,
 		     pgoff_t vm_pgoff,
-		     struct vm_userfaultfd_ctx vm_userfaultfd_ctx)
+		     struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
+		     const char *anon_name)
 {
-	if (is_mergeable_vma(vma, file, vm_flags, vm_userfaultfd_ctx) &&
+	if (is_mergeable_vma(vma, file, vm_flags, vm_userfaultfd_ctx, anon_name) &&
 	    is_mergeable_anon_vma(anon_vma, vma->anon_vma, vma)) {
 		if (vma->vm_pgoff == vm_pgoff)
 			return 1;
@@ -1100,9 +1104,10 @@ static int
 can_vma_merge_after(struct vm_area_struct *vma, unsigned long vm_flags,
 		    struct anon_vma *anon_vma, struct file *file,
 		    pgoff_t vm_pgoff,
-		    struct vm_userfaultfd_ctx vm_userfaultfd_ctx)
+		    struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
+		    const char *anon_name)
 {
-	if (is_mergeable_vma(vma, file, vm_flags, vm_userfaultfd_ctx) &&
+	if (is_mergeable_vma(vma, file, vm_flags, vm_userfaultfd_ctx, anon_name) &&
 	    is_mergeable_anon_vma(anon_vma, vma->anon_vma, vma)) {
 		pgoff_t vm_pglen;
 		vm_pglen = vma_pages(vma);
@@ -1113,9 +1118,9 @@ can_vma_merge_after(struct vm_area_struc
 }
 
 /*
- * Given a mapping request (addr,end,vm_flags,file,pgoff), figure out
- * whether that can be merged with its predecessor or its successor.
- * Or both (it neatly fills a hole).
+ * Given a mapping request (addr,end,vm_flags,file,pgoff,anon_name),
+ * figure out whether that can be merged with its predecessor or its
+ * successor.  Or both (it neatly fills a hole).
  *
  * In most cases - when called for mmap, brk or mremap - [addr,end) is
  * certain not to be mapped by the time vma_merge is called; but when
@@ -1160,7 +1165,8 @@ struct vm_area_struct *vma_merge(struct
 			unsigned long end, unsigned long vm_flags,
 			struct anon_vma *anon_vma, struct file *file,
 			pgoff_t pgoff, struct mempolicy *policy,
-			struct vm_userfaultfd_ctx vm_userfaultfd_ctx)
+			struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
+			const char *anon_name)
 {
 	pgoff_t pglen = (end - addr) >> PAGE_SHIFT;
 	struct vm_area_struct *area, *next;
@@ -1190,7 +1196,7 @@ struct vm_area_struct *vma_merge(struct
 			mpol_equal(vma_policy(prev), policy) &&
 			can_vma_merge_after(prev, vm_flags,
 					    anon_vma, file, pgoff,
-					    vm_userfaultfd_ctx)) {
+					    vm_userfaultfd_ctx, anon_name)) {
 		/*
 		 * OK, it can.  Can we now merge in the successor as well?
 		 */
@@ -1199,7 +1205,7 @@ struct vm_area_struct *vma_merge(struct
 				can_vma_merge_before(next, vm_flags,
 						     anon_vma, file,
 						     pgoff+pglen,
-						     vm_userfaultfd_ctx) &&
+						     vm_userfaultfd_ctx, anon_name) &&
 				is_mergeable_anon_vma(prev->anon_vma,
 						      next->anon_vma, NULL)) {
 							/* cases 1, 6 */
@@ -1222,7 +1228,7 @@ struct vm_area_struct *vma_merge(struct
 			mpol_equal(policy, vma_policy(next)) &&
 			can_vma_merge_before(next, vm_flags,
 					     anon_vma, file, pgoff+pglen,
-					     vm_userfaultfd_ctx)) {
+					     vm_userfaultfd_ctx, anon_name)) {
 		if (prev && addr < prev->vm_end)	/* case 4 */
 			err = __vma_adjust(prev, prev->vm_start,
 					 addr, prev->vm_pgoff, NULL, next);
@@ -1754,7 +1760,7 @@ unsigned long mmap_region(struct file *f
 	 * Can we just expand an old mapping?
 	 */
 	vma = vma_merge(mm, prev, addr, addr + len, vm_flags,
-			NULL, file, pgoff, NULL, NULL_VM_UFFD_CTX);
+			NULL, file, pgoff, NULL, NULL_VM_UFFD_CTX, NULL);
 	if (vma)
 		goto out;
 
@@ -1803,7 +1809,7 @@ unsigned long mmap_region(struct file *f
 		 */
 		if (unlikely(vm_flags != vma->vm_flags && prev)) {
 			merge = vma_merge(mm, prev, vma->vm_start, vma->vm_end, vma->vm_flags,
-				NULL, vma->vm_file, vma->vm_pgoff, NULL, NULL_VM_UFFD_CTX);
+				NULL, vma->vm_file, vma->vm_pgoff, NULL, NULL_VM_UFFD_CTX, NULL);
 			if (merge) {
 				/* ->mmap() can change vma->vm_file and fput the original file. So
 				 * fput the vma->vm_file here or we would add an extra fput for file
@@ -3056,7 +3062,7 @@ static int do_brk_flags(unsigned long ad
 
 	/* Can we just expand an old private anonymous mapping? */
 	vma = vma_merge(mm, prev, addr, addr + len, flags,
-			NULL, NULL, pgoff, NULL, NULL_VM_UFFD_CTX);
+			NULL, NULL, pgoff, NULL, NULL_VM_UFFD_CTX, NULL);
 	if (vma)
 		goto out;
 
@@ -3249,7 +3255,7 @@ struct vm_area_struct *copy_vma(struct v
 		return NULL;	/* should never get here */
 	new_vma = vma_merge(mm, prev, addr, addr + len, vma->vm_flags,
 			    vma->anon_vma, vma->vm_file, pgoff, vma_policy(vma),
-			    vma->vm_userfaultfd_ctx);
+			    vma->vm_userfaultfd_ctx, vma_anon_name(vma));
 	if (new_vma) {
 		/*
 		 * Source vma may have been merged into new_vma
--- a/mm/mprotect.c~mm-add-a-field-to-store-names-for-private-anonymous-memory
+++ a/mm/mprotect.c
@@ -464,7 +464,7 @@ mprotect_fixup(struct vm_area_struct *vm
 	pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
 	*pprev = vma_merge(mm, *pprev, start, end, newflags,
 			   vma->anon_vma, vma->vm_file, pgoff, vma_policy(vma),
-			   vma->vm_userfaultfd_ctx);
+			   vma->vm_userfaultfd_ctx, vma_anon_name(vma));
 	if (*pprev) {
 		vma = *pprev;
 		VM_WARN_ON((vma->vm_flags ^ newflags) & ~VM_SOFTDIRTY);
_
