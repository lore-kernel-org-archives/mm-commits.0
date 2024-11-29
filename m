Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F5C155345
	for <mm-commits@vger.kernel.org>; Fri, 29 Nov 2024 10:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732876824; cv=none; b=b7xDfUgH4OxjBpeu+77UsaaicewBWEajDBto56HjAeJ5dRardD9KJld5gepTPzcF5ysULZzhuOLAKHjEAqmf076cUEqmsW9VM2xXQdfL8vnOY1y5tpDgyA13fTSrVtRaXX+jngkkDdE0MlmZXcg4IyM0mx8O6XZxT9uxflQxjEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732876824; c=relaxed/simple;
	bh=ObSgMpvS7ON0YI85RJ+Cf8A4PpCbtyqoyKFAFstHIDU=;
	h=Date:To:From:Subject:Message-Id; b=uL8jf8jelQayF5czCj5rR0G5rnlri2kcdTs4QGwS13cUyK4kMAFaKZXGY/7pT20uKj05EFa1N+7jyvsCkZRjkUnCDKFzgkZYFMuHw/uwokCSkMzwA3I53AB6tFvUvRhyOYtg5I8HiDHW+oglLhlxXFzsKKZe02Wyj3zVTDi066g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bo+vx2Eu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bo+vx2Eu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43038C4CECF;
	Fri, 29 Nov 2024 10:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732876824;
	bh=ObSgMpvS7ON0YI85RJ+Cf8A4PpCbtyqoyKFAFstHIDU=;
	h=Date:To:From:Subject:From;
	b=bo+vx2EuJ2D5AumTTBBherLivE8tWoFRIEspDLyXbHRmUDdxKvH93J/SYl5xjnvBN
	 dru6q0br7VpxBzlIfhQEHAC0OATNcvO6heD4Prp6DNpQTCIklu6Gka/aLWkpPcvMw5
	 8VyaaHh4n9kShRh6LOSXboJxMT3YRJrFlmuarJcw=
Date: Fri, 29 Nov 2024 02:40:23 -0800
To: mm-commits@vger.kernel.org,zev@bewilderbeest.net,viro@zeniv.linux.org.uk,serge@hallyn.com,paul@paul-moore.com,oleg@redhat.com,jmorris@namei.org,catalin.marinas@arm.com,brauner@kernel.org,zhen.ni@easystack.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kernel-sys-optimize-do_prlimit-lock-scope-to-reduce-contention.patch removed from -mm tree
Message-Id: <20241129104024.43038C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/sys: optimize do_prlimit lock scope to reduce contention
has been removed from the -mm tree.  Its filename was
     kernel-sys-optimize-do_prlimit-lock-scope-to-reduce-contention.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zhen Ni <zhen.ni@easystack.cn>
Subject: kernel/sys: optimize do_prlimit lock scope to reduce contention
Date: Wed, 20 Nov 2024 21:21:56 +0800

Refine the lock scope in the do_prlimit function to reduce contention on
task_lock(tsk->group_leader).  The lock now protects only sections that
access or modify shared resources (rlim).  Permission checks (capable) and
security validations (security_task_setrlimit) are placed outside the
lock, as they do not modify rlim and are independent of shared data
protection.

security_task_setrlimit() is a Linux Security Module (LSM) hook that
evaluates resource limit changes based on security policies.  It does not
alter the rlim data structure, as confirmed by existing LSM
implementations (e.g., SELinux and AppArmor).  Thus, this function does
not require locking, ensuring correctness while improving concurrency.

Link: https://lkml.kernel.org/r/20241120132156.207250-1-zhen.ni@easystack.cn
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Zev Weiss <zev@bewilderbeest.net>
Cc: James Morris <jmorris@namei.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Serge E. Hallyn <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/kernel/sys.c~kernel-sys-optimize-do_prlimit-lock-scope-to-reduce-contention
+++ a/kernel/sys.c
@@ -1481,18 +1481,20 @@ static int do_prlimit(struct task_struct
 
 	/* Holding a refcount on tsk protects tsk->signal from disappearing. */
 	rlim = tsk->signal->rlim + resource;
-	task_lock(tsk->group_leader);
 	if (new_rlim) {
 		/*
 		 * Keep the capable check against init_user_ns until cgroups can
 		 * contain all limits.
 		 */
 		if (new_rlim->rlim_max > rlim->rlim_max &&
-				!capable(CAP_SYS_RESOURCE))
-			retval = -EPERM;
-		if (!retval)
-			retval = security_task_setrlimit(tsk, resource, new_rlim);
+		    !capable(CAP_SYS_RESOURCE))
+			return -EPERM;
+		retval = security_task_setrlimit(tsk, resource, new_rlim);
+		if (retval)
+			return retval;
 	}
+
+	task_lock(tsk->group_leader);
 	if (!retval) {
 		if (old_rlim)
 			*old_rlim = *rlim;
_

Patches currently in -mm which might be from zhen.ni@easystack.cn are


