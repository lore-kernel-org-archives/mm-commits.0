Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61397C6379F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbjBCGm4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbjBCGl3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:41:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D091A3C3D
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F3D6B82985
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B05DC433EF;
        Fri,  3 Feb 2023 06:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406281;
        bh=QHHyAHAKBKYstGWciI2ohltc9eegOMFxAwN6ZDqFlPY=;
        h=Date:To:From:Subject:From;
        b=uPwys1Hsh+/guent7YpIUtKkaCo482ikkuy08j0b3JUzUERUZ8HzTijoVVN+ANdDH
         AHTuuzJd6pnQPgYqg8x+eOlbo4NWJ1RT8KSlnmSAu+anjTbiTHTsg700BTmk7oOeGB
         u+BWqD7Ec6PVcD7OuCR9Z5wTXDtEnF3p9m95HCJs=
Date:   Thu, 02 Feb 2023 22:38:00 -0800
To:     mm-commits@vger.kernel.org, zbyszek@in.waw.pl,
        viro@zeniv.linux.org.uk, toiwoton@gmail.com, szabolcs.nagy@arm.com,
        shuah@kernel.org, nd@arm.com, lennart@poettering.net,
        keescook@chromium.org, jeremy.linton@arm.com, david@redhat.com,
        catalin.marinas@arm.com, broonie@kernel.org, joey.gouly@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-implement-memory-deny-write-execute-as-a-prctl.patch removed from -mm tree
Message-Id: <20230203063801.1B05DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: implement memory-deny-write-execute as a prctl
has been removed from the -mm tree.  Its filename was
     mm-implement-memory-deny-write-execute-as-a-prctl.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joey Gouly <joey.gouly@arm.com>
Subject: mm: implement memory-deny-write-execute as a prctl
Date: Thu, 19 Jan 2023 16:03:43 +0000

Patch series "mm: In-kernel support for memory-deny-write-execute (MDWE)",
v2.

The background to this is that systemd has a configuration option called
MemoryDenyWriteExecute [2], implemented as a SECCOMP BPF filter.  Its aim
is to prevent a user task from inadvertently creating an executable
mapping that is (or was) writeable.  Since such BPF filter is stateless,
it cannot detect mappings that were previously writeable but subsequently
changed to read-only.  Therefore the filter simply rejects any
mprotect(PROT_EXEC).  The side-effect is that on arm64 with BTI support
(Branch Target Identification), the dynamic loader cannot change an ELF
section from PROT_EXEC to PROT_EXEC|PROT_BTI using mprotect().  For
libraries, it can resort to unmapping and re-mapping but for the main
executable it does not have a file descriptor.  The original bug report in
the Red Hat bugzilla - [3] - and subsequent glibc workaround for libraries
- [4].

This series adds in-kernel support for this feature as a prctl
PR_SET_MDWE, that is inherited on fork().  The prctl denies PROT_WRITE |
PROT_EXEC mappings.  Like the systemd BPF filter it also denies adding
PROT_EXEC to mappings.  However unlike the BPF filter it only denies it if
the mapping didn't previous have PROT_EXEC.  This allows to PROT_EXEC ->
PROT_EXEC | PROT_BTI with mprotect(), which is a problem with the BPF
filter.


This patch (of 2):

The aim of such policy is to prevent a user task from creating an
executable mapping that is also writeable.

An example of mmap() returning -EACCESS if the policy is enabled:

	mmap(0, size, PROT_READ | PROT_WRITE | PROT_EXEC, flags, 0, 0);

Similarly, mprotect() would return -EACCESS below:

	addr = mmap(0, size, PROT_READ | PROT_EXEC, flags, 0, 0);
	mprotect(addr, size, PROT_READ | PROT_WRITE | PROT_EXEC);

The BPF filter that systemd MDWE uses is stateless, and disallows
mprotect() with PROT_EXEC completely. This new prctl allows PROT_EXEC to
be enabled if it was already PROT_EXEC, which allows the following case:

	addr = mmap(0, size, PROT_READ | PROT_EXEC, flags, 0, 0);
	mprotect(addr, size, PROT_READ | PROT_EXEC | PROT_BTI);

where PROT_BTI enables branch tracking identification on arm64.

Link: https://lkml.kernel.org/r/20230119160344.54358-1-joey.gouly@arm.com
Link: https://lkml.kernel.org/r/20230119160344.54358-2-joey.gouly@arm.com
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Co-developed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jeremy Linton <jeremy.linton@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Mark Brown <broonie@kernel.org>
Cc: nd <nd@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Szabolcs Nagy <szabolcs.nagy@arm.com>
Cc: Topi Miettinen <toiwoton@gmail.com>
Cc: Zbigniew Jędrzejewski-Szmek <zbyszek@in.waw.pl>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mman.h~mm-implement-memory-deny-write-execute-as-a-prctl
+++ a/include/linux/mman.h
@@ -156,4 +156,38 @@ calc_vm_flag_bits(unsigned long flags)
 }
 
 unsigned long vm_commit_limit(void);
+
+/*
+ * Denies creating a writable executable mapping or gaining executable permissions.
+ *
+ * This denies the following:
+ *
+ * 	a)	mmap(PROT_WRITE | PROT_EXEC)
+ *
+ *	b)	mmap(PROT_WRITE)
+ *		mprotect(PROT_EXEC)
+ *
+ *	c)	mmap(PROT_WRITE)
+ *		mprotect(PROT_READ)
+ *		mprotect(PROT_EXEC)
+ *
+ * But allows the following:
+ *
+ *	d)	mmap(PROT_READ | PROT_EXEC)
+ *		mmap(PROT_READ | PROT_EXEC | PROT_BTI)
+ */
+static inline bool map_deny_write_exec(struct vm_area_struct *vma,  unsigned long vm_flags)
+{
+	if (!test_bit(MMF_HAS_MDWE, &current->mm->flags))
+		return false;
+
+	if ((vm_flags & VM_EXEC) && (vm_flags & VM_WRITE))
+		return true;
+
+	if (!(vma->vm_flags & VM_EXEC) && (vm_flags & VM_EXEC))
+		return true;
+
+	return false;
+}
+
 #endif /* _LINUX_MMAN_H */
--- a/include/linux/sched/coredump.h~mm-implement-memory-deny-write-execute-as-a-prctl
+++ a/include/linux/sched/coredump.h
@@ -81,9 +81,13 @@ static inline int get_dumpable(struct mm
  * lifecycle of this mm, just for simplicity.
  */
 #define MMF_HAS_PINNED		27	/* FOLL_PIN has run, never cleared */
+
+#define MMF_HAS_MDWE		28
+#define MMF_HAS_MDWE_MASK	(1 << MMF_HAS_MDWE)
+
 #define MMF_DISABLE_THP_MASK	(1 << MMF_DISABLE_THP)
 
 #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
-				 MMF_DISABLE_THP_MASK)
+				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK)
 
 #endif /* _LINUX_SCHED_COREDUMP_H */
--- a/include/uapi/linux/prctl.h~mm-implement-memory-deny-write-execute-as-a-prctl
+++ a/include/uapi/linux/prctl.h
@@ -281,6 +281,12 @@ struct prctl_mm_map {
 # define PR_SME_VL_LEN_MASK		0xffff
 # define PR_SME_VL_INHERIT		(1 << 17) /* inherit across exec */
 
+/* Memory deny write / execute */
+#define PR_SET_MDWE			65
+# define PR_MDWE_REFUSE_EXEC_GAIN	1
+
+#define PR_GET_MDWE			66
+
 #define PR_SET_VMA		0x53564d41
 # define PR_SET_VMA_ANON_NAME		0
 
--- a/kernel/sys.c~mm-implement-memory-deny-write-execute-as-a-prctl
+++ a/kernel/sys.c
@@ -2348,6 +2348,33 @@ static int prctl_set_vma(unsigned long o
 }
 #endif /* CONFIG_ANON_VMA_NAME */
 
+static inline int prctl_set_mdwe(unsigned long bits, unsigned long arg3,
+				 unsigned long arg4, unsigned long arg5)
+{
+	if (arg3 || arg4 || arg5)
+		return -EINVAL;
+
+	if (bits & ~(PR_MDWE_REFUSE_EXEC_GAIN))
+		return -EINVAL;
+
+	if (bits & PR_MDWE_REFUSE_EXEC_GAIN)
+		set_bit(MMF_HAS_MDWE, &current->mm->flags);
+	else if (test_bit(MMF_HAS_MDWE, &current->mm->flags))
+		return -EPERM; /* Cannot unset the flag */
+
+	return 0;
+}
+
+static inline int prctl_get_mdwe(unsigned long arg2, unsigned long arg3,
+				 unsigned long arg4, unsigned long arg5)
+{
+	if (arg2 || arg3 || arg4 || arg5)
+		return -EINVAL;
+
+	return test_bit(MMF_HAS_MDWE, &current->mm->flags) ?
+		PR_MDWE_REFUSE_EXEC_GAIN : 0;
+}
+
 SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		unsigned long, arg4, unsigned long, arg5)
 {
@@ -2623,6 +2650,12 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 		error = sched_core_share_pid(arg2, arg3, arg4, arg5);
 		break;
 #endif
+	case PR_SET_MDWE:
+		error = prctl_set_mdwe(arg2, arg3, arg4, arg5);
+		break;
+	case PR_GET_MDWE:
+		error = prctl_get_mdwe(arg2, arg3, arg4, arg5);
+		break;
 	case PR_SET_VMA:
 		error = prctl_set_vma(arg2, arg3, arg4, arg5);
 		break;
--- a/mm/mmap.c~mm-implement-memory-deny-write-execute-as-a-prctl
+++ a/mm/mmap.c
@@ -2669,6 +2669,16 @@ cannot_expand:
 		vma_set_anonymous(vma);
 	}
 
+	if (map_deny_write_exec(vma, vma->vm_flags)) {
+		error = -EACCES;
+		if (file)
+			goto close_and_free_vma;
+		else if (vma->vm_file)
+			goto unmap_and_free_vma;
+		else
+			goto free_vma;
+	}
+
 	/* Allow architectures to sanity-check the vm_flags */
 	if (!arch_validate_flags(vma->vm_flags)) {
 		error = -EINVAL;
--- a/mm/mprotect.c~mm-implement-memory-deny-write-execute-as-a-prctl
+++ a/mm/mprotect.c
@@ -799,6 +799,11 @@ static int do_mprotect_pkey(unsigned lon
 			break;
 		}
 
+		if (map_deny_write_exec(vma, newflags)) {
+			error = -EACCES;
+			goto out;
+		}
+
 		/* Allow architectures to sanity-check the new flags */
 		if (!arch_validate_flags(newflags)) {
 			error = -EINVAL;
_

Patches currently in -mm which might be from joey.gouly@arm.com are


