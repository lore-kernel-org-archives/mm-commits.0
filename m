From: akpm@linux-foundation.org
Subject: + dont-clean-boundsh-and-asm-offsetsh.patch added to -mm tree
Date: Mon, 19 May 2008 15:54:50 -0700
Message-ID: <200805192254.m4JMso88025226@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753531AbYESWy7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 18:54:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, clameter@sgi.com, sam@ravnborg.org


The patch titled
     kbuild: don't clean bounds.h and asm-offsets.h
has been added to the -mm tree.  Its filename is
     dont-clean-boundsh-and-asm-offsetsh.patch

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
