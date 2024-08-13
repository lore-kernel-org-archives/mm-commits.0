Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FB219925F
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 23:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723591958; cv=none; b=LRDD5cNUjuXq4TVyzwsTdGjWMGc4Y2fXAo9LXbffQlIUb0lGKqjn9R4m5nhlxrEePylQjp85c0tKK9aPd4CmyKrXv1rsLhtxuTRKZHki21fKf7hqLCqUTPDW0paX2NnaR3oOPtEYFaosQwtiMvxqXDIE5E455L5+Xthr69iAbtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723591958; c=relaxed/simple;
	bh=NRgueCK50Xhqa37v4M1gwwc1sKJ6g3hrnAKSISKFXfk=;
	h=Date:To:From:Subject:Message-Id; b=AKm2jaUWFP4D/TnhLM7l42gNJzF0Vz5qDRuJIpV3zP3Ux9VdFLPFxDLH2dxlmT0SapsZKzh+F48utEremQMT6k4neXXmxc5yXfhqNEYsmiX9b4taOPVS84WG5lkg3CYNV7tZXuztIC/z4tzjq3rwC+tJ/PYQ8t2ehYJOhvTjvUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FAXJ3vLE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FAXJ3vLE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C3AC32782;
	Tue, 13 Aug 2024 23:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723591958;
	bh=NRgueCK50Xhqa37v4M1gwwc1sKJ6g3hrnAKSISKFXfk=;
	h=Date:To:From:Subject:From;
	b=FAXJ3vLEg0utRSvlxirYYfH5ud0T82rJnT9D2dqyrfWFDVWFmOTIzqFnoQW+3i7EI
	 wEdD6AifwOXmlx7q0kvgQJiPGmUwJqp8s8wiN4SJledyhUGeo589v+BUTKuJ3cKb+8
	 jV1n8IR9jeOoLdb4Oaay+Vy8yQzdtQ2FRCtrqT6o=
Date: Tue, 13 Aug 2024 16:32:37 -0700
To: mm-commits@vger.kernel.org,ssengar@linux.microsoft.com,mtodorovac69@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup-fix.patch removed from -mm tree
Message-Id: <20240813233238.80C3AC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup-fix.
has been removed from the -mm tree.  Its filename was
     mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup-fix.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Mirsad Todorovac <mtodorovac69@gmail.com>
Subject: mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup-fix.
Date: Wed, 14 Aug 2024 00:03:34 +0200

fix build:

mm/vmstat.c:34:12: error: `vmstat_late_init_done' defined but not used [-Werror=unused-variable]
   34 | static int vmstat_late_init_done;
      |            ^~~~~~~~~~~~~~~~~~~~~

Link: https://lkml.kernel.org/r/b604b19d-c548-4795-adb7-3d0736b8b560@alu.unizg.hr
Fixes: ef534a0d51984 ("mm/vmstat: defer the refresh_zone_stat_thresholds after all CPUs bringup")
Signed-off-by: Mirsad Todorovac <mtodorovac69@gmail.com>
Cc: Saurabh Sengar <ssengar@linux.microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/vmstat.c~mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup-fix
+++ a/mm/vmstat.c
@@ -31,7 +31,10 @@
 
 #include "internal.h"
 
+#ifdef CONFIG_SMP
 static int vmstat_late_init_done;
+#endif /* CONFIG_SMP */
+
 #ifdef CONFIG_NUMA
 int sysctl_vm_numa_stat = ENABLE_NUMA_STAT;
 
_

Patches currently in -mm which might be from mtodorovac69@gmail.com are


