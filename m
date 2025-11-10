Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF41313E18
	for <mm-commits@vger.kernel.org>; Mon, 10 Nov 2025 18:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762798679; cv=none; b=LdLO8KjhTyCiD//ZjqC/WViOUeRCePxD4bIiHKbeCzT5svxNlYAQN035+PDsdMWGAkTBpsnBwLpDRoBT/feWyjDSQEoTi/Nd22aAEmtPV8a91prN5gcTuA7ZsSSMQ1bqihBGuH2upPhbMlFAkpWLl7yINM2ZmF/y7OScBcuQdcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762798679; c=relaxed/simple;
	bh=8G7BVhN9cKNgdeY0GWIDMwIjQjwK7ChAYhopUBluijc=;
	h=Date:To:From:Subject:Message-Id; b=cH/p8joL4/XP5pVwCoz/PE5vpCZhuV3euefHSTiKbULHCtWcK2C6xwlYJAz4OVWXxmbvHxTrkNtLCRnpFeoyzs6+ZDIeqBqPnLwnkTwHyN6YHbvg6rFHbnlsA4RZOi5Qid5OXWxFlVJg0JtSlnZsFZ33BtQWJaWgWwBImBHUU54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CWTZhEe4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CWTZhEe4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3755C116D0;
	Mon, 10 Nov 2025 18:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762798679;
	bh=8G7BVhN9cKNgdeY0GWIDMwIjQjwK7ChAYhopUBluijc=;
	h=Date:To:From:Subject:From;
	b=CWTZhEe4d/ETNCuzvygm/Em3BaGIl1sVoLHRjYJezacoJBkJyL+951zqCEQIdnl6d
	 p2mf91332/hw96KkSscEJjCLEbqjO4NNHAcq/nCmwtdO4VHe/yW5uSUTaqbx3zp9q5
	 qJYDlunZGaJnwUApG9NbvpaMKxLvf/PWhCzr5MPQ=
Date: Mon, 10 Nov 2025 10:17:58 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,graf@amazon.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-kho-enable-kho-by-default.patch added to mm-nonmm-unstable branch
Message-Id: <20251110181758.F3755C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate: kho: enable KHO by default
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     liveupdate-kho-enable-kho-by-default.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-kho-enable-kho-by-default.patch

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
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: liveupdate: kho: enable KHO by default
Date: Mon, 10 Nov 2025 13:07:15 -0500

Upcoming LUO requires KHO for its operations, the requirement to place
both KHO=on and liveupdate=on becomes redundant.  Set KHO to be enabled by
default.

Link: https://lkml.kernel.org/r/20251110180715.602807-1-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/liveupdate/kexec_handover.c~liveupdate-kho-enable-kho-by-default
+++ a/kernel/liveupdate/kexec_handover.c
@@ -51,7 +51,7 @@ union kho_page_info {
 
 static_assert(sizeof(union kho_page_info) == sizeof(((struct page *)0)->private));
 
-static bool kho_enable __ro_after_init;
+static bool kho_enable __ro_after_init = true;
 
 bool kho_is_enabled(void)
 {
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

lib-test_kho-check-if-kho-is-enabled.patch
kho-make-debugfs-interface-optional.patch
kho-add-interfaces-to-unpreserve-folios-page-ranges-and-vmalloc.patch
memblock-unpreserve-memory-in-case-of-error.patch
test_kho-unpreserve-memory-in-case-of-error.patch
kho-dont-unpreserve-memory-during-abort.patch
liveupdate-kho-move-to-kernel-liveupdate.patch
liveupdate-kho-move-to-kernel-liveupdate-fix.patch
maintainers-update-kho-maintainers.patch
liveupdate-luo_core-luo_ioctl-live-update-orchestrator.patch
liveupdate-luo_core-integrate-with-kho.patch
reboot-call-liveupdate_reboot-before-kexec.patch
liveupdate-kconfig-make-debugfs-optional.patch
liveupdate-kho-when-live-update-add-kho-image-during-kexec-load.patch
liveupdate-luo_session-add-sessions-support.patch
liveupdate-luo_ioctl-add-user-interface.patch
liveupdate-luo_file-implement-file-systems-callbacks.patch
liveupdate-luo_session-add-ioctls-for-file-preservation-and-state-management.patch
liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
docs-add-luo-documentation.patch
maintainers-add-liveupdate-entry.patch
selftests-liveupdate-add-userspace-api-selftests.patch
selftests-liveupdate-add-kexec-based-selftest-for-session-lifecycle.patch
selftests-liveupdate-add-kexec-test-for-multiple-and-empty-sessions.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch
liveupdate-kho-enable-kho-by-default.patch

