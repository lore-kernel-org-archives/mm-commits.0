Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FEF14A09C;
	Thu,  4 Sep 2025 00:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756944709; cv=none; b=ZzmKFPC4v4G/I4C7tfKUhK4VLzuiWoxAAFYi8g/MfHRkcsb02WNxziD+TU5iOClD/rADZAOmhGbtodNL4zUkhzJnbn8Rhlx/5jMrKRIdFEaYyeCBhdgXjWiwX2WR4IgpgCUjPyylHbVD0n/CkaHoJflH5rhDDJRdqZEeC9c6vwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756944709; c=relaxed/simple;
	bh=+FWWhkwdIeME9IDVkHmV24FevrlzfDJ1fYtO0qEdvbA=;
	h=Date:To:From:Subject:Message-Id; b=KU/Ikdaeb7opN/bqZ6o8YdXCBAQrfcUkxFqXF8Ps/hvNmuFGO5JYeFBdCqqZ5QI2dzqCp71KQHQh+CC2Qr5F3Ivl6aGX/JuvPY+2DaZtpbcEn1G+51t1ZPYppNlQj4ynsqcjMMcbXYcLrgwKyx8Q4YSf9aXQEnO4ITbn4MNeuck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i2aNUYrc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i2aNUYrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52488C4CEE7;
	Thu,  4 Sep 2025 00:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756944709;
	bh=+FWWhkwdIeME9IDVkHmV24FevrlzfDJ1fYtO0qEdvbA=;
	h=Date:To:From:Subject:From;
	b=i2aNUYrcnlp3JH86pzj0p3aeHfRLKvos6/kYq1Kl2Myo50bYT2AF5SS+Pbemq2ZXU
	 6A0siDvJ2Y1ZMcVHmXk/em+XB9SH6RsuPYvomFcEgUAJEqb1xFg04wfd6FwYAZYXDr
	 gOEucy8mZBIYC557cJskgNOZslSmcp/Kye4k7d3U=
Date: Wed, 03 Sep 2025 17:11:48 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tony.luck@intel.com,surenb@google.com,stable@vger.kernel.org,russ.anderson@hpe.com,rppt@kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,jiaqiyan@google.com,jane.chu@oracle.com,david@redhat.com,bp@alien8.de,kyle.meyer@hpe.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memory-failure-fix-redundant-updates-for-already-poisoned-pages.patch removed from -mm tree
Message-Id: <20250904001149.52488C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: fix redundant updates for already poisoned pages
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-fix-redundant-updates-for-already-poisoned-pages.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kyle Meyer <kyle.meyer@hpe.com>
Subject: mm/memory-failure: fix redundant updates for already poisoned pages
Date: Thu, 28 Aug 2025 13:38:20 -0500

Duplicate memory errors can be reported by multiple sources.

Passing an already poisoned page to action_result() causes issues:

* The amount of hardware corrupted memory is incorrectly updated.
* Per NUMA node MF stats are incorrectly updated.
* Redundant "already poisoned" messages are printed.

Avoid those issues by:

* Skipping hardware corrupted memory updates for already poisoned pages.
* Skipping per NUMA node MF stats updates for already poisoned pages.
* Dropping redundant "already poisoned" messages.

Make MF_MSG_ALREADY_POISONED consistent with other action_page_types and
make calls to action_result() consistent for already poisoned normal pages
and huge pages.

Link: https://lkml.kernel.org/r/aLCiHMy12Ck3ouwC@hpe.com
Fixes: b8b9488d50b7 ("mm/memory-failure: improve memory failure action_result messages")
Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
Reviewed-by: Jiaqi Yan <jiaqiyan@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Kyle Meyer <kyle.meyer@hpe.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Russ Anderson <russ.anderson@hpe.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-fix-redundant-updates-for-already-poisoned-pages
+++ a/mm/memory-failure.c
@@ -956,7 +956,7 @@ static const char * const action_page_ty
 	[MF_MSG_BUDDY]			= "free buddy page",
 	[MF_MSG_DAX]			= "dax page",
 	[MF_MSG_UNSPLIT_THP]		= "unsplit thp",
-	[MF_MSG_ALREADY_POISONED]	= "already poisoned",
+	[MF_MSG_ALREADY_POISONED]	= "already poisoned page",
 	[MF_MSG_UNKNOWN]		= "unknown page",
 };
 
@@ -1349,9 +1349,10 @@ static int action_result(unsigned long p
 {
 	trace_memory_failure_event(pfn, type, result);
 
-	num_poisoned_pages_inc(pfn);
-
-	update_per_node_mf_stats(pfn, result);
+	if (type != MF_MSG_ALREADY_POISONED) {
+		num_poisoned_pages_inc(pfn);
+		update_per_node_mf_stats(pfn, result);
+	}
 
 	pr_err("%#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
@@ -2094,12 +2095,11 @@ retry:
 		*hugetlb = 0;
 		return 0;
 	} else if (res == -EHWPOISON) {
-		pr_err("%#lx: already hardware poisoned\n", pfn);
 		if (flags & MF_ACTION_REQUIRED) {
 			folio = page_folio(p);
 			res = kill_accessing_process(current, folio_pfn(folio), flags);
-			action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
 		}
+		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
 		return res;
 	} else if (res == -EBUSY) {
 		if (!(flags & MF_NO_RETRY)) {
@@ -2285,7 +2285,6 @@ try_again:
 		goto unlock_mutex;
 
 	if (TestSetPageHWPoison(p)) {
-		pr_err("%#lx: already hardware poisoned\n", pfn);
 		res = -EHWPOISON;
 		if (flags & MF_ACTION_REQUIRED)
 			res = kill_accessing_process(current, pfn, flags);
_

Patches currently in -mm which might be from kyle.meyer@hpe.com are


