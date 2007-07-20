From: akpm@linux-foundation.org
Subject: - fallout-from-kbuild-changes.patch removed from -mm tree
Date: Thu, 19 Jul 2007 23:43:10 -0700
Message-ID: <200707200643.l6K6hApS011950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59483 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751380AbXGTGnX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 02:43:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viro@ftp.linux.org.uk, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fallout from kbuild changes
has been removed from the -mm tree.  Its filename was
     fallout-from-kbuild-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
introduce-i_sync.patch
slab-leaks3-default-y.patch
