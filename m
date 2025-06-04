Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B966D3D6D
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 02:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749003631; cv=none; b=Z/dysLqjW0cIndhOHWdRMiGDd5pklZl6JsZdFBm1HdUQZNhG2OpZGcNCkwsZzk4oYWmRuej+wr+j3jxkVY7yWOAxU/XWDH/KgOEE0u2wDQgHwA2p5AH3dFAA4SAhNpxa2bFEiczgj0dN7tsEtJpbvhwVhMU6MfWAGXG5kAs6ZAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749003631; c=relaxed/simple;
	bh=5fbjZbqO8eAzvAqdNFsjbFwwe3za0XlmkbPN4uLdhCQ=;
	h=Date:To:From:Subject:Message-Id; b=OtG4GE3vT00LxLYAcHM+kO2AhlrtPfuD6O1RbS58ou4mofaO7GGz0+XknJ5C6SnJt/hF/ngrToZ5kK4TVTKbpyDonTkPbs5XQqIUdBwl3sLPPwKRb02HycrmAWyHTDgdbK6R3vkEb5+N6smg9+Ejx3sEcNLyUV4nEjpGPQqvBfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m1q9wegC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m1q9wegC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A84EC4CEED;
	Wed,  4 Jun 2025 02:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749003631;
	bh=5fbjZbqO8eAzvAqdNFsjbFwwe3za0XlmkbPN4uLdhCQ=;
	h=Date:To:From:Subject:From;
	b=m1q9wegCnZUX8ob7QPWEhjBKmAnKkqoKadzEfjUBukFXMGYYB0k3J3HkXpr9p023a
	 taSxxwxBdPahVOY2iIt69T6fEIFEmldWdMlaa0aabGnuKVHv/Z6UuEtm5ovJfN2CzD
	 P6vW5dj22m8kL7AQ/0vbg1eTX1D5NbpzslvaD328=
Date: Tue, 03 Jun 2025 19:20:30 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rakie.kim@sk.com,Jonathan.Cameron@huawei.com,harry.yoo@oracle.com,david@redhat.com,42.hyeyoo@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmmemory_hotplug-rename-status_change_nid-parameter-in-memory_notify.patch added to mm-new branch
Message-Id: <20250604022031.7A84EC4CEED@smtp.kernel.org>
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
Date: Tue, 3 Jun 2025 13:08:50 +0200

The 'status_change_nid' field was used to track changes in the memory
state of a numa node, but that funcionality has been decoupled from
memory_notify and moved to node_notify.

Current consumers of memory_notify are only interested in which node the
memory we are adding belongs to, so rename current 'status_change_nid' to
'nid'.

Link: https://lkml.kernel.org/r/20250603110850.192912-4-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory.h |    2 +-
 mm/memory_hotplug.c    |    4 ++--
 mm/page_ext.c          |   12 +-----------
 3 files changed, 4 insertions(+), 14 deletions(-)

--- a/include/linux/memory.h~mmmemory_hotplug-rename-status_change_nid-parameter-in-memory_notify
+++ a/include/linux/memory.h
@@ -117,7 +117,7 @@ struct memory_notify {
 	unsigned long altmap_nr_pages;
 	unsigned long start_pfn;
 	unsigned long nr_pages;
-	int status_change_nid;
+	int nid;
 };
 
 struct node_notify {
--- a/mm/memory_hotplug.c~mmmemory_hotplug-rename-status_change_nid-parameter-in-memory_notify
+++ a/mm/memory_hotplug.c
@@ -1186,7 +1186,7 @@ int online_pages(unsigned long pfn, unsi
 	cancel_mem_notifier_on_err = true;
 	mem_arg.start_pfn = pfn;
 	mem_arg.nr_pages = nr_pages;
-	mem_arg.status_change_nid = node_arg.status_change_nid;
+	mem_arg.nid = nid;
 	ret = memory_notify(MEM_GOING_ONLINE, &mem_arg);
 	ret = notifier_to_errno(ret);
 	if (ret)
@@ -1990,7 +1990,7 @@ int offline_pages(unsigned long start_pf
 	cancel_mem_notifier_on_err = true;
 	mem_arg.start_pfn = start_pfn;
 	mem_arg.nr_pages = nr_pages;
-	mem_arg.status_change_nid = node_arg.status_change_nid;
+	mem_arg.nid = node;
 	ret = memory_notify(MEM_GOING_OFFLINE, &mem_arg);
 	ret = notifier_to_errno(ret);
 	if (ret) {
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
mmmemory_hotplug-implement-numa-node-notifier.patch
mmmemory_hotplug-rename-status_change_nid-parameter-in-memory_notify.patch

