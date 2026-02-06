Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7F22EBDDE
	for <mm-commits@vger.kernel.org>; Fri,  6 Feb 2026 06:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770358629; cv=none; b=FaFREmQna7t5V5k0w+wO1kVwv+zptSwbMFJjCsHSEZwHpsiifvUGGgKaPGLAss8gU8weVfvXAwqmYvolztXzO/SNto2hjt3aEVTvKGKzVp/KiHnJs6x5tZoIUhbVkFBbx84eEzpeq8mrvNMtXyfMUesEaAeHiBflRldEd6aGkkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770358629; c=relaxed/simple;
	bh=K6e5RECKGrD4WMYroLmwRfFSK5vuwv2U6C0M/aSta2o=;
	h=Date:To:From:Subject:Message-Id; b=epvb/h9Y0xb6xl6M8CAfXBhk7GVocKaxS9qTfP7+q0H/SSPCtTlz6ptqPW7JdNy7LHC/zV6eYqdGa2JpdemytDNsDcg8442cCQ6yKp7NZpr7/QnhgEZGyXTSbgs8wC+OLiqD9ojIQ2KCMhqL71JsEYC+Lc2hlZlgO6YcfBm6PCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YpUF7Scs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YpUF7Scs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DF5C116C6;
	Fri,  6 Feb 2026 06:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770358628;
	bh=K6e5RECKGrD4WMYroLmwRfFSK5vuwv2U6C0M/aSta2o=;
	h=Date:To:From:Subject:From;
	b=YpUF7ScscefZJC/NxmxDsvYysh6oRWqu+aZLvYJWw3OzW6cCnb1RE3LTFOBw9oGrp
	 wvMZt2JFGSu3lC+BMVRTT0/ri+qduo9xpP093qYqvt/Pk17kpeiEK972Omsm92ZZBQ
	 jPxHoIz1z4UrePPZXu0xkiY1SmtzcPTN5eCJEtcQ=
Date: Thu, 05 Feb 2026 22:17:08 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-fix-missing-early_memunmap-call-in-kho_populate.patch added to mm-nonmm-unstable branch
Message-Id: <20260206061708.93DF5C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: fix missing early_memunmap() call in kho_populate()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-fix-missing-early_memunmap-call-in-kho_populate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-fix-missing-early_memunmap-call-in-kho_populate.patch

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
From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: kho: fix missing early_memunmap() call in kho_populate()
Date: Fri, 6 Feb 2026 04:31:20 +0000

kho_populate() returns without calling early_memunmap() on success path,
this will cause early ioremap virtual address space leak.

Link: https://lkml.kernel.org/r/20260206043121.197564-2-ranxiaokai627@163.com
Fixes: b50634c5e84a ("kho: cleanup error handling in kho_populate()")
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Cc: Alexander Graf <graf@amazon.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-fix-missing-early_memunmap-call-in-kho_populate
+++ a/kernel/liveupdate/kexec_handover.c
@@ -1463,6 +1463,7 @@ void __init kho_populate(phys_addr_t fdt
 	struct kho_scratch *scratch = NULL;
 	phys_addr_t mem_map_phys;
 	void *fdt = NULL;
+	int populated = 0;
 	int err;
 
 	/* Validate the input FDT */
@@ -1529,16 +1530,17 @@ void __init kho_populate(phys_addr_t fdt
 	kho_in.scratch_phys = scratch_phys;
 	kho_in.mem_map_phys = mem_map_phys;
 	kho_scratch_cnt = scratch_cnt;
-	pr_info("found kexec handover data.\n");
 
-	return;
+	populated = 1;
+	pr_info("found kexec handover data.\n");
 
 err_unmap_scratch:
 	early_memunmap(scratch, scratch_len);
 err_unmap_fdt:
 	early_memunmap(fdt, fdt_len);
 err_report:
-	pr_warn("disabling KHO revival\n");
+	if (!populated)
+		pr_warn("disabling KHO revival\n");
 }
 
 /* Helper functions for kexec_file_load */
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are

kho-fix-missing-early_memunmap-call-in-kho_populate.patch
kho-remove-unnecessary-warn_onerr-in-kho_populate.patch

