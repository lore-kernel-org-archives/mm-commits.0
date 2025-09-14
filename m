Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5095A33987
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810133; cv=none; b=EmQ+ImTdndKasiw5JxKAu4MfAgyBAugDgzm0A9CMWbyVc4B9qHROYDdOV3BPAJ+k5ECK6UbSwm4iW5d4+GaCCcgnL/aFtQ+sMMe22GpCP3AQmu4kI9AWDBMo6KFmP+9HHGZd9jjFq7EQ8ddOj8Zfe1095TnnClBRqbRaXvwvAoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810133; c=relaxed/simple;
	bh=+dvr4K6PKYVQDbFdFxGx++G8oKhJD5iTjpzZ1MZ91ps=;
	h=Date:To:From:Subject:Message-Id; b=LcNnEkDdaEeysVbIr2uHw/TSgEW8vj2LtC7noU6TrixhvNPoKwq9uOJ9ahSGIv0w5WHt1mfy61Pb8cU1OSvs2QDgZoI3QAMB1iPS69ldOKG7Fgqb86bGCTQ2tmqwZsGVklS+CJPozamZzETrIIUuRaHSo8vwDbWxVtqoUcbnXz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DT1Wv/kY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DT1Wv/kY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCD8C4CEEB;
	Sun, 14 Sep 2025 00:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810133;
	bh=+dvr4K6PKYVQDbFdFxGx++G8oKhJD5iTjpzZ1MZ91ps=;
	h=Date:To:From:Subject:From;
	b=DT1Wv/kYAhXSt4aT4KOnwioPPSLPvy2PSEnDvvHK5QALjm90h7cSjdGelmluu1D5U
	 yEga5ifDWUwW8bI8JZFhLg2ve7b1Sv1BJLgaG6TvvV7jUjxF5xeAn/+sPPdsiJ9vjO
	 j13UCOivqD5otsG1/PtaUgcHULYZIZx3jK+hl1uU=
Date: Sat, 13 Sep 2025 17:35:32 -0700
To: mm-commits@vger.kernel.org,safinaskar@zohomail.com,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,lance.yang@linux.dev,john.ogness@linutronix.de,corbet@lwn.net,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] panic-add-note-that-panic_print-parameter-is-deprecated.patch removed from -mm tree
Message-Id: <20250914003533.1CCD8C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: add note that 'panic_print' parameter is deprecated
has been removed from the -mm tree.  Its filename was
     panic-add-note-that-panic_print-parameter-is-deprecated.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


