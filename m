Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA38215533F
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752977358; cv=none; b=QTizqE1ILQ9kMn6Gb4rWaFSU/accoEKORPfQBHajYZbfk3Z7fuMlPnUjnJ/1cAPaa9015BPd3e2Tursdlq3uNujNz8k4bpXcz78yaFyrgmh4cyiB7rr2uyeX1LafGuPC5FdkkAwgPvbD1YMikd8x6HTSKD910VuKS8mcnFVQqlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752977358; c=relaxed/simple;
	bh=bd45zivIw3FxMe3DTx4j/XtA3ld6JiVahyy40yoCVIg=;
	h=Date:To:From:Subject:Message-Id; b=fZakt8OM7NMZMoScaTi+fsME6u52VveeOltpFO5yZe3ppOan7AFd+5B4AhrIWsZBQyXlJYbmPX4aosTEC/EGA/HOTyGcoeCKwzocE2Udn6+3a81EuFGNlGCn1GgwheHXVic0XxRX8oZG5Jgo5BEEqHd49FgmL+w6gxYDyn68npo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0FNxKVpZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0FNxKVpZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E59C4CEE3;
	Sun, 20 Jul 2025 02:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752977356;
	bh=bd45zivIw3FxMe3DTx4j/XtA3ld6JiVahyy40yoCVIg=;
	h=Date:To:From:Subject:From;
	b=0FNxKVpZ2xGxnmMMUT8Xbt5AxizmTNNZzLemEjmCs8IeFwyxIq5QfPHW+GmQUAE+M
	 IBCy2jgGi+lFsAi1LLSh0AjGPa93H8oMu9v0dhpqJaHdRsfMwLtphlLUMVuza+XyZh
	 EzlB27VvqNxg7Tr4YIk1Avp2GOilkb9PPAoYGsUs=
Date: Sat, 19 Jul 2025 19:09:15 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,nathan@kernel.org,lance.yang@linux.dev,john.ogness@linutronix.de,corbet@lwn.net,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] panic-add-panic_sys_info=-setup-option-for-kernel-cmdline.patch removed from -mm tree
Message-Id: <20250720020916.28E59C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: add 'panic_sys_info=' setup option for kernel cmdline
has been removed from the -mm tree.  Its filename was
     panic-add-panic_sys_info=-setup-option-for-kernel-cmdline.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Feng Tang <feng.tang@linux.alibaba.com>
Subject: panic: add 'panic_sys_info=' setup option for kernel cmdline
Date: Thu, 3 Jul 2025 10:10:03 +0800

'panic_sys_info=' sysctl interface is already added for runtime setting. 
Add counterpart kernel cmdline option for boottime setting.

Link: https://lkml.kernel.org/r/20250703021004.42328-5-feng.tang@linux.alibaba.com
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Suggested-by: Petr Mladek <pmladek@suse.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |   15 ++++++++++++++
 kernel/panic.c                                  |    9 ++++++++
 2 files changed, 24 insertions(+)

--- a/Documentation/admin-guide/kernel-parameters.txt~panic-add-panic_sys_info=-setup-option-for-kernel-cmdline
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -4563,6 +4563,21 @@
 			Use this option carefully, maybe worth to setup a
 			bigger log buffer with "log_buf_len" along with this.
 
+	panic_sys_info= A comma separated list of extra information to be dumped
+                        on panic.
+                        Format: val[,val...]
+                        Where @val can be any of the following:
+
+                        tasks:          print all tasks info
+                        mem:            print system memory info
+			timers:         print timers info
+                        locks:          print locks info if CONFIG_LOCKDEP is on
+                        ftrace:         print ftrace buffer
+                        all_bt:         print all CPUs backtrace (if available in the arch)
+                        blocked_tasks:  print only tasks in uninterruptible (blocked) state
+
+                        This is a human readable alternative to the 'panic_print' option.
+
 	parkbd.port=	[HW] Parallel port number the keyboard adapter is
 			connected to, default is 0.
 			Format: <parport#>
--- a/kernel/panic.c~panic-add-panic_sys_info=-setup-option-for-kernel-cmdline
+++ a/kernel/panic.c
@@ -143,6 +143,15 @@ static __init int kernel_panic_sysctls_i
 late_initcall(kernel_panic_sysctls_init);
 #endif
 
+/* The format is "panic_sys_info=tasks,mem,locks,ftrace,..." */
+static int __init setup_panic_sys_info(char *buf)
+{
+	/* There is no risk of race in kernel boot phase */
+	panic_print = sys_info_parse_param(buf);
+	return 1;
+}
+__setup("panic_sys_info=", setup_panic_sys_info);
+
 static atomic_t warn_count = ATOMIC_INIT(0);
 
 #ifdef CONFIG_SYSFS
_

Patches currently in -mm which might be from feng.tang@linux.alibaba.com are


