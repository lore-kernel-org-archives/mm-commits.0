From: akpm@linux-foundation.org
Subject: + xtensa-fix-incorrect-memset.patch added to -mm tree
Date: Tue, 10 Jul 2012 13:16:28 -0700
Message-ID: <20120710201628.9A8EF1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:43218 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab2GJUQ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jul 2012 16:16:29 -0400
Received: by vcbfl13 with SMTP id fl13so45358vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jul 2012 13:16:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@linux.intel.com, chris@zankel.net, dcb314@hotmail.com


The patch titled
     Subject: xtensa: fix incorrect memset
has been added to the -mm tree.  Its filename is
     xtensa-fix-incorrect-memset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alan Cox <alan@linux.intel.com>
Subject: xtensa: fix incorrect memset

Addresses: https://bugzilla.kernel.org/show_bug.cgi?id=43871
Reported-by: <dcb314@hotmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/xtensa/kernel/process.c~xtensa-fix-incorrect-memset arch/xtensa/kernel/process.c
--- a/arch/xtensa/kernel/process.c~xtensa-fix-incorrect-memset
+++ a/arch/xtensa/kernel/process.c
@@ -277,7 +277,7 @@ void xtensa_elf_core_copy_regs (xtensa_g
 
 	/* Don't leak any random bits. */
 
-	memset(elfregs, 0, sizeof (elfregs));
+	memset(elfregs, 0, sizeof(*elfregs));
 
 	/* Note:  PS.EXCM is not set while user task is running; its
 	 * being set in regs->ps is for exception handling convenience.
_
Subject: Subject: xtensa: fix incorrect memset

Patches currently in -mm which might be from alan@linux.intel.com are

linux-next.patch
xtensa-fix-incorrect-memset.patch
fs-make-dumpable=2-require-fully-qualified-path.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
kernel-sysc-fix-mishandling-of-out-of-memory-in-poweroff.patch

