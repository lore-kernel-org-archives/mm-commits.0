Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9632F5324;
	Tue,  4 Aug 2026 04:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816345; cv=none; b=bUkQLqX6PW2l+tJRAErDSZ+rm2swityYGdjHa6ESbG5DHE2droXfvXTsBASWYGJjuzIj138yxUGyeCjBMhfamsTaGXzc1IiY9nB7JEfsso3Ks5/A4RETgj91QWVwiuCzu1+DJlsNm6FtN7IPgGzVU+IcHvENcMK9N2RnQMzw/3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816345; c=relaxed/simple;
	bh=4GuRHplfAvixBJyIHR7sR1MAO4AMfiH/LVJhYQ9He00=;
	h=Date:To:From:Subject:Message-Id; b=dsjTcKbEb3MLdwMQo7LkXGnpfbz8AI9ZsqqsWyMADDifw4aE0E3VFroRp75x2BwcpTrZIdb602j20d3WEDJwVF1KTK8GGAMltk5jlV1mznJGmOD/Suw/3mXXqqZbiuS6HWpI+GCpwVADMC3mnLNF/r4Kgup6HP7K/R8VUzAR1cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k1MFStJW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k1MFStJW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D2A1F000E9;
	Tue,  4 Aug 2026 04:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816344;
	bh=1iOX0glbqbzopHAvNheEG8zAHBHUl7L2lbCwwhcOc5M=;
	h=Date:To:From:Subject;
	b=k1MFStJWVu2QVXINulIjRFY5nj2uU3WFrsWY/gZgxTkyu48I85RTseb9Mvw5vmkNG
	 KZ3jzZS7x2W9q0wQy9A6yg9QIYHUlP0Tm8uHw3qeS+VKgX1oPs5QqQOunm71jDl9+k
	 eMCsU15vVjC+8cgHAOnudDkg1wQX9raPRdAtXliw=
Date: Mon, 03 Aug 2026 21:05:44 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ptikhomirov@virtuozzo.com,mjguzik@gmail.com,legion@kernel.org,include@grrlz.net,ebiederm@xmission.com,brauner@kernel.org,blbllhy@gmail.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] sysctl-move-the-cad_pid-entry-from-pid_table-to-kern_reboot_table.patch removed from -mm tree
Message-Id: <20260804040544.84D2A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sysctl: move the "cad_pid" entry from pid_table[] to kern_reboot_table[]
has been removed from the -mm tree.  Its filename was
     sysctl-move-the-cad_pid-entry-from-pid_table-to-kern_reboot_table.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: "Cen Zhang (Microsoft)" <blbllhy@gmail.com>
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
@@ -1366,6 +1366,29 @@ static struct attribute *reboot_attrs[]
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
@@ -1381,6 +1404,12 @@ static const struct ctl_table kern_reboo
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


