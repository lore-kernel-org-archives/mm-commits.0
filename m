From: akpm@linux-foundation.org
Subject: - clean-modulessymvers-in-external-module-dirs.patch removed from -mm tree
Date: Thu, 30 Aug 2007 23:34:42 -0700
Message-ID: <200708310634.l7V6YgkA027720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44818 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757325AbXHaGes (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 02:34:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     clean Modules.symvers in external module dirs
has been removed from the -mm tree.  Its filename was
     clean-modulessymvers-in-external-module-dirs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: clean Modules.symvers in external module dirs
From: Mike Frysinger <vapier@gentoo.org>

At the moment, running `make clean` in an external module directory does a
nice job of cleaning up with one exception: it leaves behind Modules.symvers. 
Attached patch adds this file to the clean list for external modules.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    2 ++
 1 files changed, 2 insertions(+)

diff -puN Makefile~clean-modulessymvers-in-external-module-dirs Makefile
--- a/Makefile~clean-modulessymvers-in-external-module-dirs
+++ a/Makefile
@@ -1254,8 +1254,10 @@ $(clean-dirs):
 	$(Q)$(MAKE) $(clean)=$(patsubst _clean_%,%,$@)
 
 clean:	rm-dirs := $(MODVERDIR)
+clean: rm-files := $(KBUILD_EXTMOD)/Module.symvers
 clean: $(clean-dirs)
 	$(call cmd,rmdirs)
+	$(call cmd,rmfiles)
 	@find $(KBUILD_EXTMOD) $(RCS_FIND_IGNORE) \
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \) \
_

Patches currently in -mm which might be from vapier@gentoo.org are

git-kbuild.patch
printk-add-interfaces-for-external-access-to-the-log-buffer.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix-2.patch
add-stack-checking-for-blackfin.patch
