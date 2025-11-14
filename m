Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414C5359707
	for <mm-commits@vger.kernel.org>; Fri, 14 Nov 2025 21:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763156350; cv=none; b=shwYjo5OkenaxemiukR5Nj/wKlIvk4ffx6+cYs0ia1AqmB0dOQKiU37xfJrWsH5E0XIOFJ2RfiLedfZYcDX47BNQi7m3gKYL7UWPa1Z6JUPf6vnU8ZWQSkyZWK6g1NL45WRazXD0FOsOMj0JeL0CMKm9PnxpYo7Hfzv1toxIr4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763156350; c=relaxed/simple;
	bh=8EyFXdOJv+jEa5UHRwluWcR07CZhwog2uWue9CrOg5k=;
	h=Date:To:From:Subject:Message-Id; b=PryhmjkrMGodgwxU8smflQRXp2zC5kCZvQgT0ww0ascv/vaSrAq0W7IsWgymD1bm+ZYixmiHOZQuUy4MtCN6i6J3wSnUPB0RX3XXooEpvD2K+B1CvGsdyMex88dizDYN/01WAqR/1cnxvf8xzy9RxCVnXfN026VYbZHwaVb3JN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YjbxvoIO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YjbxvoIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE847C116D0;
	Fri, 14 Nov 2025 21:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763156349;
	bh=8EyFXdOJv+jEa5UHRwluWcR07CZhwog2uWue9CrOg5k=;
	h=Date:To:From:Subject:From;
	b=YjbxvoIOST1czHukZWkP0qemgRGRLUnuXrvy4wsBpCeQ4PxLHk1tXCP7h3dmMv+us
	 H0l5VqjSTHH+2V0IxQTWa7UjJRgK9doQEGVlXcYWpxXxbrRHFm0lrQYAK0HpUgWZrS
	 i0TUhCqh9zaR5ZEiLBYpneUfgf3JTb/3P4NowaDA=
Date: Fri, 14 Nov 2025 13:39:09 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,graf@amazon.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] liveupdate-kho-enable-kho-by-default.patch removed from -mm tree
Message-Id: <20251114213909.AE847C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: enable KHO by default
has been removed from the -mm tree.  Its filename was
     liveupdate-kho-enable-kho-by-default.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: kho: enable KHO by default
Date: Mon, 10 Nov 2025 13:07:15 -0500

Upcoming LUO requires KHO for its operations, the requirement to place
both KHO=on and liveupdate=on becomes redundant.  Set KHO to be enabled by
default.

Link: https://lkml.kernel.org/r/20251110180715.602807-1-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
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
reboot-call-liveupdate_reboot-before-kexec.patch
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

