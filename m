Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED7A6107;
	Wed, 10 Jan 2024 04:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xGXQulHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901C1C433C7;
	Wed, 10 Jan 2024 04:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704859974;
	bh=GmI+DF4ZuYqvQfS7ulf87Al1XvlQ/67VMhNCPrL1IgY=;
	h=Date:To:From:Subject:From;
	b=xGXQulHBTn+W5bFYNC9Ce3Zhr1fkJCwxBMF93rJ74BuoDZGjb7FjJt/9VEd8/keky
	 VYdBbnLIChqjllQc1Lzqpf7YyXPI48xkkyJk1SRkEUzfAZNU7C6RMW1O/N1fjbkb68
	 28fhKmbSr/5aoCA3NwxQZTjTCNkHv2ygV7TGvbnI=
Date: Tue, 09 Jan 2024 20:12:53 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,riel@surriel.com,peterz@infradead.org,mingo@kernel.org,mgorman@techsingularity.net,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bounds-support-non-power-of-two-config_nr_cpus.patch added to mm-nonmm-unstable branch
Message-Id: <20240110041254.901C1C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bounds: support non-power-of-two CONFIG_NR_CPUS
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     bounds-support-non-power-of-two-config_nr_cpus.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bounds-support-non-power-of-two-config_nr_cpus.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

bounds-support-non-power-of-two-config_nr_cpus.patch

