From: akpm@linux-foundation.org
Subject: + drivers-net-wireless-libertas-cfgc-needs-schedh.patch added to -mm tree
Date: Tue, 10 Aug 2010 16:32:05 -0700
Message-ID: <201008110002.o7B024BM024580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754014Ab0HKADN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Aug 2010 20:03:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, dcbw@redhat.com, linville@tuxdriver.com, mingo@elte.hu


The patch titled
     drivers/net/wireless/libertas/cfg.c: needs sched.h
has been added to the -mm tree.  Its filename is
     drivers-net-wireless-libertas-cfgc-needs-schedh.patch

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
Subject: drivers/net/wireless/libertas/cfg.c: needs sched.h
From: Andrew Morton <akpm@linux-foundation.org>

i386 allmodconfig:

drivers/net/wireless/libertas/cfg.c: In function 'lbs_scan_worker':
drivers/net/wireless/libertas/cfg.c:722: error: 'TASK_NORMAL' undeclared (first use in this function)
drivers/net/wireless/libertas/cfg.c:722: error: (Each undeclared identifier is reported only once
drivers/net/wireless/libertas/cfg.c:722: error: for each function it appears in.)
drivers/net/wireless/libertas/cfg.c: In function 'lbs_cfg_connect':
drivers/net/wireless/libertas/cfg.c:1267: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
drivers/net/wireless/libertas/cfg.c:1267: error: implicit declaration of function 'signal_pending'
drivers/net/wireless/libertas/cfg.c:1267: error: implicit declaration of function 'schedule_timeout'

So wait.h has a dependency on sched.h, but doesn't include sched.h.  This
patch doesn't fix that.

Cc: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/libertas/cfg.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/net/wireless/libertas/cfg.c~drivers-net-wireless-libertas-cfgc-needs-schedh drivers/net/wireless/libertas/cfg.c
--- a/drivers/net/wireless/libertas/cfg.c~drivers-net-wireless-libertas-cfgc-needs-schedh
+++ a/drivers/net/wireless/libertas/cfg.c
@@ -6,6 +6,8 @@
  *
  */
 
+#include <linux/sched.h>
+#include <linux/wait.h>
 #include <linux/slab.h>
 #include <linux/ieee80211.h>
 #include <net/cfg80211.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-net-wireless-libertas-cfgc-needs-schedh.patch
fix-hwmon-coretemp-update-hotplug-condition-check.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
mmc-recognize-csd-structure-fix.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
rtc-add-support-for-ds3232-rtc-fix.patch
drivers-video-igafbc-make-igafb_setup-and-igafb_init-static.patch
lib-bugc-make-warn-implementation-match-the-kernel-panicc-one-checkpatch-fixes.patch
fs-sysv-v7-adjust-sanity-checks-for-some-volumes-checkpatch-fixes.patch
fs-sysv-superc-add-support-for-non-pdp11-v7-filesystems-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
a.patch

