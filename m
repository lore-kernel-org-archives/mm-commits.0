Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8967513C690
	for <mm-commits@vger.kernel.org>; Mon, 14 Oct 2024 19:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728935164; cv=none; b=EKD4/oETj1W/OUWM0zH9/XV3fny2KwdiqsNt9iX3kJ1TT3FZbe2O3b0Uorcpby8HVRje3AppjXscHe6MU656BqkWMnHhTkf+FvT4Yiw+nGzPAAcm6mHEY3YAHowwJngm1x+nkkrQTs94nEM6gPhmc3JIHGCaH6hB7EoHnAQuTJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728935164; c=relaxed/simple;
	bh=P6zRylZTzygSxwBQGV4WeRS+avoPJRhiF/CpCLW3K1Q=;
	h=Date:To:From:Subject:Message-Id; b=Wl8ve5wYlbijMWBARRnicW4mgJzQ3h9EhLzZlx8WNhebXXBkPM3QIoWrkuhNoa88xZ0iBPHcWXqKaFrXLRALz+Hp5Ev/HvT0x6c7jDWC0izFRYh6Df0G5pCTqzbdmtZ+fHtff6cf9iSIqcB+E09BGNHuC5jpqfmnM2XT9zhLYTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DTzgUu3N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DTzgUu3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5D4C4CEC3;
	Mon, 14 Oct 2024 19:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728935164;
	bh=P6zRylZTzygSxwBQGV4WeRS+avoPJRhiF/CpCLW3K1Q=;
	h=Date:To:From:Subject:From;
	b=DTzgUu3NHPsL1x3FcumnzqOrLFypumy1iwLbJbKMdeHNphiSvPtv4YkJ1i1+0MdjA
	 gR7PAuH4M3CiOKwitEZFRf+Jjj06+wJmczk7NOVnaOOGHFFwaP69OWXYTANJl8L+d4
	 sajlLtYqyZ7qYsp0eUu4+jr0WeELL94IBvgjFSs4=
Date: Mon, 14 Oct 2024 12:46:03 -0700
To: mm-commits@vger.kernel.org,mtodorovac69@gmail.com,ssengar@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup-fix.patch removed from -mm tree
Message-Id: <20241014194604.3C5D4C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup-fix
has been removed from the -mm tree.  Its filename was
     mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup-fix.patch

This patch was dropped because it was folded into mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup.patch

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
 
@@ -1930,6 +1929,7 @@ static const struct seq_operations vmsta
 #ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
 int sysctl_stat_interval __read_mostly = HZ;
+static int vmstat_late_init_done;
 
 #ifdef CONFIG_PROC_FS
 static void refresh_vm_stats(struct work_struct *work)
_

Patches currently in -mm which might be from ssengar@linux.microsoft.com are

mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup.patch

