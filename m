From: akpm@linux-foundation.org
Subject: + pm-schedule-sysrq-poweroff-on-boot-cpu.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:41:03 -0700
Message-ID: <200807111846.m6BIkiX8031028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754806AbYGKSqx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:46:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rui.zhang@intel.com, harbour@sfinx.od.ua, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     pm: schedule sysrq poweroff on boot cpu
has been added to the -mm tree.  Its filename is
     pm-schedule-sysrq-poweroff-on-boot-cpu.patch

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
Subject: pm: schedule sysrq poweroff on boot cpu
From: Zhang Rui <rui.zhang@intel.com>

schedule sysrq poweroff on boot cpu.

sysrq poweroff needs to disable nonboot cpus, and we need to run this on boot
cpu to avoid any recursion.  http://bugzilla.kernel.org/show_bug.cgi?id=10897

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Rus <harbour@sfinx.od.ua>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/poweroff.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/power/poweroff.c~pm-schedule-sysrq-poweroff-on-boot-cpu kernel/power/poweroff.c
--- a/kernel/power/poweroff.c~pm-schedule-sysrq-poweroff-on-boot-cpu
+++ a/kernel/power/poweroff.c
@@ -25,7 +25,8 @@ static DECLARE_WORK(poweroff_work, do_po
 
 static void handle_poweroff(int key, struct tty_struct *tty)
 {
-	schedule_work(&poweroff_work);
+	/* run sysrq poweroff on boot cpu */
+	schedule_work_on(first_cpu(cpu_online_map), &poweroff_work);
 }
 
 static struct sysrq_key_op	sysrq_poweroff_op = {
_

Patches currently in -mm which might be from rui.zhang@intel.com are

linux-next.patch
pm-ahci-speed-up-resume.patch
pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on.patch
pm-schedule-sysrq-poweroff-on-boot-cpu.patch
dcdbas-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer.patch

