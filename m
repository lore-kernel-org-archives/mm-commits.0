From: akpm@linux-foundation.org
Subject: + hrtimer-reorder-struct-hrtimer-to-save-8-bytes-on-64-bit-builds.patch added to -mm tree
Date: Thu, 14 Aug 2008 01:59:11 -0700
Message-ID: <200808140859.m7E8xBWE000428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752298AbYHNI7V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 04:59:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@rsk.demon.co.uk, tglx@linutronix.de


The patch titled
     hrtimer: reorder struct hrtimer to save 8 bytes on 64 bit builds
has been added to the -mm tree.  Its filename is
     hrtimer-reorder-struct-hrtimer-to-save-8-bytes-on-64-bit-builds.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -115,12 +115,12 @@ struct hrtimer {
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

hrtimer-reorder-struct-hrtimer-to-save-8-bytes-on-64-bit-builds.patch

