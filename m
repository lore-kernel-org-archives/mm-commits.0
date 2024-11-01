Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA5D1459F7
	for <mm-commits@vger.kernel.org>; Fri,  1 Nov 2024 20:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730492368; cv=none; b=s0toZg7OYZYCOAPNyLVpVJ9zJk/fM3qJ2wydGH3Z6/SpBbtpKD+Yo941feYUxhT97IyZ1ar+8tPof2zwsMA1bVmeNWRg8qYGr2uMXrlO64WrXHgzzmd2G8ELpB+Pi7/lXm4IjavRn0CvN2ZgBMJ84kKtugrQUaofk3EN3we1b3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730492368; c=relaxed/simple;
	bh=t7vNltN5/RxFViVb0J2t3gppHYb75V/Zga2t/anI3ww=;
	h=Date:To:From:Subject:Message-Id; b=Pz+dcuSnW1+GyXcdaLmjutMEUOj3EhDVOhWz+/IfGh1mLLNtkwad0h8CRNFVtnFRBSNrtpy/kPunXMyXDAHCd9wpHpNv51B183Y8jrak3zucGgAEt05+shi+jsNycx2/n2mF1dmWeC4Vr7IX8b0AYIMCGwABD0usr0W2nTt07To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zAFGdkq1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zAFGdkq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A550C4CECE;
	Fri,  1 Nov 2024 20:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730492366;
	bh=t7vNltN5/RxFViVb0J2t3gppHYb75V/Zga2t/anI3ww=;
	h=Date:To:From:Subject:From;
	b=zAFGdkq1g0x5WClIJglyTO+XDR3XslxQrvfcslSlIr5QesigurzrcGloLHQ0FCmO/
	 dAHbkabqPqadOtUSK3MTUJe56NKm3pnvdhk6dm1f5Y+KUquT87OkZ7HxuWRPHCSu/P
	 FEbsMQo7FiTlSbRrRT5r5Dgjv+ID/zYyqIqjfzR4=
Date: Fri, 01 Nov 2024 13:19:25 -0700
To: mm-commits@vger.kernel.org,alexjlzheng@tencent.com,mengensun@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmstat-call-fold_vm_zone_numa_events-before-show-per-zone-numa-event.patch added to mm-unstable branch
Message-Id: <20241101201926.1A550C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmstat: call fold_vm_zone_numa_events() before show per zone NUMA event
has been added to the -mm mm-unstable branch.  Its filename is
     vmstat-call-fold_vm_zone_numa_events-before-show-per-zone-numa-event.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmstat-call-fold_vm_zone_numa_events-before-show-per-zone-numa-event.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmstat.c~vmstat-call-fold_vm_zone_numa_events-before-show-per-zone-numa-event
+++ a/mm/vmstat.c
@@ -1781,6 +1781,7 @@ static void zoneinfo_show_print(struct s
 			   zone_page_state(zone, i));
 
 #ifdef CONFIG_NUMA
+	fold_vm_zone_numa_events(zone);
 	for (i = 0; i < NR_VM_NUMA_EVENT_ITEMS; i++)
 		seq_printf(m, "\n      %-12s %lu", numa_stat_name(i),
 			   zone_numa_event_state(zone, i));
_

Patches currently in -mm which might be from mengensun@tencent.com are

mm-add-pcp-high_min-high_max-to-proc-zoneinfo.patch
vmstat-call-fold_vm_zone_numa_events-before-show-per-zone-numa-event.patch

