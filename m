Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC63C8BE3
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gXzoBfsz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B591C433C7;
	Mon, 11 Dec 2023 01:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257755;
	bh=psaRVDe5B6r49IUKC02LtxkRcVMSoj//zaoSJlJNqgw=;
	h=Date:To:From:Subject:From;
	b=gXzoBfsz+bmqDG8CRijD29yooGmbTahQ2PJQZWNJ5MEAI4MqUgtlOT6G+KCXGZvzn
	 px+SFyaNOjvwIJHHoY+Ju6/Kckfm93WH56GdK40g+4nLmmJnwtoq3H42VJVngrZ/8E
	 jbESbC/6yRzfSwsQNTkORrnTy79nxzDw9FnAh8Sw=
Date: Sun, 10 Dec 2023 17:22:34 -0800
To: mm-commits@vger.kernel.org,ldmldm05@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off.patch removed from -mm tree
Message-Id: <20231211012235.4B591C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/reboot: explicitly notify if halt occurred instead of power off
has been removed from the -mm tree.  Its filename was
     kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dongmin Lee <ldmldm05@gmail.com>
Subject: kernel/reboot: explicitly notify if halt occurred instead of power off
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

[akpm@linux-foundation.org: tweak comment text]
Link: https://lkml.kernel.org/r/20231104113320.72440-1-ldmldm05@gmail.com
Signed-off-by: Dongmin Lee <ldmldm05@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/reboot.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/kernel/reboot.c~kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off
+++ a/kernel/reboot.c
@@ -59,6 +59,14 @@ struct sys_off_handler {
 };
 
 /*
+ * This variable is used to indicate if a halt was initiated instead of a
+ * reboot when the reboot call was invoked with LINUX_REBOOT_CMD_POWER_OFF, but
+ * the system cannot be powered off. This allowes kernel_halt() to notify users
+ * of that.
+ */
+static bool poweroff_fallback_to_halt;
+
+/*
  * Temporary stub that prevents linkage failure while we're in process
  * of removing all uses of legacy pm_power_off() around the kernel.
  */
@@ -297,7 +305,10 @@ void kernel_halt(void)
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
@@ -732,8 +743,10 @@ SYSCALL_DEFINE4(reboot, int, magic1, int
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


