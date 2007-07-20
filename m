From: akpm@linux-foundation.org
Subject: + fallout-from-kbuild-changes.patch added to -mm tree
Date: Thu, 19 Jul 2007 18:26:44 -0700
Message-ID: <200707200126.l6K1QiYW000576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60057 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934006AbXGTB11 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 21:27:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viro@ftp.linux.org.uk, viro@zeniv.linux.org.uk


The patch titled
     fallout from kbuild changes
has been added to the -mm tree.  Its filename is
     fallout-from-kbuild-changes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fallout from kbuild changes
From: Al Viro <viro@ftp.linux.org.uk>

Change in 'kbuild: do section mismatch check on full vmlinux' should've
been replicated in arch/um/Makefile.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Makefile |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/Makefile~fallout-from-kbuild-changes arch/um/Makefile
--- a/arch/um/Makefile~fallout-from-kbuild-changes
+++ a/arch/um/Makefile
@@ -146,7 +146,7 @@ define cmd_vmlinux__
 	-Wl,-T,$(vmlinux-lds) $(vmlinux-init) \
 	-Wl,--start-group $(vmlinux-main) -Wl,--end-group \
 	-lutil \
-	$(filter-out $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) \
+	$(filter-out $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o \
 	FORCE ,$^) ; rm -f linux
 endef
 
_

Patches currently in -mm which might be from viro@ftp.linux.org.uk are

origin.patch
coda-breakage.patch
fallout-from-kbuild-changes.patch
introduce-i_sync.patch
slab-leaks3-default-y.patch
