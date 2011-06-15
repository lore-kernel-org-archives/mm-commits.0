From: akpm@linux-foundation.org
Subject: + kbuild-call-depmodsh-via-shell.patch added to -mm tree
Date: Wed, 15 Jun 2011 13:38:00 -0700
Message-ID: <201106152038.p5FKc2gG017943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751313Ab1FOUiI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jun 2011 16:38:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mmarek@suse.cz, penguin-kernel@I-love.SAKURA.ne.jp


The patch titled
     kbuild: call depmod.sh via shell
has been added to the -mm tree.  Its filename is
     kbuild-call-depmodsh-via-shell.patch

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
Subject: kbuild: call depmod.sh via shell
From: Michal Marek <mmarek@suse.cz>

The script has the executable bit in git, but plain old patch(1) can't
create executable files.

Signed-off-by: Michal Marek <mmarek@suse.cz>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN Makefile~kbuild-call-depmodsh-via-shell Makefile
--- a/Makefile~kbuild-call-depmodsh-via-shell
+++ a/Makefile
@@ -1526,7 +1526,8 @@ quiet_cmd_rmfiles = $(if $(wildcard $(rm
 
 # Run depmod only if we have System.map and depmod is executable
 quiet_cmd_depmod = DEPMOD  $(KERNELRELEASE)
-      cmd_depmod = $(srctree)/scripts/depmod.sh $(DEPMOD) $(KERNELRELEASE)
+      cmd_depmod = $(CONFIG_SHELL) $(srctree)/scripts/depmod.sh $(DEPMOD) \
+                   $(KERNELRELEASE)
 
 # Create temporary dir for module support files
 # clean it up only when building all modules
_

Patches currently in -mm which might be from mmarek@suse.cz are

linux-next.patch
kbuild-call-depmodsh-via-shell.patch

