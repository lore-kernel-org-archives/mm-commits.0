From: akpm@linux-foundation.org
Subject: + lktdm-bring-support-for-hardlockup-softlockup-and-hung-task-crashes.patch added to -mm tree
Date: Wed, 19 May 2010 12:58:49 -0700
Message-ID: <201005191958.o4JJwnA4002650@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754834Ab0EST7V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 15:59:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fweisbec@gmail.com, dzickus@redhat.com, gorcunov@gmail.com, mingo@elte.hu, simon.kagstrom@netinsight.net


The patch titled
     lktdm: add support for hardlockup, softlockup and hung task crashes
has been added to the -mm tree.  Its filename is
     lktdm-bring-support-for-hardlockup-softlockup-and-hung-task-crashes.patch

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
Subject: lktdm: add support for hardlockup, softlockup and hung task crashes
From: Frederic Weisbecker <fweisbec@gmail.com>

This adds three new types of kernel "crashes" in the lkdtm driver to
trigger hardlockups, softlockups and task hung states at will.

The first two are useful to test the new generic lockup detector and check
its further regressions.  The latter one is a bonus to check the hung task
detector regressions even though it's not currently in rework.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lkdtm.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN drivers/misc/lkdtm.c~lktdm-bring-support-for-hardlockup-softlockup-and-hung-task-crashes drivers/misc/lkdtm.c
--- a/drivers/misc/lkdtm.c~lktdm-bring-support-for-hardlockup-softlockup-and-hung-task-crashes
+++ a/drivers/misc/lkdtm.c
@@ -75,6 +75,9 @@ enum ctype {
 	UNALIGNED_LOAD_STORE_WRITE,
 	OVERWRITE_ALLOCATION,
 	WRITE_AFTER_FREE,
+	SOFTLOCKUP,
+	HARDLOCKUP,
+	HUNG_TASK,
 };
 
 static char* cp_name[] = {
@@ -99,6 +102,9 @@ static char* cp_type[] = {
 	"UNALIGNED_LOAD_STORE_WRITE",
 	"OVERWRITE_ALLOCATION",
 	"WRITE_AFTER_FREE",
+	"SOFTLOCKUP",
+	"HARDLOCKUP",
+	"HUNG_TASK",
 };
 
 static struct jprobe lkdtm;
@@ -320,6 +326,20 @@ static void lkdtm_do_action(enum ctype w
 		memset(data, 0x78, len);
 		break;
 	}
+	case SOFTLOCKUP:
+		preempt_disable();
+		for (;;)
+			cpu_relax();
+		break;
+	case HARDLOCKUP:
+		local_irq_disable();
+		for (;;)
+			cpu_relax();
+		break;
+	case HUNG_TASK:
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule();
+		break;
 	case NONE:
 	default:
 		break;
_

Patches currently in -mm which might be from fweisbec@gmail.com are

origin.patch
linux-next.patch
lktdm-bring-support-for-hardlockup-softlockup-and-hung-task-crashes.patch
osst-update-ppos-instead-of-using-file-f_pos.patch
arch-cris-arch-v10-drivers-eepromc-eeprom_read-eeprom_write-should-update-ppos-instead-of-file-f_pos.patch
frv-remove-struct-file-argument-from-sysctl-proc_handler.patch
misdn-remove-unnecessary-test-on-f_pos.patch
rtc-m41t80-use-nonseekable_open.patch
vfs-introduce-noop_llseek.patch
osst-use-noop_llseek-instead-of-default_llseek.patch
st-use-noop_llseek-instead-of-default_llseek.patch
fs-do-not-fallback-to-default_llseek-when-readdir-uses-bkl.patch
documentation-filesystems-locking-update-documentation-on-llseek-wrt-bkl.patch

