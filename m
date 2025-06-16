Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A69136349
	for <mm-commits@vger.kernel.org>; Mon, 16 Jun 2025 23:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750117786; cv=none; b=YyOhe7pO9I4g+tsSSNNZg3fMFB66+K8r0IasUfC+unhONfMK25/+N1Uo6gGDFGz5xOVogoGvnbqYq8Rkt86xgiE6NomYE29NGNDiRQwTsoTuiWNTxg3NBoTBdBLg4sLzJjBvku8D1i1DGQwcxuZQid7szQCu9yTQIFriOthVyC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750117786; c=relaxed/simple;
	bh=92KLT/Foa/nxXDLDerlB8jd3v+CTMB8ZK7n8mLRs+3Y=;
	h=Date:To:From:Subject:Message-Id; b=oNKmsNg6qYGFPhG90DL/Jg4Sl3aoCDrRRfm1heSxZHnjdxRzGXAOYuXMuqNJlVRwBnZnyYLfHJZUg4Q+XtGfYK9kTVbxCPV3drtkTAP+iQb1yOy3QqPFcbgD39w7nKMLmPWB7kdIRNf/vzLZbqIJd3aMDLwYXC1jGbUCxg0EgFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L7g3Us8Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L7g3Us8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21FAC4CEEA;
	Mon, 16 Jun 2025 23:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750117785;
	bh=92KLT/Foa/nxXDLDerlB8jd3v+CTMB8ZK7n8mLRs+3Y=;
	h=Date:To:From:Subject:From;
	b=L7g3Us8YpIQ5p3Zz64mkcK0DFTfRt/rQHDAVStuUzT86NdsN1Nj3LPAwsk3fha6Gg
	 VGYhdzxn9UO1Q7bxVL0MPKQEBp4pp2m4Ggk2pRPFPKwNx5xye0xSQz6YtcMW0MWfQ7
	 dG0G7y7h+98cgxxePx0oMQ3/ipUGI+dZvI3z557o=
Date: Mon, 16 Jun 2025 16:49:45 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rakie.kim@sk.com,Jonathan.Cameron@huawei.com,harry.yoo@oracle.com,david@redhat.com,42.hyeyoo@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmpage_ext-derive-the-node-from-the-pfn.patch added to mm-unstable branch
Message-Id: <20250616234945.C21FAC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,page_ext: derive the node from the pfn
has been added to the -mm mm-unstable branch.  Its filename is
     mmpage_ext-derive-the-node-from-the-pfn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmpage_ext-derive-the-node-from-the-pfn.patch

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
Subject: mm,page_ext: derive the node from the pfn
Date: Mon, 16 Jun 2025 15:51:53 +0200

page_ext is the only user of 'status_change_nid', which is set in
online/offline operations, to know to which node we are adding/removing
memory.

Prior to call any notifiers, the memmap is initialized via, which among
other things, sets the node the pages belong to, to all corresponging
pages.  This means that there is no need to keep using 'status_change_nid'
since we can derive the node from the pfn.  This will allow us to finally
drop 'status_change_nid' from the memory_notify struct.

Link: https://lkml.kernel.org/r/20250616135158.450136-11-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_ext.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

--- a/mm/page_ext.c~mmpage_ext-derive-the-node-from-the-pfn
+++ a/mm/page_ext.c
@@ -369,25 +369,15 @@ static void __invalidate_page_ext(unsign
 }
 
 static int __meminit online_page_ext(unsigned long start_pfn,
-				unsigned long nr_pages,
-				int nid)
+				unsigned long nr_pages)
 {
+	int nid = pfn_to_nid(start_pfn);
 	unsigned long start, end, pfn;
 	int fail = 0;
 
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
@@ -435,8 +425,7 @@ static int __meminit page_ext_callback(s
 
 	switch (action) {
 	case MEM_GOING_ONLINE:
-		ret = online_page_ext(mn->start_pfn,
-				   mn->nr_pages, mn->status_change_nid);
+		ret = online_page_ext(mn->start_pfn, mn->nr_pages);
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
mmpage_ext-derive-the-node-from-the-pfn.patch
mmmemory_hotplug-drop-status_change_nid-parameter-from-memory_notify.patch

