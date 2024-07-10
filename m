Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3AE195985
	for <mm-commits@vger.kernel.org>; Wed, 10 Jul 2024 17:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720633874; cv=none; b=pKHqn1uJY2qTHoU5U41J12ZcOrRzL0HhWE/vDFHPYiVBTWJzlMDk44FvEk+nWp1NkavwWpRxOXaOetsKFdXWXrJMJNSm3E9E9T0WqwJXfE0IlkyAJNfHJO7trLK3d0IhY+eRMa8czaUZEEAsjnllTBKwSMEVmvr1Zmx0FJ8qx+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720633874; c=relaxed/simple;
	bh=iAeAlTRhTiOSjZAOD4tFk5PIGZSeFN+R7tVbFhLo34I=;
	h=Date:To:From:Subject:Message-Id; b=uJQabQEDezwL/KquJ+vSM2YVyj3+ifdekV+o1hmOJEFDEppejNdItscn1IHnVkZvF+28m8+SUHu3StXyBwayakyIEEWjGxziucr5kPl/UpEJ3FIQ6wvqtZoNI1W77jIcwiiK1F3YK6+7nFAYHhQKXLW+Q/1JW1vjhykJ1ajeUT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F5rd5q7y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F5rd5q7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393E5C32786;
	Wed, 10 Jul 2024 17:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720633874;
	bh=iAeAlTRhTiOSjZAOD4tFk5PIGZSeFN+R7tVbFhLo34I=;
	h=Date:To:From:Subject:From;
	b=F5rd5q7ySmLCiGM+LUfKXF/QIDJ1o1F9xopJ/geu/F5VyGwMZ1WoIIAxnD0PSSTg3
	 +qXEL718hfP1bi4/0o2FbVae3qrpnVA05gEciGbpOP3Am5PHH14xE/lwvdxeUUHCyW
	 OD4ukJ71T036vo3ywD4lXflZyh7gGD6hD8ELbkGo=
Date: Wed, 10 Jul 2024 10:51:13 -0700
To: mm-commits@vger.kernel.org,mgorman@techsingularity.net,hannes@cmpxchg.org,bharata@amd.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-truncate-batch-clear-shadow-entries-v2.patch added to mm-unstable branch
Message-Id: <20240710175114.393E5C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-truncate-batch-clear-shadow-entries-v2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-truncate-batch-clear-shadow-entries-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-truncate-batch-clear-shadow-entries-v2.patch

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
From: Yu Zhao <yuzhao@google.com>
Subject: mm-truncate-batch-clear-shadow-entries-v2
Date: Wed, 10 Jul 2024 00:09:33 -0600

restore comment, rename clear_shadow_entry() to clear_shadow_entries()

Link: https://lkml.kernel.org/r/20240710060933.3979380-1-yuzhao@google.com
Reported-by: Bharata B Rao <bharata@amd.com>
Closes: https://lore.kernel.org/d2841226-e27b-4d3d-a578-63587a3aa4f3@amd.com/
Tested-by: Bharata B Rao <bharata@amd.com>
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/truncate.c~mm-truncate-batch-clear-shadow-entries-v2
+++ a/mm/truncate.c
@@ -39,11 +39,12 @@ static inline void __clear_shadow_entry(
 	xas_store(&xas, NULL);
 }
 
-static void clear_shadow_entry(struct address_space *mapping,
-			       struct folio_batch *fbatch, pgoff_t *indices)
+static void clear_shadow_entries(struct address_space *mapping,
+				 struct folio_batch *fbatch, pgoff_t *indices)
 {
 	int i;
 
+	/* Handled by shmem itself, or for DAX we do nothing. */
 	if (shmem_mapping(mapping) || dax_mapping(mapping))
 		return;
 
@@ -507,7 +508,7 @@ unsigned long mapping_try_invalidate(str
 		}
 
 		if (xa_has_values)
-			clear_shadow_entry(mapping, &fbatch, indices);
+			clear_shadow_entries(mapping, &fbatch, indices);
 
 		folio_batch_remove_exceptionals(&fbatch);
 		folio_batch_release(&fbatch);
@@ -657,7 +658,7 @@ int invalidate_inode_pages2_range(struct
 		}
 
 		if (xa_has_values)
-			clear_shadow_entry(mapping, &fbatch, indices);
+			clear_shadow_entries(mapping, &fbatch, indices);
 
 		folio_batch_remove_exceptionals(&fbatch);
 		folio_batch_release(&fbatch);
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-truncate-batch-clear-shadow-entries.patch
mm-truncate-batch-clear-shadow-entries-v2.patch

