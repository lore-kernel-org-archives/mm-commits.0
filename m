Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C12223DE8
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343209; cv=none; b=cXgd1+5NuPaS7H1obAogBw5kSGgT17hwnFR974kW9YR0zKeYeYnV+AQrl484VxEfnRmyqYsoB4iF7X4OQaN7M3jGIaEhhk0atTv3xJnLhrDDsHtAVMpSqkWh1Zdqp6MFxt5rUb88QBD7ZQcpEyfi/PDQXXnMNUQ3NQSyy9+k5X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343209; c=relaxed/simple;
	bh=eTzf2VoPj6sEWXYklUVlHl5d7x9xx09H0aKAKX8eqxU=;
	h=Date:To:From:Subject:Message-Id; b=F9cIjmD+DU5HKe1QA4Nq6TUYlIi/sAgm+BHcE2JC+l38+F+B0Y6spf6WZEaryXk1UgY1GivY2eLLdVhDL62sizumfzQga7MaN85SB1cI84zDEuf651GboJqqK7PBMehne5S8jm7Y2AtZ5pTwdk/S0kopcxZm5CcyZAoVK6XGwa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hFKlSzK9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hFKlSzK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F12BC113D0;
	Mon, 17 Nov 2025 01:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343209;
	bh=eTzf2VoPj6sEWXYklUVlHl5d7x9xx09H0aKAKX8eqxU=;
	h=Date:To:From:Subject:From;
	b=hFKlSzK903HgAiKST2HTaNPxycyv7pAscPEnuTKwz9wO3Gx/dc4mNb3PG+pyx+ovd
	 JktlNKYe+OpIhsl1ZCqf6q95q86e+vzwJtued8+RqZ/eCKFIwgPq3jnm9yVmXB23lY
	 TqZ+/lTaVgBSfNP5nRil3mDQbnzhbDsLqBlJ+ibE=
Date: Sun, 16 Nov 2025 17:33:28 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,donettom@linux.ibm.com,dev.jain@arm.com,david@redhat.com,jingsusu@didiglobal.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmstat-fix-indentation-in-fold_diff-function.patch removed from -mm tree
Message-Id: <20251117013329.0F12BC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmstat: fix indentation in fold_diff function
has been removed from the -mm tree.  Its filename was
     mm-vmstat-fix-indentation-in-fold_diff-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jing Su <jingsusu@didiglobal.com>
Subject: mm/vmstat: fix indentation in fold_diff function
Date: Tue, 21 Oct 2025 15:37:07 +0800

Adjust misaligned braces in fold_diff() to improve code readability and
maintain consistent coding style.

[akpm@linux-foundation.org: add braces, per Vlastimil & Liam]
Link: https://lkml.kernel.org/r/aPc4I/8zXCGyiapN@pilot-ThinkCentre-M930t-N000
Signed-off-by: Jing Su <jingsusu@didiglobal.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/vmstat.c~mm-vmstat-fix-indentation-in-fold_diff-function
+++ a/mm/vmstat.c
@@ -778,17 +778,20 @@ static int fold_diff(int *zone_diff, int
 	int i;
 	bool changed = false;
 
-	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
+	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++) {
 		if (zone_diff[i]) {
 			atomic_long_add(zone_diff[i], &vm_zone_stat[i]);
 			changed = true;
+		}
 	}
 
-	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
+	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
 		if (node_diff[i]) {
 			atomic_long_add(node_diff[i], &vm_node_stat[i]);
 			changed = true;
+		}
 	}
+
 	return changed;
 }
 
_

Patches currently in -mm which might be from jingsusu@didiglobal.com are


