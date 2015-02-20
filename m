From: akpm@linux-foundation.org
Subject: [merged]
 debug-prevent-entering-debug-mode-on-panic-exception.patch removed from -mm tree
Date: Fri, 20 Feb 2015 12:31:02 -0800
Message-ID: <54e79986.MIoy24cuoK5KqnuO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbbBTUbF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Feb 2015 15:31:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ccross@android.com, daniel.thompson@linaro.org, jason.wessel@windriver.com, john.stultz@linaro.org, kiran.kumar@linaro.org, sumit.semwal@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kgdb: prevent entering debug mode on panic/exception.
has been removed from the -mm tree.  Its filename was
     debug-prevent-entering-debug-mode-on-panic-exception.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Cross <ccross@android.com>
Subject: kgdb: prevent entering debug mode on panic/exception.

On non-developer devices, kgdb prevents the device from rebooting after a
panic.

In case of panics and exceptions, to allow the device to reboot, prevent
entering debug mode to avoid getting stuck waiting for the user to
interact with debugger.

To avoid entering the debugger on panic/exception without any extra
configuration, panic_timeout is being used which can be set via
/proc/sys/kernel/panic at run time and CONFIG_PANIC_TIMEOUT sets the
default value.

Setting panic_timeout indicates that the user requested machine to perform
unattended reboot after panic.  We dont want to get stuck waiting for the
user input in case of panic.

[kiran.kumar@linaro.org: add context to commit message.  Panic_timeout is
used instead of break_on_panic and break_on_exception to honor
CONFIG_PANIC_TIMEOUT.  Modified the commit as per community feedback]
Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/debug/debug_core.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN kernel/debug/debug_core.c~debug-prevent-entering-debug-mode-on-panic-exception kernel/debug/debug_core.c
--- a/kernel/debug/debug_core.c~debug-prevent-entering-debug-mode-on-panic-exception
+++ a/kernel/debug/debug_core.c
@@ -696,6 +696,14 @@ kgdb_handle_exception(int evector, int s
 
 	if (arch_kgdb_ops.enable_nmi)
 		arch_kgdb_ops.enable_nmi(0);
+	/*
+	 * Avoid entering the debugger if we were triggered due to an oops
+	 * but panic_timeout indicates the system should automatically
+	 * reboot on panic. We don't want to get stuck waiting for input
+	 * on such systems, especially if its "just" an oops.
+	 */
+	if (signo != SIGTRAP && panic_timeout)
+		return 1;
 
 	memset(ks, 0, sizeof(struct kgdb_state));
 	ks->cpu			= raw_smp_processor_id();
@@ -828,6 +836,15 @@ static int kgdb_panic_event(struct notif
 			    unsigned long val,
 			    void *data)
 {
+	/*
+	 * Avoid entering the debugger if we were triggered due to a panic
+	 * We don't want to get stuck waiting for input from user in such case.
+	 * panic_timeout indicates the system should automatically
+	 * reboot on panic.
+	 */
+	if (panic_timeout)
+		return NOTIFY_DONE;
+
 	if (dbg_kdb_mode)
 		kdb_printf("PANIC: %s\n", (char *)data);
 	kgdb_breakpoint();
_

Patches currently in -mm which might be from ccross@android.com are

linux-next.patch

