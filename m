Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AFA2BF011
	for <mm-commits@vger.kernel.org>; Thu,  3 Jul 2025 22:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751582500; cv=none; b=QP5u9TrbazCVcol41AEKYyuiPP4uDsW+oLbbZeS5nko6vfbyEkZQZQTOIFwL9T3s4jotNPWC50/3qn01hcTiawXY5z9Y8q49WSMkR0yvR63KULy9i/M2ETsJo2oOJlboTpFrtdYaX/Up/nRhMYN9zRy/oTcJxyi1glv1f8g7KVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751582500; c=relaxed/simple;
	bh=Tn3iWVa0au6aXLF9tHfyfcPIhRwMdn33NMdVDEtbSPQ=;
	h=Date:To:From:Subject:Message-Id; b=uCmIQUGFgtwGodsRUqipmPKClNw6OzrTqZKxlKZSHXTBgTQpv3uVGE+tZHJg5M0dEXHzfdvSM/N0xTsJ2ixk/DsWP+7ZuxrMSnlWLybO5q+vmJW96NtJoU6+ct+PTy4bP2Qx1Xj9PNPOdEE5saRdr40si2r91S9xLzxovp89i3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ex3wg9hn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ex3wg9hn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38215C4CEE3;
	Thu,  3 Jul 2025 22:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751582500;
	bh=Tn3iWVa0au6aXLF9tHfyfcPIhRwMdn33NMdVDEtbSPQ=;
	h=Date:To:From:Subject:From;
	b=Ex3wg9hnzby2Yx1Ayt3ekwIcI92Cq4J6/kqmdcB13kU2DlMK4q6ZTNGR7g/wJAzeW
	 PQ9QKD+DaCW0zdLxjC4VBwup0QKQ3b19p0Bc1Hs6aUR0dGlE0Iix5zBiQp8h7WYAZX
	 z//gxpSeQbZPMB6771JsKNzZQHPOLVKvtEDeLhuQ=
Date: Thu, 03 Jul 2025 15:41:39 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,lance.yang@linux.dev,john.ogness@linutronix.de,corbet@lwn.net,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-add-panic_sys_info=-setup-option-for-kernel-cmdline.patch added to mm-nonmm-unstable branch
Message-Id: <20250703224140.38215C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: add 'panic_sys_info=' setup option for kernel cmdline
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-add-panic_sys_info=-setup-option-for-kernel-cmdline.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-add-panic_sys_info=-setup-option-for-kernel-cmdline.patch

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

panic-clean-up-code-for-console-replay.patch
panic-generalize-panic_prints-function-to-show-sys-info.patch
panic-add-panic_sys_info-sysctl-to-take-human-readable-string-parameter.patch
panic-add-panic_sys_info=-setup-option-for-kernel-cmdline.patch
panic-add-note-that-panic_print-sysctl-interface-is-deprecated.patch

