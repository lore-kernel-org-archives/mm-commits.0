From: akpm@linux-foundation.org
Subject: - cris-turn-local_save_flags-local_irq_disable-into-local_irq_save-in-headers.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:48:07 -0800
Message-ID: <200702112248.l1BMm7Ep015599@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59700 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932663AbXBKWsV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:48:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     CRIS: turn local_save_flags() + local_irq_disable() into local_irq_save() in headers
has been removed from the -mm tree.  Its filename was
     cris-turn-local_save_flags-local_irq_disable-into-local_irq_save-in-headers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CRIS: turn local_save_flags() + local_irq_disable() into local_irq_save() in headers
From: Jiri Kosina <jkosina@suse.cz>

Various headers for CRIS architecture contain local_irq_disable() after
local_save_flags().  Turn it into local_irq_save().

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Mikael Starvik <starvik@axis.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-cris/semaphore-helper.h |    9 +++------
 include/asm-cris/system.h           |    3 +--
 2 files changed, 4 insertions(+), 8 deletions(-)

diff -puN include/asm-cris/semaphore-helper.h~cris-turn-local_save_flags-local_irq_disable-into-local_irq_save-in-headers include/asm-cris/semaphore-helper.h
--- a/include/asm-cris/semaphore-helper.h~cris-turn-local_save_flags-local_irq_disable-into-local_irq_save-in-headers
+++ a/include/asm-cris/semaphore-helper.h
@@ -30,8 +30,7 @@ static inline int waking_non_zero(struct
 	unsigned long flags;
 	int ret = 0;
 
-	local_save_flags(flags);
-	local_irq_disable();
+	local_irq_save(flags);
 	if (read(&sem->waking) > 0) {
 		dec(&sem->waking);
 		ret = 1;
@@ -46,8 +45,7 @@ static inline int waking_non_zero_interr
 	int ret = 0;
 	unsigned long flags;
 
-	local_save_flags(flags);
-	local_irq_disable();
+	local_irq_save(flags);
 	if (read(&sem->waking) > 0) {
 		dec(&sem->waking);
 		ret = 1;
@@ -64,8 +62,7 @@ static inline int waking_non_zero_tryloc
         int ret = 1;
 	unsigned long flags;
 
-	local_save_flags(flags);
-	local_irq_disable();
+	local_irq_save(flags);
 	if (read(&sem->waking) <= 0)
 		inc(&sem->count);
 	else {
diff -puN include/asm-cris/system.h~cris-turn-local_save_flags-local_irq_disable-into-local_irq_save-in-headers include/asm-cris/system.h
--- a/include/asm-cris/system.h~cris-turn-local_save_flags-local_irq_disable-into-local_irq_save-in-headers
+++ a/include/asm-cris/system.h
@@ -44,8 +44,7 @@ static inline unsigned long __xchg(unsig
   /* since Etrax doesn't have any atomic xchg instructions, we need to disable
      irq's (if enabled) and do it with move.d's */
   unsigned long flags,temp;
-  local_save_flags(flags); /* save flags, including irq enable bit */
-  local_irq_disable();             /* shut off irq's */
+  local_irq_save(flags); /* save flags, including irq enable bit and shut off irqs */
   switch (size) {
   case 1:
     *((unsigned char *)&temp) = x;
_

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
git-alsa.patch
git-hid.patch
git-ipwireless_cs.patch
ds1302-local_irq_disable-is-redundant-after-local_irq_save.patch
sysctl-mac_hid-remove-unnecessary-insert_at_head-flag.patch
