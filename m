Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F001E317145;
	Thu, 11 Jun 2026 16:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781196518; cv=none; b=RbuwpTSIWZo5cbA57IKuWurp9k3y6HILyYGVgA9iwGcReNRrihazK432B/CZGCdgNvxKpqAgy/rXHzFHO9p5rzmVT4h3BrOi/lcCGaspStuxSRLg/njf+RvxmEmxUJNnRUVcTixfQ3qOxrW0UczeUjb2qwJQq2616jP8pa1FJwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781196518; c=relaxed/simple;
	bh=rBJ9afOA/bVjFNjhNE0EjYjuArt/4EBnlHJ19qvrP7c=;
	h=Date:To:From:Subject:Message-Id; b=mpuVV9kNVhFXGGouPh4X0JYCC5Cje81eL8i3MbqX1NPI9bVhmjb95ymSeqDx9fN/uDBqpioIZf5xAEDbyuvzsS0TCLw6y6whI9aRFbM0Dq9Club98RfX8ZcJOoQDy3wwZvacoX6GGVl6b+I8LI3nMyhEFq7xgzXMPY6JkwYk6K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l5Y6gYkp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l5Y6gYkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6C71F00893;
	Thu, 11 Jun 2026 16:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781196516;
	bh=CDA8w4OtKvS5XoTW+gbDG90BRFfFcRfr3ZoME+3PPpw=;
	h=Date:To:From:Subject;
	b=l5Y6gYkpPKgNq+9b70QQvtP6gzRuFiYQWXTd/cNrvShwSBYlBVL1Rh5L3wEBNsq9b
	 Pll5LPDq/vjLqyZrMReI14RurmllmeFsohqiUaNbFCeC+rdpEImN9h7mYKScCniTPQ
	 G8TS0yOI3gJTv2nqLa62I56/PiwI3V69tdUuTLDs=
Date: Thu, 11 Jun 2026 09:48:36 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,stable@vger.kernel.org,sj@kernel.org,roman.gushchin@linux.dev,qi.zheng@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,david@fromorbit.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinker-do-not-hold-rcu-lock-in-shrinker_debugfs_count_show.patch added to mm-unstable branch
Message-Id: <20260611164836.6F6C71F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shrinker: do not hold RCU lock in shrinker_debugfs_count_show()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shrinker-do-not-hold-rcu-lock-in-shrinker_debugfs_count_show.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinker-do-not-hold-rcu-lock-in-shrinker_debugfs_count_show.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: mm/shrinker: do not hold RCU lock in shrinker_debugfs_count_show()
Date: Wed, 10 Jun 2026 16:20:48 -0700

Reading the debugfs "count" file of a memcg-aware shrinker can sleep
inside an RCU read-side critical section:

  BUG: sleeping function called from invalid context at kernel/cgroup/rstat.c:421
  RCU nest depth: 1, expected: 0
   css_rstat_flush
   mem_cgroup_flush_stats
   zswap_shrinker_count
   shrinker_debugfs_count_show

shrinker_debugfs_count_show() invokes the ->count_objects() callback under
rcu_read_lock().  The zswap callback flushes memcg stats via
css_rstat_flush(), which may sleep, so it must not run under RCU.

The RCU lock is not needed here.  mem_cgroup_iter() takes RCU internally
and returns a memcg holding a css reference (dropped on the next iteration
or by mem_cgroup_iter_break()), so the memcg stays alive without it.  The
shrinker is kept alive by the open debugfs file: shrinker_free() removes
the debugfs entries via debugfs_remove_recursive(), which waits for
in-flight readers to drain, before call_rcu(..., shrinker_free_rcu_cb). 
The sibling "scan" handler already invokes the sleeping ->scan_objects()
callback with no RCU section.

Drop the rcu_read_lock()/rcu_read_unlock().

Link: https://lore.kernel.org/20260610232048.62930-1-shakeel.butt@linux.dev
Fixes: 5035ebc644ae ("mm: shrinkers: introduce debugfs interface for memory shrinkers")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
Closes: https://lore.kernel.org/all/c052a064-cddb-494f-a0d8-f8a10b4b1c4d@linux.dev/
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Tested-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shrinker_debug.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/shrinker_debug.c~mm-shrinker-do-not-hold-rcu-lock-in-shrinker_debugfs_count_show
+++ a/mm/shrinker_debug.c
@@ -57,8 +57,6 @@ static int shrinker_debugfs_count_show(s
 	if (!count_per_node)
 		return -ENOMEM;
 
-	rcu_read_lock();
-
 	memcg_aware = shrinker->flags & SHRINKER_MEMCG_AWARE;
 
 	memcg = mem_cgroup_iter(NULL, NULL, NULL);
@@ -88,8 +86,6 @@ static int shrinker_debugfs_count_show(s
 		}
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
 
-	rcu_read_unlock();
-
 	kfree(count_per_node);
 	return ret;
 }
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

mm-shrinker-do-not-hold-rcu-lock-in-shrinker_debugfs_count_show.patch

