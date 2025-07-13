Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03CD1D54FA
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450008; cv=none; b=oPo32sCn1qfX8cUPX5U0C56SdifQe1mbQfGpzYpzmuSm1VRRD1PZ3Rc7/BwddIi6G1K5T1HmxQ8/YEVB14rFV7uLCqAqec/w3VkmYZCWdRQdS6RwNfcbamQ6Ye56eCs/0R09j1VRcFZYxSQCeceoPsdokDvbKUTj8Qs8/o/TSco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450008; c=relaxed/simple;
	bh=nhn2lbrSLcjPIrboE24vf3ffsvW90Zj8KkmdTyvm5Kk=;
	h=Date:To:From:Subject:Message-Id; b=hqoplpR81W268Docz9uxqI3nqbKiHN3AGaNodjJnLVBakvvuxvd4a5gQTFFR82S6WUdb/LGWBJmplJ72vdmh57+cRmPzqh/imILndWBc6+gUgg9OCXS5QEHqMPBzDZm8hl5wjGr+troaT6qroMGPE9kol92WxtL7NFHiFBB2nPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hedjEIgv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hedjEIgv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BAEC4CEE3;
	Sun, 13 Jul 2025 23:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450007;
	bh=nhn2lbrSLcjPIrboE24vf3ffsvW90Zj8KkmdTyvm5Kk=;
	h=Date:To:From:Subject:From;
	b=hedjEIgv6ickbHKxsgSxmtk0Xuy2iJPYSvNhLEbe+g4JKIBqQC8/CuUfQx3st+jSZ
	 6ixkdLzet1XcRDCOd/3pxtWOeBygefL89SFsR5g2lvoE2EF6y1CmkoObXSVyFz94pl
	 PINOinJIwK99TqMhpyf8ZuzSQnxDh2BQgEMQ++lk=
Date: Sun, 13 Jul 2025 16:40:07 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rakie.kim@sk.com,Jonathan.Cameron@huawei.com,harry.yoo@oracle.com,david@redhat.com,42.hyeyoo@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmpage_ext-derive-the-node-from-the-pfn.patch removed from -mm tree
Message-Id: <20250713234007.B5BAEC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm,page_ext: derive the node from the pfn
has been removed from the -mm tree.  Its filename was
     mmpage_ext-derive-the-node-from-the-pfn.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


