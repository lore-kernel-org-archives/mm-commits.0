Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C46348468
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676287; cv=none; b=bWkBAByihsS2XPHR4oL08OYe5OmN13uVXYjfjZGG1R4irIvVaqpK9HprqZgRs/d/e5ZzmQbF7eu/4N0Q4EI5PwriLVeZU2FDKI0oLVd3R5FgRuGSQ2LYv+9Upl6ilnlsKDZRA+GjyvcixOrrFqF055xyyR1KUDuebZb9jwH1ehI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676287; c=relaxed/simple;
	bh=ClX1TFupdeOsD5djPb+2bpaaMykt83lSQmeXvmTVbv8=;
	h=Date:To:From:Subject:Message-Id; b=IDbOhJAsJmU7sga6Qnkt/swM0wX+bSwSBGp9oKGIHCoPm33BDTma80ZLFSMUzQwRbGE4ZKUGUVP/p5lAw3rShgvl5IHsaIgn0VHTOSJFm4gXJ6Z0SdQ70yffnBqsR3Ngssxz3dNX2D2UDVTBurjaj9wL1k55h2FLhlc9gIIuP0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hw9K0Bie; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hw9K0Bie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED3BC113D0;
	Thu, 20 Nov 2025 22:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676286;
	bh=ClX1TFupdeOsD5djPb+2bpaaMykt83lSQmeXvmTVbv8=;
	h=Date:To:From:Subject:From;
	b=Hw9K0BieiwWuARtw1+VebTLRFf0wn9BqMLtaDt/Ac1+aI2FNGBM2H78iAxMIVLGBt
	 rwOwNFeJFnk70bnU/aTaMmgztBvYiSt8E236tqiz86AXBgQIaeHlqBGmH+VnaS6g/9
	 zIkzAen9p0l4GOub0/w/wohHqFUQPNLcYL2puUy0=
Date: Thu, 20 Nov 2025 14:04:45 -0800
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,ioworker0@gmail.com,corbet@lwn.net,akpm@linux-foundation.org,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] sys_info-add-a-default-kernel-sys_info-mask.patch removed from -mm tree
Message-Id: <20251120220446.7ED3BC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sys_info: add a default kernel sys_info mask
has been removed from the -mm tree.  Its filename was
     sys_info-add-a-default-kernel-sys_info-mask.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Feng Tang <feng.tang@linux.alibaba.com>
Subject: sys_info: add a default kernel sys_info mask
Date: Thu, 13 Nov 2025 19:10:39 +0800

Which serves as a global default sys_info mask.  When users want the same
system information for many error cases (panic, hung, lockup ...), they
can chose to set this global knob only once, while not setting up each
individual sys_info knobs.

This just adds a 'lazy' option, and doesn't change existing kernel
behavior as the mask is 0 by default.

Link: https://lkml.kernel.org/r/20251113111039.22701-5-feng.tang@linux.alibaba.com
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |    9 +++++
 lib/sys_info.c                              |   31 +++++++++++++++++-
 2 files changed, 39 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst~sys_info-add-a-default-kernel-sys_info-mask
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -521,6 +521,15 @@ default), only processes with the CAP_SY
 io_uring instances.
 
 
+kernel_sys_info
+===============
+A comma separated list of extra system information to be dumped when
+soft/hard lockup is detected, for example, "tasks,mem,timers,locks,...".
+Refer 'panic_sys_info' section below for more details.
+
+It serves as the default kernel control knob, which will take effect
+when a kernel module calls sys_info() with parameter==0.
+
 kexec_load_disabled
 ===================
 
--- a/lib/sys_info.c~sys_info-add-a-default-kernel-sys_info-mask
+++ a/lib/sys_info.c
@@ -24,6 +24,13 @@ static const char * const si_names[] = {
 	[ilog2(SYS_INFO_BLOCKED_TASKS)]		= "blocked_tasks",
 };
 
+/*
+ * Default kernel sys_info mask.
+ * If a kernel module calls sys_info() with "parameter == 0", then
+ * this mask will be used.
+ */
+static unsigned long kernel_si_mask;
+
 /* Expecting string like "xxx_sys_info=tasks,mem,timers,locks,ftrace,..." */
 unsigned long sys_info_parse_param(char *str)
 {
@@ -110,9 +117,26 @@ int sysctl_sys_info_handler(const struct
 	else
 		return sys_info_read_handler(&table, buffer, lenp, ppos, ro_table->data);
 }
+
+static const struct ctl_table sys_info_sysctls[] = {
+	{
+		.procname	= "kernel_sys_info",
+		.data		= &kernel_si_mask,
+		.maxlen         = sizeof(kernel_si_mask),
+		.mode		= 0644,
+		.proc_handler	= sysctl_sys_info_handler,
+	},
+};
+
+static int __init sys_info_sysctl_init(void)
+{
+	register_sysctl_init("kernel", sys_info_sysctls);
+	return 0;
+}
+subsys_initcall(sys_info_sysctl_init);
 #endif
 
-void sys_info(unsigned long si_mask)
+static void __sys_info(unsigned long si_mask)
 {
 	if (si_mask & SYS_INFO_TASKS)
 		show_state();
@@ -135,3 +159,8 @@ void sys_info(unsigned long si_mask)
 	if (si_mask & SYS_INFO_BLOCKED_TASKS)
 		show_state_filter(TASK_UNINTERRUPTIBLE);
 }
+
+void sys_info(unsigned long si_mask)
+{
+	__sys_info(si_mask ? : kernel_si_mask);
+}
_

Patches currently in -mm which might be from feng.tang@linux.alibaba.com are


