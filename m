Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896A8194124
	for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2025 00:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755736439; cv=none; b=a2l4pPuIapFOQiBvDaCmIw5FDBR1DB6X6lS8xW9ISwa+RHdfp6PYkvqqw5IGZtgNv0D4x8NWYh2KbAoP5nFydU42mQN9nS8JggmiiR/YRihfDV97keC+Rc2tO/wJwXiVj0JTB2w9Y6SGinV6Hb5dsj9LM/nomavpOXSbvo1W4vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755736439; c=relaxed/simple;
	bh=5VdZ6tzpYPCGBJdNrjC54IfQFsYafKCf7YAWhmmLRdc=;
	h=Date:To:From:Subject:Message-Id; b=YHRXOLk8OGffltZ0gBZMgnbsZ3jat2Ywrulr87HA5GqDniqCCSjSq3wvaVCHHXXn3g1yo8b9fx7k2NC9fbWUj0uExjiotyWQhfCEJeOd7nkKJfOqnjycTXZ0O6IDlpcMcR/bISYZ0rAM1FHrT5CC++7N0AmtKxq1a77x86DxLY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LgaMY4Xl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LgaMY4Xl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB26C4CEE7;
	Thu, 21 Aug 2025 00:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755736439;
	bh=5VdZ6tzpYPCGBJdNrjC54IfQFsYafKCf7YAWhmmLRdc=;
	h=Date:To:From:Subject:From;
	b=LgaMY4XlIqQu9VMoHQiT+YnXZykgGWM9Olb2CXm7fRhbgmxWWFfo/iTrhgxm05E/w
	 MaovEnOpS+hcpd6+FCOIMtSfgXVu4Ig1iMP/TMcacIEEwr/wjvJdpdcVqCTmBg7uHH
	 JSenRSiWzilP6ZORGNDk3a4/K3OyBwrMekGqKZSg=
Date: Wed, 20 Aug 2025 17:33:56 -0700
To: mm-commits@vger.kernel.org,safinaskar@zohomail.com,rostedt@goodmis.org,paulmck@kernel.org,lance.yang@linux.dev,john.ogness@linutronix.de,feng.tang@linux.alibaba.com,corbet@lwn.net,pmladek@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] panic-add-note-that-panic_print-parameter-is-deprecated-fix.patch removed from -mm tree
Message-Id: <20250821003359.4FB26C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: clean up message about deprecated 'panic_print' parameter
has been removed from the -mm tree.  Its filename was
     panic-add-note-that-panic_print-parameter-is-deprecated-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: panic: clean up message about deprecated 'panic_print' parameter
Date: Tue, 19 Aug 2025 11:51:37 +0200

Remove duplication of the message about the deprecated 'panic_print'
parameter.

Also make the wording more direct. Make it clear that the new
parameters already exist and should be used instead.

Link: https://lkml.kernel.org/r/aKRJKZHgcxyNF3y7@pathway.suse.cz
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Askar Safin <safinaskar@zohomail.com>
Cc: Feng Tang <feng.tang@linux.alibaba.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/kernel/panic.c~panic-add-note-that-panic_print-parameter-is-deprecated-fix
+++ a/kernel/panic.c
@@ -122,10 +122,15 @@ static int proc_taint(const struct ctl_t
 	return err;
 }
 
+static void panic_print_deprecated(void)
+{
+	pr_info_once("Kernel: The 'panic_print' parameter is now deprecated. Please use 'panic_sys_info' and 'panic_console_replay' instead.\n");
+}
+
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


