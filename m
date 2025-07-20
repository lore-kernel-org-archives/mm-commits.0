Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4501712B73
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 01:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976324; cv=none; b=M4wxUGj3Lh/ipKWg6e6M0uK2h2eXWJnpVrFS8QGGZ5oU01qhTwBKuvDmij3RpwGIKhqKhfJFVjPnGkIBgHM7qGdgY3lXU6BKfQj/YyBOBNJOGMhY0Q8E83yfmeADz5S/HcUghTBX5g0gIpLG99kdHRJNE+gg4l1hkUdEB2Bz6mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976324; c=relaxed/simple;
	bh=A+LpQUsu505pQRIxZN5V9JR/N5UbQChcfRsfvTx4xXU=;
	h=Date:To:From:Subject:Message-Id; b=d7//bkyA1FL2beV9qhnDqGCpkapYsF0sjNTDEUnbmeMTGbHsVZlC11FowuYnCpN4lPJaFjGDDeDGSH8E4TCKvgkgRnGWR6cbcGfqjDsiCTvRmH+Kw7ahUeq1MXObVtgMIO1U/dTZG6zT7a8dcIZf6/HEB3x1YODpjg55yMAsIyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GfzP7PQR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GfzP7PQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE392C4CEE3;
	Sun, 20 Jul 2025 01:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976323;
	bh=A+LpQUsu505pQRIxZN5V9JR/N5UbQChcfRsfvTx4xXU=;
	h=Date:To:From:Subject:From;
	b=GfzP7PQR8pjdeSsAEI/nkB3RbhiAY31Qhz7I9Nt8c2St3qX6toPMl3WD64pF29mBX
	 NzenSQvZKkEhpMJ9WranbBWmRj9sNPG1M7to3XbfNhF4HE6mwsrtXHFGIzv8G5mczQ
	 mzBUVCmVl0npsvX6UOt6jj+9pTq5sVlD5FWvyUFY=
Date: Sat, 19 Jul 2025 18:52:03 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,lkp@intel.com,hannes@cmpxchg.org,dave@stgolabs.net,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memcg-make-memoryreclaim-interface-generic-fix.patch removed from -mm tree
Message-Id: <20250720015203.BE392C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memcg-make-memoryreclaim-interface-generic-fix
has been removed from the -mm tree.  Its filename was
     mm-memcg-make-memoryreclaim-interface-generic-fix.patch

This patch was dropped because it was folded into mm-memcg-make-memoryreclaim-interface-generic.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-make-memoryreclaim-interface-generic-fix
Date: Tue Jun 24 02:08:06 PM PDT 2025

fix CONFIG_NUMA=n build

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506250208.ZOcoZLb6-lkp@intel.com/
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/internal.h~mm-memcg-make-memoryreclaim-interface-generic-fix
+++ a/mm/internal.h
@@ -533,8 +533,16 @@ extern unsigned long highest_memmap_pfn;
 bool folio_isolate_lru(struct folio *folio);
 void folio_putback_lru(struct folio *folio);
 extern void reclaim_throttle(pg_data_t *pgdat, enum vmscan_throttle_state reason);
+#ifdef CONFIG_NUMA
 int user_proactive_reclaim(char *buf,
 			   struct mem_cgroup *memcg, pg_data_t *pgdat);
+#else
+static inline int user_proactive_reclaim(char *buf,
+			   struct mem_cgroup *memcg, pg_data_t *pgdat)
+{
+	return 0;
+}
+#endif
 
 /*
  * in mm/rmap.c:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcg-make-memoryreclaim-interface-generic.patch
mm-introduce-per-node-proactive-reclaim-interface-fix.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling-fix.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling-fix-fix.patch
kasan-add-shadow-checks-to-wrappers-and-rename-kasan_arch_is_ready-fix.patch
squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call-fix.patch
init-kconfig-restore-config_broken-help-text.patch

