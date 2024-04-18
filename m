Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0AF4503A
	for <mm-commits@vger.kernel.org>; Thu, 18 Apr 2024 20:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713472051; cv=none; b=ckX9dOS22oZnBQLWAuC15Juw3b6lE7q+VgDhbEdOJPUHFl/kjoHoikfoiizBUR93Z+gQ/MWXbBCHBgEGUC+Z0SqurlGeEZZiKdu1Pdk2NrXDEuSdAqUaQQFIc4JaRDJDvV3Eimup/2rbG0oXMGftbXogm8HHZCyLCyCEyxXqPJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713472051; c=relaxed/simple;
	bh=SBrkyYdHCiLUEW3GGR8Ppf9/AS9YJrIbr5pDSi90qJs=;
	h=Date:To:From:Subject:Message-Id; b=r0Qr56bsd3TPO6Bw/9MfVJ63cbi8VRXrsD8c1sTFLtVZeiGRhDEyVfZ3IsUpYtsMFulrQcnJww43Ms8OGSYYuwXh/80DHsO9P7pQVlAj1En2naUe5bStHKn6v1aRO5nsneyhp0KSva3+gtjeaHqWdeBrgWK/+bia2LacX48uPB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zAAYu2Od; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zAAYu2Od"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22998C113CC;
	Thu, 18 Apr 2024 20:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713472050;
	bh=SBrkyYdHCiLUEW3GGR8Ppf9/AS9YJrIbr5pDSi90qJs=;
	h=Date:To:From:Subject:From;
	b=zAAYu2OdqhmkTivgfiNugFTQeqDZ/BH6xuCIkzVDAO7OFjbPWIHNV2aHvmiLPUWRJ
	 dN/araDkPatFC+AJv+VpH7KFMivS+3IgtSa3Kwx8Im2JoCKyIwqSWN72MkUFGOjzen
	 5URDFblPR1YWYh7CQWOJroS3GW4Q8VUYxmFVofng=
Date: Thu, 18 Apr 2024 13:27:29 -0700
To: mm-commits@vger.kernel.org,jirislaby@kernel.org,dyoung@redhat.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash-add-prefix-for-crash-dumping-messages.patch added to mm-nonmm-unstable branch
Message-Id: <20240418202730.22998C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash: add prefix for crash dumping messages
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash-add-prefix-for-crash-dumping-messages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash-add-prefix-for-crash-dumping-messages.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: crash: add prefix for crash dumping messages
Date: Thu, 18 Apr 2024 11:58:43 +0800

Add pr_fmt() to kernel/crash_core.c to add the module name to debugging
message printed as prefix.

And also add prefix 'crashkernel:' to two lines of message printing code
in kernel/crash_reserve.c. In kernel/crash_reserve.c, almost all
debugging messages have 'crashkernel:' prefix or there's keyword
crashkernel at the beginning or in the middle, adding pr_fmt() makes it
redundant.

Link: https://lkml.kernel.org/r/20240418035843.1562887-1-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c    |    2 ++
 kernel/crash_reserve.c |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/crash_core.c~crash-add-prefix-for-crash-dumping-messages
+++ a/kernel/crash_core.c
@@ -4,6 +4,8 @@
  * Copyright (C) 2002-2004 Eric Biederman  <ebiederm@xmission.com>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/buildid.h>
 #include <linux/init.h>
 #include <linux/utsname.h>
--- a/kernel/crash_reserve.c~crash-add-prefix-for-crash-dumping-messages
+++ a/kernel/crash_reserve.c
@@ -109,7 +109,7 @@ static int __init parse_crashkernel_mem(
 
 		size = memparse(cur, &tmp);
 		if (cur == tmp) {
-			pr_warn("Memory value expected\n");
+			pr_warn("crashkernel: Memory value expected\n");
 			return -EINVAL;
 		}
 		cur = tmp;
@@ -132,7 +132,7 @@ static int __init parse_crashkernel_mem(
 			cur++;
 			*crash_base = memparse(cur, &tmp);
 			if (cur == tmp) {
-				pr_warn("Memory value expected after '@'\n");
+				pr_warn("crahskernel: Memory value expected after '@'\n");
 				return -EINVAL;
 			}
 		}
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmallocc-optimize-to-reduce-arguments-of-alloc_vmap_area.patch
x86-remove-unneeded-memblock_find_dma_reserve.patch
mm-mm_initc-remove-the-useless-dma_reserve.patch
mm-mm_initc-add-new-function-calc_nr_all_pages.patch
mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch
mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core-v3.patch
mm-mm_initc-remove-unneeded-calc_memmap_size.patch
mm-mm_initc-remove-arch_reserved_kernel_pages.patch
mm-move-array-mem_section-init-code-out-of-memory_present.patch
mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node.patch
mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node-v2.patch
mm-make-__absent_pages_in_range-as-static.patch
mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists.patch
mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-v2.patch
mm-mm_initc-remove-the-outdated-code-comment-above-deferred_grow_zone.patch
mm-page_allocc-dont-show-protection-in-zones-lowmem_reserve-for-empty-zone.patch
mm-page_allocc-change-the-array-length-to-migrate_pcptypes.patch
documentation-kdump-clean-up-the-outdated-description.patch
kexec-fix-the-unexpected-kexec_dprintk-macro.patch
crash-add-prefix-for-crash-dumping-messages.patch

