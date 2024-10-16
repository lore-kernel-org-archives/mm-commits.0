Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75961D3573
	for <mm-commits@vger.kernel.org>; Wed, 16 Oct 2024 22:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729116661; cv=none; b=GSE/dh11JFUCQIx1LwO7bEwhxnDri2lm9xt3X4MOd88bWnE/c735j+ARky2QVYsUvuZ4mkXPcc+3KQoVOueTGY166DoFmF1l5PbTfOg0QAt0WXj61dWImt4yAYPi2MlVYgQJx2kJYv5TFVWQJ5JtdDMDIYpylKL2bHvM8FOk0So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729116661; c=relaxed/simple;
	bh=pdFWd3FzM53OjNDcXahAum9AcnzyxWypyCxPZ+fdPnE=;
	h=Date:To:From:Subject:Message-Id; b=GwJx2Os4NPrgElRu2Y/0XtDzzhkYLzk04a7GksPpAEqxHlIKT9FBbfihgGyHg4dif8KBi1FTdaotDBTSuU9u1L+sxJ+a7Fq/SDwOsbjkRhtK5QcKnKrujl4VsMOK6ndlnJUi6K6AbiAPHti5L9I+xFHobXAxC13+ASOLfGW/lSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YVGcWJxr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YVGcWJxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305A0C4CEC5;
	Wed, 16 Oct 2024 22:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729116661;
	bh=pdFWd3FzM53OjNDcXahAum9AcnzyxWypyCxPZ+fdPnE=;
	h=Date:To:From:Subject:From;
	b=YVGcWJxrwiickmEU5o7q9ksdV2LXN6YxreHrIPDhqce1BwA1loowAOvSipDXeGuiI
	 6hn0vz3XJKdG2N6l3CxG7Vio/fPPi3DMzA3dY6Lpu0Zpc84YT8Y1dD3tMQFDkOvHcT
	 rLcV4h5GhPfmB9j+j/LKXjx+6HMYpVFdNGiKQnJ8=
Date: Wed, 16 Oct 2024 15:11:00 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sj@kernel.org,minchan@kernel.org,kaleshsingh@google.com,jaewon31.kim@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmscan-add-a-vmscan-event-for-reclaim_pages-v3.patch added to mm-unstable branch
Message-Id: <20241016221101.305A0C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmscan-add-a-vmscan-event-for-reclaim_pages-v3
has been added to the -mm mm-unstable branch.  Its filename is
     vmscan-add-a-vmscan-event-for-reclaim_pages-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmscan-add-a-vmscan-event-for-reclaim_pages-v3.patch

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
From: Jaewon Kim <jaewon31.kim@samsung.com>
Subject: vmscan-add-a-vmscan-event-for-reclaim_pages-v3
Date: Wed, 16 Oct 2024 23:32:27 +0900

use sc.nr_scanned rather than new counting

Link: https://lkml.kernel.org/r/20241016143227.961162-1-jaewon31.kim@samsung.com
Signed-off-by: Jaewon Kim <jaewon31.kim@samsung.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/mm/vmscan.c~vmscan-add-a-vmscan-event-for-reclaim_pages-v3
+++ a/mm/vmscan.c
@@ -2126,7 +2126,6 @@ static void shrink_active_list(unsigned
 }
 
 static unsigned int reclaim_folio_list(struct list_head *folio_list,
-				      unsigned int nr_scanned,
 				      struct pglist_data *pgdat)
 {
 	struct reclaim_stat stat;
@@ -2146,7 +2145,7 @@ static unsigned int reclaim_folio_list(s
 		list_del(&folio->lru);
 		folio_putback_lru(folio);
 	}
-	trace_mm_vmscan_reclaim_pages(pgdat->node_id, nr_scanned, nr_reclaimed, &stat);
+	trace_mm_vmscan_reclaim_pages(pgdat->node_id, sc.nr_scanned, nr_reclaimed, &stat);
 
 	return nr_reclaimed;
 }
@@ -2154,7 +2153,6 @@ static unsigned int reclaim_folio_list(s
 unsigned long reclaim_pages(struct list_head *folio_list)
 {
 	int nid;
-	unsigned int nr_scanned = 0;
 	unsigned int nr_reclaimed = 0;
 	LIST_HEAD(node_folio_list);
 	unsigned int noreclaim_flag;
@@ -2171,18 +2169,15 @@ unsigned long reclaim_pages(struct list_
 		if (nid == folio_nid(folio)) {
 			folio_clear_active(folio);
 			list_move(&folio->lru, &node_folio_list);
-			nr_scanned += folio_nr_pages(folio);
 			continue;
 		}
 
-		nr_reclaimed += reclaim_folio_list(&node_folio_list, nr_scanned,
-						   NODE_DATA(nid));
-		nr_scanned = 0;
+		nr_reclaimed += reclaim_folio_list(&node_folio_list, NODE_DATA(nid));
 		nid = folio_nid(lru_to_folio(folio_list));
 	} while (!list_empty(folio_list));
 
-	nr_reclaimed += reclaim_folio_list(&node_folio_list, nr_scanned,
-					   NODE_DATA(nid));
+	nr_reclaimed += reclaim_folio_list(&node_folio_list, NODE_DATA(nid));
+
 	memalloc_noreclaim_restore(noreclaim_flag);
 
 	return nr_reclaimed;
_

Patches currently in -mm which might be from jaewon31.kim@samsung.com are

vmscan-add-a-vmscan-event-for-reclaim_pages.patch
vmscan-add-a-vmscan-event-for-reclaim_pages-v3.patch

