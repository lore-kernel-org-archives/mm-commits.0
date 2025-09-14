Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8ED5145329
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810134; cv=none; b=Z3WtcvJuZPaC2oBZHrTcAKQiNVgloBt1AZAcgswWUlEcFyaDDAVT5XN5qislnWEPQzy27C2vaZhyI3NRoQAbkdZ4413WMiotSF7r/aPq+q5mFwg8pPJXzv7fH7s3Q03kH+NmnVVUtdcNDkMZ7MHJQE2MrX0KUE5ifhgbqWE3CRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810134; c=relaxed/simple;
	bh=fo/N3Vb+usnzw7NLRvCHnwtNBd5mQBNifMCOB2wqOxc=;
	h=Date:To:From:Subject:Message-Id; b=oVKRRbHhusZ23mn1i0+FgSniDsV4a+ihMbbprfjOuW8JdyX2m7EZdAGAf1JWtwciI44TqbmkdOVCtWFsUVOrV/zjPRAdCduZc7bTP7rgTUVnXuky5989Hc+8FkCgRZl68CI976IltmnPcyYOKLPlFeadTPp8k4KwrJIig2Xs+zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xjWCI9RT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xjWCI9RT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3D6C4CEEB;
	Sun, 14 Sep 2025 00:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810134;
	bh=fo/N3Vb+usnzw7NLRvCHnwtNBd5mQBNifMCOB2wqOxc=;
	h=Date:To:From:Subject:From;
	b=xjWCI9RTWZjgieMExBQSWzGMqSMnT3WqhWsPJRF10OpaSLZlg/9uZyKM/F+8iVcPi
	 RY1Cb5pj89TEuGN0k38fqySA2syp/keIKM0M30smOGPQiibAOvOMhIhb1GP7iimIYI
	 Z0Y6YmgpYNOYaqFX+7n5loeQAQUEgdOR31Cd3k2s=
Date: Sat, 13 Sep 2025 17:35:34 -0700
To: mm-commits@vger.kernel.org,safinaskar@zohomail.com,rostedt@goodmis.org,paulmck@kernel.org,lance.yang@linux.dev,john.ogness@linutronix.de,feng.tang@linux.alibaba.com,corbet@lwn.net,pmladek@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] panic-clean-up-message-about-deprecated-panic_print-parameter.patch removed from -mm tree
Message-Id: <20250914003534.8F3D6C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: clean up message about deprecated 'panic_print' parameter
has been removed from the -mm tree.  Its filename was
     panic-clean-up-message-about-deprecated-panic_print-parameter.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: panic: clean up message about deprecated 'panic_print' parameter
Date: Mon, 25 Aug 2025 10:57:01 +0800

Remove duplication of the message about deprecated 'panic_print'
parameter.

Also make the wording more direct.  Make it clear that the new parameters
already exist and should be used instead.

Link: https://lkml.kernel.org/r/20250825025701.81921-5-feng.tang@linux.alibaba.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Feng Tang <feng.tang@linux.alibaba.com>
Cc: Askar Safin <safinaskar@zohomail.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/kernel/panic.c~panic-clean-up-message-about-deprecated-panic_print-parameter
+++ a/kernel/panic.c
@@ -77,6 +77,11 @@ ATOMIC_NOTIFIER_HEAD(panic_notifier_list
 
 EXPORT_SYMBOL(panic_notifier_list);
 
+static void panic_print_deprecated(void)
+{
+	pr_info_once("Kernel: The 'panic_print' parameter is now deprecated. Please use 'panic_sys_info' and 'panic_console_replay' instead.\n");
+}
+
 #ifdef CONFIG_SYSCTL
 
 /*
@@ -125,7 +130,7 @@ static int proc_taint(const struct ctl_t
 static int sysctl_panic_print_handler(const struct ctl_table *table, int write,
 			   void *buffer, size_t *lenp, loff_t *ppos)
 {
-	pr_info_once("Kernel: 'panic_print' sysctl interface will be obsoleted by both 'panic_sys_info' and 'panic_console_replay'\n");
+	panic_print_deprecated();
 	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
 }
 
@@ -944,13 +949,13 @@ core_param(panic_console_replay, panic_c
 
 static int panic_print_set(const char *val, const struct kernel_param *kp)
 {
-	pr_info_once("Kernel: 'panic_print' parameter will be obsoleted by both 'panic_sys_info' and 'panic_console_replay'\n");
+	panic_print_deprecated();
 	return  param_set_ulong(val, kp);
 }
 
 static int panic_print_get(char *val, const struct kernel_param *kp)
 {
-	pr_info_once("Kernel: 'panic_print' parameter will be obsoleted by both 'panic_sys_info' and 'panic_console_replay'\n");
+	panic_print_deprecated();
 	return  param_get_ulong(val, kp);
 }
 
_

Patches currently in -mm which might be from pmladek@suse.com are


