Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F9FEDE;
	Fri, 15 Nov 2024 00:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731629738; cv=none; b=lzIuWR6eiFn6T2ekwVPg6ctxCT4fBQ74ayfHrb/NdGKCqrhugyyoNSInM44AMAd/h9UKNZvXvETYRKBzL9mjIyz4c7GvlKs6Ypm4lk3MRpdku6q8L7K7FbIdM2LSAi5skX1URzA3n7O9W14Ked3xjYXp9jEAFblrva4KqZmru0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731629738; c=relaxed/simple;
	bh=qtIf/XvE2L7S0s4UzV1eT0s98Kdh4Y4vXKEKcAjaQ5k=;
	h=Date:To:From:Subject:Message-Id; b=ehR//YeIcA4KGcxiugNGxN/maB/0oR33sQH29NIJ3q2U2SFJaYiVSMShs6DS/Okq0ZJQFf5MiYbd3M485NW8wFbRievv8m/suqcjM/eCq0hHd2PrmLqvtyHwS7RzptnN34+rcnAntqRlXuhuAhk5qpbKkFyr3btysjAyUs3deEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gmt5sAud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gmt5sAud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A09AC4CECD;
	Fri, 15 Nov 2024 00:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731629738;
	bh=qtIf/XvE2L7S0s4UzV1eT0s98Kdh4Y4vXKEKcAjaQ5k=;
	h=Date:To:From:Subject:From;
	b=Gmt5sAudpb6F8rM7JHcVRdPEyuVvE+nkX5fQglE1BDipHmzxh0o+FYCFrhEq/A18h
	 4VW/4QO5iJx81QU11tezOp/dVny+J5sb64yx5jsO/lLW77Sieg7HZvzv8kLZQbwC8I
	 CQiDcNbBz+ZpqzcRv5Aj/t/Nn+cPflflb3VFqEbY=
Date: Thu, 14 Nov 2024 16:15:33 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,vbabka@suse.cz,sunnanyong@huawei.com,stable@vger.kernel.org,mgorman@techsingularity.net,david@redhat.com,alobakin@pm.me,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-null-pointer-dereference-in-alloc_pages_bulk_noprof.patch added to mm-hotfixes-unstable branch
Message-Id: <20241115001537.7A09AC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix NULL pointer dereference in alloc_pages_bulk_noprof
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-null-pointer-dereference-in-alloc_pages_bulk_noprof.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-null-pointer-dereference-in-alloc_pages_bulk_noprof.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm: fix NULL pointer dereference in alloc_pages_bulk_noprof
Date: Wed, 13 Nov 2024 16:32:35 +0800

We triggered a NULL pointer dereference for ac.preferred_zoneref->zone in
alloc_pages_bulk_noprof() when the task is migrated between cpusets.

When cpuset is enabled, in prepare_alloc_pages(), ac->nodemask may be
&current->mems_allowed.  when first_zones_zonelist() is called to find
preferred_zoneref, the ac->nodemask may be modified concurrently if the
task is migrated between different cpusets.  Assuming we have 2 NUMA Node,
when traversing Node1 in ac->zonelist, the nodemask is 2, and when
traversing Node2 in ac->zonelist, the nodemask is 1.  As a result, the
ac->preferred_zoneref points to NULL zone.

In alloc_pages_bulk_noprof(), for_each_zone_zonelist_nodemask() finds a
allowable zone and calls zonelist_node_idx(ac.preferred_zoneref), leading
to NULL pointer dereference.

__alloc_pages_noprof() fixes this issue by checking NULL pointer in commit
ea57485af8f4 ("mm, page_alloc: fix check for NULL preferred_zone") and
commit df76cee6bbeb ("mm, page_alloc: remove redundant checks from alloc
fastpath").

To fix it, check NULL pointer for preferred_zoneref->zone.

Link: https://lkml.kernel.org/r/20241113083235.166798-1-tujinjiang@huawei.com
Fixes: 387ba26fb1cb ("mm/page_alloc: add a bulk page allocator")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-fix-null-pointer-dereference-in-alloc_pages_bulk_noprof
+++ a/mm/page_alloc.c
@@ -4607,7 +4607,8 @@ unsigned long alloc_pages_bulk_noprof(gf
 	gfp = alloc_gfp;
 
 	/* Find an allowed local zone that meets the low watermark. */
-	for_each_zone_zonelist_nodemask(zone, z, ac.zonelist, ac.highest_zoneidx, ac.nodemask) {
+	z = ac.preferred_zoneref;
+	for_next_zone_zonelist_nodemask(zone, z, ac.highest_zoneidx, ac.nodemask) {
 		unsigned long mark;
 
 		if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-fix-null-pointer-dereference-in-alloc_pages_bulk_noprof.patch

