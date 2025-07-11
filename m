Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9161A29A
	for <mm-commits@vger.kernel.org>; Fri, 11 Jul 2025 01:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752198213; cv=none; b=N5+eg/0DPpVpHCtLPTNNJbpwK/oJhKvYwGLGsSe4fCfdPm5AgE73Ff3pjgBoKlFcRYzan4yYHrC9mKukwHHDLG4fLo10mwnfosAxTNoaDnFxnswEtR/pD/OEc4VlHoXLGpEzkmr1g2cTnSPM6FtU+bwq4/segCGr1vtOgoEIrg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752198213; c=relaxed/simple;
	bh=LVCHMVfCCg+O/ghL6ULzYm1A060AZOQ/OqnTb4mRajE=;
	h=Date:To:From:Subject:Message-Id; b=Ftsz8Ed/+2ScxqFZp7m4COxN9ycHepMK24W4TDTgH4ozN4lv+U/OQdsXQHpywEeGtJI8Wh+dRICw7m/a9XQW2zKOExYQ0CakpqXYYASwcYwfPUZqAVPf4Rq7O0Ti1O6CCge27e07HQbiCAUcsmvjrPrW1/DpKSLZ9H6Zl4ysYKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GPvPGUER; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GPvPGUER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A4DC4CEE3;
	Fri, 11 Jul 2025 01:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752198212;
	bh=LVCHMVfCCg+O/ghL6ULzYm1A060AZOQ/OqnTb4mRajE=;
	h=Date:To:From:Subject:From;
	b=GPvPGUERFLsnutlhtUtYGJdGsqy1Ma8IvX5aDSArYnZfGoE+9N7brLI5fMwsIZy/1
	 jrBS6+H/aJuxK1JTr7Exlbuey6Y76womwfO5dZrvtxLXeraxVW3KO8/px5F+gkKtOj
	 7CkG8vbZubkoREcecBSDatZ6qNfEdSPxjvsJCUPw=
Date: Thu, 10 Jul 2025 18:43:31 -0700
To: mm-commits@vger.kernel.org,rafael.j.wysocki@intel.com,sfr@canb.auug.org.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_core-fix-error-code-path-in-the-kexec_jump-flow-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20250711014332.25A4DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec_core-fix-error-code-path-in-the-kexec_jump-flow-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kexec_core-fix-error-code-path-in-the-kexec_jump-flow-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_core-fix-error-code-path-in-the-kexec_jump-flow-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: kexec_core-fix-error-code-path-in-the-kexec_jump-flow-fix
Date: Fri, 11 Jul 2025 10:35:39 +1000

remove now-unused label

Link: https://lkml.kernel.org/r/20250711105804.3447e832@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/kexec_core.c~kexec_core-fix-error-code-path-in-the-kexec_jump-flow-fix
+++ a/kernel/kexec_core.c
@@ -1135,7 +1135,6 @@ int kernel_kexec(void)
 		dpm_resume_start(PMSG_RESTORE);
  Resume_devices:
 		dpm_resume_end(PMSG_RESTORE);
- Resume_console:
 		pm_restore_gfp_mask();
 		console_resume_all();
 		thaw_processes();
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

kexec_core-fix-error-code-path-in-the-kexec_jump-flow-fix.patch

