Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B4B35957
	for <mm-commits@vger.kernel.org>; Sat,  7 Jun 2025 21:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749331941; cv=none; b=bnITowVWDJcbv8d2+JN4DDPO8tPG+7qg9runB/2O/FLfGQuRazPw66+NMaEGNrRnXBFlKbCjYaW7uxNEKAD1WMzHmLk2h1egQ/Bp5PGnHGpb4VrUuRcPLz3XB/hBZDgNNc1N7+PXlVPoxz3s8a5elv6T+0905hsJ14DoH1TKOOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749331941; c=relaxed/simple;
	bh=5kXNS2WITsyqXte7B242TTU80hsHGj3hITWb9iAEKKE=;
	h=Date:To:From:Subject:Message-Id; b=BqxvF/9DgXXl0K0i1IuxyZLC04m7NcorUwDQPALQ51zlr8Kmg50BnyBuhr5X92CCebo1fW9klgY4noSeFeO8bXHbvhgxcl/a63D29ltRJThsDFPQYyu3dlTbIUh6mbHJ35NUm/xUhMiO/+ydmto3p4WRJMdcQUGCC7ih2BIO7P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U5OM+Wzr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U5OM+Wzr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77A1C4CEE4;
	Sat,  7 Jun 2025 21:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749331941;
	bh=5kXNS2WITsyqXte7B242TTU80hsHGj3hITWb9iAEKKE=;
	h=Date:To:From:Subject:From;
	b=U5OM+WzrsWjXHdVUwraFtI9UXEym92OsVii1yJBpa/9BKXSphY1RMGlEHm1SbBQJq
	 ySXGFHTeqXAxjxJU/izaYpkMvcbblXsqr7ehZ9YY+TS5jRTXQE2KyQAq514J3RZS8W
	 N8K8z3eBdCQpay4RBQchXT8n7//Ub67Z+PettxD0=
Date: Sat, 07 Jun 2025 14:32:20 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,liam.howlett@oracle.com,david@redhat.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,broonie@kernel.org,andrii@kernel.org,wangfushuai@baidu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-add-vm_shadow_stack-for-arm64-when-support-gcs.patch added to mm-hotfixes-unstable branch
Message-Id: <20250607213220.E77A1C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: add VM_SHADOW_STACK for arm64 when support GCS
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-proc-task_mmu-add-vm_shadow_stack-for-arm64-when-support-gcs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-add-vm_shadow_stack-for-arm64-when-support-gcs.patch

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
From: wangfushuai <wangfushuai@baidu.com>
Subject: fs/proc/task_mmu: add VM_SHADOW_STACK for arm64 when support GCS
Date: Sat, 7 Jun 2025 21:15:25 +0800

The recent commit adding VM_SHADOW_STACK for arm64 GCS did not update
the /proc/[pid]/smaps display logic to show the "ss" flag for GCS pages.
This patch adds the necessary condition to display "ss" flag.

Link: https://lkml.kernel.org/r/20250607131525.76746-1-wangfushuai@baidu.com
Fixes: ae80e1629aea ("mm: Define VM_SHADOW_STACK for arm64 when we support GCS")
Signed-off-by: wangfushuai <wangfushuai@baidu.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-add-vm_shadow_stack-for-arm64-when-support-gcs
+++ a/fs/proc/task_mmu.c
@@ -994,6 +994,9 @@ static void show_smap_vma_flags(struct s
 #ifdef CONFIG_ARCH_HAS_USER_SHADOW_STACK
 		[ilog2(VM_SHADOW_STACK)] = "ss",
 #endif
+#if defined(CONFIG_ARM64_GCS)
+		[ilog2(VM_SHADOW_STACK)] = "ss",
+#endif
 #if defined(CONFIG_64BIT) || defined(CONFIG_PPC32)
 		[ilog2(VM_DROPPABLE)] = "dp",
 #endif
_

Patches currently in -mm which might be from wangfushuai@baidu.com are

docs-proc-update-vmflags-documentation-in-smaps.patch
fs-proc-task_mmu-add-vm_shadow_stack-for-arm64-when-support-gcs.patch

