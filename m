Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACC028371
	for <mm-commits@vger.kernel.org>; Thu, 26 Sep 2024 21:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727384648; cv=none; b=q1gRtGMomsVZveWHteYBdragKoIf+WhLK/fcHeeE64qiE0ChDIc0GLYy73m/asT/S7+w8+A85+v12ckHbsK8UQZKlWDksWr5Pwi8S0RyNdybheyic712xKMNZKaAQct9AK/rmWu4teg8DVWmouw+c4QMdZoBfrWtERskcNer1Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727384648; c=relaxed/simple;
	bh=l5jHMeeLcXlqfhvyPIgR+rBCmqoHB/9jv+AW4MqaiZM=;
	h=Date:To:From:Subject:Message-Id; b=d0qt8uwWBoTENms+/WDtXpFSiRLSBIBVOvexFwPlVOLyCJ0dkYnej0+2qW+3i24/u02L9/FPqnMuC42R2TXCOCvTGIRbonQPdmF52UgYdPRGJTxMqBCE8UddxwqnnXZSlcL5hsS43Wykkb6H/Zwh+OLq+SxjZwade0rPBUfrOkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U8Q1DyfA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U8Q1DyfA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFE2C4AF09;
	Thu, 26 Sep 2024 21:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727384647;
	bh=l5jHMeeLcXlqfhvyPIgR+rBCmqoHB/9jv+AW4MqaiZM=;
	h=Date:To:From:Subject:From;
	b=U8Q1DyfALPticvJsyVN2pA0/PeeH9pOa8dNKJU/RdH10PdYE0I1xrHm2sr9m1QPcz
	 EScuY4JXfkBJ8AY5wR/mVrsEzLzAll5BhzpAdh+8cEASMIkI4lWf5BZaTqM+ddygeQ
	 atk6Wdm0dbUxnJJeSqt6fdl6Kl3tBjkeQU5BQ4FI=
Date: Thu, 26 Sep 2024 14:04:07 -0700
To: mm-commits@vger.kernel.org,geert@linux-m68k.org,david@redhat.com,linux@roeck-us.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-make-split_pte_ptlocks-depend-on-smp.patch removed from -mm tree
Message-Id: <20240926210407.ADFE2C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make SPLIT_PTE_PTLOCKS depend on SMP
has been removed from the -mm tree.  Its filename was
     mm-make-split_pte_ptlocks-depend-on-smp.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Guenter Roeck <linux@roeck-us.net>
Subject: mm: make SPLIT_PTE_PTLOCKS depend on SMP
Date: Tue, 24 Sep 2024 08:42:05 -0700

SPLIT_PTE_PTLOCKS depends on "NR_CPUS >= 4".  Unfortunately, that
evaluates to true if there is no NR_CPUS configuration option.  This
results in CONFIG_SPLIT_PTE_PTLOCKS=y for mac_defconfig.  This in turn
causes the m68k "q800" and "virt" machines to crash in qemu if debugging
options are enabled.

Making CONFIG_SPLIT_PTE_PTLOCKS dependent on the existence of NR_CPUS does
not work since a dependency on the existence of a numeric Kconfig entry
always evaluates to false.  Example:

config HAVE_NO_NR_CPUS
       def_bool y
       depends on !NR_CPUS

After adding this to a Kconfig file, "make defconfig" includes:
$ grep NR_CPUS .config
CONFIG_NR_CPUS=64
CONFIG_HAVE_NO_NR_CPUS=y

Defining NR_CPUS for m68k does not help either since many architectures
define NR_CPUS only for SMP configurations.

Make SPLIT_PTE_PTLOCKS depend on SMP instead to solve the problem.

Link: https://lkml.kernel.org/r/20240924154205.1491376-1-linux@roeck-us.net
Fixes: 394290cba966 ("mm: turn USE_SPLIT_PTE_PTLOCKS / USE_SPLIT_PTE_PTLOCKS into Kconfig options")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/Kconfig~mm-make-split_pte_ptlocks-depend-on-smp
+++ a/mm/Kconfig
@@ -595,6 +595,7 @@ config ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
 config SPLIT_PTE_PTLOCKS
 	def_bool y
 	depends on MMU
+	depends on SMP
 	depends on NR_CPUS >= 4
 	depends on !ARM || CPU_CACHE_VIPT
 	depends on !PARISC || PA20
_

Patches currently in -mm which might be from linux@roeck-us.net are


