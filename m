From: akpm@linux-foundation.org
Subject: - binfmt_elf_fdpic-support-auxvec-base-platform-string.patch removed from -mm tree
Date: Mon, 04 Aug 2008 21:17:47 -0700
Message-ID: <200808050417.m754Hl0I016417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754102AbYHEESj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 00:18:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, dhowells@redhat.com, dwmw2@infradead.org, p_gortmaker@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     binfmt_elf_fdpic: support auxvec base platform string
has been removed from the -mm tree.  Its filename was
     binfmt_elf_fdpic-support-auxvec-base-platform-string.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: binfmt_elf_fdpic: support auxvec base platform string
From: Paul Mundt <lethal@linux-sh.org>

Commit 483fad1c3fa1060d7e6710e84a065ad514571739 introduces
AT_BASE_PLATFORM, but only implements it for binfmt_elf.  Given that
AT_VECTOR_SIZE_BASE is unconditionally enlarged for us, and it's only
optionally added in for the platforms that set ELF_BASE_PLATFORM, wire it
up for binfmt_elf_fdpic, too.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: David Howells <dhowells@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf_fdpic.c |   50 ++++++++++++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 7 deletions(-)

diff -puN fs/binfmt_elf_fdpic.c~binfmt_elf_fdpic-support-auxvec-base-platform-string fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~binfmt_elf_fdpic-support-auxvec-base-platform-string
+++ a/fs/binfmt_elf_fdpic.c
@@ -455,6 +455,16 @@ error_kill:
 }
 
 /*****************************************************************************/
+
+#ifndef ELF_BASE_PLATFORM
+/*
+ * AT_BASE_PLATFORM indicates the "real" hardware/microarchitecture.
+ * If the arch defines ELF_BASE_PLATFORM (in asm/elf.h), the value
+ * will be copied to the user stack in the same manner as AT_PLATFORM.
+ */
+#define ELF_BASE_PLATFORM NULL
+#endif
+
 /*
  * present useful information to the program
  */
@@ -466,8 +476,8 @@ static int create_elf_fdpic_tables(struc
 	unsigned long sp, csp, nitems;
 	elf_caddr_t __user *argv, *envp;
 	size_t platform_len = 0, len;
-	char *k_platform;
-	char __user *u_platform, *p;
+	char *k_platform, *k_base_platform;
+	char __user *u_platform, *u_base_platform, *p;
 	long hwcap;
 	int loop;
 	int nr;	/* reset for each csp adjustment */
@@ -483,11 +493,14 @@ static int create_elf_fdpic_tables(struc
 		return -EFAULT;
 #endif
 
-	/* get hold of platform and hardware capabilities masks for the machine
-	 * we are running on.  In some cases (Sparc), this info is impossible
-	 * to get, in others (i386) it is merely difficult.
-	 */
 	hwcap = ELF_HWCAP;
+
+	/*
+	 * If this architecture has a platform capability string, copy it
+	 * to userspace.  In some cases (Sparc), this info is impossible
+	 * for userspace to get any other way, in others (i386) it is
+	 * merely difficult.
+	 */
 	k_platform = ELF_PLATFORM;
 	u_platform = NULL;
 
@@ -499,6 +512,21 @@ static int create_elf_fdpic_tables(struc
 			return -EFAULT;
 	}
 
+	/*
+	 * If this architecture has a "base" platform capability
+	 * string, copy it to userspace.
+	 */
+	k_base_platform = ELF_BASE_PLATFORM;
+	u_base_platform = NULL;
+
+	if (k_base_platform) {
+		platform_len = strlen(k_base_platform) + 1;
+		sp -= platform_len;
+		u_base_platform = (char __user *) sp;
+		if (__copy_to_user(u_base_platform, k_base_platform, platform_len) != 0)
+			return -EFAULT;
+	}
+
 #if defined(__i386__) && defined(CONFIG_SMP)
 	/* in some cases (e.g. Hyper-Threading), we want to avoid L1 evictions
 	 * by the processes running on the same package. One thing we can do is
@@ -543,7 +571,8 @@ static int create_elf_fdpic_tables(struc
 	/* force 16 byte _final_ alignment here for generality */
 #define DLINFO_ITEMS 13
 
-	nitems = 1 + DLINFO_ITEMS + (k_platform ? 1 : 0) + AT_VECTOR_SIZE_ARCH;
+	nitems = 1 + DLINFO_ITEMS + (k_platform ? 1 : 0) + \
+		(k_base_platform ? 1 : 0) + AT_VECTOR_SIZE_ARCH;
 
 	csp = sp;
 	sp -= nitems * 2 * sizeof(unsigned long);
@@ -575,6 +604,13 @@ static int create_elf_fdpic_tables(struc
 			    (elf_addr_t) (unsigned long) u_platform);
 	}
 
+	if (k_base_platform) {
+		nr = 0;
+		csp -= 2 * sizeof(unsigned long);
+		NEW_AUX_ENT(AT_BASE_PLATFORM,
+			    (elf_addr_t) (unsigned long) u_base_platform);
+	}
+
 	nr = 0;
 	csp -= DLINFO_ITEMS * 2 * sizeof(unsigned long);
 	NEW_AUX_ENT(AT_HWCAP,	hwcap);
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
mn10300-fix-up-__bug_table-handling-in-module-loader.patch
linux-next.patch
i2c-renesas-highlander-fpga-smbus-support.patch
maple-allow-removal-and-reinsertion-of-keyboard-driver-module.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore.patch
binfmt_elf_fdpic-support-auxvec-base-platform-string.patch
binfmt_elf_fdpic-convert-initial-stack-alignment-to-arch_align_stack.patch
binfmt_elf_fdpic-wire-up-at_execfd-at_execfn-at_secure.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

