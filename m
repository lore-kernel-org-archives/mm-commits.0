Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C2E1BC4E
	for <mm-commits@vger.kernel.org>; Sun, 16 Jun 2024 17:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718560047; cv=none; b=Rf8ZxN4jc9bkqPFkbfRo5hd4bX8ubvNP31V7tIZFddN8ZzJTdGSzgZ0abZi8JkxpfaoAEnAN8ezOLWHNgGRSlw03Tjtz4RBA7EPlMKk6nrps/f8EkJpgCYJ6SmNYRag7oW6YSa28SlV1PqB36LlsHb6qT3ZcNogDr2PVOEhKuU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718560047; c=relaxed/simple;
	bh=VFbTJwEZlWCSOCHIjJ3F+alfh9uBF/MFHI4Kp3dn/9U=;
	h=Date:To:From:Subject:Message-Id; b=pQaFMx3Tcfj7XP0PHkNwr5Jwhp0KswK0PqHGlwv+/K9j+rsd4iAU4B59gReAIJJDR/nxq9IxzH8CK1jwVqbf+4QgVfCm4ObZfA/g11UiB98DpBtfO3Okau/3xjm+cQmJ9j6+dVf647hBNPCIQQgviJ44ngOTkRUJnFP7okcR3Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZOLH+WAV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZOLH+WAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ADD7C2BBFC;
	Sun, 16 Jun 2024 17:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718560046;
	bh=VFbTJwEZlWCSOCHIjJ3F+alfh9uBF/MFHI4Kp3dn/9U=;
	h=Date:To:From:Subject:From;
	b=ZOLH+WAVKuh2auAl9RdFdv9zra2NbaZR6akCFsBH0V5rAJh6t+FYolacTW0WK+h1b
	 sG6QcSeahqa7KEOqzzIh0SARJdJudILu+YpZpDiSITGMqu5dxbjK/0/Y50ireALOal
	 CzFNfiVm9yIBX17X4Jd7SXOX3BFM0XF+Jiw+pifM=
Date: Sun, 16 Jun 2024 10:47:25 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-3.patch added to mm-unstable branch
Message-Id: <20240616174726.9ADD7C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-3
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-3.patch

This patch will later appear in the mm-unstable branch at
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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-3
Date: Sun, 16 Jun 2024 21:45:27 +0800

move huge_shmem_orders_lock under CONFIG_SYSFS

Link: https://lkml.kernel.org/r/eb34da66-7f12-44f3-a39e-2bcc90c33354@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202406152213.CoQNZR6z-lkp@intel.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-3
+++ a/mm/shmem.c
@@ -136,7 +136,6 @@ static unsigned long huge_shmem_orders_a
 static unsigned long huge_shmem_orders_madvise __read_mostly;
 static unsigned long huge_shmem_orders_inherit __read_mostly;
 static unsigned long huge_shmem_orders_within_size __read_mostly;
-static DEFINE_SPINLOCK(huge_shmem_orders_lock);
 #endif
 
 #ifdef CONFIG_TMPFS
@@ -4757,6 +4756,7 @@ static ssize_t shmem_enabled_store(struc
 }
 
 struct kobj_attribute shmem_enabled_attr = __ATTR_RW(shmem_enabled);
+static DEFINE_SPINLOCK(huge_shmem_orders_lock);
 
 static ssize_t thpsize_shmem_enabled_show(struct kobject *kobj,
 					  struct kobj_attribute *attr, char *buf)
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-memory-extend-finish_fault-to-support-large-folio.patch
mm-memory-extend-finish_fault-to-support-large-folio-fix.patch
mm-memory-extend-finish_fault-to-support-large-folio-fix-fix.patch
mm-shmem-add-thp-validation-for-pmd-mapped-thp-related-statistics.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-3.patch
mm-shmem-add-mthp-support-for-anonymous-shmem.patch
mm-shmem-add-mthp-size-alignment-in-shmem_get_unmapped_area.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem-fix.patch
mm-memcontrol-add-vm_bug_on_folio-to-catch-lru-folio-in-mem_cgroup_migrate.patch

