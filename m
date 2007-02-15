From: akpm@linux-foundation.org
Subject: - kbuild-remove-references-to-deprecated-prepare-all-target.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:47:15 -0800
Message-ID: <200702150847.l1F8lFOp024968@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39888 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965343AbXBOIrV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:47:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, olecom@flower.upol.cz, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Kbuild: Remove references to deprecated "prepare-all" target from Makefile
has been removed from the -mm tree.  Its filename was
     kbuild-remove-references-to-deprecated-prepare-all-target.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Kbuild: Remove references to deprecated "prepare-all" target from Makefile
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove references to the deprecated "make prepare-all" target from the
top-level Makefile; use just "make prepare" instead.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Oleg Verych <olecom@flower.upol.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN Makefile~kbuild-remove-references-to-deprecated-prepare-all-target Makefile
--- a/Makefile~kbuild-remove-references-to-deprecated-prepare-all-target
+++ a/Makefile
@@ -825,9 +825,6 @@ include/config/kernel.release: include/c
 # Listed in dependency order
 PHONY += prepare archprepare prepare0 prepare1 prepare2 prepare3
 
-# prepare-all is deprecated, use prepare as valid replacement
-PHONY += prepare-all
-
 # prepare3 is used to check if we are building in a separate output directory,
 # and if so do:
 # 1) Check that make has not been executed in the kernel src $(srctree)
@@ -860,7 +857,7 @@ prepare0: archprepare FORCE
 	$(Q)$(MAKE) $(build)=.
 
 # All the preparing..
-prepare prepare-all: prepare0
+prepare: prepare0
 
 # Leave this as default for preprocessing vmlinux.lds.S, which is now
 # done in arch/$(ARCH)/kernel/Makefile
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-avr32.patch
git-dvb.patch
git-mips.patch
git-netdev-all.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
