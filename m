Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545441E5714
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 21:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752356569; cv=none; b=cBKaYKTkWOrSwE/CjJ/fLoXw09Q0amdLPTa3u64/w5iGkESuCUjV843QoZ1wSnpcpR2Y4zEyGrqH/c4OGo7nUnWJKvY2SGKKWxJ2vXj46Cg99Vt0B4ccC/orGu5A75u6NasV3swWxcpmPm7s4XXd8jXN19I3uJQZBC7Yx8Mwop4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752356569; c=relaxed/simple;
	bh=EtHL2mS/7OcKbU6xoHgMuGaV+tCWYCwhaVKK+Ba8I2w=;
	h=Date:To:From:Subject:Message-Id; b=C1kEzuWfIUFgtYPlO+lMgqyCwK2urGP/8Ka/PTEiIMOnJOcBWnSoTFctokhPYWw0RoUyjmDyyoQR4SiBE6S6MbOSbJvztX03hROJWOjUOLUZnx3cn+1cCpb45QOQHnAOejmDyY5/83HUyHQ6qs8APwxVyH7eGwI0hsPQ/YJdsgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m8TVuV9O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m8TVuV9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD0CC4CEEF;
	Sat, 12 Jul 2025 21:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752356568;
	bh=EtHL2mS/7OcKbU6xoHgMuGaV+tCWYCwhaVKK+Ba8I2w=;
	h=Date:To:From:Subject:From;
	b=m8TVuV9OE37Te8FlXPqirc5NNkef0bjBFMb6VpySUtIcUWyXg/duiCMGotEamy5Su
	 0Ww7awEzScbPgLYX/Mo94FNIynD5W1jjo272vENXeVkNlFYiIRp45ocjPhr9sqRF1g
	 2vXzGbI1wfkewMoZo2ec0dnYiQPq39OzOuPC6NH0=
Date: Sat, 12 Jul 2025 14:42:48 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,mario.limonciello@amd.com,dyoung@redhat.com,dwmw2@infradead.org,bhe@redhat.com,rafael.j.wysocki@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kexec_core-fix-error-code-path-in-the-kexec_jump-flow.patch removed from -mm tree
Message-Id: <20250712214248.CAD0CC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec_core: fix error code path in the KEXEC_JUMP flow
has been removed from the -mm tree.  Its filename was
     kexec_core-fix-error-code-path-in-the-kexec_jump-flow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: kexec_core: fix error code path in the KEXEC_JUMP flow
Date: Thu, 10 Jul 2025 15:10:41 +0200

If dpm_suspend_start() fails, dpm_resume_end() must be called to recover
devices whose suspend callbacks have been called, but this does not happen
in the KEXEC_JUMP flow's error path due to a confused goto target label.

Address this by using the correct target label in the goto statement in
question.

[sfr@canb.auug.org.au: remove now-unused label]
  Link: https://lkml.kernel.org/r/20250711105804.3447e832@canb.auug.org.au
Link: https://lkml.kernel.org/r/2396879.ElGaqSPkdT@rjwysocki.net
Fixes: 2965faa5e03d ("kexec: split kexec_load syscall from kexec core code")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/kexec_core.c~kexec_core-fix-error-code-path-in-the-kexec_jump-flow
+++ a/kernel/kexec_core.c
@@ -1080,7 +1080,7 @@ int kernel_kexec(void)
 		console_suspend_all();
 		error = dpm_suspend_start(PMSG_FREEZE);
 		if (error)
-			goto Resume_console;
+			goto Resume_devices;
 		/*
 		 * dpm_suspend_end() must be called after dpm_suspend_start()
 		 * to complete the transition, like in the hibernation flows
@@ -1135,7 +1135,6 @@ int kernel_kexec(void)
 		dpm_resume_start(PMSG_RESTORE);
  Resume_devices:
 		dpm_resume_end(PMSG_RESTORE);
- Resume_console:
 		pm_restore_gfp_mask();
 		console_resume_all();
 		thaw_processes();
_

Patches currently in -mm which might be from rafael.j.wysocki@intel.com are

kexec_core-drop-redundant-pm_restore_gfp_mask-call.patch

