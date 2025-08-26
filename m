Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CCF260583
	for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2025 00:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756168877; cv=none; b=Vh1h0ZHOxBN2waagWLFklUjYQ0hrlaRgW/JzGDOwSvbk3rCdeFylINU8IY/nlewJNNuro0aVMgaopc13fIxDlK+DjOiHqyH+ZKuNs98kQOjrhkOG2zIkIAS1agHVWrGBTodBqUORy+imUSnvW9U3jX2pVyPzWaX+ryTHJ31rdBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756168877; c=relaxed/simple;
	bh=TnvSZ6pJLrPW1I/3nBkkCXari2mksYkubvxEYgPQ2Nk=;
	h=Date:To:From:Subject:Message-Id; b=jHM9v6BSGhdgTAopCc7WwCt5jXpz3fF7rvugFGGKr1zGpN+l6Rvm0emH8P2NNdpDozSrH7xZyzr9c/gYwd7Lcp5b+TCL8sdfu3dM2390Dwk8BBr/UY7wkuRI0J6HVjm7w7t055NemQ1XJVyzYGGYPnjb2rFemQda/gR2T3WvvlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UVkPqYcS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UVkPqYcS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666ABC4CEED;
	Tue, 26 Aug 2025 00:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756168876;
	bh=TnvSZ6pJLrPW1I/3nBkkCXari2mksYkubvxEYgPQ2Nk=;
	h=Date:To:From:Subject:From;
	b=UVkPqYcSwrmXidUl9Y40qmqmIYiHRDXBSJnFJmysaAFr0ojdZ30ce5ZnRY/XeH9qM
	 hR3n4weuF6ezkMDdlRHdFHtGGOqZ5YoP3HkpALNN3coT8v+WjNHN2mB7PpDCzbu4Ul
	 nkyJeyeoInWgE8IFJKNhG8nw9aGMYsaL2aUWMqqE=
Date: Mon, 25 Aug 2025 17:41:15 -0700
To: mm-commits@vger.kernel.org,safinaskar@zohomail.com,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,lance.yang@linux.dev,john.ogness@linutronix.de,corbet@lwn.net,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-add-note-that-panic_print-parameter-is-deprecated.patch added to mm-nonmm-unstable branch
Message-Id: <20250826004116.666ABC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: add note that 'panic_print' parameter is deprecated
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-add-note-that-panic_print-parameter-is-deprecated.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-add-note-that-panic_print-parameter-is-deprecated.patch

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
Subject: panic: add note that 'panic_print' parameter is deprecated
Date: Mon, 25 Aug 2025 10:57:00 +0800

Just like for 'panic_print's systcl interface, add similar note for setup
of kernel cmdline parameter and parameter under /sys/module/kernel/.

Also add __core_param_cb() macro, which enables to add special get/set
operation for a kernel parameter.

Link: https://lkml.kernel.org/r/20250825025701.81921-4-feng.tang@linux.alibaba.com
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Suggested-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Askar Safin <safinaskar@zohomail.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/moduleparam.h |   13 +++++++++++++
 kernel/panic.c              |   19 ++++++++++++++++++-
 2 files changed, 31 insertions(+), 1 deletion(-)

--- a/include/linux/moduleparam.h~panic-add-note-that-panic_print-parameter-is-deprecated
+++ a/include/linux/moduleparam.h
@@ -349,6 +349,19 @@ static inline void kernel_param_unlock(s
 	__module_param_call("", name, &param_ops_##type, &var, perm,	\
 			    -1, KERNEL_PARAM_FL_UNSAFE)
 
+/**
+ * __core_param_cb - similar like core_param, with a set/get ops instead of type.
+ * @name: the name of the cmdline and sysfs parameter (often the same as var)
+ * @var: the variable
+ * @ops: the set & get operations for this parameter.
+ * @perm: visibility in sysfs
+ *
+ * Ideally this should be called 'core_param_cb', but the name has been
+ * used for module core parameter, so add the '__' prefix
+ */
+#define __core_param_cb(name, ops, arg, perm) \
+	__module_param_call("", name, ops, arg, perm, -1, 0)
+
 #endif /* !MODULE */
 
 /**
--- a/kernel/panic.c~panic-add-note-that-panic_print-parameter-is-deprecated
+++ a/kernel/panic.c
@@ -937,12 +937,29 @@ EXPORT_SYMBOL(__stack_chk_fail);
 #endif
 
 core_param(panic, panic_timeout, int, 0644);
-core_param(panic_print, panic_print, ulong, 0644);
 core_param(pause_on_oops, pause_on_oops, int, 0644);
 core_param(panic_on_warn, panic_on_warn, int, 0644);
 core_param(crash_kexec_post_notifiers, crash_kexec_post_notifiers, bool, 0644);
 core_param(panic_console_replay, panic_console_replay, bool, 0644);
 
+static int panic_print_set(const char *val, const struct kernel_param *kp)
+{
+	pr_info_once("Kernel: 'panic_print' parameter will be obsoleted by both 'panic_sys_info' and 'panic_console_replay'\n");
+	return  param_set_ulong(val, kp);
+}
+
+static int panic_print_get(char *val, const struct kernel_param *kp)
+{
+	pr_info_once("Kernel: 'panic_print' parameter will be obsoleted by both 'panic_sys_info' and 'panic_console_replay'\n");
+	return  param_get_ulong(val, kp);
+}
+
+static const struct kernel_param_ops panic_print_ops = {
+	.set	= panic_print_set,
+	.get	= panic_print_get,
+};
+__core_param_cb(panic_print, &panic_print_ops, &panic_print, 0644);
+
 static int __init oops_setup(char *s)
 {
 	if (!s)
_

Patches currently in -mm which might be from feng.tang@linux.alibaba.com are

lib-sys_info-handle-sys_info_mask==0-case.patch
panic-refine-the-document-for-panic_print.patch
panic-add-note-that-panic_print-parameter-is-deprecated.patch

