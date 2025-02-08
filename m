Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF198BEC
	for <mm-commits@vger.kernel.org>; Sat,  8 Feb 2025 03:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738983610; cv=none; b=EPri06zT3WWHbWtg1dul8q9cQ0mBs9psUZheFu1DoGbg+ySJMTN/AB+LFX5Ks44QbU4gUtrtjUsa3WBisWQF7wNK/EHYEy5dyBSib477GNTtapRKY1cdGGrWmr0GxFrqAFDrPZJCE/Rm0A9MUNEsxTbbAkl5FZNPaP+M9fEMWT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738983610; c=relaxed/simple;
	bh=SHBKg8UNT99GnSHgmPHLjOqC/m/oUAWDr12gWCvXZ+Y=;
	h=Date:To:From:Subject:Message-Id; b=olEn0uMwKhauI2/ofnolopXauoDH/2/sK5kd6czGmItT01DgQJu9vR5JJCqdLSf7+1+lqEAq1THLdS+4/ETVYxy+dsSFxWgX1yQzCZL/vA6oITp3kmQqC0d42Ig+LOyXc/uaUDCz33zwVau42jPqq4nfjChTRP/OZsvsUm8omOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=khB6jUef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="khB6jUef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FBAC4CED1;
	Sat,  8 Feb 2025 03:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738983609;
	bh=SHBKg8UNT99GnSHgmPHLjOqC/m/oUAWDr12gWCvXZ+Y=;
	h=Date:To:From:Subject:From;
	b=khB6jUef5EQA9wuWejncOkj7TDpAHB5gqJi6hpgvUYkDp3eAyzkcpNnR8HA+DtSEl
	 SaS87OUDDzEZRwhz2H1eWACv14006PoR018UDkdpC6KFr2tjjlAmq2ZYIAFHUlBZc8
	 XMsKOlUYi8njpKv/Coi4CPmvAAbqbRoyFux5XBRM=
Date: Fri, 07 Feb 2025 19:00:08 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-use-round_up-to-align-movable-range.patch added to mm-unstable branch
Message-Id: <20250208030009.83FBAC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init.c: use round_up() to align movable range
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-use-round_up-to-align-movable-range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-use-round_up-to-align-movable-range.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/mm_init.c: use round_up() to align movable range
Date: Fri, 7 Feb 2025 10:04:53 +0000

Since MAX_ORDER_NR_PAGES is power of 2, let's use a faster version.

Link: https://lkml.kernel.org/r/20250207100453.9989-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mm_init.c~mm-mm_initc-use-round_up-to-align-movable-range
+++ a/mm/mm_init.c
@@ -440,7 +440,7 @@ static void __init find_zone_movable_pfn
 		 * was requested by the user
 		 */
 		required_movablecore =
-			roundup(required_movablecore, MAX_ORDER_NR_PAGES);
+			round_up(required_movablecore, MAX_ORDER_NR_PAGES);
 		required_movablecore = min(totalpages, required_movablecore);
 		corepages = totalpages - required_movablecore;
 
@@ -551,7 +551,7 @@ out2:
 		unsigned long start_pfn, end_pfn;
 
 		zone_movable_pfn[nid] =
-			roundup(zone_movable_pfn[nid], MAX_ORDER_NR_PAGES);
+			round_up(zone_movable_pfn[nid], MAX_ORDER_NR_PAGES);
 
 		get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
 		if (zone_movable_pfn[nid] >= end_pfn)
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-mm_initc-use-round_up-to-align-movable-range.patch

