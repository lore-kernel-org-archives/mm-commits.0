From: akpm@linux-foundation.org
Subject: + power-disable-hibernation-if-module-loading-is-disabled.patch added to -mm tree
Date: Mon, 07 Mar 2011 14:59:35 -0800
Message-ID: <201103072259.p27MxZwU032637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756345Ab1CGXAQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2011 18:00:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segoon@openwall.com, kees.cook@canonical.com, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     power: disable hibernation if module loading is disabled
has been added to the -mm tree.  Its filename is
     power-disable-hibernation-if-module-loading-is-disabled.patch

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
Subject: power: disable hibernation if module loading is disabled
From: Vasiliy Kulikov <segoon@openwall.com>

If /proc/sys/kernel/modules_disabled is set to 1, then nobody (even full
root) may not read/write arbitrary kernel memory.  In spite of it,
hibernation allows anyone with an access to either /dev/snapshot or
/sys/power/ make the full snapshot of the system.  This snapshot may be
freely changed and uploaded back.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Acked-by: Kees Cook <kees.cook@canonical.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/hibernate.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN kernel/power/hibernate.c~power-disable-hibernation-if-module-loading-is-disabled kernel/power/hibernate.c
--- a/kernel/power/hibernate.c~power-disable-hibernation-if-module-loading-is-disabled
+++ a/kernel/power/hibernate.c
@@ -328,6 +328,9 @@ int hibernation_snapshot(int platform_mo
 {
 	int error;
 
+	if (modules_disabled)
+		return -EPERM;
+
 	error = platform_begin(platform_mode);
 	if (error)
 		goto Close;
@@ -385,6 +388,9 @@ static int resume_target_kernel(bool pla
 {
 	int error;
 
+	if (modules_disabled)
+		return -EPERM;
+
 	error = dpm_suspend_noirq(PMSG_QUIESCE);
 	if (error) {
 		printk(KERN_ERR "PM: Some devices failed to power down, "
_

Patches currently in -mm which might be from segoon@openwall.com are

origin.patch
linux-next.patch
power-disable-hibernation-if-module-loading-is-disabled.patch

