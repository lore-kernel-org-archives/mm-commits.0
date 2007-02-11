From: akpm@linux-foundation.org
Subject: - cris-local_irq_disable-is-redundant-after-local_irq_save.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:48:05 -0800
Message-ID: <200702112248.l1BMm5CE015596@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59701 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932670AbXBKWsV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:48:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     CRIS: local_irq_disable() is redundant after local_irq_save()
has been removed from the -mm tree.  Its filename was
     cris-local_irq_disable-is-redundant-after-local_irq_save.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CRIS: local_irq_disable() is redundant after local_irq_save()
From: Jiri Kosina <jkosina@suse.cz>

arch/cris/arch-v10/kernel/time.c::get_ns_in_jiffie() contains
local_irq_disable() call after local_irq_save().  This looks redundant.

arch/cris/kernel/time.c::do_gettimeofday() contains local_irq_disable() call
after local_irq_save().  This looks redundant.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/kernel/time.c |    1 -
 arch/cris/kernel/time.c          |    1 -
 2 files changed, 2 deletions(-)

diff -puN arch/cris/arch-v10/kernel/time.c~cris-local_irq_disable-is-redundant-after-local_irq_save arch/cris/arch-v10/kernel/time.c
--- a/arch/cris/arch-v10/kernel/time.c~cris-local_irq_disable-is-redundant-after-local_irq_save
+++ a/arch/cris/arch-v10/kernel/time.c
@@ -38,7 +38,6 @@ unsigned long get_ns_in_jiffie(void)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	local_irq_disable();
 	timer_count = *R_TIMER0_DATA;
 	presc_count = *R_TIM_PRESC_STATUS;  
 	/* presc_count might be wrapped */
diff -puN arch/cris/kernel/time.c~cris-local_irq_disable-is-redundant-after-local_irq_save arch/cris/kernel/time.c
--- a/arch/cris/kernel/time.c~cris-local_irq_disable-is-redundant-after-local_irq_save
+++ a/arch/cris/kernel/time.c
@@ -55,7 +55,6 @@ void do_gettimeofday(struct timeval *tv)
 	unsigned long flags;
 	signed long usec, sec;
 	local_irq_save(flags);
-	local_irq_disable();
 	usec = do_gettimeoffset();
 
         /*
_

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
git-alsa.patch
git-hid.patch
git-ipwireless_cs.patch
ds1302-local_irq_disable-is-redundant-after-local_irq_save.patch
sysctl-mac_hid-remove-unnecessary-insert_at_head-flag.patch
