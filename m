Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922986FB0
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739389; cv=none; b=MxpikX26h1dt+hTUZtcle6pP+psS0ccYDTOp3gmgF3RXiBJ8yCFuWNE55hcXD6kzG4Z8ZjBLn2hQZdrGqfVPBMHWkHAnRyMNo9iKAOq5SkEHuOF2xOqRO5zKGDABcAscuGiLn6Ms6xEtVVbUzqwx7feKiX4N4ltmP2LuWoCHFmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739389; c=relaxed/simple;
	bh=Q2AmKGmttIhWTPxP1HDClCJP9ORq38h0B7B+uotudD8=;
	h=Date:To:From:Subject:Message-Id; b=BzQsNhP/DqWtl4/XZaDIUHobLos0ODT68vP5BgDxKxS7fCRrvl3jw/QknK0lK7u3cbjhQxtu8yJoJlttBRtnZTqoAZI1bhRBSsqt8M7rffWqVw11JzXpq78ewEekW5E6qTERxbMRNHYRrdSj0B666bAlXU4RAWknJCaqX3mtSuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jFs1dphD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jFs1dphD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096BEC433F1;
	Sat, 24 Feb 2024 01:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739389;
	bh=Q2AmKGmttIhWTPxP1HDClCJP9ORq38h0B7B+uotudD8=;
	h=Date:To:From:Subject:From;
	b=jFs1dphDROQRnsOOIMDTroVVYIn0e2LuCUNDk5FPzNjzxGzbDCVilCFWSmvgHgN+h
	 kyVrGnvIzcrx+17Bm9V2JAr1Zl9bmw1pUNV8s/BG2MFrup/nNXEjYz5r/po1jaXl7Q
	 o9Tr1n0sTDYfgdzGRp1hhKbEGNaaJ/4hNJq8UEPw=
Date: Fri, 23 Feb 2024 17:49:48 -0800
To: mm-commits@vger.kernel.org,yang.lee@linux.alibaba.com,viro@zeniv.linux.org.uk,sfr@canb.auug.org.au,piliu@redhat.com,nathan@kernel.org,mhklinux@outlook.com,klarasmodin@gmail.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] crash-remove-dependency-of-fa_dump-on-crash_dump.patch removed from -mm tree
Message-Id: <20240224014949.096BEC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash: remove dependency of FA_DUMP on CRASH_DUMP
has been removed from the -mm tree.  Its filename was
     crash-remove-dependency-of-fa_dump-on-crash_dump.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: crash: remove dependency of FA_DUMP on CRASH_DUMP
Date: Wed, 24 Jan 2024 13:12:43 +0800

In kdump kernel, /proc/vmcore is an elf file mapping the crashed kernel's
old memory content. Its elf header is constructed in 1st kernel and passed
to kdump kernel via elfcorehdr_addr. Config CRASH_DUMP enables the code
of 1st kernel's old memory accessing in different architectures.

Currently, config FA_DUMP has dependency on CRASH_DUMP because fadump
needs access global variable 'elfcorehdr_addr' to judge if it's in
kdump kernel within function is_kdump_kernel(). In the current
kernel/crash_dump.c, variable 'elfcorehdr_addr' is defined, and function
setup_elfcorehdr() used to parse kernel parameter to fetch the passed
value of elfcorehdr_addr. Only for accessing elfcorehdr_addr, FA_DUMP
really doesn't have to depends on CRASH_DUMP.

To remove the dependency of FA_DUMP on CRASH_DUMP to avoid confusion,
rename kernel/crash_dump.c to kernel/elfcorehdr.c, and build it when
CONFIG_VMCORE_INFO is ebabled. With this, FA_DUMP doesn't need to depend
on CRASH_DUMP.

[bhe@redhat.com: power/fadump: make FA_DUMP select CRASH_DUMP]
  Link: https://lkml.kernel.org/r/Zb8D1ASrgX0qVm9z@MiWiFi-R3L-srv
Link: https://lkml.kernel.org/r/20240124051254.67105-4-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Hari Bathini <hbathini@linux.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Pingfan Liu <piliu@redhat.com>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Michael Kelley <mhklinux@outlook.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig    |    2 -
 kernel/Makefile         |    3 --
 kernel/crash_dump.c     |   41 --------------------------------------
 kernel/elfcorehdr.c     |   41 ++++++++++++++++++++++++++++++++++++++
 kernel/kexec_internal.h |    2 +
 5 files changed, 44 insertions(+), 45 deletions(-)

--- a/arch/powerpc/Kconfig~crash-remove-dependency-of-fa_dump-on-crash_dump
+++ a/arch/powerpc/Kconfig
@@ -690,8 +690,6 @@ config ARCH_SELECTS_CRASH_DUMP
 config FA_DUMP
 	bool "Firmware-assisted dump"
 	depends on PPC64 && (PPC_RTAS || PPC_POWERNV)
-	select VMCORE_INFO
-	select CRASH_RESERVE
 	select CRASH_DUMP
 	help
 	  A robust mechanism to get reliable kernel crash dump with
--- a/kernel/crash_dump.c
+++ /dev/null
@@ -1,41 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-#include <linux/kernel.h>
-#include <linux/crash_dump.h>
-#include <linux/init.h>
-#include <linux/errno.h>
-#include <linux/export.h>
-
-/*
- * stores the physical address of elf header of crash image
- *
- * Note: elfcorehdr_addr is not just limited to vmcore. It is also used by
- * is_kdump_kernel() to determine if we are booting after a panic. Hence put
- * it under CONFIG_CRASH_DUMP and not CONFIG_PROC_VMCORE.
- */
-unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
-EXPORT_SYMBOL_GPL(elfcorehdr_addr);
-
-/*
- * stores the size of elf header of crash image
- */
-unsigned long long elfcorehdr_size;
-
-/*
- * elfcorehdr= specifies the location of elf core header stored by the crashed
- * kernel. This option will be passed by kexec loader to the capture kernel.
- *
- * Syntax: elfcorehdr=[size[KMG]@]offset[KMG]
- */
-static int __init setup_elfcorehdr(char *arg)
-{
-	char *end;
-	if (!arg)
-		return -EINVAL;
-	elfcorehdr_addr = memparse(arg, &end);
-	if (*end == '@') {
-		elfcorehdr_size = elfcorehdr_addr;
-		elfcorehdr_addr = memparse(end + 1, &end);
-	}
-	return end > arg ? 0 : -EINVAL;
-}
-early_param("elfcorehdr", setup_elfcorehdr);
--- /dev/null
+++ a/kernel/elfcorehdr.c
@@ -0,0 +1,41 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/kernel.h>
+#include <linux/crash_dump.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/export.h>
+
+/*
+ * stores the physical address of elf header of crash image
+ *
+ * Note: elfcorehdr_addr is not just limited to vmcore. It is also used by
+ * is_kdump_kernel() to determine if we are booting after a panic. Hence put
+ * it under CONFIG_CRASH_DUMP and not CONFIG_PROC_VMCORE.
+ */
+unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
+EXPORT_SYMBOL_GPL(elfcorehdr_addr);
+
+/*
+ * stores the size of elf header of crash image
+ */
+unsigned long long elfcorehdr_size;
+
+/*
+ * elfcorehdr= specifies the location of elf core header stored by the crashed
+ * kernel. This option will be passed by kexec loader to the capture kernel.
+ *
+ * Syntax: elfcorehdr=[size[KMG]@]offset[KMG]
+ */
+static int __init setup_elfcorehdr(char *arg)
+{
+	char *end;
+	if (!arg)
+		return -EINVAL;
+	elfcorehdr_addr = memparse(arg, &end);
+	if (*end == '@') {
+		elfcorehdr_size = elfcorehdr_addr;
+		elfcorehdr_addr = memparse(end + 1, &end);
+	}
+	return end > arg ? 0 : -EINVAL;
+}
+early_param("elfcorehdr", setup_elfcorehdr);
--- a/kernel/kexec_internal.h~crash-remove-dependency-of-fa_dump-on-crash_dump
+++ a/kernel/kexec_internal.h
@@ -4,6 +4,8 @@
 
 #include <linux/kexec.h>
 
+struct kexec_segment;
+
 struct kimage *do_kimage_alloc_init(void);
 int sanity_check_segment_list(struct kimage *image);
 void kimage_free_page_list(struct list_head *list);
--- a/kernel/Makefile~crash-remove-dependency-of-fa_dump-on-crash_dump
+++ a/kernel/Makefile
@@ -68,7 +68,7 @@ obj-$(CONFIG_MODULE_SIG_FORMAT) += modul
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
 obj-$(CONFIG_KALLSYMS_SELFTEST) += kallsyms_selftest.o
 obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
-obj-$(CONFIG_VMCORE_INFO) += vmcore_info.o
+obj-$(CONFIG_VMCORE_INFO) += vmcore_info.o elfcorehdr.o
 obj-$(CONFIG_CRASH_RESERVE) += crash_reserve.o
 obj-$(CONFIG_KEXEC_CORE) += kexec_core.o crash_core.o
 obj-$(CONFIG_KEXEC) += kexec.o
@@ -121,7 +121,6 @@ obj-$(CONFIG_PERF_EVENTS) += events/
 
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
-obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
 obj-$(CONFIG_JUMP_LABEL) += jump_label.o
 obj-$(CONFIG_CONTEXT_TRACKING) += context_tracking.o
 obj-$(CONFIG_TORTURE_TEST) += torture.o
_

Patches currently in -mm which might be from bhe@redhat.com are


