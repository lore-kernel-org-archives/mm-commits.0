Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D648C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  6 Nov 2023 16:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbjKFQY3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Nov 2023 11:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjKFQY2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2023 11:24:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA07A4
        for <mm-commits@vger.kernel.org>; Mon,  6 Nov 2023 08:24:26 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4E4C433C8;
        Mon,  6 Nov 2023 16:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699287865;
        bh=IpZc/nGgFte1dcefhp9s2zfxpRWk2qOwjppSXs/vT0A=;
        h=Date:To:From:Subject:From;
        b=sN1CiL8T4zN4OwF+ZtGD5pAxjNxs9O/WCElUj6AClcL7jqPs/lJ/1WVQWQcqecRP5
         DuhOa3irVoFxFvV6ElLM9820NGIxfiudRz7q6j7aqs2WQOkN2R9LCPsEIUX0chX4NN
         3tNtbs+eskJmd3vw2Jtn6SGqinokvBeKpJHTUpL8=
Date:   Mon, 06 Nov 2023 08:24:25 -0800
To:     mm-commits@vger.kernel.org, ldmldm05@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off.patch added to mm-nonmm-unstable branch
Message-Id: <20231106162425.AF4E4C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/reboot: Explicitly notify if halt occurred instead of power off
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Dongmin Lee <ldmldm05@gmail.com>
Subject: kernel/reboot: Explicitly notify if halt occurred instead of power off
Date: Sat, 4 Nov 2023 20:33:20 +0900

When kernel_can_power_off() returns false, and reboot has called with
LINUX_REBOOT_CMD_POWER_OFF, kernel_halt() will be initiated instead of
actual power off function.

However, in this situation, Kernel never explicitly notifies user that
system halted instead of requested power off.

Since halt and power off perform different behavior, and user initiated
reboot call with power off command, not halt, This could be unintended
behavior to user, like this:

~ # poweroff -f
[    3.581482] reboot: System halted

Therefore, this explicitly notifies user that poweroff is not available,
and halting has been occured as an alternative behavior instead:

~ # poweroff -f
[    4.123668] reboot: Power off not available: System halted instead

Link: https://lkml.kernel.org/r/20231104113320.72440-1-ldmldm05@gmail.com
Signed-off-by: Dongmin Lee <ldmldm05@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/reboot.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/kernel/reboot.c~kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off
+++ a/kernel/reboot.c
@@ -59,6 +59,13 @@ struct sys_off_handler {
 };
 
 /*
+ * This variable is used to indicate if a halt initiated instead when
+ * reboot call is invoked with LINUX_REBOOT_CMD_POWER_OFF, but system
+ * cannot be powered off. This allowes kernel_halt() to notify that.
+ */
+static bool poweroff_fallback_to_halt;
+
+/*
  * Temporary stub that prevents linkage failure while we're in process
  * of removing all uses of legacy pm_power_off() around the kernel.
  */
@@ -297,7 +304,10 @@ void kernel_halt(void)
 	kernel_shutdown_prepare(SYSTEM_HALT);
 	migrate_to_reboot_cpu();
 	syscore_shutdown();
-	pr_emerg("System halted\n");
+	if (poweroff_fallback_to_halt)
+		pr_emerg("Power off not available: System halted instead\n");
+	else
+		pr_emerg("System halted\n");
 	kmsg_dump(KMSG_DUMP_SHUTDOWN);
 	machine_halt();
 }
@@ -732,8 +742,10 @@ SYSCALL_DEFINE4(reboot, int, magic1, int
 	/* Instead of trying to make the power_off code look like
 	 * halt when pm_power_off is not set do it the easy way.
 	 */
-	if ((cmd == LINUX_REBOOT_CMD_POWER_OFF) && !kernel_can_power_off())
+	if ((cmd == LINUX_REBOOT_CMD_POWER_OFF) && !kernel_can_power_off()) {
+		poweroff_fallback_to_halt = true;
 		cmd = LINUX_REBOOT_CMD_HALT;
+	}
 
 	mutex_lock(&system_transition_mutex);
 	switch (cmd) {
_

Patches currently in -mm which might be from ldmldm05@gmail.com are

kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off.patch

