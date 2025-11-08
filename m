Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D551A23AC
	for <mm-commits@vger.kernel.org>; Sat,  8 Nov 2025 18:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762626415; cv=none; b=AkrVvscPKeorQ3rc+xqrETkhcEXAoiAw0HgW7sALJ4r2DiPfbzDj/y5m9EpyNgPUlJeiRzkIqyQB3CXbplRT2K4BRlzCkWXohdBGaed9P9aeVrHrlM/tYbSQfxc2V77TCqeCKnHwCBrVO9fPT5clQktnoT/b94X+ZX/xFIiIMh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762626415; c=relaxed/simple;
	bh=Y+B9V1wPGIcy2zSq4WZJBCedHPgspoiTfokCyP+s0vg=;
	h=Date:To:From:Subject:Message-Id; b=l01dzxtt1k2I4t3OBlyggNzMYQUT59Wsw6vTtKmM0bj1I4Ebpi7HkJuuNyf9n8FyC+UBTXpa4ug9HnK0D9fxfd8qpBS+ktchV59PLI1eHcWd3OXT5HFczEPrwBqe8a0u1QYAlv/dGTqiKOi8H6zjWu2hpRBYWDmF3DNs5q2tW2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dftjcy3r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dftjcy3r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFF0C4CEFB;
	Sat,  8 Nov 2025 18:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762626415;
	bh=Y+B9V1wPGIcy2zSq4WZJBCedHPgspoiTfokCyP+s0vg=;
	h=Date:To:From:Subject:From;
	b=Dftjcy3r9Bbr27D3Wz2Kv2l8BMRv2Xg4PKpvrs00te0m7/B0iQRtFqfd3lWjCzCDW
	 ldRmOLyKUkbDr9BP8ebdnfvO6pNZz928IlcH+Xfv8K5rPzIdnx3tDB9H2qhdA9laLm
	 E+2sP6HqkFoxEGe+i0fTRuOIcnA/YwK8oDy6SdWk=
Date: Sat, 08 Nov 2025 10:26:54 -0800
To: mm-commits@vger.kernel.org,yanjun.zhu@linux.dev,tj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,pratyush@kernel.org,ojeda@kernel.org,masahiroy@kernel.org,jgg@ziepe.ca,jgg@nvidia.com,horms@kernel.org,graf@amazon.com,corbet@lwn.net,changyuanl@google.com,brauner@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-kho-move-to-kernel-liveupdate-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20251108182654.DFFF0C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate-kho-move-to-kernel-liveupdate-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     liveupdate-kho-move-to-kernel-liveupdate-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-kho-move-to-kernel-liveupdate-fix.patch

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
Subject: liveupdate-kho-move-to-kernel-liveupdate-fix
Date: Sat, 8 Nov 2025 13:01:30 -0500

disable the menu when DEFERRED_STRUCT_PAGE_INIT

Link: https://lkml.kernel.org/r/CA+CK2bAvh9Oa2SLfsbJ8zztpEjrgr_hr-uGgF1coy8yoibT39A@mail.gmail.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Simon Horman <horms@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/liveupdate/Kconfig~liveupdate-kho-move-to-kernel-liveupdate-fix
+++ a/kernel/liveupdate/Kconfig
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
 menu "Live Update and Kexec HandOver"
+	depends on !DEFERRED_STRUCT_PAGE_INIT
 
 config KEXEC_HANDOVER
 	bool "kexec handover"
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area.patch
liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area-fix-2.patch
liveupdate-kho-increase-metadata-bitmap-size-to-page_size.patch
liveupdate-kho-allocate-metadata-directly-from-the-buddy-allocator.patch
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

