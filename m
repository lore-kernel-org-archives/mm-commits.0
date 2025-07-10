Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E38F17741
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127150; cv=none; b=K3Ya+KhrIFBAD7AXLkEQgA3hkwAEiiHWOWCgMU4SBon00SpnPjz/IFuVecZbdPPRo9t5rOGrkkIlQ6Sy08YrSayZZXr7AHRUpojfaX5bxiX5ozbrZ2D2giPu988k0+olacnZakyWAt0yogrl/dUxUKXgpfusjVJ0xxkqaAR5zjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127150; c=relaxed/simple;
	bh=r6tEmM4cHH3qV+NzliaTevO4A7m+PvEn3Y4zpcy0+hM=;
	h=Date:To:From:Subject:Message-Id; b=CkZbPsTNYAU48vgb4r1/Q/eynpt1jpR0QANBGkSfTSoThU/nVYfkJJBQinWutgv5Ws6+iGk6v3kEWcyn48p8kv6JxSrUVZna/mIlCozwgbKBEs5wCiEBrpEa4nTZuhrp6OuWiEYM4S+8mrX/Wgtr4cD9clA4EihXf0vCOgRlx24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hOhgnBVi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hOhgnBVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393D7C4CEE3;
	Thu, 10 Jul 2025 05:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127150;
	bh=r6tEmM4cHH3qV+NzliaTevO4A7m+PvEn3Y4zpcy0+hM=;
	h=Date:To:From:Subject:From;
	b=hOhgnBVitKN5Ow1V8oHjEMkDXtIYZWDUdZb7gwCthldOB2/6Fnb09wTgTkAneFcxW
	 jmJ1c1rCdR4VvqSUjlR7RH2MfqqjEtFlf1wHhrZQbyfIAJTZq/JW0heA8/jwKFHiWP
	 /t/THF6Cb6mtz8GW7dd63ZA1szt+Z8qa5Y2qJrqU=
Date: Wed, 09 Jul 2025 22:59:09 -0700
To: mm-commits@vger.kernel.org,git@elijahs.space,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-relay-use-__gfp_zero-in-relay_alloc_buf.patch removed from -mm tree
Message-Id: <20250710055910.393D7C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel: relay: use __GFP_ZERO in relay_alloc_buf
has been removed from the -mm tree.  Its filename was
     kernel-relay-use-__gfp_zero-in-relay_alloc_buf.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Elijah Wright <git@elijahs.space>
Subject: kernel: relay: use __GFP_ZERO in relay_alloc_buf
Date: Tue, 10 Jun 2025 15:56:28 -0700

Passing the __GFP_ZERO flag to alloc_page should result in less overhead
th= an using memset()

Link: https://lkml.kernel.org/r/20250610225639.314970-3-git@elijahs.space
Signed-off-by: Elijah Wright <git@elijahs.space>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/relay.c~kernel-relay-use-__gfp_zero-in-relay_alloc_buf
+++ a/kernel/relay.c
@@ -118,7 +118,7 @@ static void *relay_alloc_buf(struct rcha
 		return NULL;
 
 	for (i = 0; i < n_pages; i++) {
-		buf->page_array[i] = alloc_page(GFP_KERNEL);
+		buf->page_array[i] = alloc_page(GFP_KERNEL | __GFP_ZERO);
 		if (unlikely(!buf->page_array[i]))
 			goto depopulate;
 		set_page_private(buf->page_array[i], (unsigned long)buf);
@@ -127,7 +127,6 @@ static void *relay_alloc_buf(struct rcha
 	if (!mem)
 		goto depopulate;
 
-	memset(mem, 0, *size);
 	buf->page_count = n_pages;
 	return mem;
 
_

Patches currently in -mm which might be from git@elijahs.space are


