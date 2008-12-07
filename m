From: akpm@linux-foundation.org
Subject: - scripts-package-allow-custom-options-to-rpm.patch removed from -mm tree
Date: Sat, 06 Dec 2008 16:05:08 -0800
Message-ID: <200812070005.mB7058G8021181@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753523AbYLGAFS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 6 Dec 2008 19:05:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jk@ozlabs.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     scripts/package: allow custom options to rpm
has been removed from the -mm tree.  Its filename was
     scripts-package-allow-custom-options-to-rpm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/package: allow custom options to rpm
From: Jeremy Kerr <jk@ozlabs.org>

Add a RPMOPTS make variable to allow arbitrary options to be passed
to rpm during 'make rpm-pkg'. For example:

 make RPMOPTS="--define '_topdir /home/jk/rpm'" rpm-pkg

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/package/Makefile |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN scripts/package/Makefile~scripts-package-allow-custom-options-to-rpm scripts/package/Makefile
--- a/scripts/package/Makefile~scripts-package-allow-custom-options-to-rpm
+++ a/scripts/package/Makefile
@@ -47,7 +47,7 @@ rpm-pkg rpm: $(objtree)/kernel.spec FORC
 	set -e; \
 	mv -f $(objtree)/.tmp_version $(objtree)/.version
 
-	$(RPM) --target $(UTS_MACHINE) -ta ../$(KERNELPATH).tar.gz
+	$(RPM) $(RPMOPTS) --target $(UTS_MACHINE) -ta ../$(KERNELPATH).tar.gz
 	rm ../$(KERNELPATH).tar.gz
 
 clean-files := $(objtree)/kernel.spec
@@ -64,7 +64,8 @@ binrpm-pkg: $(objtree)/binkernel.spec FO
 	set -e; \
 	mv -f $(objtree)/.tmp_version $(objtree)/.version
 
-	$(RPM) --define "_builddir $(srctree)" --target $(UTS_MACHINE) -bb $<
+	$(RPM) $(RPMOPTS) --define "_builddir $(srctree)" --target \
+		$(UTS_MACHINE) -bb $<
 
 clean-files += $(objtree)/binkernel.spec
 
_

Patches currently in -mm which might be from jk@ozlabs.org are

linux-next.patch
fix-similar-typos-to-successfull-v2.patch

