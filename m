From: akpm@linux-foundation.org
Subject: + binfmt_elf_fdpic-wire-up-at_execfd-at_execfn-at_secure.patch added to -mm tree
Date: Mon, 11 Aug 2008 14:19:05 -0700
Message-ID: <200808112119.m7BLJ6fP021966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59297 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758089AbYHKVT4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 17:19:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, dhowells@redhat.com


The patch titled
     binfmt_elf_fdpic: wire up AT_EXECFD, AT_EXECFN, AT_SECURE
has been added to the -mm tree.  Its filename is
     binfmt_elf_fdpic-wire-up-at_execfd-at_execfn-at_secure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: binfmt_elf_fdpic: wire up AT_EXECFD, AT_EXECFN, AT_SECURE
From: Paul Mundt <lethal@linux-sh.org>

These auxvec entries are the only ones left unhandled out of the current
base implementation. This syncs up binfmt_elf_fdpic with linux/auxvec.h
and current binfmt_elf.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: David Howells <dhowells@redhat.com>
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
@@ -561,11 +562,14 @@ static int create_elf_fdpic_tables(struc
 	}
 
 	/* force 16 byte _final_ alignment here for generality */
-#define DLINFO_ITEMS 13
+#define DLINFO_ITEMS 15
 
 	nitems = 1 + DLINFO_ITEMS + (k_platform ? 1 : 0) +
 		(k_base_platform ? 1 : 0) + AT_VECTOR_SIZE_ARCH;
 
+	if (bprm->interp_flags & BINPRM_FLAGS_EXECFD)
+		nitems++;
+
 	csp = sp;
 	sp -= nitems * 2 * sizeof(unsigned long);
 	sp -= (bprm->envc + 1) * sizeof(char *);	/* envv[] */
@@ -603,6 +607,12 @@ static int create_elf_fdpic_tables(struc
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
@@ -618,6 +628,8 @@ static int create_elf_fdpic_tables(struc
 	NEW_AUX_ENT(AT_EUID,	(elf_addr_t) cred->euid);
 	NEW_AUX_ENT(AT_GID,	(elf_addr_t) cred->gid);
 	NEW_AUX_ENT(AT_EGID,	(elf_addr_t) cred->egid);
+	NEW_AUX_ENT(AT_SECURE,	security_bprm_secureexec(bprm));
+	NEW_AUX_ENT(AT_EXECFN,	bprm->exec);
 
 #ifdef ARCH_DLINFO
 	nr = 0;
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
linux-next.patch
i2c-renesas-highlander-fpga-smbus-support.patch
i2c-renesas-highlander-fpga-smbus-support-update.patch
i2c-renesas-highlander-fpga-smbus-support-update-fix.patch
kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore.patch
binfmt_elf_fdpic-support-auxvec-base-platform-string.patch
binfmt_elf_fdpic-convert-initial-stack-alignment-to-arch_align_stack.patch
binfmt_elf_fdpic-wire-up-at_execfd-at_execfn-at_secure.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

