Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2219728E3
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628222; cv=none; b=j9FXDhO8SK641Q9tSqs/NJ0p4pnO8M5RDZ2q1YquUAFkRW/roKspDO1sV91ET8nUMh3nOfCafFIKPgI6eHFjjzivxUVg8gcoUPGK/kdNWr6FzILRel9x1LTRmUp8Qo0IuwgKRzK4IDdJVeVRKsQ8qrWUUBo2JJOw6MRRqs4XE3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628222; c=relaxed/simple;
	bh=Spw6HV2P0lOXqO7DaIkxriT1CBgrEkt2z2cLQiIoDNU=;
	h=Date:To:From:Subject:Message-Id; b=eOkrsZLqzHTPHj3s2IWc0F4QVrtc1Lf9xd1OpuzE177REViSTbL0zqrDChhCGFYmv/3jZP3uNsJrTFswgw2qIiyO74s4O8YQ0num68n0/ClsKqdICRcdRcJRXCTJPwADliiGK5icN55MoWADjeCQWLN/apj/82kMN1hMZdBif6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oupux2BK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oupux2BK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E168FC32781;
	Sat, 29 Jun 2024 02:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628222;
	bh=Spw6HV2P0lOXqO7DaIkxriT1CBgrEkt2z2cLQiIoDNU=;
	h=Date:To:From:Subject:From;
	b=oupux2BKeU5q8hvz6VrWuG9LIEWcW/INSJ/0Ek4cg6Hr6LFWjfJ0m+8KNh1hHuD4M
	 zrAwQgfn49tApg8ov89iDd+WPenNk/epbX48McBmG2XJfLwCNWL82BZ35JlNZGGmBn
	 +teBU1dY4+e/zCZiIq0SUqA5aF+lhaVe1mVpamAo=
Date: Fri, 28 Jun 2024 19:30:21 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-nr_pages-wont-be-0.patch removed from -mm tree
Message-Id: <20240629023021.E168FC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse: nr_pages won't be 0
has been removed from the -mm tree.  Its filename was
     mm-sparse-nr_pages-wont-be-0.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/sparse: nr_pages won't be 0
Date: Wed, 19 Jun 2024 01:06:09 +0000

Function subsection_map_init() is only used in free_area_init() in the
loop of for_each_mem_pfn_range().  And we are sure in each iteration of
for_each_mem_pfn_range(), start_pfn < end_pfn.

So nr_pages is not possible to be 0 and we can remove the check.

Link: https://lkml.kernel.org/r/20240619010612.20740-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/sparse.c~mm-sparse-nr_pages-wont-be-0
+++ a/mm/sparse.c
@@ -195,9 +195,6 @@ void __init subsection_map_init(unsigned
 	int end_sec_nr = pfn_to_section_nr(pfn + nr_pages - 1);
 	unsigned long nr, start_sec_nr = pfn_to_section_nr(pfn);
 
-	if (!nr_pages)
-		return;
-
 	for (nr = start_sec_nr; nr <= end_sec_nr; nr++) {
 		struct mem_section *ms;
 		unsigned long pfns;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


