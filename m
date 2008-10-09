From: akpm@linux-foundation.org
Subject: - hrtimer-reorder-struct-hrtimer-to-save-8-bytes-on-64-bit-builds.patch removed from -mm tree
Date: Thu, 09 Oct 2008 15:27:14 -0700
Message-ID: <200810092227.m99MRESU005938@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60687 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750816AbYJIW12 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 18:27:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@rsk.demon.co.uk, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     hrtimer: reorder struct hrtimer to save 8 bytes on 64 bit builds
has been removed from the -mm tree.  Its filename was
     hrtimer-reorder-struct-hrtimer-to-save-8-bytes-on-64-bit-builds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hrtimer: reorder struct hrtimer to save 8 bytes on 64 bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>

reorder struct hrtimer to save 8 bytes on 64 bit builds when
CONFIG_TIMER_STATS selected.  (also removes 8 bytes from signal_struct)

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hrtimer.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/hrtimer.h~hrtimer-reorder-struct-hrtimer-to-save-8-bytes-on-64-bit-builds include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~hrtimer-reorder-struct-hrtimer-to-save-8-bytes-on-64-bit-builds
+++ a/include/linux/hrtimer.h
@@ -116,12 +116,12 @@ struct hrtimer {
 	enum hrtimer_restart		(*function)(struct hrtimer *);
 	struct hrtimer_clock_base	*base;
 	unsigned long			state;
-	enum hrtimer_cb_mode		cb_mode;
 	struct list_head		cb_entry;
+	enum hrtimer_cb_mode		cb_mode;
 #ifdef CONFIG_TIMER_STATS
+	int				start_pid;
 	void				*start_site;
 	char				start_comm[16];
-	int				start_pid;
 #endif
 };
 
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

git-tip.patch
git-nfs.patch
libata-reorder-ata_device-to-remove-8-bytes-of-padding-on-64-bits.patch

