Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBFF2770E
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 18:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723056807; cv=none; b=M1N9aWY5IpQTwVzba7ry/pVeoLUV9/bY5P4e74mx5ILi3M6cixZAB8HUrlmWGiIS9qNrh5Gdmi89utYx2iKd7Gz4T+hLS2A1Zme5pClRXDzFyIwXNkfnU05J03JxAHpn78d/s9s8FFfatqwaTWLUltqNHxfY3Gy481P6xQH/8WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723056807; c=relaxed/simple;
	bh=/DQhptxvrqDvzhw/MQZwPTzWV/c8l6M1a5nmblOnE+c=;
	h=Date:To:From:Subject:Message-Id; b=Ci7tRANqN9iueniGt+PqLaGD4EaSjLNf4Gr/eu6Zfpa/LL6yIwjMHOmailL/7ArZ2HuXmIhcz6qY2fp39sGAFod4ogdqC79PlohPaef5Sjx73LW6hYcWdV8UWRevOntZRkyZNgrVTbnAodsG/s+aC1exSxeYLEDPW/6KQ8esRJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gayt0SX7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gayt0SX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9108C32781;
	Wed,  7 Aug 2024 18:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723056807;
	bh=/DQhptxvrqDvzhw/MQZwPTzWV/c8l6M1a5nmblOnE+c=;
	h=Date:To:From:Subject:From;
	b=Gayt0SX74d4kRGlaVpQzuBI9ocDPTVlG7DJtbX+iCNssj/kr1WiLJiODfy2JhgTnR
	 HbttxG+oE/M+o0f9rMBMLgqOSeL4vCJ7acC0bMUKQb5QDNyLfDGENhbmHtgj0Dezwa
	 89RTPb/eUFjQ0YmazBk+BfhR9s+QcY2cR0K7kMDw=
Date: Wed, 07 Aug 2024 11:53:25 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,nao.horiguchi@gmail.com,linmiaohe@huawei.com,len.brown@intel.com,juri.lelli@redhat.com,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-use-raw_spinlock_t-in-struct-memory_failure_cpu-v3.patch added to mm-hotfixes-unstable branch
Message-Id: <20240807185326.E9108C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memory-failure-use-raw_spinlock_t-in-struct-memory_failure_cpu-v3
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-failure-use-raw_spinlock_t-in-struct-memory_failure_cpu-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-use-raw_spinlock_t-in-struct-memory_failure_cpu-v3.patch

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
From: Waiman Long <longman@redhat.com>
Subject: mm-memory-failure-use-raw_spinlock_t-in-struct-memory_failure_cpu-v3
Date: Wed, 7 Aug 2024 14:11:30 -0400

don't hold percpu ref across pr_err(), per Miaohe

Link: https://lkml.kernel.org/r/20240807181130.1122660-1-longman@redhat.com
Fixes: 0f383b6dc96e ("locking/spinlock: Provide RT variant")
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failure-use-raw_spinlock_t-in-struct-memory_failure_cpu-v3
+++ a/mm/memory-failure.c
@@ -2455,10 +2455,10 @@ void memory_failure_queue(unsigned long
 	if (!buffer_overflow)
 		schedule_work_on(smp_processor_id(), &mf_cpu->work);
 	raw_spin_unlock_irqrestore(&mf_cpu->lock, proc_flags);
+	put_cpu_var(memory_failure_cpu);
 	if (buffer_overflow)
 		pr_err("buffer overflow when queuing memory failure at %#lx\n",
 		       pfn);
-	put_cpu_var(memory_failure_cpu);
 }
 EXPORT_SYMBOL_GPL(memory_failure_queue);
 
_

Patches currently in -mm which might be from longman@redhat.com are

padata-fix-possible-divide-by-0-panic-in-padata_mt_helper.patch
mm-memory-failure-use-raw_spinlock_t-in-struct-memory_failure_cpu.patch
mm-memory-failure-use-raw_spinlock_t-in-struct-memory_failure_cpu-v3.patch
watchdog-handle-the-enodev-failure-case-of-lockup_detector_delay_init-separately.patch

