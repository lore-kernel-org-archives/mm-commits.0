From: akpm@linux-foundation.org
Subject: + kbuild-clean-up-marker.patch added to -mm tree
Date: Thu, 19 Nov 2009 15:10:40 -0800
Message-ID: <200911192310.nAJNAeSI026336@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756398AbZKSXKs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Nov 2009 18:10:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wenji.huang@oracle.com, rusty@rustcorp.com.au, sam@ravnborg.org


The patch titled
     kbuild: clean up marker
has been added to the -mm tree.  Its filename is
     kbuild-clean-up-marker.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kbuild: clean up marker
From: Wenji Huang <wenji.huang@oracle.com>

Drop Module.markers from cleaning list since marker is removed.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN Makefile~kbuild-clean-up-marker Makefile
--- a/Makefile~kbuild-clean-up-marker
+++ a/Makefile
@@ -1169,7 +1169,7 @@ CLEAN_FILES +=	vmlinux System.map \
 MRPROPER_DIRS  += include/config usr/include include/generated
 MRPROPER_FILES += .config .config.old .version .old_version             \
                   include/linux/version.h                               \
-		  Module.symvers Module.markers tags TAGS cscope*
+		  Module.symvers tags TAGS cscope*
 
 # clean - Delete most, but leave enough to build external modules
 #
@@ -1188,7 +1188,7 @@ clean: archclean $(clean-dirs)
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
 		-o -name '*.symtypes' -o -name 'modules.order' \
-		-o -name 'modules.builtin' -o -name 'Module.markers' \
+		-o -name 'modules.builtin' \
 		-o -name '.tmp_*.o.*' -o -name '*.gcno' \) \
 		-type f -print | xargs rm -f
 
@@ -1387,7 +1387,6 @@ $(clean-dirs):
 
 clean:	rm-dirs := $(MODVERDIR)
 clean: rm-files := $(KBUILD_EXTMOD)/Module.symvers \
-                   $(KBUILD_EXTMOD)/Module.markers \
                    $(KBUILD_EXTMOD)/modules.order \
                    $(KBUILD_EXTMOD)/modules.builtin
 clean: $(clean-dirs)
_

Patches currently in -mm which might be from wenji.huang@oracle.com are

kbuild-clean-up-marker.patch
kbuild-clear-marker-out-of-modpost.patch

