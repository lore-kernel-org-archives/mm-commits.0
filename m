Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB4F1CEAC2
	for <mm-commits@vger.kernel.org>; Sun,  9 Nov 2025 19:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762715311; cv=none; b=fWRWl/sWgbEj1c8GkAcMgfue9dL68bLP3clEeG1CRXxFE34cI/1phLBzWdJMD5xL54gLRd6m6/AhCMYhEtLaLzSd7pf2fsxt9GKMmopt1a07iG7+Ei/VDMXVDYq0/qSqgetukaYhnEdm3UtEwV9m2ZMvGyvw4IkiCNd7FVG/kXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762715311; c=relaxed/simple;
	bh=j9KaC5ACK+5r4ljPR+FYX3fq2qF9ERE+VS8CHeFfBrY=;
	h=Date:To:From:Subject:Message-Id; b=A8VSn3WcDWtvKdQmXfejqiDWntXz7gQooEe7B4tXhnkhwLJMiJDPCwweTbQPYZi8WVU4n2mrfSeF6hrOwIuQmkpiAPB/KDuGlRMrhmqkZN0YYh7JUkQQeBzSZM/BF4XVj+ruTAzCntHxPFDIAiwlvfqTOmydYiDyE2wtEfUZeAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b2RZLwow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b2RZLwow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8147FC19422;
	Sun,  9 Nov 2025 19:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762715311;
	bh=j9KaC5ACK+5r4ljPR+FYX3fq2qF9ERE+VS8CHeFfBrY=;
	h=Date:To:From:Subject:From;
	b=b2RZLwoww50ILcbkNZ2Wd1qF8LWQmwMiV3Ih4Yf5GSPFtmp11/1HHj4i+oFAraLU/
	 OO+uyJxPL9ozcZ/hPMGQMuQfwlj4GtVbxMfcbIhvvOn5jg5mb2Nqbt6ALRMeSNZJYc
	 K0ogvcE2rf6tMOdFjxTnPuOtstgGOeLqMSdCakkM=
Date: Sun, 09 Nov 2025 11:08:31 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,lkp@intel.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area-fix-2.patch removed from -mm tree
Message-Id: <20251109190831.8147FC19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area-fix-2
has been removed from the -mm tree.  Its filename was
     liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area-fix-2.patch

This patch was dropped because it was folded into liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area.patch

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area-fix-2
Date: Tue, 4 Nov 2025 12:50:49 -0500

build fix

Link: https://lkml.kernel.org/r/CA+CK2bBnorfsTymKtv4rKvqGBHs=y=MjEMMRg_tE-RME6n-zUw@mail.gmail.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511042251.paO6f5BZ-lkp@intel.com/
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c          |    4 ++--
 kernel/kexec_handover_internal.h |    4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/kernel/kexec_handover.c~liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area-fix-2
+++ a/kernel/kexec_handover.c
@@ -476,8 +476,8 @@ static void __init kho_mem_deserialize(c
  * area for early allocations that happen before page allocator is
  * initialized.
  */
-static struct kho_scratch *kho_scratch;
-static unsigned int kho_scratch_cnt;
+struct kho_scratch *kho_scratch;
+unsigned int kho_scratch_cnt;
 
 /*
  * The scratch areas are scaled by default as percent of memory allocated from
--- a/kernel/kexec_handover_internal.h~liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area-fix-2
+++ a/kernel/kexec_handover_internal.h
@@ -2,8 +2,12 @@
 #ifndef LINUX_KEXEC_HANDOVER_INTERNAL_H
 #define LINUX_KEXEC_HANDOVER_INTERNAL_H
 
+#include <linux/kexec_handover.h>
 #include <linux/types.h>
 
+extern struct kho_scratch *kho_scratch;
+extern unsigned int kho_scratch_cnt;
+
 #ifdef CONFIG_KEXEC_HANDOVER_DEBUG
 bool kho_scratch_overlap(phys_addr_t phys, size_t size);
 #else
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area.patch
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

