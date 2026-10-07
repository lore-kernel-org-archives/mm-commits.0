Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD9E3546FC;
	Wed,  7 Oct 2026 02:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338721; cv=none; b=Up0AMzPf7UFcufrwbIH/Cg5EjEb1/dLeP4Cqk+foItFSQFnrL2lOoxOjl3Hgs27T0G1mmDX16i0k6SN+ITteedT0bZ8tqtTzM8nIK3jmrNnBnPY9lt6N5MD6Qa0KdXdAM67XVuCUduCyVTuEELQTmRupqJryVIBxQuOGs5oNG9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338721; c=relaxed/simple;
	bh=YawWEcd9iyEAaNDmMZ1E+/uRIplfmpaQGcsR8MSnhF4=;
	h=Date:To:From:Subject:Message-Id; b=bhJyuYxF4ds8rv9Jj048cKj6kUNeuG6C5BMMRRFoFYK8i6xX5oHcXqxNv6S2i/4j/GClRV0Xv2HIbiKsXJfJJ3XP04uFIvrYggltiWYZTy/k3RBEAhfdVYFcAkUz+gbKAvor84gCjchdnlDPk50Tnx6pqDiVlsqh8U10xoYcTNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x3Q5glcc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x3Q5glcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16EB1F0089B;
	Wed,  7 Oct 2026 02:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338719;
	bh=qosx4u6PP+lodQzEkpl5fHI0Mg4qjdHtJy63lgaDu1Q=;
	h=Date:To:From:Subject;
	b=x3Q5glcccPsm9UyPa0nCnvOK7zTG5p+K+9jVEUsN/Tt6CDGUFL47kYQxFh7jK3pa9
	 93KVMi0M0kzY2mgEenSEHFzMzvD+nEySvz6jeHhHaEqdBU63tIlENfWxJL1pyYHuWh
	 pF05IqRewFin5HVwLPsjA4wvsCVzrjudw1fnf52w=
Date: Tue, 06 Oct 2026 19:05:19 -0700
To: mm-commits@vger.kernel.org,wim@linux-watchdog.org,wangjinchao600@gmail.com,stable@vger.kernel.org,sashiko-bot@kernel.org,pmladek@suse.com,linux@roeck-us.net,brads@mainlining.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] panic-restore-variable-arguments-to-nmi_panic.patch removed from -mm tree
Message-Id: <20261007020519.C16EB1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: restore variable arguments to nmi_panic()
has been removed from the -mm tree.  Its filename was
     panic-restore-variable-arguments-to-nmi_panic.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bradley Morgan <brads@mainlining.org>
Subject: panic: restore variable arguments to nmi_panic()
Date: Wed, 16 Sep 2026 18:29:55 +0000

nmi_panic() used to accept variable arguments until commit ebc41f20d77f
("panic: change nmi_panic from macro to function") flattened it to a final
message string.  vpanic() did not exist back then, so the function had to
format through panic("%s", msg).

Bring the variable arguments back and format with vpanic() directly. 
The next patch makes nmi_panic() try the panic_force_cpu= redirect
before claiming panic_cpu.  panic_try_force_cpu() needs to print the
message but it is used also by panic() which accepts variable argument
list.  The string could be formatted only when a CPU gets assigned to
process the redirection.  Otherwise, there might be a race when writing
to the `panic_force_buf`.

No current caller passes a string with format specifiers.  The closest one
is hpwdt_pretimeout(), which builds panic_msg with hex_byte_pack() and has
only two variants, both plain strings.  But the new __printf() annotation
on nmi_panic() would warn with -Wformat-security there because the buffer
is passed directly as the format argument, so switch it to nmi_panic(regs,
"%s", panic_msg).

[pmladek@suse.com: changelog fix]
	Link: https://lore.kernel.org/arJxFybmtD7OBIcL@pathway.suse.cz
Link: https://lore.kernel.org/20260916182957.7788-5-brads@mainlining.org
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
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

watchdog-perf-one-digit-too-short-in-the-raw-event-config-copy.patch

