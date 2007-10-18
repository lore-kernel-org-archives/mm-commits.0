From: akpm@linux-foundation.org
Subject: - add-linux-elfcore-compath.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:55:21 -0700
Message-ID: <200710180655.l9I6tLpw030600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52858 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932492AbXJRHnw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:43:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, ak@suse.de, benh@kernel.crashing.org, linux-arch@vger.kernel.org, paulus@samba.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Add linux/elfcore-compat.h
has been removed from the -mm tree.  Its filename was
     add-linux-elfcore-compath.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add linux/elfcore-compat.h
From: Roland McGrath <roland@redhat.com>

This adds the linux/elfcore-compat.h header file, which is the CONFIG_COMPAT
analog of the linux/elfcore.h header.  Each arch that needs to fake out
fs/binfmt_elf.c for its compat code can use this header to replace the
hand-copied definitions of the compat variants of struct elf_prstatus et al. 
Only the pr_reg field varies by arch, so asm/{compat,elf}.h must define
compat_elf_gregset_t before linux/elfcore-compat.h can be used.

It's a clean-up that every arch with compat core dumping code can benefit
from.  I only touched the ones I have handy to test at home.  Doing the same
for each other arch should be straightforward, and I'm happy to offer tips.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/elfcore-compat.h |   55 +++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

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

origin.patch
x86_64-use-linux-elfcore-compath.patch
fix-tsk-exit_state-usage-resend.patch
