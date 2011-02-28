From: akpm@linux-foundation.org
Subject: + x86-fix-mmap-random-address-range.patch added to -mm tree
Date: Mon, 28 Feb 2011 15:18:43 -0800
Message-ID: <201102282318.p1SNIh9P003449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753620Ab1B1XTb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Feb 2011 18:19:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ludwig.nussel@suse.de, harvey.harrison@gmail.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: fix mmap random address range
has been added to the -mm tree.  Its filename is
     x86-fix-mmap-random-address-range.patch

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
Subject: x86: fix mmap random address range
From: Ludwig Nussel <ludwig.nussel@suse.de>

On x86 casting the unsigned int result of get_random_int() to long may
result in a negative value.  On x86 the range of mmap_rnd() therefore was
-255 to 255.  The 32bit mode on x86_64 used 0 to 255 as intended.

The bug was introduced by 675a081 ("x86: unify mmap_{32|64}.c") in January
2008.

Signed-off-by: Ludwig Nussel <ludwig.nussel@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/mm/mmap.c~x86-fix-mmap-random-address-range arch/x86/mm/mmap.c
--- a/arch/x86/mm/mmap.c~x86-fix-mmap-random-address-range
+++ a/arch/x86/mm/mmap.c
@@ -87,9 +87,9 @@ static unsigned long mmap_rnd(void)
 	*/
 	if (current->flags & PF_RANDOMIZE) {
 		if (mmap_is_ia32())
-			rnd = (long)get_random_int() % (1<<8);
+			rnd = get_random_int() % (1<<8);
 		else
-			rnd = (long)(get_random_int() % (1<<28));
+			rnd = get_random_int() % (1<<28);
 	}
 	return rnd << PAGE_SHIFT;
 }
_

Patches currently in -mm which might be from ludwig.nussel@suse.de are

x86-fix-mmap-random-address-range.patch

