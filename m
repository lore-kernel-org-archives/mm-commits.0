Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FCA73477
	for <mm-commits@vger.kernel.org>; Sun, 28 Jul 2024 20:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722200248; cv=none; b=SRozK3Ajg4IzWXcG3MmykDYziuiXam6LOw4kWS7uDOj+LOkJd0VNtCNOy5ggNtITKxgowNfaAj8lIAyhH11AUS1gHOTeaz+jXEJKIlo+xZkGTR5iG2EnK0Pwgh7ekc3aAO4rbysvRmcO57LkJpig8j0h2KSaH66Aw46MTcCtfAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722200248; c=relaxed/simple;
	bh=u/mx+GNVg7ZplxRfXyKwZL/hXC91LLlAbVIW7hdRBE0=;
	h=Date:To:From:Subject:Message-Id; b=kEYaW+FjhPNuWGl77VyPqsIiCCx46pqurobCHWQWlmCXiMOE9UCdp2XeMb1dky1nk1D39SfxBMXmytGrGJU+oiU0I0m1FAWA1RPaCte6nIFCdRt9tod+j28CmOMtfh4pMcLZVC+tCGsrqikwrsPIKUZJomnjLqGQsmjrrHvBlg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XKMuutCr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XKMuutCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A27C116B1;
	Sun, 28 Jul 2024 20:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722200248;
	bh=u/mx+GNVg7ZplxRfXyKwZL/hXC91LLlAbVIW7hdRBE0=;
	h=Date:To:From:Subject:From;
	b=XKMuutCrjKpJt1NCYz1Mb1axJmMekjj9U8Z3g9hr5nCsXLGhu1C+vlEgxEx2arSF2
	 QSj4hhaB1+r0q8MbUUdQzCGn3+AUTEhF4/uj/rgobvjBXBjMswUiK56sHWU6NimWuw
	 jZLVFzTuFr0J2bytcseGbNgeyIMxE3KlTJLFqVVE=
Date: Sun, 28 Jul 2024 13:57:27 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,shakeel.butt@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_counters-put-page_counter_calculate_protection-under-config_memcg.patch added to mm-unstable branch
Message-Id: <20240728205727.F1A27C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_counters: put page_counter_calculate_protection() under CONFIG_MEMCG
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_counters-put-page_counter_calculate_protection-under-config_memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_counters-put-page_counter_calculate_protection-under-config_memcg.patch

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
Subject: mm: page_counters: put page_counter_calculate_protection() under CONFIG_MEMCG
Date: Fri, 26 Jul 2024 20:31:09 +0000

Put page_counter_calculate_protection() under CONFIG_MEMCG.

The protection functionality (min/low limits) is not supported by any
other cgroup subsystem, so page_counter_calculate_protection() and related
static effective_protection() can be compiled out if CONFIG_MEMCG is not
enabled.

Link: https://lkml.kernel.org/r/20240726203110.1577216-3-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_counter.h |    6 ++++++
 mm/page_counter.c            |    2 ++
 2 files changed, 8 insertions(+)

--- a/include/linux/page_counter.h~mm-page_counters-put-page_counter_calculate_protection-under-config_memcg
+++ a/include/linux/page_counter.h
@@ -95,8 +95,14 @@ static inline void page_counter_reset_wa
 	counter->watermark = usage;
 }
 
+#ifdef CONFIG_MEMCG
 void page_counter_calculate_protection(struct page_counter *root,
 				       struct page_counter *counter,
 				       bool recursive_protection);
+#else
+static inline void page_counter_calculate_protection(struct page_counter *root,
+						     struct page_counter *counter,
+						     bool recursive_protection) {}
+#endif
 
 #endif /* _LINUX_PAGE_COUNTER_H */
--- a/mm/page_counter.c~mm-page_counters-put-page_counter_calculate_protection-under-config_memcg
+++ a/mm/page_counter.c
@@ -288,6 +288,7 @@ int page_counter_memparse(const char *bu
 }
 
 
+#ifdef CONFIG_MEMCG
 /*
  * This function calculates an individual page counter's effective
  * protection which is derived from its own memory.min/low, its
@@ -459,3 +460,4 @@ void page_counter_calculate_protection(s
 			atomic_long_read(&parent->children_low_usage),
 			recursive_protection));
 }
+#endif /* CONFIG_MEMCG */
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcg-dont-call-propagate_protected_usage-needlessly.patch
mm-page_counters-put-page_counter_calculate_protection-under-config_memcg.patch
mm-page_counters-initialize-usage-using-atomic_long_init-macro.patch

