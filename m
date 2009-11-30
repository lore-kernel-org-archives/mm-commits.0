From: akpm@linux-foundation.org
Subject: [merged] kbuild-clean-up-marker.patch removed from -mm tree
Date: Mon, 30 Nov 2009 12:34:08 -0800
Message-ID: <200911302034.nAUKY8Hk022810@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753045AbZK3UfE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Nov 2009 15:35:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wenji.huang@oracle.com, anibal@debian.org, mmarek@suse.cz, rostedt@goodmis.org, rusty@rustcorp.com.au, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kbuild: clean up marker
has been removed from the -mm tree.  Its filename was
     kbuild-clean-up-marker.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

