Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57203271823
	for <mm-commits@vger.kernel.org>; Thu, 13 Feb 2025 00:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739406694; cv=none; b=mbJXIv2q2z81nxCZ1pTDogdQION0JJWmT5JJh1H0KJ3LH1FqphbW7JEbmucAIkZi2fXE96TVf3a1FM1QkrkBi2rY2cJLjdilenefEHlgMDSblx4xKLbB9F+a3ccZmChUrX5MBlY4GbDQOeubBFFlZGi2+PiipNrWbDrP5V6TRmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739406694; c=relaxed/simple;
	bh=ZQgQL4o0NbH7VIAByt36ucaOKMHYJrx1sfap+OYzxs0=;
	h=Date:To:From:Subject:Message-Id; b=GZtxYa7H+4pRiDTbo4I2F5KK93qEGF1jOo9ZilGBQUdvS3IJ6lJkbLGEtOF7ifbbV2Y5FhSduJLEswPDXB0C7qe4f/VRe+T/8TWWBSWT/6TniqTzFUz9HXY42+iBNnVGdVYSNSDfkO4ysmVuln2xkHhy54tTqpskVl8nLGi3MTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tvOntQ4k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tvOntQ4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97989C4CEDF;
	Thu, 13 Feb 2025 00:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739406693;
	bh=ZQgQL4o0NbH7VIAByt36ucaOKMHYJrx1sfap+OYzxs0=;
	h=Date:To:From:Subject:From;
	b=tvOntQ4kVzQ9TDXv0Ht68fMeDLdhunC9HYwp8zNIN/XztFUicqINdmpIlbC2ZIBpa
	 2Y++O4vAl+eH3AA6N+PLG8OUz58RSpqbBqjMwLzGSxie1KypFJ7MJF7J9mnmgKX/3X
	 w6vF19LgtSQ+oFwVyO+Nq9YwmgYuw5mu+b+nTQ/k=
Date: Wed, 12 Feb 2025 16:31:32 -0800
To: mm-commits@vger.kernel.org,shivankg@amd.com,rppt@kernel.org,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-use-round_up-to-calculate-usermap-size.patch added to mm-unstable branch
Message-Id: <20250213003133.97989C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init.c: use round_up() to calculate usermap size
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-use-round_up-to-calculate-usermap-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-use-round_up-to-calculate-usermap-size.patch

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
Subject: mm/mm_init.c: use round_up() to calculate usermap size
Date: Wed, 12 Feb 2025 01:38:18 +0000

Since pageblock_nr_pages and BITS_PER_LONG are power of 2, we could use
round_up() to calculate it.

Also we have renamed blockflags to pageblock_flags, adjust the comment
accordingly.

Link: https://lkml.kernel.org/r/20250212013818.873-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Suggested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/mm_init.c~mm-mm_initc-use-round_up-to-calculate-usermap-size
+++ a/mm/mm_init.c
@@ -1450,7 +1450,7 @@ void __meminit init_currently_empty_zone
 
 #ifndef CONFIG_SPARSEMEM
 /*
- * Calculate the size of the zone->blockflags rounded to an unsigned long
+ * Calculate the size of the zone->pageblock_flags rounded to an unsigned long
  * Start by making sure zonesize is a multiple of pageblock_order by rounding
  * up. Then use 1 NR_PAGEBLOCK_BITS worth of bits per pageblock, finally
  * round what is now in bits to nearest long in bits, then return it in
@@ -1461,10 +1461,10 @@ static unsigned long __init usemap_size(
 	unsigned long usemapsize;
 
 	zonesize += zone_start_pfn & (pageblock_nr_pages-1);
-	usemapsize = roundup(zonesize, pageblock_nr_pages);
+	usemapsize = round_up(zonesize, pageblock_nr_pages);
 	usemapsize = usemapsize >> pageblock_order;
 	usemapsize *= NR_PAGEBLOCK_BITS;
-	usemapsize = roundup(usemapsize, BITS_PER_LONG);
+	usemapsize = round_up(usemapsize, BITS_PER_LONG);
 
 	return usemapsize / BITS_PER_BYTE;
 }
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-mm_initc-use-round_up-to-align-movable-range.patch
mm-mm_initc-only-align-start-of-zone_movalbe-on-nodes-with-memory.patch
mm-mm_initc-use-round_up-to-calculate-usermap-size.patch

