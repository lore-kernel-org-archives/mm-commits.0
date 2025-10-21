Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4E022173F
	for <mm-commits@vger.kernel.org>; Tue, 21 Oct 2025 19:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761075999; cv=none; b=iFcoa5q2ud0m1DUh0qiE7+FchJHHjRyUIVWA+hB2Y0KUX5ApYz4AlbihzE0y8grnPc9pRHvNeAHDPrZqkQRJuyP578CDVEKKsnWWgufJlUswwrJ5uzQEOG/AKTTl4ysrUxpJJRe4UdvEn3ukdMrmaF9qVRtslayRwY3WbBgCexs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761075999; c=relaxed/simple;
	bh=oWJJH8VW5qWD/HnaUuYXJ0koTaervejERyfYi7ABZ/c=;
	h=Date:To:From:Subject:Message-Id; b=abnRrpSl1EjtyDcNoaCZUJRBXi9LAGPXu44OQXNJYpvNnfyZKfMCu0EzRrt7CqOM9V0MBZaqGobM+p5rIVXhe1S1RaROtEV3MAGkyDLiCd292IZI2UJsEATWft1jepex/QCKCNw9DNrxObbdfO7I9RS8VqgbPQh9YyyNasX56hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YqEoV34p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YqEoV34p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4067EC4CEF5;
	Tue, 21 Oct 2025 19:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761075999;
	bh=oWJJH8VW5qWD/HnaUuYXJ0koTaervejERyfYi7ABZ/c=;
	h=Date:To:From:Subject:From;
	b=YqEoV34pMSyFfRkn5WOPIYHsdyD5VdruhJ2DKEruEJEGulntcLKqn5FvRPGK2r/NF
	 GcByftouhd/sX+T3iAFDT2X7FMJQTNvUd1hdyPTcxNY4AnZ7Bk5hmvFtTkLdkbctmp
	 R/DHEhUd3lTkIKVRZw1mJSrAHx3iYMcGt2317H4w=
Date: Tue, 21 Oct 2025 12:46:38 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jingsusu@didiglobal.com,donettom@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-fix-indentation-in-fold_diff-function-fix.patch added to mm-new branch
Message-Id: <20251021194639.4067EC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-vmstat-fix-indentation-in-fold_diff-function-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-vmstat-fix-indentation-in-fold_diff-function-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmstat-fix-indentation-in-fold_diff-function-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmstat-fix-indentation-in-fold_diff-function-fix
Date: Tue Oct 21 12:45:37 PM PDT 2025

add braces, per Vlastimil & Liam

Cc: David Hildenbrand <david@redhat.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jing Su <jingsusu@didiglobal.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/vmstat.c~mm-vmstat-fix-indentation-in-fold_diff-function-fix
+++ a/mm/vmstat.c
@@ -778,17 +778,19 @@ static int fold_diff(int *zone_diff, int
 	int i;
 	bool changed = false;
 
-	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
+	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++) {
 		if (zone_diff[i]) {
 			atomic_long_add(zone_diff[i], &vm_zone_stat[i]);
 			changed = true;
 		}
+	}
 
-	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
+	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
 		if (node_diff[i]) {
 			atomic_long_add(node_diff[i], &vm_node_stat[i]);
 			changed = true;
 		}
+	}
 
 	return changed;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
mm-swap-do-not-choose-swap-device-according-to-numa-node-fix.patch
drivers-base-node-fold-register_node-into-register_one_node-fix.patch
mm-vmstat-fix-indentation-in-fold_diff-function-fix.patch
liveupdate-kho-move-to-kernel-liveupdate-fix.patch

