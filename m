Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C7E435AAA
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 22:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783377244; cv=none; b=h8hoT+95coFN0jWwJbXFOr5FAoVs5HWCcD3LLiAtnhk8GVktPk2GetqrIc0RqFj8fZgDibTGPQ89Au5LhS7ClnLC2YC1LdfmP3GlpnS+obI8ABk113yvz8Szw8jKhcrB+wmWuroJu4606OoXTL/xHikgthsrDNj5rTTNjjFiOF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783377244; c=relaxed/simple;
	bh=I6pqv/qTPLyDdOHKilCLy/w4u2ECTBjt4BE/kBZv32Q=;
	h=Date:To:From:Subject:Message-Id; b=lzH52HH6pBNr0srwqPYvc6nWnXG5CGEnVceBXeDg4m8UXaKfuzw5D+r2Hc8oueeVJv4X36UpuEMdkouFmNGmvUSG/Pw3kbEn1WGMZ2gddeuMwvkDRCEjzjdgT0f5HX1rYtQVeRkjqmnYUfUjMW/2fDGKA2fNixylxz9AZUEZEHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HUepEe1f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HUepEe1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB221F000E9;
	Mon,  6 Jul 2026 22:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783377242;
	bh=7BClQTHLH2iEo18ldS4Wbl3Z+dc/awCjIIps33r2wDQ=;
	h=Date:To:From:Subject;
	b=HUepEe1fZ5WlENMdzl6TRXPVpsUvaR3ad1EnMHfQOV//pPDV4GtyRN4wrb0wSi/Q8
	 /MOIl43stocFkE+igh3zkqD5QljhFVUaFK69ZGGmgFT8zNdt0Q6Jh6J1mEz6RpHLJc
	 C360HNzRtGV+gt3cEPgRLtLbpHYGBHkozbjC3LRg=
Date: Mon, 06 Jul 2026 15:34:02 -0700
To: mm-commits@vger.kernel.org,farhad.alemi@berkeley.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] cgroup-cpuset-rebind-mm-mempolicy-to-effective_mems-not-mems_allowed.patch removed from -mm tree
Message-Id: <20260706223402.7DB221F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: cgroup/cpuset: rebind mm mempolicy to effective_mems, not mems_allowed
has been removed from the -mm tree.  Its filename was
     cgroup-cpuset-rebind-mm-mempolicy-to-effective_mems-not-mems_allowed.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Farhad Alemi <farhad.alemi@berkeley.edu>
Subject: cgroup/cpuset: rebind mm mempolicy to effective_mems, not mems_allowed
Date: Sun, 14 Jun 2026 06:25:55 -0700

Creating a child cpuset where cpuset.mems is never set leads to a div/0
when a VMA mempolicy with MPOL_F_RELATIVE_NODES rebinds in response to a
CPU hotplug event.

Reproduction steps:
 1) Create a cgroup w/ cpuset controls (do not set cpuset.mems)
 2) Move the task into the child cpuset
 3) Create a VMA mempolicy for that task with MPOL_F_RELATIVE_NODES
 4) unplug and hotplug a cpu
      echo 0 > /sys/devices/system/cpu/cpu1/online
      echo 1 > /sys/devices/system/cpu/cpu1/online
 5) mempolicy rebind does a div/0 in mpol_relative_nodemask on the
    call to __nodes_fold()

The cpuset code passes (cs->mems_allowed) which is not guaranteed to have
nodes to the rebind routine.  Use cs->effective_mems instead, which is
guaranteed to have a non-empty nodemask.

Link: https://lore.kernel.org/linux-mm/CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+afQBbGNmw@mail.gmail.com/
Link: https://lore.kernel.org/all/CA+0ovCiEz6SP_sn3kN4Tb+_oC=eHMXy_Ffj=usV3wREdQrUtww@mail.gmail.com/
Link: https://lore.kernel.org/CA+0ovCgfHJHv5d1mzapWWvF-LhjppzDX8NPPLvCPZxPKg8RiYw@mail.gmail.com
Fixes: ae1c802382f7 ("cpuset: apply cs->effective_{cpus,mems}")
Signed-off-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Suggested-by: Gregory Price <gourry@gourry.net>
Suggested-by: Waiman Long <longman@redhat.com>
Closes: https://lore.kernel.org/linux-mm/CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+afQBbGNmw@mail.gmail.com/
Acked-by: Waiman Long <longman@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup/cpuset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/cgroup/cpuset.c~cgroup-cpuset-rebind-mm-mempolicy-to-effective_mems-not-mems_allowed
+++ a/kernel/cgroup/cpuset.c
@@ -2653,7 +2653,7 @@ void cpuset_update_tasks_nodemask(struct
 
 		migrate = is_memory_migrate(cs);
 
-		mpol_rebind_mm(mm, &cs->mems_allowed);
+		mpol_rebind_mm(mm, &cs->effective_mems);
 		if (migrate)
 			cpuset_migrate_mm(mm, &cs->old_mems_allowed, &newmems);
 		else
_

Patches currently in -mm which might be from farhad.alemi@berkeley.edu are


