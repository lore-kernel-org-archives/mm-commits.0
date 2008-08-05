From: akpm@linux-foundation.org
Subject: - binfmt_elf_fdpic-wire-up-at_execfd-at_execfn-at_secure.patch removed from -mm tree
Date: Mon, 04 Aug 2008 21:17:52 -0700
Message-ID: <200808050417.m754Hq4l016425@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754152AbYHEESl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 00:18:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, dhowells@redhat.com, dwmw2@infradead.org, p_gortmaker@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     binfmt_elf_fdpic: wire up AT_EXECFD, AT_EXECFN, AT_SECURE
has been removed from the -mm tree.  Its filename was
     binfmt_elf_fdpic-wire-up-at_execfd-at_execfn-at_secure.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: binfmt_elf_fdpic: wire up AT_EXECFD, AT_EXECFN, AT_SECURE
From: Paul Mundt <lethal@linux-sh.org>

These auxvec entries are the only ones left unhandled out of the current
base implementation.  This syncs up binfmt_elf_fdpic with linux/auxvec.h
and current binfmt_elf.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: David Howells <dhowells@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf_fdpic.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN fs/binfmt_elf_fdpic.c~binfmt_elf_fdpic-wire-up-at_execfd-at_execfn-at_secure fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~binfmt_elf_fdpic-wire-up-at_execfd-at_execfn-at_secure
+++ a/fs/binfmt_elf_fdpic.c
@@ -25,6 +25,7 @@
 #include <linux/fcntl.h>
 #include <linux/slab.h>
 #include <linux/pagemap.h>
+#include <linux/security.h>
 #include <linux/highmem.h>
 #include <linux/highuid.h>
 #include <linux/personality.h>
@@ -562,11 +563,14 @@ static int create_elf_fdpic_tables(struc
 	}
 
 	/* force 16 byte _final_ alignment here for generality */
-#define DLINFO_ITEMS 13
+#define DLINFO_ITEMS 15
 
 	nitems = 1 + DLINFO_ITEMS + (k_platform ? 1 : 0) + \
 		(k_base_platform ? 1 : 0) + AT_VECTOR_SIZE_ARCH;
 
+	if (bprm->interp_flags & BINPRM_FLAGS_EXECFD)
+		nitems++;
+
 	csp = sp;
 	sp -= nitems * 2 * sizeof(unsigned long);
 	sp -= (bprm->envc + 1) * sizeof(char *);	/* envv[] */
@@ -604,6 +608,12 @@ static int create_elf_fdpic_tables(struc
 			    (elf_addr_t) (unsigned long) u_base_platform);
 	}
 
+	if (bprm->interp_flags & BINPRM_FLAGS_EXECFD) {
+		nr = 0;
+		csp -= 2 * sizeof(unsigned long);
+		NEW_AUX_ENT(AT_EXECFD, bprm->interp_data);
+	}
+
 	nr = 0;
 	csp -= DLINFO_ITEMS * 2 * sizeof(unsigned long);
 	NEW_AUX_ENT(AT_HWCAP,	hwcap);
@@ -619,6 +629,8 @@ static int create_elf_fdpic_tables(struc
 	NEW_AUX_ENT(AT_EUID,	(elf_addr_t) current->euid);
 	NEW_AUX_ENT(AT_GID,	(elf_addr_t) current->gid);
 	NEW_AUX_ENT(AT_EGID,	(elf_addr_t) current->egid);
+	NEW_AUX_ENT(AT_SECURE,	security_bprm_secureexec(bprm));
+	NEW_AUX_ENT(AT_EXECFN,	bprm->exec);
 
 #ifdef ARCH_DLINFO
 	nr = 0;
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
binfmt_elf_fdpic-wire-up-at_execfd-at_execfn-at_secure.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

