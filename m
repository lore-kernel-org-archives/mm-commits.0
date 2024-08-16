Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C53378C8F
	for <mm-commits@vger.kernel.org>; Fri, 16 Aug 2024 05:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723785070; cv=none; b=guqGdGxA73ZNALhogA1KmiYUte/8OKNhdXTbzFX0xmxJSJEfiuMKYDFB6f3NXso3dQhMf8jBxxAg+aUr4PAAG1LoP0B93Irh8bqdyoIiLOvx2w61KxiBD1K7ZwER24hPvi99oaOpU2Jh2UZaOMNh9Da/TcYyB588K99fQ6wXqHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723785070; c=relaxed/simple;
	bh=9tLcUyNz79alV3DQeG7j6QpeKMHHGJsNWBaPSsDLq34=;
	h=Date:To:From:Subject:Message-Id; b=QtWBZTWFW92id12ea4qUGTB1AgLE4uhV9cGBBratoXTI/26co3oBPFJq49m2x+lNe6TK6Cwe5xAaZSIaPvMNvRH19LRntsR/t+VhslmFi2IOypRsET9OEsmXLXPMOKVxmPGukynomKNdjEaqYewsXOT+8zzt8vtj52nN5NHkOF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YIY5hgFJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YIY5hgFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B763C4AF0B;
	Fri, 16 Aug 2024 05:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723785070;
	bh=9tLcUyNz79alV3DQeG7j6QpeKMHHGJsNWBaPSsDLq34=;
	h=Date:To:From:Subject:From;
	b=YIY5hgFJyKM0eZ2fv1YzczaL62PZDkftSP9pAV+uXwaWCiv26zQToJhGS14ykPQtL
	 JrDrHDkGDCLoLzsjqnWWHWPVpfRPS9JsCMP1I7jXSX1AyL4vDp6InQqAbEscfTizGg
	 QzEh+/TDRTApJAUCUV2boHIp2x0+0tEt7fIKZyb4=
Date: Thu, 15 Aug 2024 22:11:09 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,nao.horiguchi@gmail.com,linmiaohe@huawei.com,len.brown@intel.com,juri.lelli@redhat.com,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memory-failure-use-raw_spinlock_t-in-struct-memory_failure_cpu-v3.patch removed from -mm tree
Message-Id: <20240816051110.1B763C4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memory-failure-use-raw_spinlock_t-in-struct-memory_failure_cpu-v3
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-use-raw_spinlock_t-in-struct-memory_failure_cpu-v3.patch

This patch was dropped because it was folded into mm-memory-failure-use-raw_spinlock_t-in-struct-memory_failure_cpu.patch

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

mm-memory-failure-use-raw_spinlock_t-in-struct-memory_failure_cpu.patch
watchdog-handle-the-enodev-failure-case-of-lockup_detector_delay_init-separately.patch

