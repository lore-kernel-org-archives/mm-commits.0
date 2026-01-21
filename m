Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA845358D32
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967370; cv=none; b=VC6AXjyzCJwrIVjqAeGyLNPO2HXiS2/Bu4p1jUwBJqbgnBNIPHW+UVNrvPU6pHXV76GezQNg57TzORUwY4lni8HXIFMmH4FuInLj31d2qGoD1Ai+C+rrgEWZA8nu7Vu9vaA7kQu4DqIV18lGBs08CfI7Mp2WGeO+GN3+2uuyBD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967370; c=relaxed/simple;
	bh=vHC4XL4Rz6LqcwelrVv1mTpkwh2zHuwBy1ALLl3e+JY=;
	h=Date:To:From:Subject:Message-Id; b=u/B4fpePvwcvTsAmY0xZOuA/NY+krTiq/CCeeSw1Cn8pTaJmV7+VIdamettgA38wnAu8Vd0/a4RGbh26isOe14T5gmG/PcwSujx9awKe5CvaSa57aI5MPJWWNUtzvCCsOtofZJ8eCPAqnnoACrHR4GseFHfD1pQFNaWerFnoGaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aOa1ijAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aOa1ijAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24C9C16AAE;
	Wed, 21 Jan 2026 03:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967369;
	bh=vHC4XL4Rz6LqcwelrVv1mTpkwh2zHuwBy1ALLl3e+JY=;
	h=Date:To:From:Subject:From;
	b=aOa1ijAg6ajUqSqN2zjz1ZGAolmdmldjEiz63Qcy7J/RklUKhkbc8I5vnik17/RNz
	 j8SW97M38ebmVlaAb2oTsS/s2lKBYP1zKB1OqVerIdpozGeXdsJOIm2W4tIAuppK+O
	 ROQ3BaG1VmiUegSUt5gUGZoAxvG5jG4V01esCobs=
Date: Tue, 20 Jan 2026 19:49:29 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] liveupdate-separate-memfd-support-into-liveupdate_memfd.patch removed from -mm tree
Message-Id: <20260121034929.A24C9C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: liveupdate: separate memfd support into LIVEUPDATE_MEMFD
has been removed from the -mm tree.  Its filename was
     liveupdate-separate-memfd-support-into-liveupdate_memfd.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


