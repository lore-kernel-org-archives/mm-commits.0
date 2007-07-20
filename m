From: akpm@linux-foundation.org
Subject: + i386-mark-pit_clockevent-static.patch added to -mm tree
Date: Fri, 20 Jul 2007 13:42:47 -0700
Message-ID: <200707202042.l6KKglJo015511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48062 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757202AbXGTUnk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 16:43:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: josht@linux.vnet.ibm.com, ak@suse.de, josh@kernel.org


The patch titled
     i386: mark pit_clockevent static
has been added to the -mm tree.  Its filename is
     i386-mark-pit_clockevent-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: mark pit_clockevent static
From: Josh Triplett <josht@linux.vnet.ibm.com>

Nothing outside of arch/i386/kernel/i8253.c uses pit_clockevent, so mark it
static.

Eliminates a sparse warning:
warning: symbol 'pit_clockevent' was not declared. Should it be static?

Signed-off-by: Josh Triplett <josh@kernel.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/i8253.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/i8253.c~i386-mark-pit_clockevent-static arch/i386/kernel/i8253.c
--- a/arch/i386/kernel/i8253.c~i386-mark-pit_clockevent-static
+++ a/arch/i386/kernel/i8253.c
@@ -91,7 +91,7 @@ static int pit_next_event(unsigned long 
  * registered. This mechanism replaces the previous #ifdef LOCAL_APIC -
  * !using_apic_timer decisions in do_timer_interrupt_hook()
  */
-struct clock_event_device pit_clockevent = {
+static struct clock_event_device pit_clockevent = {
 	.name		= "pit",
 	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
 	.set_mode	= init_pit_timer,
_

Patches currently in -mm which might be from josht@linux.vnet.ibm.com are

origin.patch
i386-mark-pit_clockevent-static.patch
