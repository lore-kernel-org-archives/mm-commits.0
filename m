Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A8C4EB4B
	for <mm-commits@vger.kernel.org>; Thu,  8 Feb 2024 21:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707426895; cv=none; b=LVoR+53TaWEEv0drYPAXUEaCe8eX6gK0ww6zPKjv45t957qqLqeZhijxhCF99jDue/UIVSkLipy9QqiXn+qz9hZfk548Op6iY1PiP97rLQcqXBOqR6xQUK/cTtM6+tFg9CkUWMAQ0+V6rIqbAf1IxKd+aDw1sXb0X5xfFjygT0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707426895; c=relaxed/simple;
	bh=mWqlJ99TwIoaLl7Lp1y4IVlc5Mz4alYmf0oHt53GF4s=;
	h=Date:To:From:Subject:Message-Id; b=USl13VKmZeBYcTyRDBzII1nSIG8Z2ZoPC2MQfTHVHlf6VaOD3QJ4PMT0l0bPH4DVi42lGSHF9Dx4tICRui4N7/6zmd47T1VNXnWkmJ5EQ7bgPW9mwAPyOpEmlVQCDATWIy6BY0UbZggoKjc9Ju04Udt1LMNyzsP/Yc5juqLJH6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mvalXHFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mvalXHFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64EE2C433C7;
	Thu,  8 Feb 2024 21:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707426894;
	bh=mWqlJ99TwIoaLl7Lp1y4IVlc5Mz4alYmf0oHt53GF4s=;
	h=Date:To:From:Subject:From;
	b=mvalXHFee/BxoOCmcGYuB7HU242HwASt8kaBbN7eucsIPBfO7EwTX/SSjQYPS/tza
	 gJLrLB3kgbnPkOJcIk72FlxqGEPMwaeF8ZRCAIv/C6OD5OGslhzLs+H7Q3Is9NIRUz
	 XBFyNW+s19Sjq7BzRvVf1D+TYbUpC3mMFqsarBqw=
Date: Thu, 08 Feb 2024 13:14:53 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-early-termination-in-compact_nodes.patch added to mm-unstable branch
Message-Id: <20240208211454.64EE2C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: compaction: early termination in compact_nodes()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-early-termination-in-compact_nodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-early-termination-in-compact_nodes.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: compaction: early termination in compact_nodes()
Date: Thu, 8 Feb 2024 10:25:08 +0800

No need to continue try compact memory if pending fatal signal, allow loop
termination earlier in compact_nodes().

Link: https://lkml.kernel.org/r/20240208022508.1771534-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/mm/compaction.c~mm-compaction-early-termination-in-compact_nodes
+++ a/mm/compaction.c
@@ -2895,7 +2895,7 @@ enum compact_result try_to_compact_pages
  * reaching score targets due to various back-off conditions, such as,
  * contention on per-node or per-zone locks.
  */
-static void compact_node(pg_data_t *pgdat, bool proactive)
+static int compact_node(pg_data_t *pgdat, bool proactive)
 {
 	int zoneid;
 	struct zone *zone;
@@ -2913,6 +2913,9 @@ static void compact_node(pg_data_t *pgda
 		if (!populated_zone(zone))
 			continue;
 
+		if (fatal_signal_pending(current))
+			return -EINTR;
+
 		cc.zone = zone;
 
 		compact_zone(&cc, NULL);
@@ -2924,18 +2927,25 @@ static void compact_node(pg_data_t *pgda
 					     cc.total_free_scanned);
 		}
 	}
+
+	return 0;
 }
 
 /* Compact all zones of all nodes in the system */
-static void compact_nodes(void)
+static int compact_nodes(void)
 {
-	int nid;
+	int ret, nid;
 
 	/* Flush pending updates to the LRU lists */
 	lru_add_drain_all();
 
-	for_each_online_node(nid)
-		compact_node(NODE_DATA(nid), false);
+	for_each_online_node(nid) {
+		ret = compact_node(NODE_DATA(nid), false);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 static int compaction_proactiveness_sysctl_handler(struct ctl_table *table, int write,
@@ -2981,9 +2991,9 @@ static int sysctl_compaction_handler(str
 		return -EINVAL;
 
 	if (write)
-		compact_nodes();
+		ret = compact_nodes();
 
-	return 0;
+	return ret;
 }
 
 #if defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-memory-use-nth_page-in-clear-copy_subpage.patch
s390-use-pfn_swap_entry_folio-in-ptep_zap_swap_entry.patch
mm-use-pfn_swap_entry_folio-in-__split_huge_pmd_locked.patch
mm-use-pfn_swap_entry_to_folio-in-zap_huge_pmd.patch
mm-use-pfn_swap_entry_folio-in-copy_nonpresent_pte.patch
mm-convert-to-should_zap_page-to-should_zap_folio.patch
mm-convert-to-should_zap_page-to-should_zap_folio-fix.patch
mm-convert-mm_counter-to-take-a-folio.patch
mm-convert-mm_counter_file-to-take-a-folio.patch
mm-memory-move-mem_cgroup_charge-into-alloc_anon_folio.patch
mm-compaction-refactor-compact_node.patch
mm-compaction-early-termination-in-compact_nodes.patch

