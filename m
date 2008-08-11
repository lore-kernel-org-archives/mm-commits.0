From: akpm@linux-foundation.org
Subject: + scripts-package-allow-custom-options-to-rpm.patch added to -mm tree
Date: Mon, 11 Aug 2008 13:30:55 -0700
Message-ID: <200808112030.m7BKUtwT019872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753039AbYHKUbM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 16:31:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jk@ozlabs.org, sam@ravnborg.org


The patch titled
     scripts/package: allow custom options to rpm
has been added to the -mm tree.  Its filename is
     scripts-package-allow-custom-options-to-rpm.patch

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

scripts-package-dont-break-if-%_smp_mflags-isnt-set.patch
scripts-package-allow-custom-options-to-rpm.patch

