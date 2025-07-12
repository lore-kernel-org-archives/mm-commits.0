Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0791E5714
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 21:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752356545; cv=none; b=V14dKDaVwBWIuMFhm5REdqhyI2cIM3909JaXxlvrlw8YvVORotUMAq/5ViU6gfw6GpqGuGwxusC4/KPLZcrfs//sOZ1tMQwyiEt5M8JkqgODfIGeyVnCIVkrwYIBqgaxJWF8ybXHP6VP+0uKflsibz0yqi+kMb9Q61UzRX0BUF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752356545; c=relaxed/simple;
	bh=lSgMgu7lMR5sUQm8ItFAn49Qz0+z26K2tNs85547oPs=;
	h=Date:To:From:Subject:Message-Id; b=KQm6bdVdBXvVfNP2NgRFKmvzed4OvJVzCIQerxwYoYmIsYC8SwS40VxoPMo1sOZY840dVQ0uxV/3c7mFNFsDXJZe/icFPjoR0AF//GBuJGaCW1JjmOn0rC+gh2wob8DpldSFCoo9icqanNEKlikC+kGMhOjWoXp0r06whvyuauE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zwrGB6O1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zwrGB6O1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203EDC4CEEF;
	Sat, 12 Jul 2025 21:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752356544;
	bh=lSgMgu7lMR5sUQm8ItFAn49Qz0+z26K2tNs85547oPs=;
	h=Date:To:From:Subject:From;
	b=zwrGB6O1D0En3SUn/Nog/2VNJ84Y/ENqYzui3IUULCq8aYTAaQ2N0V9rsfXlzBjZE
	 0eZhoocjA+P47BwV1sunaU1adSmXm/HUde8OXS3SlCILJMIOupf4OtC3AcnMmEtkXq
	 APTDCAtokZ4pT36JgAITaC4NB93g9iFgRGJhaSps=
Date: Sat, 12 Jul 2025 14:42:23 -0700
To: mm-commits@vger.kernel.org,rafael.j.wysocki@intel.com,sfr@canb.auug.org.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kexec_core-fix-error-code-path-in-the-kexec_jump-flow-fix.patch removed from -mm tree
Message-Id: <20250712214224.203EDC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec_core-fix-error-code-path-in-the-kexec_jump-flow-fix
has been removed from the -mm tree.  Its filename was
     kexec_core-fix-error-code-path-in-the-kexec_jump-flow-fix.patch

This patch was dropped because it was folded into kexec_core-fix-error-code-path-in-the-kexec_jump-flow.patch

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

kexec_core-fix-error-code-path-in-the-kexec_jump-flow.patch

