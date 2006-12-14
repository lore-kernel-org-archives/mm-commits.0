From: akpm@osdl.org
Subject: - fix-crossbuilding-checkstack.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:04:30 -0800
Message-ID: <200612140604.kBE64UKc001812@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51742 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbWLNGEm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:04:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     Fix crossbuilding checkstack
has been removed from the -mm tree.  Its filename was
     fix-crossbuilding-checkstack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix crossbuilding checkstack
From: Jeff Dike <jdike@addtoit.com>

The previous checkstack fix for UML, which needs to use the host's tools,
was wrong in the crossbuilding case.  It would use the build host's, rather
than the target's, toolchain.

This patch removes the old fix and adds an explicit special case for UML,
leaving everyone else alone.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Makefile |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN Makefile~fix-crossbuilding-checkstack Makefile
--- a/Makefile~fix-crossbuilding-checkstack
+++ a/Makefile
@@ -1390,12 +1390,18 @@ endif #ifeq ($(mixed-targets),1)
 
 PHONY += checkstack kernelrelease kernelversion
 
-# Use $(SUBARCH) here instead of $(ARCH) so that this works for UML.
-# In the UML case, $(SUBARCH) is the name of the underlying
-# architecture, while for all other arches, it is the same as $(ARCH).
+# UML needs a little special treatment here.  It wants to use the host
+# toolchain, so needs $(SUBARCH) passed to checkstack.pl.  Everyone
+# else wants $(ARCH), including people doing cross-builds, which means
+# that $(SUBARCH) doesn't work here.
+ifeq ($(ARCH), um)
+CHECKSTACK_ARCH := $(SUBARCH)
+else
+CHECKSTACK_ARCH := $(ARCH)
+endif
 checkstack:
 	$(OBJDUMP) -d vmlinux $$(find . -name '*.ko') | \
-	$(PERL) $(src)/scripts/checkstack.pl $(SUBARCH)
+	$(PERL) $(src)/scripts/checkstack.pl $(CHECKSTACK_ARCH)
 
 kernelrelease:
 	$(if $(wildcard include/config/kernel.release), $(Q)echo $(KERNELRELEASE), \
_

Patches currently in -mm which might be from jdike@addtoit.com are

x86_64-i386-kernel-mode-faults-pollute-current-thead.patch
uml-fix-prototypes.patch

