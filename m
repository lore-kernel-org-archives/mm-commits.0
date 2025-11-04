Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7C334B68C
	for <mm-commits@vger.kernel.org>; Tue,  4 Nov 2025 23:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762300487; cv=none; b=oeV5B5D0q7JiyVHO+AUB9KppbmOli2BZ1MZfEvvkh0DjcdpAH6Ry7XGaG0/a5z84e7NOYI3wQ7Bj4GYlNk6bB2XbCsf9dfnQ/G4sKreIorBINmjfdA+ySaFtiyqKDbvmEp3Z5g3DLyzDvuLUGLJKNsCXH+opUans6L8Eyj4fEVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762300487; c=relaxed/simple;
	bh=soHZnY6X/QKOtPjeqo/kfNhlcwroZN57iexKSKdmL6o=;
	h=Date:To:From:Subject:Message-Id; b=ZT29Orb5WkyKihzgxdGBL6aWfI7VTMSSZbpN2YVe1ktRX0axhDSulfQTbSCi/ECt9A49rIHsr2Gh18qROuHyyj8vt/jA0YuGRIQH9qEZMHBI7wOvG0rxhMEu59sjuO9SoEb8dpfJyXy4lyM3hdUuqkmtVLj86odGa8ni9m23bpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hdh3ywK9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hdh3ywK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5358BC4CEF7;
	Tue,  4 Nov 2025 23:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762300487;
	bh=soHZnY6X/QKOtPjeqo/kfNhlcwroZN57iexKSKdmL6o=;
	h=Date:To:From:Subject:From;
	b=Hdh3ywK9jFEe00q7zuJBBocsjyp17msSoYztxdSDnGSuX+fKZM5d4tvG3HX5o1FVv
	 DN0L6Eg9H9YXgfiDYRlCc/EWSWhqShGO61kP2WfW23xfTmpOFvOV5kQqQtbQKOHUxw
	 Rgf8QiIX1XUyEwS/ykLNdVphZigacvR6iHgXH15s=
Date: Tue, 04 Nov 2025 15:54:46 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,lkp@intel.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area-fix-2.patch added to mm-hotfixes-unstable branch
Message-Id: <20251104235447.5358BC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area-fix-2
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area-fix-2.patch

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
liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area-fix-2.patch
liveupdate-kho-increase-metadata-bitmap-size-to-page_size.patch
liveupdate-kho-allocate-metadata-directly-from-the-buddy-allocator.patch
kho-make-debugfs-interface-optional.patch
kho-add-interfaces-to-unpreserve-folios-page-ranges-and-vmalloc.patch
memblock-unpreserve-memory-in-case-of-error.patch
test_kho-unpreserve-memory-in-case-of-error.patch
kho-dont-unpreserve-memory-during-abort.patch
liveupdate-kho-move-to-kernel-liveupdate.patch
maintainers-update-kho-maintainers.patch

