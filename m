From: akpm@linux-foundation.org
Subject: - i386-and-x86_64-randomize-brk-fix-2.patch removed from -mm tree
Date: Mon, 19 Nov 2007 15:16:29 -0800
Message-ID: <200711192316.lAJNGTi2001775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60732 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751639AbXKSXRw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 18:17:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, arjan@infradead.org, hugh@veritas.com, jakub@redhat.com, mingo@elte.hu, roland@redhat.com, safari-kernel@safari.iki.fi, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     brk randomization: compute RLIMIT_DATA properly
has been removed from the -mm tree.  Its filename was
     i386-and-x86_64-randomize-brk-fix-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: brk randomization: compute RLIMIT_DATA properly
From: Jiri Kosina <jkosina@suse.cz>

In cases of heap area placed at randomly-generated offset from mm->end_data
(arch_randomize_brk()), we need to subtract the value of the offset for
setrlimit(RLIMIT_DATA) to work properly -- otherwise we count the
unoccupied memory between mm->end_data and mm->start_brk as occupied.

Tested-by: Sami Farin <safari-kernel@safari.iki.fi>
Acked-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/mmap.c~i386-and-x86_64-randomize-brk-fix-2 mm/mmap.c
--- a/mm/mmap.c~i386-and-x86_64-randomize-brk-fix-2
+++ a/mm/mmap.c
@@ -251,7 +251,8 @@ asmlinkage unsigned long sys_brk(unsigne
 	 * not page aligned -Ram Gupta
 	 */
 	rlim = current->signal->rlim[RLIMIT_DATA].rlim_cur;
-	if (rlim < RLIM_INFINITY && brk - mm->start_data > rlim)
+	if (rlim < RLIM_INFINITY && (brk - mm->start_brk) +
+			(mm->end_data - mm->start_data) > rlim)
 		goto out;
 
 	newbrk = PAGE_ALIGN(brk);
_

Patches currently in -mm which might be from jkosina@suse.cz are

git-hid.patch
make-wistron-btns-recognize-special-keys-on-medion-wim2160-notebooks.patch
fujitsu-application-panel-driver.patch
fujitsu-application-panel-driver-space-savings.patch
elantech-touchpad-driver.patch
elantech-touchpad-driver-fix.patch
usbserial-fix-inconsistent-lock-state.patch
git-ipwireless_cs.patch
git-x86.patch
rtc-convert-mutex-to-bitfield.patch
pie-executable-randomization.patch
pie-executable-randomization-uninlining.patch
pie-executable-randomization-checkpatch-fixes.patch
