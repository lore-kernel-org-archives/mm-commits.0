Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CA217BD5
	for <mm-commits@vger.kernel.org>; Thu, 28 Nov 2024 01:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732758406; cv=none; b=lDE9TMyEQF+IRM7Hvvg7IDVuqU4ReIIfuKLE00AvmVh+ZO7EvTziRoj4//7jKIpqksBNVMquLogA/gnq38F1yyPGhZmjWzGbNTQGYL9hC2nGZVqUnlGlRgiN501BRLWNrgFOqU1oMEdwRjxyb8iCU8di76oe+9A1hV2ZW06MR7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732758406; c=relaxed/simple;
	bh=3ehp8RT/tx924S3Uaf5HcYyhoKZ3T/2dEDhRGDQLnII=;
	h=Date:To:From:Subject:Message-Id; b=Wgtm6dETAe+ljq3lZeTsf18iVEmxzPjlbwFTOlBo+YFnOFMBXH4PAuWHTuaAfzcnF2qwgtBsvtCwRp5ivjmk3HmhNsURA89o2Ru1i9AKVqAm/xcRlCjOWXkGhzMtqBnZ1HYuO9Ke7/d4Kx9j2W7grHc9pyrerhccJTHTGBs3Rw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WhIzpZEd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WhIzpZEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606BAC4CECC;
	Thu, 28 Nov 2024 01:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732758404;
	bh=3ehp8RT/tx924S3Uaf5HcYyhoKZ3T/2dEDhRGDQLnII=;
	h=Date:To:From:Subject:From;
	b=WhIzpZEdsuciw6akjSRWbliCYPD1s9yikCo+wbVdiEK14Wa3iMpb+dVLNSxihYjyC
	 v0Zyz4Vs97Al1vT232I2ebpDzek4/P7YE3K/rTTbFU/3tdPugkR7qQbIhke6Sj2QdH
	 bzTszvXSC7TZwABuOhKU12cjNG7guw24Es/epZuE=
Date: Wed, 27 Nov 2024 17:46:43 -0800
To: mm-commits@vger.kernel.org,zev@bewilderbeest.net,viro@zeniv.linux.org.uk,serge@hallyn.com,paul@paul-moore.com,oleg@redhat.com,jmorris@namei.org,catalin.marinas@arm.com,brauner@kernel.org,zhen.ni@easystack.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-sys-optimize-do_prlimit-lock-scope-to-reduce-contention.patch added to mm-nonmm-unstable branch
Message-Id: <20241128014644.606BAC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/sys: optimize do_prlimit lock scope to reduce contention
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-sys-optimize-do_prlimit-lock-scope-to-reduce-contention.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-sys-optimize-do_prlimit-lock-scope-to-reduce-contention.patch

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

kernel-sys-optimize-do_prlimit-lock-scope-to-reduce-contention.patch

