Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6703326E719
	for <mm-commits@vger.kernel.org>; Tue, 30 Dec 2025 18:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767118000; cv=none; b=en+QEF3DyIW5PPdWd9NqRYoQytZWY3amcSdkciSAaVGD3iteRRYumK4yQkZjAKDu9vuK80h2jB6F/H6hfLSBLU1ah95yPuri1Aexa4H+a0h8VyifrnbUlkZzVqa0FxyFc+r7kWdZvsh/w0oYrg7WtWWDpDnwRwEoWYqRu4mFb7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767118000; c=relaxed/simple;
	bh=qlEo1EdWIwLFYfzsH5rrTrtTxF5jqKc2cTpRLh5dAX0=;
	h=Date:To:From:Subject:Message-Id; b=QLPlULt8HX0KecglcRhFlXu+ZRhoLJWOoipKKxqbcn6qF6CESWv+HFfDYYIN026cZImDBfU+xOr55N2K4ziDgir3tqL9z8S0q6ZWXavGcIfnUjkIprwxI11VNm36nSscEPWlqISSu00VID5cux9s+ndc7cfAJk0IV/voVCM3Wtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O7AS/pl4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O7AS/pl4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5936C4CEFB;
	Tue, 30 Dec 2025 18:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767117999;
	bh=qlEo1EdWIwLFYfzsH5rrTrtTxF5jqKc2cTpRLh5dAX0=;
	h=Date:To:From:Subject:From;
	b=O7AS/pl411I/sRxfz1wwOHzTe2OOT8WnFwXo6xD0bclmif5Yw8BwWtC3f66plG85j
	 Gr9qMq4/qa5yrxisACn/YojnbxzCgYmQt3cwZkoE4SmxdVA8t9YKHTC6VED2KUvQu/
	 baFfoZ6ao3+ZwX+HFFj3SFR4SaKlR7U9VRGdina8=
Date: Tue, 30 Dec 2025 10:06:39 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-separate-memfd-support-into-liveupdate_memfd.patch added to mm-nonmm-unstable branch
Message-Id: <20251230180639.B5936C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate: separate memfd support into LIVEUPDATE_MEMFD
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     liveupdate-separate-memfd-support-into-liveupdate_memfd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-separate-memfd-support-into-liveupdate_memfd.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: liveupdate: separate memfd support into LIVEUPDATE_MEMFD
Date: Tue, 30 Dec 2025 11:14:02 -0500

Decouple memfd preservation support from the core Live Update Orchestrator
configuration.

Previously, enabling CONFIG_LIVEUPDATE forced a dependency on CONFIG_SHMEM
and unconditionally compiled memfd_luo.o.  However, Live Update may be
used for purposes that do not require memfd-backed memory preservation.

Introduce CONFIG_LIVEUPDATE_MEMFD to gate memfd_luo.o.  This moves the
SHMEM and MEMFD_CREATE dependencies to the specific feature that needs
them, allowing the base LIVEUPDATE option to be selected independently of
shared memory support.

Link: https://lkml.kernel.org/r/20251230161402.1542099-1-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/Kconfig |   17 ++++++++++++++++-
 mm/Makefile               |    2 +-
 2 files changed, 17 insertions(+), 2 deletions(-)

--- a/kernel/liveupdate/Kconfig~liveupdate-separate-memfd-support-into-liveupdate_memfd
+++ a/kernel/liveupdate/Kconfig
@@ -54,7 +54,6 @@ config KEXEC_HANDOVER_ENABLE_DEFAULT
 config LIVEUPDATE
 	bool "Live Update Orchestrator"
 	depends on KEXEC_HANDOVER
-	depends on SHMEM
 	help
 	  Enable the Live Update Orchestrator. Live Update is a mechanism,
 	  typically based on kexec, that allows the kernel to be updated
@@ -73,4 +72,20 @@ config LIVEUPDATE
 
 	  If unsure, say N.
 
+config LIVEUPDATE_MEMFD
+	bool "Live update support for memfd"
+	depends on LIVEUPDATE
+	depends on MEMFD_CREATE
+	depends on SHMEM
+	default LIVEUPDATE
+	help
+	  Enable live update support for memfd regions. This allows preserving
+	  memfd-backed memory across kernel live updates.
+
+	  This can be used to back VM memory with memfds, allowing the guest
+	  memory to persist, or for other user workloads needing to preserve
+	  pages.
+
+	  If unsure, say N.
+
 endmenu
--- a/mm/Makefile~liveupdate-separate-memfd-support-into-liveupdate_memfd
+++ a/mm/Makefile
@@ -100,7 +100,7 @@ obj-$(CONFIG_NUMA) += memory-tiers.o
 obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
 obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
-obj-$(CONFIG_LIVEUPDATE) += memfd_luo.o
+obj-$(CONFIG_LIVEUPDATE_MEMFD) += memfd_luo.o
 obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
 obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
 ifdef CONFIG_SWAP
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

kho-validate-preserved-memory-map-during-population.patch
list-add-primitives-for-private-list-manipulations.patch
list-add-kunit-test-for-private-list-primitives.patch
liveupdate-luo_file-use-private-list.patch
liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch
liveupdate-separate-memfd-support-into-liveupdate_memfd.patch

