Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C3A2B9D8;
	Thu,  8 Feb 2024 20:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707424906; cv=none; b=NQcHAOt7nxwBoSGRSvulgLaGQoXIL2yHYWyYMJdUEmER/EUr71uO6xdzLRX1W0NbMTMEQkeGSBeqdWNdV/a0TS4lY93mJlAJIuZjxBXsATr1g0sw5OWljpfwd5uLVaEZQ+Oi8tlFysXe6t3OaouNoBtbjzwYepgx7p5bJKMwTys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707424906; c=relaxed/simple;
	bh=iymS9N6MpSa6UZMdjc9Nay8JksKAosETXud5N90lqPY=;
	h=Date:To:From:Subject:Message-Id; b=IkRr4GuqWJxH4WLvAvEeAQ+Ej6+jgbFDMz+Y5Wx/O0rc48yrP17Agsj4lLyYCPJT6KiQ0i++hLUvW5OoeAr85K3kWJu38n4mV2laDJrjxOOcPlQFMa8nsq2t+OHMNe1fbECYiOB/lfvRrbokfJCWc2uMnhV9Sut0S+cOtKr+b+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dc4Bu3rv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dc4Bu3rv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45980C433F1;
	Thu,  8 Feb 2024 20:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707424905;
	bh=iymS9N6MpSa6UZMdjc9Nay8JksKAosETXud5N90lqPY=;
	h=Date:To:From:Subject:From;
	b=Dc4Bu3rvCO/VMvuhv7AmAxsA0HfM0ffX/0UjhplUJDKocHzg5CeF4zH1cpkMydtuv
	 SZ5VfkAgtjre88gigvglDIcnKqZ/Ciwjf0glGXwsAZL13f+KjV/QV7eXbVXf1ci4yK
	 x8EU1VqqrGloZeNjxrFGThWFNR2Ir9OU5bpfkL/I=
Date: Thu, 08 Feb 2024 12:41:44 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,david@redhat.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-add-display-flag-for-vm_mayoverlay.patch added to mm-hotfixes-unstable branch
Message-Id: <20240208204145.45980C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: add display flag for VM_MAYOVERLAY
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-proc-task_mmu-add-display-flag-for-vm_mayoverlay.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-add-display-flag-for-vm_mayoverlay.patch

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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: fs/proc/task_mmu: add display flag for VM_MAYOVERLAY
Date: Thu, 8 Feb 2024 14:18:05 +0530

VM_UFFD_MISSING flag is mutually exclussive with VM_MAYOVERLAY flag as
they both use the same bit position i.e 0x00000200 in the vm_flags.  Let's
update show_smap_vma_flags() to display the correct flags depending on
CONFIG_MMU.

Link: https://lkml.kernel.org/r/20240208084805.1252337-1-anshuman.khandual@arm.com
Fixes: b6b7a8faf05c ("mm/nommu: don't use VM_MAYSHARE for MAP_PRIVATE mappings")
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-add-display-flag-for-vm_mayoverlay
+++ a/fs/proc/task_mmu.c
@@ -681,7 +681,11 @@ static void show_smap_vma_flags(struct s
 		[ilog2(VM_HUGEPAGE)]	= "hg",
 		[ilog2(VM_NOHUGEPAGE)]	= "nh",
 		[ilog2(VM_MERGEABLE)]	= "mg",
+#ifdef CONFIG_MMU
 		[ilog2(VM_UFFD_MISSING)]= "um",
+#else
+		[ilog2(VM_MAYOVERLAY)]	= "ov",
+#endif /* CONFIG_MMU */
 		[ilog2(VM_UFFD_WP)]	= "uw",
 #ifdef CONFIG_ARM64_MTE
 		[ilog2(VM_MTE)]		= "mt",
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

fs-proc-task_mmu-add-display-flag-for-vm_mayoverlay.patch
mm-cma-dont-treat-bad-input-arguments-for-cma_alloc-as-its-failure.patch
mm-cma-drop-config_cma_debug.patch
mm-cma-make-max_cma_areas-=-config_cma_areas.patch
mm-cma-add-sysfs-file-release_pages_success.patch

