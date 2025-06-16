Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652F5136349
	for <mm-commits@vger.kernel.org>; Mon, 16 Jun 2025 23:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750117784; cv=none; b=qGrkZ3UYCIFHfg+scZU/Pb5EmGYvZSEBlFXqGJA9MS0KYNGeLFG5w/V8i/SglLXin7YGpZEz30BVTNcQaOqClRFZtwMzNb09zBttC4gC5l2QBCEhOJW4eHTllBrSo9Xfn9zHXTv7i2IRBUg2d0YlB334fmwLQzo8lr3dyONPh9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750117784; c=relaxed/simple;
	bh=IojgxtWlmMDcKl+Or/zrtmgNgJzjq5s3cOr9omn6BXc=;
	h=Date:To:From:Subject:Message-Id; b=g60JBtqYxGbqXuiySHHhep4DxY25TlSUsSFzPwt7bHdbTlhoc3tQhuI+AUPe2GkwfB8OjOr/o/+dj2nV8pihH/06obuGuu4AmtTUuCCtuionpcVkMaaSAKtqwhu8p+0dV7aTKCTbEpTsuGd/fhSL26FJe5eDz1IDhfqOrmOS7wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KkZfXOXp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KkZfXOXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34C6C4CEEA;
	Mon, 16 Jun 2025 23:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750117783;
	bh=IojgxtWlmMDcKl+Or/zrtmgNgJzjq5s3cOr9omn6BXc=;
	h=Date:To:From:Subject:From;
	b=KkZfXOXp/Dq/UrSs+3rrGOy9ARCJduXH5d3+0tU49m0N+ueNwVbFO+1DY7uB2n0Wz
	 ffyua/90i3DipLsHBOV18sfuyDw6b40HSHn9kW5eys+iqEnkR5wQCzTObdOE5opXXU
	 hVk0OIMHHpINCF7Atvkw8N7Aew8CHKY9rras5AsM=
Date: Mon, 16 Jun 2025 16:49:43 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rakie.kim@sk.com,Jonathan.Cameron@huawei.com,harry.yoo@oracle.com,david@redhat.com,42.hyeyoo@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmmempolicy-use-node-notifier-instead-of-memory-notifier.patch added to mm-unstable branch
Message-Id: <20250616234943.C34C6C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,mempolicy: use node-notifier instead of memory-notifier
has been added to the -mm mm-unstable branch.  Its filename is
     mmmempolicy-use-node-notifier-instead-of-memory-notifier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmmempolicy-use-node-notifier-instead-of-memory-notifier.patch

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

mmslub-do-not-special-case-n_normal-nodes-for-slab_nodes.patch
mmmemory_hotplug-remove-status_change_nid_normal-and-update-documentation.patch
mmmemory_hotplug-implement-numa-node-notifier.patch
mmslub-use-node-notifier-instead-of-memory-notifier.patch
mmmemory-tiers-use-node-notifier-instead-of-memory-notifier.patch
driverscxl-use-node-notifier-instead-of-memory-notifier.patch
drivershmat-use-node-notifier-instead-of-memory-notifier.patch
kernelcpuset-use-node-notifier-instead-of-memory-notifier.patch
mmmempolicy-use-node-notifier-instead-of-memory-notifier.patch
mmpage_ext-derive-the-node-from-the-pfn.patch
mmmemory_hotplug-drop-status_change_nid-parameter-from-memory_notify.patch

