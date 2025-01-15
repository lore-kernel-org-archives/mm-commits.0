Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79DE132C38;
	Wed, 15 Jan 2025 22:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736979777; cv=none; b=DjWJNh2SrkhPAw/JhdPftF26ohQj1ANyb0nRgJnZTjOX4NXXXVclnsc0RI/4c4S2WiCwckTVKo/UqQFOO8tVflJ2w7y9JO4hJgdoLNZJVfqvvK6agwvpSvCUDhHocbS84DpauVU64MK7TDh35cO3v9ehCs3WX2jL0CdFadi1/1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736979777; c=relaxed/simple;
	bh=6o3lFDZyKkoqcMNAclhxEZciJskAQ3kBeza39LvGOkI=;
	h=Date:To:From:Subject:Message-Id; b=kkSi5buKzZZAEL/rnJDnZQyeMBxasOeGHyL205tsy9f3mh+obSSR8o0J5AxYRyutacUJgpmGgspbUFFpusxqoK6gzqpKZenwMVCC8OGf43Tslonm7ZunVLDRj45TPuFLMfUrnFM10DC2BmcQCRYKzAGT+HNpRU407mIhazMovm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dIAoV2fF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dIAoV2fF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC8FC4CED1;
	Wed, 15 Jan 2025 22:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736979776;
	bh=6o3lFDZyKkoqcMNAclhxEZciJskAQ3kBeza39LvGOkI=;
	h=Date:To:From:Subject:From;
	b=dIAoV2fFsbopiwdbAuV2+YCK/Vseg//NZDJuku5jsfvBJYuSnmnFdMF3gPZjpPQlu
	 k+EE0m7h4QT6NhMF6iBCjiGVp15VXoKnx9IkX6wNSIGc1AIWS/MPyDSALZ4RbdDYhd
	 /tYI3WeHxSJKK/3Fvn+kCQwh/8WkPF9Hbdv8476I=
Date: Wed, 15 Jan 2025 14:22:55 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,stable@vger.kernel.org,kaiyang2@cs.cmu.edu,lizhijian@fujitsu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-vmscan-fix-pgdemote_-accounting-with-lru_gen_enabled.patch removed from -mm tree
Message-Id: <20250115222256.8EC8FC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: fix pgdemote_* accounting with lru_gen_enabled
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-pgdemote_-accounting-with-lru_gen_enabled.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Li Zhijian <lizhijian@fujitsu.com>
Subject: mm/vmscan: fix pgdemote_* accounting with lru_gen_enabled
Date: Fri, 10 Jan 2025 20:21:33 +0800

Commit f77f0c751478 ("mm,memcg: provide per-cgroup counters for NUMA
balancing operations") moved the accounting of PGDEMOTE_* statistics to
shrink_inactive_list().  However, shrink_inactive_list() is not called
when lrugen_enabled is true, leading to incorrect demotion statistics
despite actual demotion events occurring.

Add the PGDEMOTE_* accounting in evict_folios(), ensuring that demotion
statistics are correctly updated regardless of the lru_gen_enabled state. 
This fix is crucial for systems that rely on accurate NUMA balancing
metrics for performance tuning and resource management.

Link: https://lkml.kernel.org/r/20250110122133.423481-2-lizhijian@fujitsu.com
Fixes: f77f0c751478 ("mm,memcg: provide per-cgroup counters for NUMA balancing operations")
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Cc: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/vmscan.c~mm-vmscan-fix-pgdemote_-accounting-with-lru_gen_enabled
+++ a/mm/vmscan.c
@@ -4650,6 +4650,8 @@ retry:
 	__mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(),
 					stat.nr_demoted);
 
+	__mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(),
+			   stat.nr_demoted);
 	item = PGSTEAL_KSWAPD + reclaimer_offset();
 	if (!cgroup_reclaim(sc))
 		__count_vm_events(item, reclaimed);
_

Patches currently in -mm which might be from lizhijian@fujitsu.com are

mm-vmscan-accumulate-nr_demoted-for-accurate-demotion-statistics.patch
mm-vmscan-accumulate-nr_demoted-for-accurate-demotion-statistics-v2.patch

