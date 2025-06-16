Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2AD136349
	for <mm-commits@vger.kernel.org>; Mon, 16 Jun 2025 23:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750117788; cv=none; b=BsLESrfZyE1nEgm/bd5Ei2mor5D/hhLUA/7jc2iXYWINGG+UMxClrci2LS8DHsNb8NQCENjREib5+sBKaglxuzdknxF4fXyMMXet4CBWozKko2Tif0o4oa7wHTmz/z7VteWYUKd/V786USCzVDfvrElLH0jSeZRL6Kc2EXYXWag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750117788; c=relaxed/simple;
	bh=DxT+DxJ/4clJyu6lCkxh1FzhHfBfmCULj6CuRaEnAdc=;
	h=Date:To:From:Subject:Message-Id; b=r5TQHi9Hz5ubZX3CXD4Z0yOveTwtbwQTgKPpedTDR3aTwkdzzOo/SqebGR1vxARbd2fwzNic0dNWGtdMegOalgrw95wKYtEXiNrVIGACNOFZiCq4BoMGWL8C991L0zXuJm9JHLqoZ2ozz51e42WSnqlLRuAkk09uVDCPrKblTtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RIGaDM5j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RIGaDM5j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8532C4CEEA;
	Mon, 16 Jun 2025 23:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750117787;
	bh=DxT+DxJ/4clJyu6lCkxh1FzhHfBfmCULj6CuRaEnAdc=;
	h=Date:To:From:Subject:From;
	b=RIGaDM5jdegRXKzter5pjkM/4F7WWFN2N7ZQ/12JjNSuS9BaFSf9vML3zUiOFsps0
	 W9kdH+WCY+YxuwhdUIWL/3mrxJ4hZ497v7AD+C8Osq59NrlpXPApko4nK04D1JEa9T
	 lKdoZ4Oy6l6ThAm3slBzYCQtx4cVpm4PSr+F1v8A=
Date: Mon, 16 Jun 2025 16:49:47 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rakie.kim@sk.com,Jonathan.Cameron@huawei.com,harry.yoo@oracle.com,david@redhat.com,42.hyeyoo@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmmemory_hotplug-drop-status_change_nid-parameter-from-memory_notify.patch added to mm-unstable branch
Message-Id: <20250616234947.B8532C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,memory_hotplug: drop status_change_nid parameter from memory_notify
has been added to the -mm mm-unstable branch.  Its filename is
     mmmemory_hotplug-drop-status_change_nid-parameter-from-memory_notify.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmmemory_hotplug-drop-status_change_nid-parameter-from-memory_notify.patch

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
Subject: mm,memory_hotplug: drop status_change_nid parameter from memory_notify
Date: Mon, 16 Jun 2025 15:51:54 +0200

There no users left of status_change_nid, so drop it from memory_notify
struct.

Link: https://lkml.kernel.org/r/20250616135158.450136-12-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/memory-hotplug.rst |    7 -------
 include/linux/memory.h                    |    1 -
 mm/memory_hotplug.c                       |    4 ----
 3 files changed, 12 deletions(-)

--- a/Documentation/core-api/memory-hotplug.rst~mmmemory_hotplug-drop-status_change_nid-parameter-from-memory_notify
+++ a/Documentation/core-api/memory-hotplug.rst
@@ -59,17 +59,10 @@ The third argument (arg) passes a pointe
 	struct memory_notify {
 		unsigned long start_pfn;
 		unsigned long nr_pages;
-		int status_change_nid;
 	}
 
 - start_pfn is start_pfn of online/offline memory.
 - nr_pages is # of pages of online/offline memory.
-- status_change_nid is set node id when N_MEMORY of nodemask is (will be)
-  set/clear. It means a new(memoryless) node gets new memory by online and a
-  node loses all memory. If this is -1, then nodemask status is not changed.
-
-  If status_changed_nid* >= 0, callback should create/discard structures for the
-  node if necessary.
 
 It is possible to get notified for MEM_CANCEL_ONLINE without having been notified
 for MEM_GOING_ONLINE, and the same applies to MEM_CANCEL_OFFLINE and
--- a/include/linux/memory.h~mmmemory_hotplug-drop-status_change_nid-parameter-from-memory_notify
+++ a/include/linux/memory.h
@@ -109,7 +109,6 @@ struct memory_notify {
 	unsigned long altmap_nr_pages;
 	unsigned long start_pfn;
 	unsigned long nr_pages;
-	int status_change_nid;
 };
 
 struct notifier_block;
--- a/mm/memory_hotplug.c~mmmemory_hotplug-drop-status_change_nid-parameter-from-memory_notify
+++ a/mm/memory_hotplug.c
@@ -1153,7 +1153,6 @@ int online_pages(unsigned long pfn, unsi
 	struct memory_notify mem_arg = {
 		.start_pfn = pfn,
 		.nr_pages = nr_pages,
-		.status_change_nid = NUMA_NO_NODE,
 	};
 	struct node_notify node_arg = {
 		.nid = NUMA_NO_NODE,
@@ -1181,7 +1180,6 @@ int online_pages(unsigned long pfn, unsi
 	if (!node_state(nid, N_MEMORY)) {
 		/* Adding memory to the node for the first time */
 		node_arg.nid = nid;
-		mem_arg.status_change_nid = nid;
 		ret = node_notify(NODE_ADDING_FIRST_MEMORY, &node_arg);
 		ret = notifier_to_errno(ret);
 		if (ret)
@@ -1904,7 +1902,6 @@ int offline_pages(unsigned long start_pf
 	struct memory_notify mem_arg = {
 		.start_pfn = start_pfn,
 		.nr_pages = nr_pages,
-		.status_change_nid = NUMA_NO_NODE,
 	};
 	struct node_notify node_arg = {
 		.nid = NUMA_NO_NODE,
@@ -1975,7 +1972,6 @@ int offline_pages(unsigned long start_pf
 	 */
 	if (nr_pages >= pgdat->node_present_pages) {
 		node_arg.nid = node;
-		mem_arg.status_change_nid = node;
 		ret = node_notify(NODE_REMOVING_LAST_MEMORY, &node_arg);
 		ret = notifier_to_errno(ret);
 		if (ret)
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

