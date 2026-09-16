Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7534D9567;
	Wed, 16 Sep 2026 20:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789591564; cv=none; b=OJUFGkShGTp+HjWXZf8uOqBl20GgRJNHi2HbaYAm2duLRtPtwYNeo4/IFmYbJw5xg4sILMS/EihDhv+i+C2TtCSttzR1+A+VC8qzwCBlTluFqLjQYDAeUMp6mVs+cfc8HQ6XmFwhDW8Ug8pz4m36NxES7gm36lm/cshY6Xv45kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789591564; c=relaxed/simple;
	bh=QWkud9kxT0GunuXy5GhLLZiEGWIHTbiFRFgWkmeqxQA=;
	h=Date:To:From:Subject:Message-Id; b=hjfKNB+d8Tc2MnFctmsVxvzjK+ikVaFJrmUE1ovMP4ED1PkZAhqjH9zIiJSIw9iRRl1qClO2O+zR9bD4x05/c1WfzPqt+1ETjKXhYtX0bFdoxkR+nvTHRmEDABe7tgku/xGxjsO0XLUdJUyVsxeuCA0jS/dYhuwevg8CzfNns3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mue+9ifP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mue+9ifP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1471F0089C;
	Wed, 16 Sep 2026 20:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789591543;
	bh=YwQ44j8L3LReDOGB1wcQnYeSPhrQ8DfVnFsMks+2/oY=;
	h=Date:To:From:Subject;
	b=mue+9ifPJ8KYrMlu5cUMd+KsvEbWuKf1t+yPxk19QrVZlvETYg8Qvz4c6jgqoUIky
	 /c7ig1hkcPL5gKDPf96Q4UipeK5OrnPyxtEZoR3EcvnVJJLH6n6T/lXij07eGvzXaX
	 8PKKNCy47R67XgeyTyQZ7OkITW/ziuRKQAZDuU44=
Date: Wed, 16 Sep 2026 13:45:43 -0700
To: mm-commits@vger.kernel.org,wim@linux-watchdog.org,wangjinchao600@gmail.com,stable@vger.kernel.org,sashiko-bot@kernel.org,pmladek@suse.com,linux@roeck-us.net,brads@mainlining.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-restore-variable-arguments-to-nmi_panic.patch added to mm-nonmm-unstable branch
Message-Id: <20260916204543.AE1471F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: restore variable arguments to nmi_panic()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-restore-variable-arguments-to-nmi_panic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-restore-variable-arguments-to-nmi_panic.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Bradley Morgan <brads@mainlining.org>
Subject: panic: restore variable arguments to nmi_panic()
Date: Wed, 16 Sep 2026 18:29:55 +0000

nmi_panic() used to accept variable arguments until commit ebc41f20d77f
("panic: change nmi_panic from macro to function") flattened it to a final
message string.  vpanic() did not exist back then, so the function had to
format through panic("%s", msg).

Bring the variable arguments back and format with vpanic() directly.  The
next patch makes nmi_panic() try the panic_force_cpu= redirect before
claiming panic_cpu, which needs the arguments twice: once to format the
message for the redirected CPU and once for vpanic() when no redirect
happens.  Passing a final string would lose that.

No current caller passes a string with format specifiers.  The closest one
is hpwdt_pretimeout(), which builds panic_msg with hex_byte_pack() and has
only two variants, both plain strings.  But the new __printf() annotation
on nmi_panic() would warn with -Wformat-security there because the buffer
is passed directly as the format argument, so switch it to nmi_panic(regs,
"%s", panic_msg).

Link: https://lore.kernel.org/20260916182957.7788-5-brads@mainlining.org
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Petr Mladek <pmladek@suse.com>
Cc: Guenetr Roeck <linux@roeck-us.net>
Cc: Sashiko <sashiko-bot@kernel.org>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Cc: Wim Van Sebroeck <wim@linux-watchdog.org>
Cc: <stable@vger.kernel.org>
---

 drivers/watchdog/hpwdt.c |    2 +-
 include/linux/panic.h    |    3 ++-
 kernel/panic.c           |   10 ++++++++--
 3 files changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/watchdog/hpwdt.c~panic-restore-variable-arguments-to-nmi_panic
+++ a/drivers/watchdog/hpwdt.c
@@ -199,7 +199,7 @@ static int hpwdt_pretimeout(unsigned int
 	}
 
 	hex_byte_pack(panic_msg, nmistat);
-	nmi_panic(regs, panic_msg);
+	nmi_panic(regs, "%s", panic_msg);
 
 	return NMI_HANDLED;
 }
--- a/include/linux/panic.h~panic-restore-variable-arguments-to-nmi_panic
+++ a/include/linux/panic.h
@@ -13,7 +13,8 @@ __printf(1, 2)
 void panic(const char *fmt, ...) __noreturn __cold;
 __printf(1, 0)
 void vpanic(const char *fmt, va_list args) __noreturn __cold;
-void nmi_panic(struct pt_regs *regs, const char *msg);
+__printf(2, 3)
+void nmi_panic(struct pt_regs *regs, const char *fmt, ...);
 void check_panic_on_warn(const char *origin);
 extern void oops_enter(void);
 extern void oops_exit(void);
--- a/kernel/panic.c~panic-restore-variable-arguments-to-nmi_panic
+++ a/kernel/panic.c
@@ -518,13 +518,19 @@ EXPORT_SYMBOL(panic_on_other_cpu);
  * nmi_panic_self_stop() which can provide architecture dependent code such
  * as saving register state for crash dump.
  */
-void nmi_panic(struct pt_regs *regs, const char *msg)
+void nmi_panic(struct pt_regs *regs, const char *fmt, ...)
 {
+	va_list args;
+
+	va_start(args, fmt);
+
 	if (panic_try_start())
-		panic("%s", msg);
+		vpanic(fmt, args);
 
 	if (panic_on_other_cpu())
 		nmi_panic_self_stop(regs);
+
+	va_end(args);
 }
 EXPORT_SYMBOL(nmi_panic);
 
_

Patches currently in -mm which might be from brads@mainlining.org are

taskstats-copy-signal-stats-under-siglock-in-taskstats_exit.patch
mailmap-update-email-address-for-bradley-morgan.patch
taskstats-drop-the-unused-cpu_dont_care-enum-member.patch
panic-fix-redirect-cpu-race-in-panic_try_force_cpu.patch
panic-flatten-nmi_panic-control-flow.patch
panic-fix-va_list-reuse-in-panic_try_force_cpu.patch
panic-restore-variable-arguments-to-nmi_panic.patch
panic-allow-force_cpu-redirect-from-an-nmi.patch
panic-kill-the-buffer-unavailable-redirect-fallback.patch

