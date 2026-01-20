Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCC63491F4
	for <mm-commits@vger.kernel.org>; Tue, 20 Jan 2026 16:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768928092; cv=none; b=CV8OErpUvGM3Aj9f2mU1GkfCiP+ibKwDe+P8xVx9ARUoPpnMMX9eq52ZjWEW+jKouy9s5ECCijTwSaPMDdUv3rAkBoyg7TDNaRxhAJGKVPgBr6KjMl4AWBk0DgzLxYbmG90e2/yOEwQF6QhRk7a+fwIl551Cj/GykZ4IK+t0QYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768928092; c=relaxed/simple;
	bh=ttUe9rtL9EkfQ6af6RK/qlgvNoikuRPth2RiM6ORDN0=;
	h=Date:To:From:Subject:Message-Id; b=FDbJuhcO8l5fkIVAxFdLJTU70Fd3DSFc67F4aCa9YumHDvczhBkOOE9EGKc7INbgMjt8CiYQs/vthDdOxhmFe+RrN7oGiMKYjKE5tJowAnBX1w43sPVC02Fl3yT/ftWcLoDPEgI7CA6Thw3S6ETGAxuVI/xvDOuPsTrYzTS3Uqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=imFpIg3T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="imFpIg3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67548C16AAE;
	Tue, 20 Jan 2026 16:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768928091;
	bh=ttUe9rtL9EkfQ6af6RK/qlgvNoikuRPth2RiM6ORDN0=;
	h=Date:To:From:Subject:From;
	b=imFpIg3TYA50sRT/oBvJp02B/Mqj7pY2Ia3XzQ+fddb4zeC7S4RNFEx5psEDxf/Ef
	 gjcGnCngZOM0SvskOPJ+N0JEdh08IUtyq2ryWNidLpLdRk/rlJOY3JCPmDpGqHNOsD
	 fXv6udLSCIa5XldZPoKJ/q0GUkcEvnhjRX9Gp+MY=
Date: Tue, 20 Jan 2026 08:54:50 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,zenghongling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pagewalk-use-min-to-simplify-the-code.patch added to mm-new branch
Message-Id: <20260120165451.67548C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/pagewalk: use min() to simplify the code
has been added to the -mm mm-new branch.  Its filename is
     mm-pagewalk-use-min-to-simplify-the-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pagewalk-use-min-to-simplify-the-code.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: zenghongling <zenghongling@kylinos.cn>
Subject: mm/pagewalk: use min() to simplify the code
Date: Tue, 20 Jan 2026 17:49:32 +0800

Use the min() macro to simplify the function and improve its readability.

Link: https://lkml.kernel.org/r/20260120094932.183697-1-zenghongling@kylinos.cn
Signed-off-by: zenghongling <zenghongling@kylinos.cn>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hongling Zeng <zenghongling@kylinos.cn>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/pagewalk.c~mm-pagewalk-use-min-to-simplify-the-code
+++ a/mm/pagewalk.c
@@ -313,7 +313,7 @@ static unsigned long hugetlb_entry_end(s
 				       unsigned long end)
 {
 	unsigned long boundary = (addr & huge_page_mask(h)) + huge_page_size(h);
-	return boundary < end ? boundary : end;
+	return min(boundary, end);
 }
 
 static int walk_hugetlb_range(unsigned long addr, unsigned long end,
_

Patches currently in -mm which might be from zenghongling@kylinos.cn are

mm-pagewalk-use-min-to-simplify-the-code.patch

