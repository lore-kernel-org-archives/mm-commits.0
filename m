Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296BF19415E
	for <mm-commits@vger.kernel.org>; Tue, 25 Feb 2025 22:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740521180; cv=none; b=L5sFovv9up1W/EKdtcUR73GiXlLsHZAyKtnyyyOy2G0tFZuFlpRQrEwWuiaLZywdnLlS4qzydKC7UN7GDtkfmEqyKadam8ngpOqm2vLNosgMCZSmPnaBeZ87lO8wnCAxUx18ZqhFz4fhymFSdUnkuiILMsuaimi91CduV/TEZ2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740521180; c=relaxed/simple;
	bh=DwM+JpWYeAj0BVLLgI+qQ4lBFNcvij9VWt+gLpPmHa4=;
	h=Date:To:From:Subject:Message-Id; b=HzIBgHUi2Bt7Q92EOoxM9NBzgk/p622c9xH6xFHaQGL7mh5HPQIrQRHU++b0yibVGl7cO0Fob4IQKkSGlTEJ6Qyy5W8XDjkkBlNN0gSBsKc7XyF5J+O8e9V0FCdpkARp5o/34I0qiETQyidNKBdm9vjBwmkxexmGDa2T21mS7Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b5aRupMe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b5aRupMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915FBC4CEDD;
	Tue, 25 Feb 2025 22:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740521179;
	bh=DwM+JpWYeAj0BVLLgI+qQ4lBFNcvij9VWt+gLpPmHa4=;
	h=Date:To:From:Subject:From;
	b=b5aRupMe9+Ewrj2zZilSJ5FYacPKbxqUwXQV2XmRCmrGF15W3SkjQlMl3h3JwUF89
	 tmzp4Sg35/sDCMBsXMPIv1E4PLSyZs/8NgTJghSqwsP9PzdS7gKUJszwSnPd9VKTz+
	 RtjuOQdk7CPqJumI/ShXOUsk/ZGUHQEB22QZ/ngM=
Date: Tue, 25 Feb 2025 14:06:18 -0800
To: mm-commits@vger.kernel.org,oleg@redhat.com,kees@kernel.org,ebiederm@xmission.com,corbet@lwn.net,brauner@kernel.org,alexander@mihalicyn.com,mkoutny@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] pid-optional-first-fit-pid-allocation.patch removed from -mm tree
Message-Id: <20250225220619.915FBC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: pid: optional first-fit pid allocation
has been removed from the -mm tree.  Its filename was
     pid-optional-first-fit-pid-allocation.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Michal Koutný <mkoutny@suse.com>
Subject: pid: optional first-fit pid allocation
Date: Fri, 21 Feb 2025 18:02:49 +0100

Noone would need to use this allocation strategy (it's slower, pid
numbers collide sooner). Its primary purpose are pid namespaces in
conjunction with pids.max cgroup limit which keeps (virtual) pid numbers
below the given limit. This is for 32-bit userspace programs that may
not work well with pid numbers above 65536.

Link: https://lore.kernel.org/r/20241122132459.135120-1-aleksandr.mikhalitsyn@canonical.com/
Link: https://lkml.kernel.org/r/20250221170249.890014-3-mkoutny@suse.com
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <kees@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |    2 +
 include/linux/pid_namespace.h               |    3 +
 kernel/pid.c                                |   12 ++++++-
 kernel/pid_namespace.c                      |   28 +++++++++++++-----
 4 files changed, 36 insertions(+), 9 deletions(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst~pid-optional-first-fit-pid-allocation
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -1043,6 +1043,8 @@ The last pid allocated in the current (t
 lives in) pid namespace. When selecting a pid for a next task on fork
 kernel tries to allocate a number starting from this one.
 
+When set to -1, first-fit pid numbering is used instead of the next-fit.
+
 
 powersave-nap (PPC only)
 ========================
--- a/include/linux/pid_namespace.h~pid-optional-first-fit-pid-allocation
+++ a/include/linux/pid_namespace.h
@@ -41,6 +41,9 @@ struct pid_namespace {
 #if defined(CONFIG_SYSCTL) && defined(CONFIG_MEMFD_CREATE)
 	int memfd_noexec_scope;
 #endif
+#ifdef CONFIG_IA32_EMULATION
+	bool pid_noncyclic;
+#endif
 } __randomize_layout;
 
 extern struct pid_namespace init_pid_ns;
--- a/kernel/pid.c~pid-optional-first-fit-pid-allocation
+++ a/kernel/pid.c
@@ -191,6 +191,10 @@ struct pid *alloc_pid(struct pid_namespa
 
 	for (i = ns->level; i >= 0; i--) {
 		int tid = 0;
+		bool pid_noncyclic = 0;
+#ifdef CONFIG_IA32_EMULATION
+		pid_noncyclic = READ_ONCE(tmp->pid_noncyclic);
+#endif
 
 		if (set_tid_size) {
 			tid = set_tid[ns->level - i];
@@ -235,8 +239,12 @@ struct pid *alloc_pid(struct pid_namespa
 			 * Store a null pointer so find_pid_ns does not find
 			 * a partially initialized PID (see below).
 			 */
-			nr = idr_alloc_cyclic(&tmp->idr, NULL, pid_min,
-					      pid_max, GFP_ATOMIC);
+			if (likely(!pid_noncyclic))
+				nr = idr_alloc_cyclic(&tmp->idr, NULL, pid_min,
+						      pid_max, GFP_ATOMIC);
+			else
+				nr = idr_alloc(&tmp->idr, NULL, pid_min,
+						      pid_max, GFP_ATOMIC);
 		}
 		spin_unlock_irq(&pidmap_lock);
 		idr_preload_end();
--- a/kernel/pid_namespace.c~pid-optional-first-fit-pid-allocation
+++ a/kernel/pid_namespace.c
@@ -114,6 +114,9 @@ static struct pid_namespace *create_pid_
 #if defined(CONFIG_SYSCTL) && defined(CONFIG_MEMFD_CREATE)
 	ns->memfd_noexec_scope = pidns_memfd_noexec_scope(parent_pid_ns);
 #endif
+#ifdef CONFIG_IA32_EMULATION
+	ns->pid_noncyclic = READ_ONCE(parent_pid_ns->pid_noncyclic);
+#endif
 	return ns;
 
 out_free_idr:
@@ -260,7 +263,7 @@ void zap_pid_ns_processes(struct pid_nam
 	return;
 }
 
-#ifdef CONFIG_CHECKPOINT_RESTORE
+#if defined(CONFIG_CHECKPOINT_RESTORE) || defined(CONFIG_IA32_EMULATION)
 static int pid_ns_ctl_handler(const struct ctl_table *table, int write,
 		void *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -271,12 +274,23 @@ static int pid_ns_ctl_handler(const stru
 	if (write && !checkpoint_restore_ns_capable(pid_ns->user_ns))
 		return -EPERM;
 
-	next = idr_get_cursor(&pid_ns->idr) - 1;
+	next = -1;
+#ifdef CONFIG_IA32_EMULATION
+	if (!pid_ns->pid_noncyclic)
+#endif
+		next += idr_get_cursor(&pid_ns->idr);
 
 	tmp.data = &next;
 	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
-	if (!ret && write)
-		idr_set_cursor(&pid_ns->idr, next + 1);
+	if (!ret && write) {
+		if (next > -1)
+			idr_set_cursor(&pid_ns->idr, next + 1);
+		else if (!IS_ENABLED(CONFIG_IA32_EMULATION))
+			ret = -EINVAL;
+#ifdef CONFIG_IA32_EMULATION
+		WRITE_ONCE(pid_ns->pid_noncyclic, next == -1);
+#endif
+	}
 
 	return ret;
 }
@@ -288,11 +302,11 @@ static const struct ctl_table pid_ns_ctl
 		.maxlen = sizeof(int),
 		.mode = 0666, /* permissions are checked in the handler */
 		.proc_handler = pid_ns_ctl_handler,
-		.extra1 = SYSCTL_ZERO,
+		.extra1 = SYSCTL_NEG_ONE,
 		.extra2 = &pid_max,
 	},
 };
-#endif	/* CONFIG_CHECKPOINT_RESTORE */
+#endif	/* CONFIG_CHECKPOINT_RESTORE || CONFIG_IA32_EMULATION */
 
 int reboot_pid_ns(struct pid_namespace *pid_ns, int cmd)
 {
@@ -449,7 +463,7 @@ static __init int pid_namespaces_init(vo
 {
 	pid_ns_cachep = KMEM_CACHE(pid_namespace, SLAB_PANIC | SLAB_ACCOUNT);
 
-#ifdef CONFIG_CHECKPOINT_RESTORE
+#if defined(CONFIG_CHECKPOINT_RESTORE) || defined(CONFIG_IA32_EMULATION)
 	register_sysctl_init("kernel", pid_ns_ctl_table);
 #endif
 
_

Patches currently in -mm which might be from mkoutny@suse.com are


