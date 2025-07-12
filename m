Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865FB225A3D
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 21:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752356583; cv=none; b=raRllDToujFVzhPxoG3wktebsKzvGqKKw58nRULgOeXFioMGunTwDLHKoDHiVx05RO1LFgxK2NLvO5VGnoC/QSep8wIVyPEH3iPy5QGB7QYZMDS8V0HIhnn3tOFnRx65mCS7SccY0q95qsB3r9wUdlxa8mp5L1KVP9RLSM4rzA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752356583; c=relaxed/simple;
	bh=m0IsTEcihq2xrpDpGnfNg6fxdsMm96y0mtJEfEe1wDA=;
	h=Date:To:From:Subject:Message-Id; b=JAEZEb5ZsT7JbhQ7D7LeZ3gKHeEkeLtN1RofZ77rIJ5gwuca+ANRjMs4J4VGcCWvOl4xnPly1hgro0iaRZy4lWCy4xiQe9s4AdL8ElJt3snxJBh00Fzh8c/3myPd6c05d9sy1bjKyxOgzF5mdBell3pwWYxGQo81NrAMsL5cfGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2DVRVB5H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2DVRVB5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EADCFC4CEEF;
	Sat, 12 Jul 2025 21:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752356583;
	bh=m0IsTEcihq2xrpDpGnfNg6fxdsMm96y0mtJEfEe1wDA=;
	h=Date:To:From:Subject:From;
	b=2DVRVB5HcxQyBzY0avolOEZSyw+eF8Gtw191Jiy4MqQSoQUBNOnYQQgrIM4mfkdVC
	 QHKqdLrtfxaJ/3ub59COQ+RfX7ZgY5SHRJRkvKJyau9t7D/wRNBJFOjLusOvHR5a/v
	 KGzEhlb4j3+/tcDLnNCW1UWpGBf9bUs5BmirFkUM=
Date: Sat, 12 Jul 2025 14:43:02 -0700
To: mm-commits@vger.kernel.org,rafael.j.wysocki@intel.com,mario.limonciello@amd.com,dyoung@redhat.com,dwmw2@infradead.org,bhe@redhat.com,rafael@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kexec_core-drop-redundant-pm_restore_gfp_mask-call.patch removed from -mm tree
Message-Id: <20250712214302.EADCFC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec_core: drop redundant pm_restore_gfp_mask() call
has been removed from the -mm tree.  Its filename was
     kexec_core-drop-redundant-pm_restore_gfp_mask-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: kexec_core: Drop redundant pm_restore_gfp_mask() call
Date: Thu, 10 Jul 2025 15:12:20 +0200

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

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
@@ -1135,7 +1135,6 @@ int kernel_kexec(void)
 		dpm_resume_start(PMSG_RESTORE);
  Resume_devices:
 		dpm_resume_end(PMSG_RESTORE);
-		pm_restore_gfp_mask();
 		console_resume_all();
 		thaw_processes();
  Restore_console:
_

Patches currently in -mm which might be from rafael@kernel.org are


