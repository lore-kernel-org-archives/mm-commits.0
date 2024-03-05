Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B32412AACB
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 20:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709671616; cv=none; b=tOyswF0UsYYZ2a9CUSU9TQq/kqPyjQMWJGHrpRp1GmhHfjhRWdyDuke0jLBxKmYrSRhmQEjWKLuuHYJICz/yTC03bJMAfau9E8VjVFAP4z3zrRxY3cSqHoWAdqFXuFsas+OwsMCPW/Vx9n1Z3GO4NRhhB9wze6vDpFePRwDVtlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709671616; c=relaxed/simple;
	bh=9KiorXj1BCsliH0rpEoV8FIOdRkqB4seqkiavEZaHrI=;
	h=Date:To:From:Subject:Message-Id; b=B24Khho9GdnDR1v08GZLNlYXTG3nOyRCL4UmK1dm1D+95ynHvV9umEcqABg/E8M3bfhwHpKKQKCXc92YAaevpZMZ2LITNkmoHhp7ZD7bGP8zCCmCt9K7lNsRKUIJtr0UoqnduMEcmtlRcELkhIbY1tq6nI/lAP/RSKfogLhMlgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JNxW2tgH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JNxW2tgH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9357FC43390;
	Tue,  5 Mar 2024 20:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709671615;
	bh=9KiorXj1BCsliH0rpEoV8FIOdRkqB4seqkiavEZaHrI=;
	h=Date:To:From:Subject:From;
	b=JNxW2tgHGOREV6+6uDXZ1Qzkl92cccf6HCKHurqN2nX+Nj7G9kYD7wtBzu8xWKPtN
	 XHtvdOUKdGwIhar2sSxobm1iW1zLNbYPIWMxuHZDP+nZgd9ql69fcJ+UfvSw8ng58Q
	 BI1AXwobbVqr2LXG17eUtJyoioZZOLp/+mhASGWQ=
Date: Tue, 05 Mar 2024 12:46:54 -0800
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,steffen.klassert@secunet.com,rientjes@google.com,rdunlap@infradead.org,paulmck@kernel.org,muchun.song@linux.dev,mike.kravetz@oracle.com,ligang.bdlg@bytedance.com,jane.chu@oracle.com,gang.li@linux.dev,david@redhat.com,daniel.m.jordan@oracle.com,adobriyan@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] hugetlb-parallelize-1g-hugetlb-initialization-fix.patch removed from -mm tree
Message-Id: <20240305204655.9357FC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb-parallelize-1g-hugetlb-initialization-fix
has been removed from the -mm tree.  Its filename was
     hugetlb-parallelize-1g-hugetlb-initialization-fix.patch

This patch was dropped because it was folded into hugetlb-parallelize-1g-hugetlb-initialization.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hugetlb-parallelize-1g-hugetlb-initialization-fix
Date: Thu Feb 22 10:34:41 AM PST 2024

s/initialied/initialized/, per Alexey

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Gang Li <gang.li@linux.dev>
Cc: Gang Li <ligang.bdlg@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~hugetlb-parallelize-1g-hugetlb-initialization-fix
+++ a/mm/hugetlb.c
@@ -3625,7 +3625,7 @@ static unsigned long __init hugetlb_page
 static void __init hugetlb_hstate_alloc_pages(struct hstate *h)
 {
 	unsigned long allocated;
-	static bool initialied __initdata;
+	static bool initialized __initdata;
 
 	/* skip gigantic hugepages allocation if hugetlb_cma enabled */
 	if (hstate_is_gigantic(h) && hugetlb_cma_size) {
@@ -3634,12 +3634,12 @@ static void __init hugetlb_hstate_alloc_
 	}
 
 	/* hugetlb_hstate_alloc_pages will be called many times, initialize huge_boot_pages once */
-	if (!initialied) {
+	if (!initialized) {
 		int i = 0;
 
 		for (i = 0; i < MAX_NUMNODES; i++)
 			INIT_LIST_HEAD(&huge_boot_pages[i]);
-		initialied = true;
+		initialized = true;
 	}
 
 	/* do node specific alloc */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

hugetlb-parallelize-1g-hugetlb-initialization.patch
mm-add-__dump_folio-fix-3-fix.patch

