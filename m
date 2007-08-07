From: akpm@linux-foundation.org
Subject: + add-linux-elfcore-compath.patch added to -mm tree
Date: Tue, 07 Aug 2007 13:28:58 -0700
Message-ID: <200708072028.l77KSwE2002435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37951 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757986AbXHGU3q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 16:29:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, ak@suse.de, benh@kernel.crashing.org, paulus@samba.org, tony.luck@intel.com


The patch titled
     Add linux/elfcore-compat.h
has been added to the -mm tree.  Its filename is
     add-linux-elfcore-compath.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add linux/elfcore-compat.h
From: Roland McGrath <roland@redhat.com>

This adds the linux/elfcore-compat.h header file, which is the CONFIG_COMPAT
analog of the linux/elfcore.h header.  Each arch that needs to fake out
fs/binfmt_elf.c for its compat code can use this header to replace the
hand-copied definitions of the compat variants of struct elf_prstatus et al. 
Only the pr_reg field varies by arch, so asm/{compat,elf}.h must define
compat_elf_gregset_t before linux/elfcore-compat.h can be used.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/elfcore-compat.h |   55 +++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+)

diff -puN /dev/null include/linux/elfcore-compat.h
--- /dev/null
+++ a/include/linux/elfcore-compat.h
@@ -0,0 +1,55 @@
+#ifndef _LINUX_ELFCORE_COMPAT_H
+#define _LINUX_ELFCORE_COMPAT_H
+
+#include <linux/elf.h>
+#include <linux/elfcore.h>
+#include <linux/compat.h>
+
+/*
+ * Make sure these layouts match the linux/elfcore.h native definitions.
+ */
+
+struct compat_elf_siginfo
+{
+	compat_int_t			si_signo;
+	compat_int_t			si_code;
+	compat_int_t			si_errno;
+};
+
+struct compat_elf_prstatus
+{
+	struct compat_elf_siginfo	pr_info;
+	short				pr_cursig;
+	compat_ulong_t			pr_sigpend;
+	compat_ulong_t			pr_sighold;
+	compat_pid_t			pr_pid;
+	compat_pid_t			pr_ppid;
+	compat_pid_t			pr_pgrp;
+	compat_pid_t			pr_sid;
+	struct compat_timeval		pr_utime;
+	struct compat_timeval		pr_stime;
+	struct compat_timeval		pr_cutime;
+	struct compat_timeval		pr_cstime;
+	compat_elf_gregset_t		pr_reg;
+#ifdef CONFIG_BINFMT_ELF_FDPIC
+	compat_ulong_t			pr_exec_fdpic_loadmap;
+	compat_ulong_t			pr_interp_fdpic_loadmap;
+#endif
+	compat_int_t			pr_fpvalid;
+};
+
+struct compat_elf_prpsinfo
+{
+	char				pr_state;
+	char				pr_sname;
+	char				pr_zomb;
+	char				pr_nice;
+	compat_ulong_t			pr_flag;
+	compat_uid_t			pr_uid;
+	compat_gid_t			pr_gid;
+	compat_pid_t			pr_pid, pr_ppid, pr_pgrp, pr_sid;
+	char				pr_fname[16];
+	char				pr_psargs[ELF_PRARGSZ];
+};
+
+#endif /* _LINUX_ELFCORE_COMPAT_H */
_

Patches currently in -mm which might be from roland@redhat.com are

powerpc-vdso-install-unstripped-copies-on-disk.patch
pass-g-to-assembler-under-config_debug_info.patch
i386-vdso-install-unstripped-copies-on-disk.patch
i386-vdso-install-unstripped-copies-on-disk-fix.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
add-sys-module-name-notes.patch
do_sigaction-remove-now-unneeded-recalc_sigpending.patch
handle-the-multi-threaded-inits-exit-properly.patch
add-linux-elfcore-compath.patch
x86_64-use-linux-elfcore-compath.patch
powerpc-use-linux-elfcore-compath.patch
