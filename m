From: akpm@linux-foundation.org
Subject: - i386-stop-bogus-nmi-softlockup-warnings-in-show_mem.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:07:47 -0700
Message-ID: <200710180707.l9I77lNd031731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57280 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759642AbXJRHI0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:08:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prarit@redhat.com, ak@suse.de, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     i386: stop bogus nmi & softlockup warnings in show_mem
has been removed from the -mm tree.  Its filename was
     i386-stop-bogus-nmi-softlockup-warnings-in-show_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: stop bogus nmi & softlockup warnings in show_mem
From: Prarit Bhargava <prarit@redhat.com>

When dumping memory via sysrq-m it is possible to take a bogus NMI watchdog
or softlockup watchdog because the dump can take a long time on big memory
systems.

Occasionally tickle the watchdog when doing the dump.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mm/pgtable.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/i386/mm/pgtable.c~i386-stop-bogus-nmi-softlockup-warnings-in-show_mem arch/i386/mm/pgtable.c
--- a/arch/x86/mm/pgtable_32.c~i386-stop-bogus-nmi-softlockup-warnings-in-show_mem
+++ a/arch/x86/mm/pgtable_32.c
@@ -6,6 +6,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/mm.h>
+#include <linux/nmi.h>
 #include <linux/swap.h>
 #include <linux/smp.h>
 #include <linux/highmem.h>
@@ -39,6 +40,8 @@ void show_mem(void)
 	for_each_online_pgdat(pgdat) {
 		pgdat_resize_lock(pgdat, &flags);
 		for (i = 0; i < pgdat->node_spanned_pages; ++i) {
+			if (unlikely(i % MAX_ORDER_NR_PAGES == 0))
+				touch_nmi_watchdog();
 			page = pgdat_page_nr(pgdat, i);
 			total++;
 			if (PageHighMem(page))
_

Patches currently in -mm which might be from prarit@redhat.com are

origin.patch
