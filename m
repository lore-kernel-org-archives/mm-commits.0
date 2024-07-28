Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9076D73477
	for <mm-commits@vger.kernel.org>; Sun, 28 Jul 2024 20:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722200250; cv=none; b=AWzqcfoUANHk+27oLTVXKP9HmEdrVMMDCUY8MpH8ymHBpkTpFq4aMsVWzsEzfAZ+uvH+7uMv1bzXdYzTvPEd5Jhp9xPL6pG5O7E5/pndIsKwxbcvaICNGCkQ79K3Q8FQo+aPgSZoPheZzosLAn/AxwxV2IENOCZv+G0301KkmtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722200250; c=relaxed/simple;
	bh=AKsLV7gByfpwXSn/NF2p2X04oQEhVAJJXx6eGme5HRU=;
	h=Date:To:From:Subject:Message-Id; b=Tx/oVhdp+MR37epIG6s6SxXOkOapAesmWdg7o0W24SenM/+EH6gCTPQVHQb3yinGvpgVKDfVAMYXmILIzxjAozxuB68bAqITUTF7cJg0CeoJVwZJ7+ckuOTNeok1U8520MzWgep9hSoAWSGgqkgZdhuaZGi30k7LkTdq0pg58cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jNStEtFc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jNStEtFc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D46DC116B1;
	Sun, 28 Jul 2024 20:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722200250;
	bh=AKsLV7gByfpwXSn/NF2p2X04oQEhVAJJXx6eGme5HRU=;
	h=Date:To:From:Subject:From;
	b=jNStEtFcl9ypab4e9mAlI17P9I2zUQtkPl6FIuNxdrRWgGVlPRvNO+XiDUfGmn0nE
	 ckth/3k8gQIHaWCGco7eWFqPpXxSPImviRAV95C8oU/sxkFL9zWvHpPgxRFIOQuB+2
	 Mxkq2AoqzyTtRFstholualzo1J0yp+CH8LX0EaTc=
Date: Sun, 28 Jul 2024 13:57:29 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,shakeel.butt@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_counters-initialize-usage-using-atomic_long_init-macro.patch added to mm-unstable branch
Message-Id: <20240728205730.4D46DC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_counters: initialize usage using ATOMIC_LONG_INIT() macro
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_counters-initialize-usage-using-atomic_long_init-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_counters-initialize-usage-using-atomic_long_init-macro.patch

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
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: page_counters: initialize usage using ATOMIC_LONG_INIT() macro
Date: Fri, 26 Jul 2024 20:31:10 +0000

When a page_counter structure is initialized, there is no need to use an
atomic set operation to initialize the usage counter because at this point
the structure is not visible to anybody else.  ATOMIC_LONG_INIT() is what
should be used in such cases.

Link: https://lkml.kernel.org/r/20240726203110.1577216-4-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_counter.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/page_counter.h~mm-page_counters-initialize-usage-using-atomic_long_init-macro
+++ a/include/linux/page_counter.h
@@ -53,7 +53,7 @@ static inline void page_counter_init(str
 				     struct page_counter *parent,
 				     bool protection_support)
 {
-	atomic_long_set(&counter->usage, 0);
+	counter->usage = (atomic_long_t)ATOMIC_LONG_INIT(0);
 	counter->max = PAGE_COUNTER_MAX;
 	counter->parent = parent;
 	counter->protection_support = protection_support;
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcg-dont-call-propagate_protected_usage-needlessly.patch
mm-page_counters-put-page_counter_calculate_protection-under-config_memcg.patch
mm-page_counters-initialize-usage-using-atomic_long_init-macro.patch

