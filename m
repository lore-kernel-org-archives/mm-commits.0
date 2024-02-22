Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B4D17BBA;
	Thu, 22 Feb 2024 23:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645166; cv=none; b=mexrVnv1NLzkVzPzZk2QiAqHWVvI/qGNdNFhTavFSkfm95TRbplf7v3l7OYYT7CDP08i7dNzNDUC3S9A/seazcTaGZrFfwf4Lcop54AR7Yt5hk2TypSuhwj0Xylm5WZTthM8seH+SyYyz2jkbxuX5Z6mE5cMaSO0TGkccjXRGwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645166; c=relaxed/simple;
	bh=7Zz9N2qREAhZwfH7evuuc/XT4gBx9hbfdzNuiYDkEA0=;
	h=Date:To:From:Subject:Message-Id; b=VmnYA+L9mmMof43SMoclhnafREeDhDPGGL3JT2EriS11Psz9I+ij7+EvZK3P3HgIwCdm7IfyAkYcVPA4Hzt+eV2VYK5hpdHV1MmI4yXn1ebowyTMM5i/ZJpiTL/CzA81kTRJ+j168G9ucJ6rXCfh8klkT4RWvDT5Z/enFjRHZOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ItWMVVKO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ItWMVVKO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF575C433F1;
	Thu, 22 Feb 2024 23:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645166;
	bh=7Zz9N2qREAhZwfH7evuuc/XT4gBx9hbfdzNuiYDkEA0=;
	h=Date:To:From:Subject:From;
	b=ItWMVVKOVit+9SnGpHLCewpuKWf/LjA1H09pBoLorMKZfNqicV3+deELn3dILvpfq
	 C/8eo431o3QPg1SNbZWX9rLq7CPFmL4N84hXzYpC6LRKwChL409HavMJkdZjV41MAC
	 sSdyudk1fn4QD6CzbewzNhm20zZx8NRoVYmG4UIA=
Date: Thu, 22 Feb 2024 15:39:25 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,riel@surriel.com,peterz@infradead.org,mingo@kernel.org,mgorman@techsingularity.net,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] bounds-support-non-power-of-two-config_nr_cpus.patch removed from -mm tree
Message-Id: <20240222233925.DF575C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bounds: support non-power-of-two CONFIG_NR_CPUS
has been removed from the -mm tree.  Its filename was
     bounds-support-non-power-of-two-config_nr_cpus.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: bounds: support non-power-of-two CONFIG_NR_CPUS
Date: Tue, 10 Oct 2023 15:55:49 +0100

ilog2() rounds down, so for example when PowerPC 85xx sets CONFIG_NR_CPUS
to 24, we will only allocate 4 bits to store the number of CPUs instead of
5.  Use bits_per() instead, which rounds up.  Found by code inspection. 
The effect of this would probably be a misaccounting when doing NUMA
balancing, so to a user, it would only be a performance penalty.  The
effects may be more wide-spread; it's hard to tell.

Link: https://lkml.kernel.org/r/20231010145549.1244748-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Fixes: 90572890d202 ("mm: numa: Change page last {nid,pid} into {cpu,pid}")
Reviewed-by: Rik van Riel <riel@surriel.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/bounds.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/bounds.c~bounds-support-non-power-of-two-config_nr_cpus
+++ a/kernel/bounds.c
@@ -19,7 +19,7 @@ int main(void)
 	DEFINE(NR_PAGEFLAGS, __NR_PAGEFLAGS);
 	DEFINE(MAX_NR_ZONES, __MAX_NR_ZONES);
 #ifdef CONFIG_SMP
-	DEFINE(NR_CPUS_BITS, ilog2(CONFIG_NR_CPUS));
+	DEFINE(NR_CPUS_BITS, bits_per(CONFIG_NR_CPUS));
 #endif
 	DEFINE(SPINLOCK_SIZE, sizeof(spinlock_t));
 #ifdef CONFIG_LRU_GEN
_

Patches currently in -mm which might be from willy@infradead.org are

writeback-remove-a-duplicate-prototype-for-tag_pages_for_writeback.patch
writeback-factor-folio_prepare_writeback-out-of-write_cache_pages.patch
writeback-factor-writeback_get_batch-out-of-write_cache_pages.patch
writeback-simplify-the-loops-in-write_cache_pages.patch
pagevec-add-ability-to-iterate-a-queue.patch
writeback-use-the-folio_batch-queue-iterator.patch
writeback-move-the-folio_prepare_writeback-loop-out-of-write_cache_pages.patch
writeback-remove-a-use-of-write_cache_pages-from-do_writepages.patch

