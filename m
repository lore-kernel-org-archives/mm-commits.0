Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8D81A9B27;
	Fri, 20 Dec 2024 22:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734734176; cv=none; b=CuCX7cReoNRqGopStZc6+eDEda5T84eh8QnVTQ4tBor4eDT9vU1eIlMqe3t/ylC5MgUvjOSbXnamS9GqKTiaeZL3vk3+EwUMonKU4Dvlht97L+bO82zH3En+J2SIg6nUIyqZ3oIeO1V6LhTHjgSv8LL16Naci7ApCdVhkFxrXh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734734176; c=relaxed/simple;
	bh=UN5R+bJFW+uyWWoSk/G7I3n4krvo7Eco5JgaK16dypg=;
	h=Date:To:From:Subject:Message-Id; b=rNYgGE2N4OIxUafWN27Me9udGk0VtGQ+Hz3/Y2o088tOgMqEU4C/hyQRwJkQ0VSN0Bg26A7o/iuF9cP94nmPS3F83tYudpoR75PxwNLfNpG9YFOm3UpkQg5PZWvzx0CJT5dEtau+c/RVvLEm5rQK7UI3CR9LSKRAnaiC9cRMApQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sgS3Z2vh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sgS3Z2vh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35ADFC4CECD;
	Fri, 20 Dec 2024 22:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734734176;
	bh=UN5R+bJFW+uyWWoSk/G7I3n4krvo7Eco5JgaK16dypg=;
	h=Date:To:From:Subject:From;
	b=sgS3Z2vhLgrDREhVvyl/Sq8gIXhNB9NXg0yUoE7hPA7kYs6ZAMImP+VnBBrxJcoCX
	 2WcQWqiOpSyy/XEIH9AJ+6m5UVI0LrWGNCPwwcMAHiUpHCEy0qVWr2DymQ3xoHyhZt
	 Gv4jHnOZ+i6sgLduAKZeFPuaOkKo6KM45xi2VfLw=
Date: Fri, 20 Dec 2024 14:36:15 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,bigeasy@linutronix.de,koichiro.den@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmstat-disable-vmstat_work-on-vmstat_cpu_down_prep.patch added to mm-hotfixes-unstable branch
Message-Id: <20241220223616.35ADFC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmstat: disable vmstat_work on vmstat_cpu_down_prep()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     vmstat-disable-vmstat_work-on-vmstat_cpu_down_prep.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmstat-disable-vmstat_work-on-vmstat_cpu_down_prep.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Koichiro Den <koichiro.den@canonical.com>
Subject: vmstat: disable vmstat_work on vmstat_cpu_down_prep()
Date: Fri, 20 Dec 2024 22:42:34 +0900

Even after mm/vmstat:online teardown, shepherd may still queue work for
the dying cpu until the cpu is removed from online mask.  While it's quite
rare, this means that after unbind_workers() unbinds a per-cpu kworker, it
potentially runs vmstat_update for the dying CPU on an irrelevant cpu
before entering STARTING section.  When CONFIG_DEBUG_PREEMPT=y, it results
in the following error with the backtrace.

  BUG: using smp_processor_id() in preemptible [00000000] code: \
                                               kworker/7:3/1702
  caller is refresh_cpu_vm_stats+0x235/0x5f0
  CPU: 0 UID: 0 PID: 1702 Comm: kworker/7:3 Tainted: G
  Tainted: [N]=TEST
  Workqueue: mm_percpu_wq vmstat_update
  Call Trace:
   <TASK>
   dump_stack_lvl+0x8d/0xb0
   check_preemption_disabled+0xce/0xe0
   refresh_cpu_vm_stats+0x235/0x5f0
   vmstat_update+0x17/0xa0
   process_one_work+0x869/0x1aa0
   worker_thread+0x5e5/0x1100
   kthread+0x29e/0x380
   ret_from_fork+0x2d/0x70
   ret_from_fork_asm+0x1a/0x30
   </TASK>

So, disable vmstat_work reliably on vmstat_cpu_down_prep().

Link: https://lkml.kernel.org/r/20241220134234.3809621-1-koichiro.den@canonical.com
Signed-off-by: Koichiro Den <koichiro.den@canonical.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmstat.c~vmstat-disable-vmstat_work-on-vmstat_cpu_down_prep
+++ a/mm/vmstat.c
@@ -2154,7 +2154,7 @@ static int vmstat_cpu_online(unsigned in
 
 static int vmstat_cpu_down_prep(unsigned int cpu)
 {
-	cancel_delayed_work_sync(&per_cpu(vmstat_work, cpu));
+	disable_delayed_work_sync(&per_cpu(vmstat_work, cpu));
 	return 0;
 }
 
_

Patches currently in -mm which might be from koichiro.den@canonical.com are

vmstat-disable-vmstat_work-on-vmstat_cpu_down_prep.patch
hugetlb-prioritize-surplus-allocation-from-current-node.patch

