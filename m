From: akpm@linux-foundation.org
Subject: + clean-modulessymvers-in-external-module-dirs.patch added to -mm tree
Date: Wed, 01 Aug 2007 15:23:34 -0700
Message-ID: <200708012223.l71MNY3I020469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51748 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753752AbXHAWXu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2007 18:23:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, sam@ravnborg.org


The patch titled
     clean Modules.symvers in external module dirs
has been added to the -mm tree.  Its filename is
     clean-modulessymvers-in-external-module-dirs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
clean-modulessymvers-in-external-module-dirs.patch
x86_64-hide-cond_syscall-behind-__kernel__.patch
printk-add-interfaces-for-external-access-to-the-log-buffer.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
