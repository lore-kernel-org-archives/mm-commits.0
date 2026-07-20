Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3382A22097;
	Mon, 20 Jul 2026 23:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784588544; cv=none; b=S08ybfRlbzQdYroJmr4OUjGmf323YnGVHy8FJXlLe2OLaDtJvJyeVLiFxJFN7yv9tXnyuJ32O4ymiSD42RpX4q6RgKx+9h63QgNMg4LEAKKzvScMMJyq+ILivU+XTmGGIeZqpW9mq7wjK2G93OW9EsDaxWEehD/5yp0LrhZIGJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784588544; c=relaxed/simple;
	bh=L040Ri4aGLmwdTssZAW71AEvHAY3f9Nr0uKGdKToRv0=;
	h=Date:To:From:Subject:Message-Id; b=YbSWEveBlY1rpux4fqKn7J63Rskz+WvTA4XVRP0va5s1GVpwHVAb+D0lmknRxFO8abivL0G4I1VL5JFXKm/SbHoeH/oxOSP/+zT72psqJ4ZhrKtEiBpz+Nwy2lAfglzbvl+cwFCzFV+qKKsR18mO6nSQi0KGcrxH01rJ2qn11TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ooZa1AAG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ooZa1AAG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A801F000E9;
	Mon, 20 Jul 2026 23:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784588542;
	bh=/T42pQHkZ/yXLN0I4KfJEOodGOMWDJLpBRu3Cn6LFRI=;
	h=Date:To:From:Subject;
	b=ooZa1AAGNPdgLyUqGQXa2FgFTwh/KTfHSc3+ZcLJm0MRJEX/N+6I3sOFoTz0YN1Qv
	 WCfgoFofyhzTZZm/6eEH4VmSdlwy9uE773JoFmY/Zk6cHlOEL89p2uJj219h+oHxI2
	 OBT4bo6OR2dHlpZzThEPhUTE8eGiozrCSX8eaJds=
Date: Mon, 20 Jul 2026 16:02:22 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ptikhomirov@virtuozzo.com,mjguzik@gmail.com,legion@kernel.org,include@grrlz.net,ebiederm@xmission.com,brauner@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sysctl-move-the-cad_pid-entry-from-pid_table-to-kern_reboot_table.patch added to mm-nonmm-unstable branch
Message-Id: <20260720230222.A3A801F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sysctl: move the "cad_pid" entry from pid_table[] to kern_reboot_table[]
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     sysctl-move-the-cad_pid-entry-from-pid_table-to-kern_reboot_table.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sysctl-move-the-cad_pid-entry-from-pid_table-to-kern_reboot_table.patch

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
From: Oleg Nesterov <oleg@redhat.com>
Subject: sysctl: move the "cad_pid" entry from pid_table[] to kern_reboot_table[]
Date: Mon, 20 Jul 2026 13:13:43 +0200

cad_pid is global, and kill_cad_pid() is only used in the root namespace.

However, due to pid_table_root_permissions(), a non-root user can unshare
pid/user namespaces and modify it from the child namespace.  This makes no
sense and is simply wrong.

Move it to kern_reboot_table[] where it logically belongs; this ensures
that only GLOBAL_ROOT_UID can read/modify this sysctl.

Note that this patch doesn't preserve "#ifdef CONFIG_PROC_SYSCTL" around
the "cad_pid"; CONFIG_PROC_SYSCTL selects CONFIG_SYSCTL, so it is always
set when kern_reboot_table[] is compiled.

Link: https://lore.kernel.org/al4C572uhLdBvyzH@redhat.com
Fixes: e054bcbe7e7a ("sysctl: move cad_pid into kernel/pid.c")
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Alexey Gladkov <legion@kernel.org>
Reviewed-by: Bradley Morgan <include@grrlz.net>
Reviewed-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
"Cen Zhang (Microsoft)" <blbllhy@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c    |   31 -------------------------------
 kernel/reboot.c |   29 +++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 31 deletions(-)

--- a/kernel/pid.c~sysctl-move-the-cad_pid-entry-from-pid_table-to-kern_reboot_table
+++ a/kernel/pid.c
@@ -764,29 +764,6 @@ static struct ctl_table_root pid_table_r
 	.set_ownership	= pid_table_root_set_ownership,
 };
 
-static int proc_do_cad_pid(const struct ctl_table *table, int write, void *buffer,
-		size_t *lenp, loff_t *ppos)
-{
-	struct pid *new_pid;
-	pid_t tmp_pid;
-	int r;
-	struct ctl_table tmp_table = *table;
-
-	tmp_pid = pid_vnr(cad_pid);
-	tmp_table.data = &tmp_pid;
-
-	r = proc_dointvec(&tmp_table, write, buffer, lenp, ppos);
-	if (r || !write)
-		return r;
-
-	new_pid = find_get_pid(tmp_pid);
-	if (!new_pid)
-		return -ESRCH;
-
-	put_pid(xchg(&cad_pid, new_pid));
-	return 0;
-}
-
 static const struct ctl_table pid_table[] = {
 	{
 		.procname	= "pid_max",
@@ -797,14 +774,6 @@ static const struct ctl_table pid_table[
 		.extra1		= &pid_max_min,
 		.extra2		= &pid_max_max,
 	},
-#ifdef CONFIG_PROC_SYSCTL
-	{
-		.procname	= "cad_pid",
-		.maxlen		= sizeof(int),
-		.mode		= 0600,
-		.proc_handler	= proc_do_cad_pid,
-	},
-#endif
 };
 #endif
 
--- a/kernel/reboot.c~sysctl-move-the-cad_pid-entry-from-pid_table-to-kern_reboot_table
+++ a/kernel/reboot.c
@@ -1347,6 +1347,29 @@ static struct attribute *reboot_attrs[]
 };
 
 #ifdef CONFIG_SYSCTL
+static int proc_do_cad_pid(const struct ctl_table *table, int write, void *buffer,
+			   size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table tmp_table = *table;
+	struct pid *new_pid;
+	pid_t tmp_pid;
+	int r;
+
+	tmp_pid = pid_vnr(cad_pid);
+	tmp_table.data = &tmp_pid;
+
+	r = proc_dointvec(&tmp_table, write, buffer, lenp, ppos);
+	if (r || !write)
+		return r;
+
+	new_pid = find_get_pid(tmp_pid);
+	if (!new_pid)
+		return -ESRCH;
+
+	put_pid(xchg(&cad_pid, new_pid));
+	return 0;
+}
+
 static const struct ctl_table kern_reboot_table[] = {
 	{
 		.procname       = "poweroff_cmd",
@@ -1362,6 +1385,12 @@ static const struct ctl_table kern_reboo
 		.mode           = 0644,
 		.proc_handler   = proc_dointvec,
 	},
+	{
+		.procname	= "cad_pid",
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= proc_do_cad_pid,
+	},
 };
 
 static void __init kernel_reboot_sysctls_init(void)
_

Patches currently in -mm which might be from oleg@redhat.com are

signal-change-sys_kill-to-use-send_sig_noinfo.patch
signal-avoid-unconditional-siginfo-copy-in-send_signal_locked.patch
sysctl-move-the-cad_pid-entry-from-pid_table-to-kern_reboot_table.patch

