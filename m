Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6B039AF1
	for <mm-commits@vger.kernel.org>; Mon,  4 Mar 2024 17:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709573088; cv=none; b=Lxv2b4k2MvF+8nLYrlY0QTcaNtSKcGulzi4AB1f2TfcwngNzmayW7ssA4gZpd6afkzj9I95m+Cua4A+LWvsgXH1RisEZabbBx9H1RZt2vTOo1MJHslOby8N4lNc8u+IjhURLEYRmHu4L6w8/PSaCjJ5LwLPiGXTcgCeCi9cwnSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709573088; c=relaxed/simple;
	bh=G4+9zRkcJWnJNJkVk8MHxy9g9EU7WNwfGyYAFBREBzo=;
	h=Date:To:From:Subject:Message-Id; b=m0wFyjti4EpdLTbZCNMHgRnD7ycd1gKj6nlN3XMBIQDLbYSuAUNK+bi9PaGxYLbcqxCNE1afiu3H0zgVDfuPd0/yP5XTgoMiZDdwHVPNqAQtb8wHydgI7rjBEge/UUySpFxAcA65j/iy1+BpQLNXJadtiK/h6kBfV5jR8R61+Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=azehdIki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="azehdIki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF15C433F1;
	Mon,  4 Mar 2024 17:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709573088;
	bh=G4+9zRkcJWnJNJkVk8MHxy9g9EU7WNwfGyYAFBREBzo=;
	h=Date:To:From:Subject:From;
	b=azehdIkijVOviDmLLzzYnniVibUWacqQZvrGyrgrRbXXbdT1+r53wYmGT+f6b30e7
	 kYHU1lPnZh/qkzMJzshBkx5O6AhNhh5goV3rIFqCJ/nbN3nW/vbMzG5yyoVUHCLFqz
	 tHY3+BA/nnX5iJiIQ7CZ9ju0Ly49DJpmjCnHpL+w=
Date: Mon, 04 Mar 2024 09:24:47 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,ying.huang@intel.com,byungchul@sk.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmscan-do-not-turn-on-cache_trim_mode-if-it-doesnt-work-fix.patch removed from -mm tree
Message-Id: <20240304172447.EBF15C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-vmscan-do-not-turn-on-cache_trim_mode-if-it-doesnt-work-fix
has been removed from the -mm tree.  Its filename was
     mm-vmscan-do-not-turn-on-cache_trim_mode-if-it-doesnt-work-fix.patch

This patch was dropped because it was folded into mm-vmscan-do-not-turn-on-cache_trim_mode-if-it-doesnt-work.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmscan-do-not-turn-on-cache_trim_mode-if-it-doesnt-work-fix
Date: Fri Feb 23 05:14:42 PM PST 2024

simplofy boolean expression, per ying.huang@intel.com

Cc: Byungchul Park <byungchul@sk.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-do-not-turn-on-cache_trim_mode-if-it-doesnt-work-fix
+++ a/mm/vmscan.c
@@ -2277,7 +2277,7 @@ static void prepare_scan_control(pg_data
 	 */
 	file = lruvec_page_state(target_lruvec, NR_INACTIVE_FILE);
 	if (file >> sc->priority && !(sc->may_deactivate & DEACTIVATE_FILE) &&
-	    !(sc->cache_trim_mode && !sc->reclaimable && sc->priority <= 1))
+	    (!sc->cache_trim_mode || sc->reclaimable || sc->priority > 1))
 		sc->cache_trim_mode = 1;
 	else
 		sc->cache_trim_mode = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

hugetlb-parallelize-1g-hugetlb-initialization-fix.patch
mm-vmscan-do-not-turn-on-cache_trim_mode-if-it-doesnt-work.patch
mm-add-alloc_contig_migrate_range-allocation-statistics-fix.patch

