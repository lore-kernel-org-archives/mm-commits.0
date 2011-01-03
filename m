From: akpm@linux-foundation.org
Subject: + brk-fix-min_brk-lower-bound-computation-for-compat_brk.patch added to -mm tree
Date: Mon, 03 Jan 2011 11:45:57 -0800
Message-ID: <201101031945.p03Jjvjw025141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752966Ab1ACTqY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jan 2011 14:46:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkosina@suse.cz, geert@linux-m68k.org, mingo@elte.hu


The patch titled
     brk: fix min_brk lower bound computation for COMPAT_BRK
has been added to the -mm tree.  Its filename is
     brk-fix-min_brk-lower-bound-computation-for-compat_brk.patch

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
Subject: brk: fix min_brk lower bound computation for COMPAT_BRK
From: Jiri Kosina <jkosina@suse.cz>

Even if CONFIG_COMPAT_BRK is set in the kernel configuration, it can still
be overriden by randomize_va_space sysctl.

If this is the case, the min_brk computation in sys_brk() implementation
is wrong, as it solely takes into account COMPAT_BRK setting, assuming
that brk start is not randomized.  But that might not be the case if
randomize_va_space sysctl has been set to '2' at the time the binary has
been loaded from disk.

In such case, the check has to be done in a same way as in
!CONFIG_COMPAT_BRK case.

In addition to that, the check for the COMPAT_BRK case introduced back in
a5b4592c ("brk: make sys_brk() honor COMPAT_BRK when computing lower
bound") is slightly wrong -- the lower bound shouldn't be mm->end_code,
but mm->end_data instead, as that's where the legacy applications expect
brk section to start (i.e.  immediately after last global variable).

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN mm/mmap.c~brk-fix-min_brk-lower-bound-computation-for-compat_brk mm/mmap.c
--- a/mm/mmap.c~brk-fix-min_brk-lower-bound-computation-for-compat_brk
+++ a/mm/mmap.c
@@ -254,7 +254,15 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 	down_write(&mm->mmap_sem);
 
 #ifdef CONFIG_COMPAT_BRK
-	min_brk = mm->end_code;
+	/*
+	 * CONFIG_COMPAT_BRK can still be overridden by setting
+	 * randomize_va_space to 2, which will still make mm->start_brk
+	 * to be arbitrarily shifted
+	 */
+	if (mm->start_brk > PAGE_ALIGN(mm->end_data))
+		min_brk = mm->start_brk;
+	else
+		min_brk = mm->end_data;
 #else
 	min_brk = mm->start_brk;
 #endif
_

Patches currently in -mm which might be from jkosina@suse.cz are

linux-next.patch
brk-fix-min_brk-lower-bound-computation-for-compat_brk.patch
brk-fix-min_brk-lower-bound-computation-for-compat_brk-fix.patch
jbd-remove-dependency-on-__gfp_nofail.patch

