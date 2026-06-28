Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F305418AFE;
	Sun, 28 Jun 2026 06:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782627335; cv=none; b=EQ6ATKp6/bi+DJgMAEQEPNZatFZhjxJf0QfqnqyheRqr2YuOPm873vkjm1ksuF9qunsPOAYCOXmLVR9qeYLDVfiZn+5Y8mA/irz29UF8TPnVfG97Sm0aG1PC1n48hgGfDmdMrzjpmCWU2CLel4fdeYW8mcpWvBYRR6wpOR3lT3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782627335; c=relaxed/simple;
	bh=AMQhf81BmeFQOMriFin92dawN0IkgkVyV0b85QZfoaw=;
	h=Date:To:From:Subject:Message-Id; b=fF8CYdZZM02oVtEByMOj4FQY8nAuOlnhcGvbpkgyOfNw+shl8FsTEGePvgvq+3/4Sm5N0hwMDU4UqPEpelUT439xDonZHpJlGFygdfTLcT/gjOHr6YsZwOgdvqC1C7v5zkZcPdS8jBD+vVfPtHeKA62GpWUsOo3h9S7EEV93YQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lbSANzlm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lbSANzlm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874861F000E9;
	Sun, 28 Jun 2026 06:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782627333;
	bh=VQkzvU9WG8XMfasuGV9v0QSt3LxwQr47wVWfhh9kTYA=;
	h=Date:To:From:Subject;
	b=lbSANzlmq6XQc/rgKqnBr/5WcyEt0U7Lis1E9gqKBmwDWDxcJ7qfj5fk5TMMKlCel
	 nny3PTjhnrpJsoZnrz5v2OB0r4Kz9hBush0Wx1FIrd382Y2yqxrqYcBAyuGEkEnuc2
	 kHuhkTBriT8SdmvvIIt3Go3KjhSIBkp7iLKM4pyk=
Date: Sat, 27 Jun 2026 23:15:33 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,tj@kernel.org,stable@vger.kernel.org,rakie.kim@sk.com,matthew.brost@intel.com,longman@redhat.com,linux@rasmusvillemoes.dk,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,farhad.alemi@berkeley.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + cgroup-cpuset-rebind-mm-mempolicy-to-effective_mems-not-mems_allowed.patch added to mm-hotfixes-unstable branch
Message-Id: <20260628061533.874861F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: cgroup/cpuset: rebind mm mempolicy to effective_mems, not mems_allowed
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     cgroup-cpuset-rebind-mm-mempolicy-to-effective_mems-not-mems_allowed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cgroup-cpuset-rebind-mm-mempolicy-to-effective_mems-not-mems_allowed.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

cgroup-cpuset-rebind-mm-mempolicy-to-effective_mems-not-mems_allowed.patch

