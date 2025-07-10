Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18B928DF27
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 21:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752184433; cv=none; b=F/8KgYztVjtYM8jeWSTco+a9JmIrt8n8U+TzATGy8lENUamtrU0RtLjHTlhItrSEc+h28BNzuBF4IgUJJM0tQvo8CGZFZ4zaAmXI0PmQwnpWu+okPegbdlZHOiiqKr47JGe70W2qbp3WmN18NtaGUPkf/at1nGCkXcbD9NC0fxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752184433; c=relaxed/simple;
	bh=PnVFxoVf2NTX2el5N137k4P/RkWBFEM2Zq9Ceje0+rc=;
	h=Date:To:From:Subject:Message-Id; b=XNbQ10nu3j9Awzwz7Hv06G5i7F4657h7CNUe1CY8eC1Dx4ZidAEqE7FT5dGQGCFBF/CrCk643e0PIYBOBBkt5OhyZ4ZYdAz2AaLSsFo/uVAt6iXCqni3iLYmGtPNhgfqtWWNDXBIIMpmONuwsAyWj37p3hfGE6qlbt9RogrWFOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t8xAcq8R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t8xAcq8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A170CC4CEE3;
	Thu, 10 Jul 2025 21:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752184432;
	bh=PnVFxoVf2NTX2el5N137k4P/RkWBFEM2Zq9Ceje0+rc=;
	h=Date:To:From:Subject:From;
	b=t8xAcq8RhxdDTcS9LFYot4znYOCp4zBYQeXeGwdd4recEEBRe2zbQejtDIOJyLwUj
	 yyxvSKSnya9j67sc2zCN55rTq+y7unr8jqhN9T2j5KOBpeDPOv/eYcq7AUxSxxJrVq
	 15U4fMV34qVMCPR0RVebrWV8JqQY9LDXVE9GDRrE=
Date: Thu, 10 Jul 2025 14:53:52 -0700
To: mm-commits@vger.kernel.org,rafael.j.wysocki@intel.com,mario.limonciello@amd.com,dyoung@redhat.com,dwmw2@infradead.org,bhe@redhat.com,rafael@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_core-drop-redundant-pm_restore_gfp_mask-call.patch added to mm-nonmm-unstable branch
Message-Id: <20250710215352.A170CC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec_core: Drop redundant pm_restore_gfp_mask() call
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec_core-drop-redundant-pm_restore_gfp_mask-call.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_core-drop-redundant-pm_restore_gfp_mask-call.patch

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
From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: kexec_core: Drop redundant pm_restore_gfp_mask() call
Date: Thu, 10 Jul 2025 15:12:20 +0200


Drop the direct pm_restore_gfp_mask() call from the KEXEC_JUMP flow in
kernel_kexec() because it is redundant.  Namely, dpm_resume_end()
called beforehand in the same code path invokes that function and
it is sufficient to invoke it once.

Link: https://lkml.kernel.org/r/1949230.tdWV9SEqCh@rjwysocki.net
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/kexec_core.c~kexec_core-drop-redundant-pm_restore_gfp_mask-call
+++ a/kernel/kexec_core.c
@@ -1136,7 +1136,6 @@ int kernel_kexec(void)
  Resume_devices:
 		dpm_resume_end(PMSG_RESTORE);
  Resume_console:
-		pm_restore_gfp_mask();
 		console_resume_all();
 		thaw_processes();
  Restore_console:
_

Patches currently in -mm which might be from rafael@kernel.org are

kexec_core-drop-redundant-pm_restore_gfp_mask-call.patch

