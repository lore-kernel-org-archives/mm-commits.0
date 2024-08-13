Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF321A3BCA
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 23:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723592071; cv=none; b=L1gx+dJ61VNdwMJR0edPe9kbSOrivoejkqLiUOB/Hl/CapT5Zv/yk9VmVclpqCYNh671669Cdz+QEbG6GZLZiqPs9EPpx0+yAeBSa5es0kwhWFUe1UW4Syi4SHMAf4W39dsryi1Gq84JnwMqCaXsuZg62bvnyOkpCPdWB1Odmto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723592071; c=relaxed/simple;
	bh=CVDjupwuWqpxkZzXrDS85COHXn0Yld/HZ3s2pA2dEvU=;
	h=Date:To:From:Subject:Message-Id; b=NebHeUon5UUJ3xt5Xej8kKq/hNKD8zoH4dE5FrNiZH0BFMOAOGLjcPpzGIrDsyQyX0RUI0x8lLSiwAdxSiwSQ3eFYiGVZ6hjSeLd5tJaZWIo4BFVp1MfWRh/tMWuCkKu39LoPMJBb18fa6v7xnNAKo+JdYK3otKs++EQgtkuK6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YLI0ywr7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YLI0ywr7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6375AC32782;
	Tue, 13 Aug 2024 23:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723592070;
	bh=CVDjupwuWqpxkZzXrDS85COHXn0Yld/HZ3s2pA2dEvU=;
	h=Date:To:From:Subject:From;
	b=YLI0ywr7ktG2zfkprjdnEevl+zHdKmapt0p+nUEObMJp/mBvMyYWUG7y1TLbNc8iN
	 tM6MV7aacKgxCmrfPB0QAfvEGrlz018+abPnsP3hCBBnNBOKtLFq8VUMbYou6jRBVi
	 cfV752be7Fu2wE0UkH8J2AIaH6QGaHmdQuW7+bzw=
Date: Tue, 13 Aug 2024 16:34:29 -0700
To: mm-commits@vger.kernel.org,mtodorovac69@gmail.com,ssengar@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup-fix.patch added to mm-unstable branch
Message-Id: <20240813233430.6375AC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup-fix
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
From: Saurabh Sengar <ssengar@linux.microsoft.com>
Subject: mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup-fix
Date: Sun, 11 Aug 2024 23:13:40 -0700

move vmstat_late_init_done under CONFIG_SMP to fix variable 'defined but
not used' warning

Link: https://lkml.kernel.org/r/1723443220-20623-1-git-send-email-ssengar@linux.microsoft.com
Signed-off-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Cc: Mirsad Todorovac <mtodorovac69@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmstat.c~mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup-fix
+++ a/mm/vmstat.c
@@ -31,7 +31,6 @@
 
 #include "internal.h"
 
-static int vmstat_late_init_done;
 #ifdef CONFIG_NUMA
 int sysctl_vm_numa_stat = ENABLE_NUMA_STAT;
 
@@ -1929,6 +1928,7 @@ static const struct seq_operations vmsta
 #ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
 int sysctl_stat_interval __read_mostly = HZ;
+static int vmstat_late_init_done;
 
 #ifdef CONFIG_PROC_FS
 static void refresh_vm_stats(struct work_struct *work)
_

Patches currently in -mm which might be from ssengar@linux.microsoft.com are

mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup.patch
mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup-fix.patch

