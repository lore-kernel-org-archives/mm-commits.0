From: akpm@linux-foundation.org
Subject: - dont-clean-boundsh-and-asm-offsetsh.patch removed from -mm tree
Date: Tue, 20 May 2008 14:13:48 -0700
Message-ID: <200805202113.m4KLDmTr011404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756736AbYETVOb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 17:14:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jblunck@suse.de, clameter@sgi.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kbuild: don't clean bounds.h and asm-offsets.h
has been removed from the -mm tree.  Its filename was
     dont-clean-boundsh-and-asm-offsetsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kbuild: don't clean bounds.h and asm-offsets.h
From: Jan Blunck <jblunck@suse.de>

Since 97965478a66fbdf0f4ad5e4ecc4828f0cb548a45 mmzone.h includes bounds.h.
Calling make clean after make prepare removes bounds.h again so when
building external modules this fails.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Kbuild   |    3 +--
 Makefile |    1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN Kbuild~dont-clean-boundsh-and-asm-offsetsh Kbuild
--- a/Kbuild~dont-clean-boundsh-and-asm-offsetsh
+++ a/Kbuild
@@ -96,5 +96,4 @@ missing-syscalls: scripts/checksyscalls.
 	$(call cmd,syscalls)
 
 # Delete all targets during make clean
-clean-files := $(addprefix $(objtree)/,$(targets))
