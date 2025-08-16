Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E34225388
	for <mm-commits@vger.kernel.org>; Sat, 16 Aug 2025 07:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755328516; cv=none; b=cdARaJyLn4FCt7pobEsJ6c6HQzbFORakZdpPfgWgipBdPa7FZFl0wUoP0v0J8PYk5MXsksQZzY3ZU8IFH+M672byawDyTO5HH8CKv7RfWZEvkWE+2fZSwCjaF9qwNWOVRUwDw2IstH22TFEOIIHgrtHUAeMs9yca2Hl+CCob2xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755328516; c=relaxed/simple;
	bh=7662nIPX6f0w0ysCE32l3uc2aPGcFL0dYbZtJ3PiFQ4=;
	h=Date:To:From:Subject:Message-Id; b=jRmGBMGB1lv7d8flwMz/Lgg2lkn6hXX87RC8Zjac65OX54QfdqjDTDqqnnvEvlKd7LCyqGB3bI1j7F2S5Q9tEybvhpW0uTL51pPE81pIMEPJMeUBSwLWNWVNxCEDVlptmtDZwp0GYrVnbo8AwH6TGCvoaTbeClY1FYVxYjH4kXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s/vag0b6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s/vag0b6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ECE7C4CEEF;
	Sat, 16 Aug 2025 07:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755328516;
	bh=7662nIPX6f0w0ysCE32l3uc2aPGcFL0dYbZtJ3PiFQ4=;
	h=Date:To:From:Subject:From;
	b=s/vag0b6yJNRS0J/F3RCDbL81XJxMvm1v40QupEKVPiK3Rh6ovITzK6TnvhseEijF
	 pR7+ZPk8gXrsOqr3keQFA8BHtLUWFUgfiNF+1qE+7ROtXwgNuWA/TKtyxHdHhr4H9Y
	 dn6MvKSIo3okufPUDLzPAj6XYBA9sEmXqihVORLk=
Date: Sat, 16 Aug 2025 00:15:15 -0700
To: mm-commits@vger.kernel.org,safinaskar@zohomail.com,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,lance.yang@linux.dev,john.ogness@linutronix.de,corbet@lwn.net,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-add-note-that-panic_print-parameter-is-deprecated.patch added to mm-nonmm-unstable branch
Message-Id: <20250816071516.0ECE7C4CEEF@smtp.kernel.org>
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
Date: Fri, 15 Aug 2025 15:14:28 +0800

Just like for 'panic_print's systcl interface, add similar note for setup
of kernel cmdline parameter and parameter under /sys/module/kernel/.

Also add __core_param_cb() macro, which enables to add special get/set
operation for a kernel parameter.

Link: https://lkml.kernel.org/r/20250815071428.98041-4-feng.tang@linux.alibaba.com
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Suggested-by: Petr Mladek <pmladek@suse.com>
Cc: Askar Safin <safinaskar@zohomail.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/moduleparam.h |   14 ++++++++++++++
 kernel/panic.c              |   19 ++++++++++++++++++-
 2 files changed, 32 insertions(+), 1 deletion(-)

--- a/include/linux/moduleparam.h~panic-add-note-that-panic_print-parameter-is-deprecated
+++ a/include/linux/moduleparam.h
@@ -199,6 +199,7 @@ struct kparam_array
 #define core_param_cb(name, ops, arg, perm)		\
 	__level_param_cb(name, ops, arg, perm, 1)
 
+
 /**
  * postcore_param_cb - general callback for a module/cmdline parameter
  *                     to be evaluated before postcore initcall level
@@ -349,6 +350,19 @@ static inline void kernel_param_unlock(s
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

