Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D4C433C9
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247695; cv=none; b=dGih7Dkn5t0eHPsdtgPipLDpklhuC6Oq/YpVZ/mBfeV1Qlxs+F3he2cYuEONlQt2M/zreeeZS2dIjNugTWz1GWB/OR77Z0V9uTOwclhzS1QvUruhmsiJbzpm3zcwOpm/w0RhqZ4fbHFvGQhp+RJ8h9+Kjp8q35KkX+h8lxbwReA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247695; c=relaxed/simple;
	bh=mPqf1eLYgUDqDhC8iAhz9NC1yJ9/M9pRxVIbwmLSsLg=;
	h=Date:To:From:Subject:Message-Id; b=A487sDH4Ali0PnTaEDI5aeGxBxGScL6GJOjHlv568VbNjM9nziufFy0EoS70HDnM8g6x7RfZgEtfCni5GOS9Ws2XRF4+oxKGCxC3pw6+rSuZ6aiciwbatqrdDh/gP64SpRvk8SpHwtimwVJ7BNK3/WNQPR2I4rzXRqJQjRWXocY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OcEgw9PT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OcEgw9PT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B08CC4CEC2;
	Mon,  2 Sep 2024 03:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247695;
	bh=mPqf1eLYgUDqDhC8iAhz9NC1yJ9/M9pRxVIbwmLSsLg=;
	h=Date:To:From:Subject:From;
	b=OcEgw9PTbR8hyKJFMftvYnzQbU6QBxvQZJOJGLf12U2IGAU+Etil7EVUiiuSifl6t
	 9gU5LolEjBvt0Za4RkiMsZhBIQj0QBHAfuvdB5wyqulM9TD5GmxHi5N8MhbitQysqJ
	 1Dpz0rDGTGOCvik6cIjpVFr1MznfYt0wdU7UM/co=
Date: Sun, 01 Sep 2024 20:28:14 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,shakeel.butt@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_counters-put-page_counter_calculate_protection-under-config_memcg.patch removed from -mm tree
Message-Id: <20240902032815.0B08CC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_counters: put page_counter_calculate_protection() under CONFIG_MEMCG
has been removed from the -mm tree.  Its filename was
     mm-page_counters-put-page_counter_calculate_protection-under-config_memcg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -87,8 +87,14 @@ static inline void page_counter_reset_wa
 	counter->watermark = page_counter_read(counter);
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
@@ -275,6 +275,7 @@ int page_counter_memparse(const char *bu
 }
 
 
+#ifdef CONFIG_MEMCG
 /*
  * This function calculates an individual page counter's effective
  * protection which is derived from its own memory.min/low, its
@@ -446,3 +447,4 @@ void page_counter_calculate_protection(s
 			atomic_long_read(&parent->children_low_usage),
 			recursive_protection));
 }
+#endif /* CONFIG_MEMCG */
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are


