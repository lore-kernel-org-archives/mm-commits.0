Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF241BC4E
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719289473; cv=none; b=XYj6y9oLLC7Sw822SlgU4mdGlbhRYar+MO86NjgtA66Rx+4tfrxV5Rg9QFSBdAriFsnPWnDKrsUt4HY3U9m/s/L/HyJPXz9s0g5RgoVqsKaGJypIDOtcQwTUwpyk5vlM6w2DOsj7x+Bw5uS/UymAoFjQnyGg9mHU9CRuIcgUbJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719289473; c=relaxed/simple;
	bh=U/9XYJF/awx4LSMshOkT+jYsG7/pX09dxnc3XdMm+6I=;
	h=Date:To:From:Subject:Message-Id; b=OWmV6wJgtCRQefr8Zp4kAL0bEyA05uIKRDp2f+OrjV02IU1G6YE2TiVs05ThXPVzpZQl278uzCW+1b4QsksSgJXDIAzGxwjKf/1yqpq52PSgOn/XjfC5vk5Ygxmrc9Y/VdYvOWFVnRJzGJcHbv0xWGRNnQOmP60Drk709jCuTy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dGGvRDMb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dGGvRDMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05BB3C32782;
	Tue, 25 Jun 2024 04:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719289473;
	bh=U/9XYJF/awx4LSMshOkT+jYsG7/pX09dxnc3XdMm+6I=;
	h=Date:To:From:Subject:From;
	b=dGGvRDMbNnmr7vA3kd8PSQZXDLZlPV91pRYZgrzA5w4GZpS9/upi1D+Oa3QwFmlCJ
	 istpLRwYSXceZlvLY4hqKpTkhexBQM3wdjYB8sh1KE3xnpBiTz4fVBe/992DfQ+Goh
	 T46LnpUTQiNPn5ly8M9HifC3GjZro5Y7fAUaczzQ=
Date: Mon, 24 Jun 2024 21:24:32 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-3.patch removed from -mm tree
Message-Id: <20240625042433.05BB3C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-3
has been removed from the -mm tree.  Its filename was
     mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-3.patch

This patch was dropped because it was folded into mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem.patch

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
mm-shmem-add-thp-validation-for-pmd-mapped-thp-related-statistics.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem.patch
mm-shmem-add-mthp-support-for-anonymous-shmem.patch
mm-shmem-add-mthp-size-alignment-in-shmem_get_unmapped_area.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem-fix.patch
mm-memcontrol-add-vm_bug_on_folio-to-catch-lru-folio-in-mem_cgroup_migrate.patch

