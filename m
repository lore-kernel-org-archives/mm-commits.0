Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8D9346FC6
	for <mm-commits@vger.kernel.org>; Sun,  8 Mar 2026 21:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773003976; cv=none; b=lgSIJHMSQcfFM0k+Tshefb1h5DGXwea5POMuN/y2CE0aX8Gs+Go1i71+7TdVJ5m96msmQFgOxkj2sE0xySlpb1Bj6fA3Q0qfTakvZ9XaZbB+cIVYsz7r2SLM46AEb7r6DdXZE9TQXwX1mC0a/9JPZ0vg4e/ihWx4qSBMyjBk4Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773003976; c=relaxed/simple;
	bh=B+eheg2gR7ZxVwUSgWNmNwO4yPRtvUzzYCkMWQI1saI=;
	h=Date:To:From:Subject:Message-Id; b=BUHwCWN+RHCs0Us4QrXw+QK4fwisC3wNgEULpOopd4QQSPAkRfyPGOIImuNN6kcNfIFAXVhVaKdCz1YCOZO2kdk+sUQmhTYQFrWPgiQJKTC833UwWImb357CC2uhHJooikK2PyQhZtdx/60rDHPPNUjAGdOJQBLWy8/WaMThXjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DW1dPbBV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DW1dPbBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E05C116C6;
	Sun,  8 Mar 2026 21:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773003976;
	bh=B+eheg2gR7ZxVwUSgWNmNwO4yPRtvUzzYCkMWQI1saI=;
	h=Date:To:From:Subject:From;
	b=DW1dPbBVL6ErFaR6RqpjDh5c63KNYsoS5Z37kKeKOMFbwCnU30xlXgtdr+2azqOvO
	 WUpybii0TFyD1QUNdtgEsrvdk5j1MFtBALSAd0h1p3VGaWs6EggcacsJQgDHlXVAFc
	 XSQxWD4oyhGWxYDTq0NvLH/Kb93YIB5MMcgbrRys=
Date: Sun, 08 Mar 2026 14:06:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,lance.yang@linux.dev,jackmanb@google.com,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ratelimit-min_free_kbytes-adjustment-messages.patch added to mm-new branch
Message-Id: <20260308210616.37E05C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: ratelimit min_free_kbytes adjustment messages
has been added to the -mm mm-new branch.  Its filename is
     mm-ratelimit-min_free_kbytes-adjustment-messages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ratelimit-min_free_kbytes-adjustment-messages.patch

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
From: Breno Leitao <leitao@debian.org>
Subject: mm: ratelimit min_free_kbytes adjustment messages
Date: Sat, 07 Mar 2026 08:08:08 -0800

The "raising min_free_kbytes" pr_info message in
set_recommended_min_free_kbytes() and the "min_free_kbytes is not updated
to" pr_warn in calculate_min_free_kbytes() can spam the kernel log when
called repeatedly.

Switch the pr_info in set_recommended_min_free_kbytes() and the pr_warn in
calculate_min_free_kbytes() to their _ratelimited variants to prevent the
log spam for this message.

Link: https://lkml.kernel.org/r/20260307-thp_logs-v3-4-a45d2c8f3685@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    4 ++--
 mm/page_alloc.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/mm/khugepaged.c~mm-ratelimit-min_free_kbytes-adjustment-messages
+++ a/mm/khugepaged.c
@@ -2693,8 +2693,8 @@ void set_recommended_min_free_kbytes(voi
 
 	if (recommended_min > min_free_kbytes) {
 		if (user_min_free_kbytes >= 0)
-			pr_info("raising min_free_kbytes from %d to %lu to help transparent hugepage allocations\n",
-				min_free_kbytes, recommended_min);
+			pr_info_ratelimited("raising min_free_kbytes from %d to %lu to help transparent hugepage allocations\n",
+					    min_free_kbytes, recommended_min);
 
 		min_free_kbytes = recommended_min;
 	}
--- a/mm/page_alloc.c~mm-ratelimit-min_free_kbytes-adjustment-messages
+++ a/mm/page_alloc.c
@@ -6513,8 +6513,8 @@ void calculate_min_free_kbytes(void)
 	if (new_min_free_kbytes > user_min_free_kbytes)
 		min_free_kbytes = clamp(new_min_free_kbytes, 128, 262144);
 	else
-		pr_warn("min_free_kbytes is not updated to %d because user defined value %d is preferred\n",
-				new_min_free_kbytes, user_min_free_kbytes);
+		pr_warn_ratelimited("min_free_kbytes is not updated to %d because user defined value %d is preferred\n",
+				    new_min_free_kbytes, user_min_free_kbytes);
 
 }
 
_

Patches currently in -mm which might be from leitao@debian.org are

mm-khugepaged-export-set_recommended_min_free_kbytes.patch
mm-huge_memory-refactor-anon_enabled_store-with-change_anon_orders.patch
mm-huge_memory-refactor-enabled_store-with-change_enabled.patch
mm-ratelimit-min_free_kbytes-adjustment-messages.patch

