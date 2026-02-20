Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C38A932
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 03:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771557472; cv=none; b=ZP0Cq4CVFkSQlOlWVgwKU6zEN9V/xY+7dsWnaycBExmJ0i+SHMP86u371QyN347YEJqWAob96kn6Vw/YnnojJKuzPavs0PfhCVazQF7yVrWNi/nqDZHDFqA52sZTk0xQMF3yCpH4tm8Vv76DoXYd0G5nyAXraQC6pI49xf9ejy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771557472; c=relaxed/simple;
	bh=VLDCShGyVZz6xe/NKUARYBOT2cmv+ep2RADO6CF5GDs=;
	h=Date:To:From:Subject:Message-Id; b=a7Zc9sdPkKB81wotU1/dYvZ2q7TRDjFVRSBo2eKcp4BemsMI0+/DgoeFOh2hBe3U2XGP5iX7BtmxrK/PVqgSfQIkSbOyOM9iddO6MFxQIDwx2SkqoGipRuFGAPgRLG0lmKELghIKw+T+DKv3sPCt61rsrEvykpxm/WPS41+Gb7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dip2yTvS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dip2yTvS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF17C4CEF7;
	Fri, 20 Feb 2026 03:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771557471;
	bh=VLDCShGyVZz6xe/NKUARYBOT2cmv+ep2RADO6CF5GDs=;
	h=Date:To:From:Subject:From;
	b=Dip2yTvSEAvMzgN6IFiH3cIViG4spPdhaQG+0mdnO/aFUVBwJNfAHJfcMmQB5XdFT
	 ewyNp5y5/1ofihqDXtO6LeUphxHTHlMeRyLBuXFf1NySyg1xXNngFhY4fcP+2PQ65k
	 yyiA6hEkz5s2tSONeqAMwI1p6KfkJY/aeguD52Ok=
Date: Thu, 19 Feb 2026 19:17:51 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,tj@kernel.org,sj@kernel.org,shuah@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,corbet@lwn.net,chengming.zhou@linux.dev,jiayuan.chen@shopee.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-add-per-memcg-stat-for-incompressible-pages.patch added to mm-new branch
Message-Id: <20260220031751.AFF17C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: add per-memcg stat for incompressible pages
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-add-per-memcg-stat-for-incompressible-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-add-per-memcg-stat-for-incompressible-pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Jiayuan Chen <jiayuan.chen@shopee.com>
Subject: mm: zswap: add per-memcg stat for incompressible pages
Date: Fri, 13 Feb 2026 15:18:22 +0800

Patch series "mm: zswap: add per-memcg stat for incompressible pages", v3.

In containerized environments, knowing which cgroup is contributing
incompressible pages to zswap is essential for effective resource
management.  This series adds a new per-memcg stat 'zswap_incomp' to track
incompressible pages, along with a selftest.


This patch (of 2):

The global zswap_stored_incompressible_pages counter was added in commit
dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page as-is")
to track how many pages are stored in raw (uncompressed) form in zswap. 
However, in containerized environments, knowing which cgroup is
contributing incompressible pages is essential for effective resource
management [1].

Add a new memcg stat 'zswap_incomp' to track incompressible pages per
cgroup.  This helps administrators and orchestrators to:

1. Identify workloads that produce incompressible data (e.g., encrypted
   data, already-compressed media, random data) and may not benefit from
   zswap.

2. Make informed decisions about workload placement - moving
   incompressible workloads to nodes with larger swap backing devices
   rather than relying on zswap.

3. Debug zswap efficiency issues at the cgroup level without needing to
   correlate global stats with individual cgroups.

While the compression ratio can be estimated from existing stats (zswap /
zswapped * PAGE_SIZE), this doesn't distinguish between "uniformly poor
compression" and "a few completely incompressible pages mixed with highly
compressible ones".  The zswap_incomp stat provides direct visibility into
the latter case.

Link: https://lkml.kernel.org/r/20260213071827.5688-1-jiayuan.chen@linux.dev
Link: https://lkml.kernel.org/r/20260213071827.5688-2-jiayuan.chen@linux.dev
Link: https://lore.kernel.org/linux-mm/CAF8kJuONDFj4NAksaR4j_WyDbNwNGYLmTe-o76rqU17La=nkOw@mail.gmail.com/ [1]
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    5 +++++
 include/linux/memcontrol.h              |    1 +
 mm/memcontrol.c                         |    6 ++++++
 3 files changed, 12 insertions(+)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-zswap-add-per-memcg-stat-for-incompressible-pages
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1734,6 +1734,11 @@ The following nested keys are defined.
 	  zswpwb
 		Number of pages written from zswap to swap.
 
+	  zswap_incomp
+		Number of incompressible pages currently stored in zswap
+		without compression. These pages could not be compressed to
+		a size smaller than PAGE_SIZE, so they are stored as-is.
+
 	  thp_fault_alloc (npn)
 		Number of transparent hugepages which were allocated to satisfy
 		a page fault. This counter is not present when CONFIG_TRANSPARENT_HUGEPAGE
--- a/include/linux/memcontrol.h~mm-zswap-add-per-memcg-stat-for-incompressible-pages
+++ a/include/linux/memcontrol.h
@@ -39,6 +39,7 @@ enum memcg_stat_item {
 	MEMCG_KMEM,
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
+	MEMCG_ZSWAP_INCOMP,
 	MEMCG_NR_STAT,
 };
 
--- a/mm/memcontrol.c~mm-zswap-add-per-memcg-stat-for-incompressible-pages
+++ a/mm/memcontrol.c
@@ -357,6 +357,7 @@ static const unsigned int memcg_stat_ite
 	MEMCG_KMEM,
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
+	MEMCG_ZSWAP_INCOMP,
 };
 
 #define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
@@ -1369,6 +1370,7 @@ static const struct memory_stat memory_s
 #ifdef CONFIG_ZSWAP
 	{ "zswap",			MEMCG_ZSWAP_B			},
 	{ "zswapped",			MEMCG_ZSWAPPED			},
+	{ "zswap_incomp",		MEMCG_ZSWAP_INCOMP		},
 #endif
 	{ "file_mapped",		NR_FILE_MAPPED			},
 	{ "file_dirty",			NR_FILE_DIRTY			},
@@ -5575,6 +5577,8 @@ void obj_cgroup_charge_zswap(struct obj_
 	memcg = obj_cgroup_memcg(objcg);
 	mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
 	mod_memcg_state(memcg, MEMCG_ZSWAPPED, 1);
+	if (size == PAGE_SIZE)
+		mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, 1);
 	rcu_read_unlock();
 }
 
@@ -5598,6 +5602,8 @@ void obj_cgroup_uncharge_zswap(struct ob
 	memcg = obj_cgroup_memcg(objcg);
 	mod_memcg_state(memcg, MEMCG_ZSWAP_B, -size);
 	mod_memcg_state(memcg, MEMCG_ZSWAPPED, -1);
+	if (size == PAGE_SIZE)
+		mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, -1);
 	rcu_read_unlock();
 }
 
_

Patches currently in -mm which might be from jiayuan.chen@shopee.com are

mm-zswap-add-per-memcg-stat-for-incompressible-pages.patch
selftests-cgroup-add-test-for-zswap-incompressible-pages.patch

