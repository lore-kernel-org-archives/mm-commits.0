Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83318144D20
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291704; cv=none; b=iBv4z+7yQ5R7Vat8T9PwUwQ8sL5n6tartOfRQP3s9XFSSr/k0lwtpem7VrL/HhLvhJYYreNB7w5Evl/ufmayXswwrhBWHV6MBRGELgsn0iPdW9Lo9MjI/7QZOliUs65Y5QqUCbVzaT8UepJlhY26/bVQqUxDo74ieRSHkMfH3F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291704; c=relaxed/simple;
	bh=N3OI3gOLhv9FiymY8+RExVHwE0zzJxmIOgSdHBhYCMw=;
	h=Date:To:From:Subject:Message-Id; b=K1wocjuMCF7PgsoTds4wHDuTnfVZgCVNPuGSY90nNk6wBQMmc6ko6cZ9Zd8q1bA694Na98Bm9GAMFaObPoNBdmA3PJXfM9uOrD03AKIB6em+KXt1Nt/k3KQSfOw2nxx5s4TDR7jzwGr5SNeODYMRtSyH+EOC20im+AmFOxj37ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PgJQZEk2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PgJQZEk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F263C32789;
	Tue, 25 Jun 2024 05:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291704;
	bh=N3OI3gOLhv9FiymY8+RExVHwE0zzJxmIOgSdHBhYCMw=;
	h=Date:To:From:Subject:From;
	b=PgJQZEk2OkXUgp+FHTj98ZfM/xUbI2zLCXVBAQ64PJpT1heTTBDBJIBmy71feDUZo
	 3hqO/1UW1ObVDSA+EpIeQyjyxqNrVgm9RIKtQC8k09DLbXUUukJHNcuNqPKish5cJs
	 g7CQtBRerhRAeXBjvkMXQfFZuF6qn824+cZt3CJo=
Date: Mon, 24 Jun 2024 22:01:43 -0700
To: mm-commits@vger.kernel.org,vivek.kasireddy@intel.com,muchun.song@linux.dev,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-guard-dequeue_hugetlb_folio_nodemask-against-numa_no_node-uses.patch removed from -mm tree
Message-Id: <20240625050144.0F263C32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: guard dequeue_hugetlb_folio_nodemask against NUMA_NO_NODE uses
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-guard-dequeue_hugetlb_folio_nodemask-against-numa_no_node-uses.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


