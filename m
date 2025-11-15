Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C041DE4E1;
	Sat, 15 Nov 2025 18:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763232761; cv=none; b=ka8oP5/5jgszZHrHaV+cR+kovPZFrF5Pyx134VECWI9Ybka3XzlavniePr2qnS/PqceZT6NRVD+3a9LAc8jGmp+/D/R9N1sbOqfdYC1/zcXZGBuV4zflX+nInNgZHQzG6ov16ImSGBlJj/GEY/+YxoTmsqaz+5gB0QfIb1AL+2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763232761; c=relaxed/simple;
	bh=8IPgpsWmtpDFcFaXtbpFVMO/EMAwG/vfB0LZpO0+60Y=;
	h=Date:To:From:Subject:Message-Id; b=Xea7oHBvx/9rrVWdM5AdiJ97SQmL/bVW/VbubUhj6QXtwR8kB7Btt4TtKAAjPJUjLc3NTkj/xJWsaRcojJxQeGg4toDr31JG+dDLjviBYI2BQ4qGjbVWgIS209Gc8+MWRgdoaH0/TkJHGZJ2gFDQsdNR8FusiXJYCYA0xdhEFXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YOPC4Mmi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YOPC4Mmi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40EAC19424;
	Sat, 15 Nov 2025 18:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763232760;
	bh=8IPgpsWmtpDFcFaXtbpFVMO/EMAwG/vfB0LZpO0+60Y=;
	h=Date:To:From:Subject:From;
	b=YOPC4MmiJXF9NO76loaqCX6cy3wV1d5UYjZKdtAwRvx0toEfiYeoqo2hRW/3k5yKA
	 AUZfwbGC4RWPBC1EEoWp9LvFTVv/ZUsFUYoO0EPp4xB0baMZF0hdtid2+AoNusW6BT
	 waXevEBbVsxyatw/Zw++sj35tlZ7TplBYS6AVZNY=
Date: Sat, 15 Nov 2025 10:52:40 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,oliver.sang@intel.com,graf@amazon.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-test_kho-check-if-kho-is-enabled.patch removed from -mm tree
Message-Id: <20251115185240.A40EAC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_kho: check if KHO is enabled
has been removed from the -mm tree.  Its filename was
     lib-test_kho-check-if-kho-is-enabled.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: lib/test_kho: check if KHO is enabled
Date: Thu, 6 Nov 2025 17:06:35 -0500

We must check whether KHO is enabled prior to issuing KHO commands,
otherwise KHO internal data structures are not initialized.

Link: https://lkml.kernel.org/r/20251106220635.2608494-1-pasha.tatashin@soleen.com
Fixes: b753522bed0b ("kho: add test for kexec handover")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202511061629.e242724-lkp@intel.com
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kho.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/test_kho.c~lib-test_kho-check-if-kho-is-enabled
+++ a/lib/test_kho.c
@@ -301,6 +301,9 @@ static int __init kho_test_init(void)
 	phys_addr_t fdt_phys;
 	int err;
 
+	if (!kho_is_enabled())
+		return 0;
+
 	err = kho_retrieve_subtree(KHO_TEST_FDT, &fdt_phys);
 	if (!err)
 		return kho_test_restore(fdt_phys);
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

kho-make-debugfs-interface-optional.patch
kho-add-interfaces-to-unpreserve-folios-page-ranges-and-vmalloc.patch
memblock-unpreserve-memory-in-case-of-error.patch
test_kho-unpreserve-memory-in-case-of-error.patch
kho-dont-unpreserve-memory-during-abort.patch
liveupdate-kho-move-to-kernel-liveupdate.patch
liveupdate-kho-move-to-kernel-liveupdate-fix.patch
maintainers-update-kho-maintainers.patch
kho-fix-misleading-log-message-in-kho_populate.patch
kho-convert-__kho_abort-to-return-void.patch
kho-introduce-high-level-memory-allocation-api.patch
kho-preserve-fdt-folio-only-once-during-initialization.patch
kho-verify-deserialization-status-and-fix-fdt-alignment-access.patch
kho-always-expose-output-fdt-in-debugfs.patch
kho-simplify-serialization-and-remove-__kho_abort.patch
kho-remove-global-preserved_mem_map-and-store-state-in-fdt.patch
kho-remove-abort-functionality-and-support-state-refresh.patch
kho-update-fdt-dynamically-for-subtree-addition-removal.patch
kho-allow-kexec-load-before-kho-finalization.patch
kho-allow-memory-preservation-state-updates-after-finalization.patch
kho-add-kconfig-option-to-enable-kho-by-default.patch
liveupdate-luo_core-luo_ioctl-live-update-orchestrator.patch
liveupdate-luo_core-integrate-with-kho.patch
liveupdate-luo_core-integrate-with-kho-fix.patch
reboot-call-liveupdate_reboot-before-kexec.patch
liveupdate-luo_session-add-sessions-support.patch
liveupdate-luo_session-add-sessions-support-fix.patch
liveupdate-luo_ioctl-add-user-interface.patch
liveupdate-luo_file-implement-file-systems-callbacks.patch
liveupdate-luo_session-add-ioctls-for-file-preservation-and-state-management.patch
liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
docs-add-luo-documentation.patch
maintainers-add-liveupdate-entry.patch
mm-memfd_luo-allow-preserving-memfd-fix.patch
selftests-liveupdate-add-userspace-api-selftests.patch
selftests-liveupdate-add-kexec-based-selftest-for-session-lifecycle.patch
selftests-liveupdate-add-kexec-test-for-multiple-and-empty-sessions.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch

