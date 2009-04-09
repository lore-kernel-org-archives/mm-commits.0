From: akpm@linux-foundation.org
Subject: + timers-add-missing-kernel-doc.patch added to -mm tree
Date: Thu, 09 Apr 2009 12:41:18 -0700
Message-ID: <200904091941.n39JfIkv021964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935762AbZDITrL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 15:47:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, johannes@sipsolutions.net, mingo@elte.hu, tglx@linutronix.de


The patch titled
     timers: add missing kernel-doc
has been added to the -mm tree.  Its filename is
     timers-add-missing-kernel-doc.patch

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
Subject: timers: add missing kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Add missing kernel-doc parameter notation and change function name to its
new name:

Warning(kernel/timer.c:543): No description found for parameter 'name'
Warning(kernel/timer.c:543): No description found for parameter 'key'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN kernel/timer.c~timers-add-missing-kernel-doc kernel/timer.c
--- a/kernel/timer.c~timers-add-missing-kernel-doc
+++ a/kernel/timer.c
@@ -531,10 +531,13 @@ static void __init_timer(struct timer_li
 }
 
 /**
- * init_timer - initialize a timer.
+ * init_timer_key - initialize a timer
  * @timer: the timer to be initialized
+ * @name: name of the timer
+ * @key: lockdep class key of the fake lock used for tracking timer
+ *       sync lock dependencies
  *
- * init_timer() must be done to a timer prior calling *any* of the
+ * init_timer_key() must be done to a timer prior calling *any* of the
  * other timer functions.
  */
 void init_timer_key(struct timer_list *timer,
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
maintainers-fix-email-address.patch
linux-next.patch
timers-add-missing-kernel-doc.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
sysctl-lockdep-support-for-sysctl-reference-counting-fix.patch
qla2x-fix-printk-format-warnings.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization-fix.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

