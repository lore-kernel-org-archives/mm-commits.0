From: akpm@linux-foundation.org
Subject: [merged] brk-fix-min_brk-lower-bound-computation-for-compat_brk.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:49:00 -0800
Message-ID: <201101142251.p0EMpohN005550@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753449Ab1ANWwG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:52:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, geert@linux-m68k.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     brk: fix min_brk lower bound computation for COMPAT_BRK
has been removed from the -mm tree.  Its filename was
     brk-fix-min_brk-lower-bound-computation-for-compat_brk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: fix comment]
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
+	 * randomize_va_space to 2, which will still cause mm->start_brk
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

origin.patch
linux-next.patch
jbd-remove-dependency-on-__gfp_nofail.patch

