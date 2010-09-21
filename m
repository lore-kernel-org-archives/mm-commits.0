From: akpm@linux-foundation.org
Subject: + perf-x86-fix-up-kmap_atomic-type.patch added to -mm tree
Date: Tue, 21 Sep 2010 16:04:06 -0700
Message-ID: <201009212304.o8LN46ew008079@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751484Ab0IUXFP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 19:05:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, benh@kernel.crashing.org, cmetcalf@tilera.com, davem@davemloft.net, dhowells@redhat.com, hpa@zytor.com, hughd@google.com, mingo@elte.hu, paulus@samba.org, ralf@linux-mips.org, riel@redhat.com, rmk@arm.linux.org.uk, rostedt@goodmis.org, tglx@linutronix.de


The patch titled
     perf, x86: Fix up kmap_atomic() type
has been added to the -mm tree.  Its filename is
     perf-x86-fix-up-kmap_atomic-type.patch

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
Subject: perf, x86: Fix up kmap_atomic() type
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Now that the KM_type stuff is history, clean up the compiler warning.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Miller <davem@davemloft.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/perf_event.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/x86/kernel/cpu/perf_event.c~perf-x86-fix-up-kmap_atomic-type arch/x86/kernel/cpu/perf_event.c
--- a/arch/x86/kernel/cpu/perf_event.c~perf-x86-fix-up-kmap_atomic-type
+++ a/arch/x86/kernel/cpu/perf_event.c
@@ -49,7 +49,6 @@ static unsigned long
 copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 {
 	unsigned long offset, addr = (unsigned long)from;
-	int type = in_nmi() ? KM_NMI : KM_IRQ0;
 	unsigned long size, len = 0;
 	struct page *page;
 	void *map;
@@ -63,9 +62,9 @@ copy_from_user_nmi(void *to, const void 
 		offset = addr & (PAGE_SIZE - 1);
 		size = min(PAGE_SIZE - offset, n - len);
 
-		map = kmap_atomic(page, type);
+		map = kmap_atomic(page);
 		memcpy(to, map+offset, size);
-		kunmap_atomic(map, type);
+		kunmap_atomic(map);
 		put_page(page);
 
 		len  += size;
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

linux-next.patch
gcc-46-perf-fix-set-but-unused-variables-in-perf.patch
mm-strictly-nested-kmap_atomic.patch
mm-stack-based-kmap_atomic.patch
mm-stack-based-kmap_atomic-checkpatch-fixes.patch
mm-remove-pte_map_nested.patch
perf-x86-fix-up-kmap_atomic-type.patch
mm-highmem-documentation.patch
kernel-remove-pf_flusher.patch

