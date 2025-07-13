Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF751D54FA
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450006; cv=none; b=S+p0PrNUdzWeH3ubQpb3cr4+9AdYNPYf0hYGA9GjXjNBAA5HwDbZBLch1S8RWeDCwb/Opo0DSzMOtqb8gNv+gzdb1lMo9Zt6OvIIlYbHR2W9K5ckYqc4HfKFJmPHsVyfnbAoqdU4w8DilYIzzSVv0zV4m0J6jx6BAYNyuG8YDks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450006; c=relaxed/simple;
	bh=eDIWvddPKDCdLfP37UDYoAVdjDEdDMUua8q9M+8dOIM=;
	h=Date:To:From:Subject:Message-Id; b=l0jGpUJE4L22O9/lDblGu93Tkj2B3jyJRr0q/HLCE8i3OCkdSBwL6q7XZysXNSBATae3gWK0dEgChpZI4UeNtWchQihCFBpLuYQwx/A430CRzHs5XDU48VGcsKOiJOLzMCsC3zP2ML1oF7o7FD1NrBxactO0PLybGOKeWCyEYbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DXYc2hlo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DXYc2hlo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4ABC4CEE3;
	Sun, 13 Jul 2025 23:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450006;
	bh=eDIWvddPKDCdLfP37UDYoAVdjDEdDMUua8q9M+8dOIM=;
	h=Date:To:From:Subject:From;
	b=DXYc2hlojXoAb5buCW7GBrMAAyssu9vUWo5n0R43f7PfywBsJCdYPUGke7H50tIEV
	 FPUWXyBMPhcBKUizTHLUqUbCQ1ztnylI8xij+xoxRpn6MC5CFIiwcJAi2ZBeNTD0ny
	 6aA+7cU1SQfIoh7mXkPkmu2WctLUfnQsS0JGkR78=
Date: Sun, 13 Jul 2025 16:40:05 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rakie.kim@sk.com,Jonathan.Cameron@huawei.com,harry.yoo@oracle.com,gourry@gourry.net,david@redhat.com,42.hyeyoo@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmmempolicy-use-node-notifier-instead-of-memory-notifier.patch removed from -mm tree
Message-Id: <20250713234006.4E4ABC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm,mempolicy: use node-notifier instead of memory-notifier
has been removed from the -mm tree.  Its filename was
     mmmempolicy-use-node-notifier-instead-of-memory-notifier.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,mempolicy: use node-notifier instead of memory-notifier
Date: Mon, 16 Jun 2025 15:51:52 +0200

mempolicy is only concerned when a numa node changes its memory state,
because it needs to take this node into account for the auto-weighted
memory policy system.  So stop using the memory notifier and use the new
numa node notifer instead.

Link: https://lkml.kernel.org/r/20250616135158.450136-10-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Rakie Kim <rakie.kim@sk.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/mm/mempolicy.c~mmmempolicy-use-node-notifier-instead-of-memory-notifier
+++ a/mm/mempolicy.c
@@ -3788,20 +3788,17 @@ static int wi_node_notifier(struct notif
 			       unsigned long action, void *data)
 {
 	int err;
-	struct memory_notify *arg = data;
-	int nid = arg->status_change_nid;
-
-	if (nid < 0)
-		return NOTIFY_OK;
+	struct node_notify *nn = data;
+	int nid = nn->nid;
 
 	switch (action) {
-	case MEM_ONLINE:
+	case NODE_ADDED_FIRST_MEMORY:
 		err = sysfs_wi_node_add(nid);
 		if (err)
 			pr_err("failed to add sysfs for node%d during hotplug: %d\n",
 			       nid, err);
 		break;
-	case MEM_OFFLINE:
+	case NODE_REMOVED_LAST_MEMORY:
 		sysfs_wi_node_delete(nid);
 		break;
 	}
@@ -3840,7 +3837,7 @@ static int __init add_weighted_interleav
 		}
 	}
 
-	hotplug_memory_notifier(wi_node_notifier, DEFAULT_CALLBACK_PRI);
+	hotplug_node_notifier(wi_node_notifier, DEFAULT_CALLBACK_PRI);
 	return 0;
 
 err_cleanup_kobj:
_

Patches currently in -mm which might be from osalvador@suse.de are


