Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABCA204F93
	for <mm-commits@vger.kernel.org>; Thu,  5 Jun 2025 20:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749155991; cv=none; b=d28DwmN6elOKwCHKVV9PP9XERfjmz9N+XXoerTN8qz6WubfMa848JFaAJs+qEHwdQJY2VDrAszorxd8Sf1s7HRoruj9nFUoQkfmQfeVROIFKCO/Ojnoh6xtUiIFW09xPROSeGSJ/xq63e42ZpuqAfBqm+UVGd7mxRLR/wxXjlqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749155991; c=relaxed/simple;
	bh=5zwoeND4eajOJouLIEvkJCTaqVbJUUm5MJjRj7CK/2U=;
	h=Date:To:From:Subject:Message-Id; b=J7ap43W3zmYv+ivoepv/+9Qvfkl60AibFnWIkBAAgCx2IgI3j0gZAuu/UdVH1sOAtfipFqu9ZC8HrkwICwziYwuEyYDWk7WXCfFLlyTCvDiSF8oONInJUL6fQknL8FlQSon/0UMQMX//uv56v0ZNuOsfbRuxf7DczFUM/VQBjiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MzEjxb0A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MzEjxb0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D65C4CEE7;
	Thu,  5 Jun 2025 20:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749155991;
	bh=5zwoeND4eajOJouLIEvkJCTaqVbJUUm5MJjRj7CK/2U=;
	h=Date:To:From:Subject:From;
	b=MzEjxb0ABBCTywzEOh+zTTWSN1f5ntII3GBtK63huC+h14AZEiQESAVjz2n4aOK+2
	 Xs/wL5lAb4ejXxSWAajELw8J0tH/uCHlma41L/jB402aMZHS3E+Hg96bx/I6qNxY//
	 QO1NhxLU5Sz7NukwVi4Q67+DjHz8IeTRHEJvgnVY=
Date: Thu, 05 Jun 2025 13:39:50 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rakie.kim@sk.com,Jonathan.Cameron@huawei.com,harry.yoo@oracle.com,david@redhat.com,42.hyeyoo@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmmemory_hotplug-rename-status_change_nid-parameter-in-memory_notify.patch added to mm-new branch
Message-Id: <20250605203950.F1D65C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,memory_hotplug: rename status_change_nid parameter in memory_notify
has been added to the -mm mm-new branch.  Its filename is
     mmmemory_hotplug-rename-status_change_nid-parameter-in-memory_notify.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmmemory_hotplug-rename-status_change_nid-parameter-in-memory_notify.patch

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
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,memory_hotplug: rename status_change_nid parameter in memory_notify
Date: Thu, 5 Jun 2025 16:23:01 +0200

The 'status_change_nid' field was used to track changes in the memory
state of a numa node, but that funcionality has been decoupled from
memory_notify and moved to node_notify.  Current consumers of
memory_notify are only interested in which node the memory we are adding
belongs to, so rename current 'status_change_nid' to 'nid'.

Link: https://lkml.kernel.org/r/20250605142305.244465-11-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/memory-hotplug.rst |    9 ++-------
 include/linux/memory.h                    |    2 +-
 mm/memory_hotplug.c                       |    4 ++--
 mm/page_ext.c                             |   12 +-----------
 4 files changed, 6 insertions(+), 21 deletions(-)

--- a/Documentation/core-api/memory-hotplug.rst~mmmemory_hotplug-rename-status_change_nid-parameter-in-memory_notify
+++ a/Documentation/core-api/memory-hotplug.rst
@@ -59,17 +59,12 @@ The third argument (arg) passes a pointe
 	struct memory_notify {
 		unsigned long start_pfn;
 		unsigned long nr_pages;
-		int status_change_nid;
+		int nid;
 	}
 
 - start_pfn is start_pfn of online/offline memory.
 - nr_pages is # of pages of online/offline memory.
-- status_change_nid is set node id when N_MEMORY of nodemask is (will be)
-  set/clear. It means a new(memoryless) node gets new memory by online and a
-  node loses all memory. If this is -1, then nodemask status is not changed.
-
-  If status_changed_nid* >= 0, callback should create/discard structures for the
-  node if necessary.
+- nid is set to the node id, where the memory we are adding or removing belongs to.
 
 The callback routine shall return one of the values
 NOTIFY_DONE, NOTIFY_OK, NOTIFY_BAD, NOTIFY_STOP
--- a/include/linux/memory.h~mmmemory_hotplug-rename-status_change_nid-parameter-in-memory_notify
+++ a/include/linux/memory.h
@@ -109,7 +109,7 @@ struct memory_notify {
 	unsigned long altmap_nr_pages;
 	unsigned long start_pfn;
 	unsigned long nr_pages;
-	int status_change_nid;
+	int nid;
 };
 
 struct notifier_block;
--- a/mm/memory_hotplug.c~mmmemory_hotplug-rename-status_change_nid-parameter-in-memory_notify
+++ a/mm/memory_hotplug.c
@@ -1186,7 +1186,7 @@ int online_pages(unsigned long pfn, unsi
 
 	mem_arg.start_pfn = pfn;
 	mem_arg.nr_pages = nr_pages;
-	mem_arg.status_change_nid = node_arg.nid;
+	mem_arg.nid = node_arg.nid;
 	cancel_mem_notifier_on_err = true;
 	ret = memory_notify(MEM_GOING_ONLINE, &mem_arg);
 	ret = notifier_to_errno(ret);
@@ -1986,7 +1986,7 @@ int offline_pages(unsigned long start_pf
 
 	mem_arg.start_pfn = start_pfn;
 	mem_arg.nr_pages = nr_pages;
-	mem_arg.status_change_nid = node_arg.nid;
+	mem_arg.nid = node_arg.nid;
 	cancel_mem_notifier_on_err = true;
 	ret = memory_notify(MEM_GOING_OFFLINE, &mem_arg);
 	ret = notifier_to_errno(ret);
--- a/mm/page_ext.c~mmmemory_hotplug-rename-status_change_nid-parameter-in-memory_notify
+++ a/mm/page_ext.c
@@ -378,16 +378,6 @@ static int __meminit online_page_ext(uns
 	start = SECTION_ALIGN_DOWN(start_pfn);
 	end = SECTION_ALIGN_UP(start_pfn + nr_pages);
 
-	if (nid == NUMA_NO_NODE) {
-		/*
-		 * In this case, "nid" already exists and contains valid memory.
-		 * "start_pfn" passed to us is a pfn which is an arg for
-		 * online__pages(), and start_pfn should exist.
-		 */
-		nid = pfn_to_nid(start_pfn);
-		VM_BUG_ON(!node_online(nid));
-	}
-
 	for (pfn = start; !fail && pfn < end; pfn += PAGES_PER_SECTION)
 		fail = init_section_page_ext(pfn, nid);
 	if (!fail)
@@ -436,7 +426,7 @@ static int __meminit page_ext_callback(s
 	switch (action) {
 	case MEM_GOING_ONLINE:
 		ret = online_page_ext(mn->start_pfn,
-				   mn->nr_pages, mn->status_change_nid);
+				   mn->nr_pages, mn->nid);
 		break;
 	case MEM_OFFLINE:
 		offline_page_ext(mn->start_pfn,
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
mmmemory_hotplug-rename-status_change_nid-parameter-in-memory_notify.patch

