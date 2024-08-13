Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C461AAE0A
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 23:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723591124; cv=none; b=Eq3if4+dqdpxIiZhcHvH25pvNHnVZfrmrAewNVRDE89MjAIP0ArxuB2mYiMFLHaz8PsCPYVvvp7XxMglp8PlutEnkZYFgwjSuISZKRA66h2bho3xbobxOLT/kGVDvIHp0HrPs048jsy9yOv9jR+nPoCDIoWCYhS2pQeH2JKtfvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723591124; c=relaxed/simple;
	bh=TWcWJAw/w/rOePA7J9rmnozAZZraYMk5ukMAmKEnaaA=;
	h=Date:To:From:Subject:Message-Id; b=tYGlmAKkbnwtY7VpmK8Rtq6u7mg5OvOIm97BpnOPeDDeAQonBDbLcciszvBeRc9XowFOw8jSgWM8Rp3xXVAadmB47xBOuWUqXPhXIx3DpigP1z3hkhBg+bRQ2jvGZu2NpSAlp6iAIq5Enq4lWYTKFaV2rUYgyIN2qasEyB74o+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TWUcLyqS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TWUcLyqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67DFC32782;
	Tue, 13 Aug 2024 23:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723591123;
	bh=TWcWJAw/w/rOePA7J9rmnozAZZraYMk5ukMAmKEnaaA=;
	h=Date:To:From:Subject:From;
	b=TWUcLyqS2x9SWxTiFePHn0c5nTWL17oZBFq3yPn3bMqBw1V6yPRWPkpPyTfEhjmip
	 PoKG1up2pG77kG1nOSScFh7AAjWxPkWrdHNs2YarUh7LNnajLBJ9z8cFZi77XlZtKd
	 4wbLiqTnAgl7pMvOcQLL4nOSMMSyCzCt8ZR8GFEk=
Date: Tue, 13 Aug 2024 16:18:43 -0700
To: mm-commits@vger.kernel.org,ssengar@linux.microsoft.com,mtodorovac69@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup-fix.patch added to mm-unstable branch
Message-Id: <20240813231843.C67DFC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup-fix.
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup-fix.patch

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

mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup-fix.patch

