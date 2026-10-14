Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF35305674
	for <mm-commits@vger.kernel.org>; Wed, 14 Oct 2026 03:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791948811; cv=none; b=Wv9xjBE7xDnDi1sniFabSCnjnaNXCWmpuHukVlNVoeXHx78F49kTZH6MtM15zEMdvUbCI2FI4bT/HYXMvtYPmgTVOBaDeWeexfyuuMuxkv6xJe++3HIxApvVBfUrHbJPDj34rFDZUSJNfFaxFgCwKW9KFfk1dNaaOQ6X6kOdO/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791948811; c=relaxed/simple;
	bh=nEYmE4Oxl4c8Y83MD55zA7HncABlmqlEZiBoLYjt+Lk=;
	h=Date:To:From:Subject:Message-Id; b=Ap8n3L1d9NRdTZHJWB9M95EzDSvHCNkpdks2/vX55S+qHDitPfABn3d86IMtsXTNFkPEF/pJiji8gpse4b/35U0V85lMvEp7y22oZZv/6vBbNbOP+5ZcEPuiSbG9ZVPBBnTDRS5L7tzcM7naT/IzAcvJ1wlbydBhHJ0k0uykxVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c+50Uk8s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c+50Uk8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880BD1F000FF;
	Wed, 14 Oct 2026 03:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791948810;
	bh=Ux/4ZbZVRnYpCDBaSZ5LvrCgRs+rkMSX0k2IbNqsydA=;
	h=Date:To:From:Subject;
	b=c+50Uk8sIJg2NPji6P8l7qX+KLLMWo+Fi61BQmve148y9izO+UMSXvqrpy5Cr+33S
	 I3WuPqS47ByxuwvyK7QSnDDmJ46Oul3HP5FDV4VvMnIDuFLpsGXtzC3qpgLhNOaJZp
	 DkdF71dEg5IsyzgQYnz9AAUnAAJ/V97HB/MKJQ0c=
Date: Tue, 13 Oct 2026 20:33:30 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-use-sizeofbuf-in-string_get_size-calls.patch added to mm-unstable branch
Message-Id: <20261014033330.880BD1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: use sizeof(buf) in string_get_size() calls
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-use-sizeofbuf-in-string_get_size-calls.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-use-sizeofbuf-in-string_get_size-calls.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Enze Li <lienze@kylinos.cn>
Subject: mm/hugetlb: use sizeof(buf) in string_get_size() calls
Date: Wed, 14 Oct 2026 11:11:47 +0800

Replace the hardcoded 32 with sizeof(buf) at the remaining four call
sites, for consistency with the rest of the file.

Link: https://lore.kernel.org/20261014031147.444733-1-lienze@kylinos.cn
Signed-off-by: Enze Li <lienze@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
---

 mm/hugetlb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-sizeofbuf-in-string_get_size-calls
+++ a/mm/hugetlb.c
@@ -3466,7 +3466,7 @@ static void __init hugetlb_hstate_alloc_
 	if (i == h->max_huge_pages_node[nid])
 		return;
 
-	string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
+	string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, sizeof(buf));
 	pr_warn("allocating %u of page size %s failed node%d.  Only allocated %lu hugepages.\n",
 		h->max_huge_pages_node[nid], buf, nid, i);
 	h->max_huge_pages -= (h->max_huge_pages_node[nid] - i);
@@ -3493,7 +3493,7 @@ static void __init hugetlb_hstate_alloc_
 	if (allocated < h->max_huge_pages) {
 		char buf[32];
 
-		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
+		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, sizeof(buf));
 		pr_warn("allocating %lu of page size %s failed.  Only allocated %lu hugepages.\n",
 			h->max_huge_pages, buf, allocated);
 		h->max_huge_pages = allocated;
@@ -3704,7 +3704,7 @@ static void __init report_hugepages(void
 	for_each_hstate(h) {
 		char buf[32];
 
-		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
+		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, sizeof(buf));
 		pr_info("registered %s page size, pre-allocated %ld pages\n",
 			buf, h->nr_huge_pages);
 		pr_info("%d KiB vmemmap can be freed for a %s page\n",
@@ -4216,7 +4216,7 @@ static int __init hugetlb_init(void)
 				char buf[32];
 
 				string_get_size(huge_page_size(&default_hstate),
-					1, STRING_UNITS_2, buf, 32);
+					1, STRING_UNITS_2, buf, sizeof(buf));
 				pr_warn("Ignoring hugepages=%lu associated with %s page size\n",
 					default_hstate.max_huge_pages, buf);
 				pr_warn("Using hugepages=%lu for number of default huge pages\n",
_

Patches currently in -mm which might be from lienze@kylinos.cn are

maintainers-cover-all-hugetlb-headers-under-hugetlb-subsystem.patch
mm-hugetlb_cgroup-add-trailing-endif-comment-for-include-guard.patch
docs-hugetlbpagerst-fix-typo-in-per-node-attribute-description.patch
mm-hugetlb-prefix-log-messages-via-pr_fmt.patch
mm-hugetlb-move-hugetlb_sysfs_initialized-into-hugetlb_register_all_nodes.patch
mm-hugetlb-use-sizeofbuf-in-string_get_size-calls.patch

