From: akpm@linux-foundation.org
Subject: + dont-assume-arguments-to-init-have-no-period-in-them.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:58:49 -0800
Message-ID: <200702272058.l1RKwrT6028406@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51993 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbXB0U7A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:59:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rob@landley.net, rusty@rustcorp.com.au


The patch titled
     Don't assume arguments to init have no period in them.
has been added to the -mm tree.  Its filename is
     dont-assume-arguments-to-init-have-no-period-in-them.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Don't assume arguments to init have no period in them.
From: Rob Landley <rob@landley.net>

The kernel assumes that nobody will ever legitimately feed in a kernel
command line option with a period in it, and the kernel is wrong: I'm
feeding the path to a script as an argument to my init program, the name of
the script ends in .sh.

I've been using this patch ever since 2.6.13, and I still need it.

Signed-off-by: Rob Landley <rob@landley.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN init/main.c~dont-assume-arguments-to-init-have-no-period-in-them init/main.c
--- a/init/main.c~dont-assume-arguments-to-init-have-no-period-in-them
+++ a/init/main.c
@@ -273,15 +273,6 @@ static int __init unknown_bootoption(cha
 	if (obsolete_checksetup(param))
 		return 0;
 
-	/*
-	 * Preemptive maintenance for "why didn't my mispelled command
-	 * line work?"
-	 */
-	if (strchr(param, '.') && (!val || strchr(param, '.') < val)) {
-		printk(KERN_ERR "Unknown boot option `%s': ignoring\n", param);
-		return 0;
-	}
-
 	if (panic_later)
 		return 0;
 
_

Patches currently in -mm which might be from rob@landley.net are

dont-assume-arguments-to-init-have-no-period-in-them.patch
