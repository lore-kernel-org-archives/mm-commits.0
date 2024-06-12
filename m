Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3438A4AEF2
	for <mm-commits@vger.kernel.org>; Wed, 12 Jun 2024 18:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718217321; cv=none; b=aC3v6SKq8tfI7BA+f23ibTSxqtAUhCGhmKVlFKFkC4PiLxg63S+CScp/sWT61dfhkFdzJ1OhiGli+scgLuAMAzLyc6mXNxo3xvjz10gsFZNSf1cEzu1h7dcPdcUFHSuZaDF9pxL+y9Ie6lDuy2qf/2sazqlASG0r2767vNZtilQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718217321; c=relaxed/simple;
	bh=QcPmVaMXh1wz9wghn6Qk08/UEWgahflDRgoNmi5euQc=;
	h=Date:To:From:Subject:Message-Id; b=Z5UMdDqi0p/2ajrt6jdgvG81s+QETO7lLg0h6bWvy/LsvI5jy3tIBXWAphkc9yR7QZ+oFCV11FAJqMBzIHirCvkVA3sTL2MOm/IvFeY1vcEqLJ9vVDc/2Lp9wii5JuHyUJb2QDrJS2vh9zOV0JW8Oo8EOl2e1P7qWPtgFZN6UdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e5+sKSHo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e5+sKSHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB387C116B1;
	Wed, 12 Jun 2024 18:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718217320;
	bh=QcPmVaMXh1wz9wghn6Qk08/UEWgahflDRgoNmi5euQc=;
	h=Date:To:From:Subject:From;
	b=e5+sKSHoP9ldJaHwJ3RCcZAMlhK32xieHYvZbfPInVT2WdhMVGy2XRwGBngDxQ0Bw
	 +ymGJ4GcR1XkksUSF8OEcU1Foz9DGMbulUG7u8HnDsxjAGnvBlPW3gyj7pWHxCpa+p
	 iq94MidXBLxwrDObqrYPjfjuMyJLablWgQfqRiH4=
Date: Wed, 12 Jun 2024 11:35:20 -0700
To: mm-commits@vger.kernel.org,vivek.kasireddy@intel.com,muchun.song@linux.dev,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-guard-dequeue_hugetlb_folio_nodemask-against-numa_no_node-uses.patch added to mm-unstable branch
Message-Id: <20240612183520.CB387C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: guard dequeue_hugetlb_folio_nodemask against NUMA_NO_NODE uses
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-guard-dequeue_hugetlb_folio_nodemask-against-numa_no_node-uses.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-guard-dequeue_hugetlb_folio_nodemask-against-numa_no_node-uses.patch

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
From: Oscar Salvador <osalvador@suse.de>
Subject: mm/hugetlb: guard dequeue_hugetlb_folio_nodemask against NUMA_NO_NODE uses
Date: Wed, 12 Jun 2024 10:29:36 +0200

dequeue_hugetlb_folio_nodemask() expects a preferred node where to get the
hugetlb page from.  It does not expect, though, users to pass
NUMA_NO_NODE, otherwise we will get trash when trying to get the zonelist
from that node.  All current users are careful enough to not pass
NUMA_NO_NODE, but it opens the door for new users to get this wrong since
it is not documented [0].

Guard against this by getting the local nid if NUMA_NO_NODE was passed.

[0] https://lore.kernel.org/linux-mm/0000000000004f12bb061a9acf07@google.com/

Closes: https://lore.kernel.org/linux-mm/0000000000004f12bb061a9acf07@google.com/
Link: https://lkml.kernel.org/r/20240612082936.10867-1-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reported-by: syzbot+569ed13f4054f271087b@syzkaller.appspotmail.com
Tested-by: syzbot+569ed13f4054f271087b@syzkaller.appspotmail.com
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-guard-dequeue_hugetlb_folio_nodemask-against-numa_no_node-uses
+++ a/mm/hugetlb.c
@@ -1355,6 +1355,10 @@ static struct folio *dequeue_hugetlb_fol
 	struct zoneref *z;
 	int node = NUMA_NO_NODE;
 
+	/* 'nid' should not be NUMA_NO_NODE. Try to catch any misuse of it and rectifiy. */
+	if (nid == NUMA_NO_NODE)
+		nid = numa_node_id();
+
 	zonelist = node_zonelist(nid, gfp_mask);
 
 retry_cpuset:
_

Patches currently in -mm which might be from osalvador@suse.de are

mm-hugetlb-drop-node_alloc_noretry-from-alloc_fresh_hugetlb_folio.patch
arch-x86-do-not-explicitly-clear-reserved-flag-in-free_pagetable.patch
mm-hugetlb-guard-dequeue_hugetlb_folio_nodemask-against-numa_no_node-uses.patch

