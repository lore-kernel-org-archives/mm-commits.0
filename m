Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793252259;
	b=AaTXY1wxQknxpd151+K1/zVZ+EJmhP0p3ztDrgko4ES587WkoN42dm0k3WDV6SBsuxfc
	 LaheFvX2fbOmbB0b0aW2+Ig1gBSsX+3jCNrT4AafVtoR0kwx+KtHsD0WKYVxLEV4nWK3J
	 /IyJ5J3A5E3mYqqz39S7HhzyeSvUr30eeGi/dbW9P+NEqutSznT3EO+JHpDw4lFSIuvvh
	 SCYAp9ItAzVByiiIVCwlFiFiBhE4KTNy9EZCVoiiF6Dss3kTHQYzv8TWK1+4z1FWbX6Yk
	 HWuiUoE2Et/eY3a6vPEIzSxtjPS0FFWVoEL18/m5srOYFAfgkLurhk7sWrD4rMIXOog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793252259;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=LlvhJfjYG+k80YhpJva0gpreN501iqOXrkl4ZNm76rE=;
	b=MH8pa04g24/SVIzMWo4tfl8ooRfuSqE0MZTkUTVj5s/0exlrtk+XxvOt2Z9BfdehtNYQ
	 ZpRVMGDEEG4gzeOxopbBqBgs9f/E+yCgrnNaUcUqzwzqyYNPuuh6aHCabmGgE1TTYMTii
	 wMqOns8E6wuLma83/m8xLspLEUj4FdUjTaINnF21TiiFHOjdw1fj0+dmcxETWf0ECQ5xN
	 XiXWhbHpnU1/O8vzcEHjyivNgIKECy5jPBw3aScRYnSFGeZpbrB7HX03WD6q2mw3jiZxZ
	 2yXW8hPe/PSDy9DlY8pHYKXCK4egYFnbPqL+QDDh0XwXgwWqW6p/syK6n5wywB7v2UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=EqaEP8oz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3810C606A31A
	for <mm-commits@vger.kernel.org>; Thu, 29 Oct 2026 05:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=EqaEP8oz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A063D1F01825;
	Thu, 29 Oct 2026 05:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793252258;
	bh=LlvhJfjYG+k80YhpJva0gpreN501iqOXrkl4ZNm76rE=;
	h=Date:To:From:Subject;
	b=EqaEP8ozQTQsFhLQ0MsMZXIIRaLfj2air43NG96J6vO0elqIPC62OWTV/JBqk8cvb
	 7I+4ihVBWatnzSFszEKaz6vW6pQsqtLfdcInZuLqkjHpSW6RP0jPXx6kyPDCNnhMY9
	 UAyL0Auaz/tRfF5udSuoW13p0YPMipm5oE+OaQgA=
Date: Wed, 28 Oct 2026 22:37:38 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,osalvador@suse.de,
	muchun.song@linux.dev,mike.kravetz@oracle.com,mhocko@suse.com,
	joshua.hahnjy@gmail.com,fvdl@google.com,david@kernel.org,
	chris@chrisdown.name,baolin.wang@linux.alibaba.com,chengkaitao@kylinos.cn,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_cma-fix-incorrect-hugetlb_cma_size-assignment-on-malformed-input.patch added to mm-new branch
Message-Id: <20261029053738.A063D1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/hugetlb_cma: fix incorrect hugetlb_cma_size assignment on malformed input
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb_cma-fix-incorrect-hugetlb_cma_size-assignment-on-malformed-input.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_cma-fix-incorrect-hugetlb_cma_size-assignment-on-malformed-input.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: mm/hugetlb_cma: fix incorrect hugetlb_cma_size assignment on malformed input
Date: Wed, 28 Oct 2026 19:33:17 +0800

When hugetlb_cma contains a global size after node-specific entries,
cmdline_parse_hugetlb_cma() enters the global branch and reparses the
original parameter string.  For hugetlb_cma=1:2G,4G, this interprets the
initial node ID as a one-byte global size and clears the 2 GiB reservation
recorded for node 1.

Global and node-specific formats cannot be mixed.  Return -EINVAL when a
global entry follows a node-specific entry, before updating any settings. 
This preserves the valid prefix, so the example retains node 1's 2 GiB
reservation and reports the malformed option.

Link: https://lore.kernel.org/20261028113319.38544-2-kaitao.cheng@linux.dev
Fixes: 38e719ab2673 ("hugetlb: support node specified when using cma for gigantic hugepages")
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://sashiko.dev/#/bug/linux-10f40d3e-3feb-4622-9da8-1fedecb2d0e2
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
---

 mm/hugetlb_cma.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/hugetlb_cma.c~mm-hugetlb_cma-fix-incorrect-hugetlb_cma_size-assignment-on-malformed-input
+++ a/mm/hugetlb_cma.c
@@ -167,6 +167,9 @@ static int __init cmdline_parse_hugetlb_
 		} else {
 			char *next;
 
+			if (s != p)
+				return -EINVAL;
+
 			tmp = memparse(p, &next);
 			if (*next == '%') {
 				if (tmp > 100) {
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are

mm-hugetlb_cma-fix-incorrect-hugetlb_cma_size-assignment-on-malformed-input.patch

