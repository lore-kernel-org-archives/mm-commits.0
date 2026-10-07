Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FA9320A14
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334358; cv=none; b=PHmRH0VVBIw3YsNzdLitLFtLcX8pK8JKH5v6pbaEesm23WNxjx1/JCVL9gzvWGeGGim2gQneV5tfs81GC5nnMU44eWCX+ur5YaEUSgTLtAanzkw7AnjgbQ7XILkMSpfFmPrM1Sb8MAd4Fmn1Wr/JEwt59lVB798yxpHhQ6ruU0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334358; c=relaxed/simple;
	bh=qcmcSOS8pxhbJlB+G1Pw2FEGckqFnRjazxMSgbc0TI0=;
	h=Date:To:From:Subject:Message-Id; b=BIbC4kcaK+bBKLz2AX0e0tMr3ru3R/mNxay150B5YHs0aHrisWkPBGUIcaZi0Cp/bUkvBQYwriZ9SgJKUjZrN32TxHx6xLZUfBK2r7y2jtFv58cBYmJyDUS/lq/1ryJtH/+dEzW3zIMOYwISQg/RxEogzBWII18zLGLHiFMFNT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JhZ8cnwh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JhZ8cnwh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907731F0089B;
	Wed,  7 Oct 2026 00:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334357;
	bh=FawfV3uCJ5vNXDSqtIJN0rPRVlaH4iPFPwpklcWVyKA=;
	h=Date:To:From:Subject;
	b=JhZ8cnwhz0it53Hx0pBIyrDbVE5xc9oPCR0F7hmOpXJmauscEiNzxFI9uYHyCEhsF
	 ZFmECVRv4HkbPRltPRZRKGOQpe4RWfyUHT8GfNQXHS7ZPw9kgrLxhFIltebJwBxjcN
	 B3jxTR3yex4wX4v8zpg43MC/wkyCQoE6BaeBXwxY=
Date: Tue, 06 Oct 2026 17:52:37 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@linux.com,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] percpu-remove-redundant-assignments-to-bits.patch removed from -mm tree
Message-Id: <20261007005237.907731F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: percpu: remove redundant assignments to bits
has been removed from the -mm tree.  Its filename was
     percpu-remove-redundant-assignments-to-bits.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: percpu: remove redundant assignments to bits
Date: Wed, 2 Sep 2026 01:53:01 +0900

Patch series "percpu: remove code with no effect".

While reading the percpu initialization path, I found some minor
cleanups for unnecessary initializations and an obsolete return
statement.

No functional change.


This patch (of 4):

pcpu_chunk_refresh_hint() and pcpu_find_block_fit() set bits to 0 and
later call pcpu_next_md_free_region() or pcpu_next_fit_region(), which
unconditionally set *bits to 0.  Nothing uses it in between, so the
assignments have no effect.

Remove redundant assignments.

No functional change.

Link: https://lore.kernel.org/20260901165307.1026248-1-ekffu200098@gmail.com
Link: https://lore.kernel.org/20260901165307.1026248-2-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
---

 mm/percpu.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/percpu.c~percpu-remove-redundant-assignments-to-bits
+++ a/mm/percpu.c
@@ -758,7 +758,6 @@ static void pcpu_chunk_refresh_hint(stru
 		chunk_md->contig_hint = 0;
 	}
 
-	bits = 0;
 	pcpu_for_each_md_free_region(chunk, bit_off, bits)
 		pcpu_block_update(chunk_md, bit_off, bit_off + bits);
 }
@@ -1122,7 +1121,6 @@ static int pcpu_find_block_fit(struct pc
 		return -1;
 
 	bit_off = pcpu_next_hint(chunk_md, alloc_bits);
-	bits = 0;
 	pcpu_for_each_fit_region(chunk, alloc_bits, align, bit_off, bits) {
 		if (!pop_only || pcpu_is_populated(chunk, bit_off, bits,
 						   &next_off))
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-swapops-remove-unused-is_hwpoison_entry.patch
bootconfig-remove-redundant-assignment-in-xbc_parse_array.patch
init-mainc-remove-unreachable-check-in-obsolete_checksetup.patch

