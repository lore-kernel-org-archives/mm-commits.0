Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E0CC129;
	Tue,  2 Jul 2024 02:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719886487; cv=none; b=k3Af2dIEUjgmyWZbwENbAs9JQSvs536Aqs2lwU00p4pk+t6oD0pyY34WcIByRB1d8fcrD6DGuw/DZX3BRke0kbg9CBA9NsFVMTC1w66NlQ2Uva6Qz2FSwwYz2wg935dZ6e7mTCu3FBrv3IZRTmYI2R2Lg+f+CbxOzGQuLYnorrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719886487; c=relaxed/simple;
	bh=C9tpno0LmuMacIyikAeiEgE/Oo4yuNefmi/Oub89KFA=;
	h=Date:To:From:Subject:Message-Id; b=J4HErAKTsHicpkZS0md0lSElZyARCJVK3GwZh47lWq0Yp/IB7P/ZGyQ8gXbMkfD59fOWZMsqAE8RABiZTaOhlQ65lHtvVXovUN+Ly8Oz3D+pghKyoAqZJp3NC2sBpRnKgOffVd9BIsCy+vLE0ACTChlzgbX0XJLi15D1EoiqhZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ojzzf8kI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ojzzf8kI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10316C116B1;
	Tue,  2 Jul 2024 02:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719886487;
	bh=C9tpno0LmuMacIyikAeiEgE/Oo4yuNefmi/Oub89KFA=;
	h=Date:To:From:Subject:From;
	b=ojzzf8kIJm5zYhrD52DnlGwpp6ZYVWlw/TcmymeT9cR2DF37E/3YJyes5ak/2q8cF
	 hTQYNSK+S1E/+VHlQOX4IowGcg1rx9kYmQJJ18puQsyzHjmJOpBs8DpwVMxduZjpMQ
	 0c1JNoRKN0v28OaY8S20dXqAUHFfMEFqrVVedQ2c=
Date: Mon, 01 Jul 2024 19:14:46 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,stable@vger.kernel.org,muchun.song@linux.dev,david@redhat.com,aris@redhat.com,aris@ruivo.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-force-allocating-surplus-hugepages-on-mempolicy-allowed-nodes-v2.patch added to mm-unstable branch
Message-Id: <20240702021447.10316C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: force allocating surplus hugepages on mempolicy allowed nodes
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-force-allocating-surplus-hugepages-on-mempolicy-allowed-nodes-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-force-allocating-surplus-hugepages-on-mempolicy-allowed-nodes-v2.patch

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
From: Aristeu Rozanski <aris@ruivo.org>
Subject: hugetlb: force allocating surplus hugepages on mempolicy allowed nodes
Date: Mon, 1 Jul 2024 17:23:43 -0400

v2: - attempt to make the description more clear
    - prevent unitialized usage of folio in case current process isn't part of any
      nodes with memory

Link: https://lkml.kernel.org/r/20240701212343.GG844599@cathedrallabs.org
Signed-off-by: Aristeu Rozanski <aris@ruivo.org>
Cc: Vishal Moola <vishal.moola@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Aristeu Rozanski <aris@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c~hugetlb-force-allocating-surplus-hugepages-on-mempolicy-allowed-nodes-v2
+++ a/mm/hugetlb.c
@@ -2631,6 +2631,7 @@ static int gather_surplus_pages(struct h
 retry:
 	spin_unlock_irq(&hugetlb_lock);
 	for (i = 0; i < needed; i++) {
+		folio = NULL;
 		for_each_node_mask(node, cpuset_current_mems_allowed) {
 			if (!mbind_nodemask || node_isset(node, *mbind_nodemask)) {
 				folio = alloc_surplus_hugetlb_folio(h, htlb_alloc_mask(h),
_

Patches currently in -mm which might be from aris@ruivo.org are

hugetlb-force-allocating-surplus-hugepages-on-mempolicy-allowed-nodes-v2.patch

