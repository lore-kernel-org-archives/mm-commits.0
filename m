Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493ADEAD0;
	Fri, 15 Nov 2024 06:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653390; cv=none; b=owvQmfji59r35Mb64yXDn7HEFzsd/C3F5BTIvuamuBlZYFQvQQaksKERfuep+lcu8LVOhoxx7EkZcK+y1Kh3KTEqDSYO+K+8lkLAEXQM1CUXLoB+hNu6QANcOpgMqWlnEudYK9CkWUHqD2y/FtS+ZPSoVZEmaZUytzdgRxNlcrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653390; c=relaxed/simple;
	bh=uujeNAv1tDXrrK17OpOHioJiExHl92rPtPkXBqBUnVs=;
	h=Date:To:From:Subject:Message-Id; b=cARaazGdWfBaGOZ0pHfnCF77YpbHPQlvX+gg9AWe6dArX6CfjzcukYqRevSaslhqqOSyHXbEHRQ0W5HVdUXnr9Sy8ALAYpsixcEVYbACueda60EUIretONLjVf446kv1GMHD3pK2O6GPqaBxjA+uAFq1H6W/VI9Rw41cg1GLP2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NVYg3rZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NVYg3rZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B957C4CECF;
	Fri, 15 Nov 2024 06:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731653390;
	bh=uujeNAv1tDXrrK17OpOHioJiExHl92rPtPkXBqBUnVs=;
	h=Date:To:From:Subject:From;
	b=NVYg3rZyekSnhcuzBbYY5od9658XMmgVDuhT7j1LJncHZy5zRb98UUUSAKyf5YXfq
	 uEU4ZohLjAPbkXX6WMBsuQlCZ8YQyiruG8kkS3qsq1RctaMuM+CfKx4HdYECUrTVFa
	 yHZhHoReU+b3SoWiCNnBh5ivEkUhuvMIMcSm3soE=
Date: Thu, 14 Nov 2024 22:49:46 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,alexjlzheng@tencent.com,mengensun@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmstat-call-fold_vm_zone_numa_events-before-show-per-zone-numa-event.patch removed from -mm tree
Message-Id: <20241115064949.7B957C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmstat: call fold_vm_zone_numa_events() before show per zone NUMA event
has been removed from the -mm tree.  Its filename was
     vmstat-call-fold_vm_zone_numa_events-before-show-per-zone-numa-event.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: MengEn Sun <mengensun@tencent.com>
Subject: vmstat: call fold_vm_zone_numa_events() before show per zone NUMA event
Date: Fri, 1 Nov 2024 12:06:38 +0800

Since 5.14-rc1, NUMA events will only be folded from per-CPU statistics to
per zone and global statistics when the user actually needs it.

Currently, the kernel has performs the fold operation when reading
/proc/vmstat, but does not perform the fold operation in /proc/zoneinfo. 
This can lead to inaccuracies in the following statistics in zoneinfo:
- numa_hit
- numa_miss
- numa_foreign
- numa_interleave
- numa_local
- numa_other

Therefore, before printing per-zone vm_numa_event when reading
/proc/zoneinfo, we should also perform the fold operation.

Link: https://lkml.kernel.org/r/1730433998-10461-1-git-send-email-mengensun@tencent.com
Fixes: f19298b9516c ("mm/vmstat: convert NUMA statistics to basic NUMA counters")
Signed-off-by: MengEn Sun <mengensun@tencent.com>
Reviewed-by: JinLiang Zheng <alexjlzheng@tencent.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmstat.c~vmstat-call-fold_vm_zone_numa_events-before-show-per-zone-numa-event
+++ a/mm/vmstat.c
@@ -1780,6 +1780,7 @@ static void zoneinfo_show_print(struct s
 			   zone_page_state(zone, i));
 
 #ifdef CONFIG_NUMA
+	fold_vm_zone_numa_events(zone);
 	for (i = 0; i < NR_VM_NUMA_EVENT_ITEMS; i++)
 		seq_printf(m, "\n      %-12s %lu", numa_stat_name(i),
 			   zone_numa_event_state(zone, i));
_

Patches currently in -mm which might be from mengensun@tencent.com are


