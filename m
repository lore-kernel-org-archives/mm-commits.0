Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A802367B5
	for <mm-commits@vger.kernel.org>; Wed,  4 Feb 2026 19:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770231816; cv=none; b=i4arh+6vcNRhh4RQzOxXt/fXWpSNnf3D/tv+d09615z4m0Rg8b+EZXK+nDGx4UyRjzhDU4dP0pVQgWKbC6a8f/RwNN8NAmR3vnL8chfsGdZWSXdQle5DDDijlIF6taMqi32aXAP5rR6hnrtDr2w8GgHERkh6yOX1E8XBmZvKf14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770231816; c=relaxed/simple;
	bh=4KUokkhZQ5dLcVNcc5P779TdVCFyVhLmGjS/qhdiUTo=;
	h=Date:To:From:Subject:Message-Id; b=QfnDe/zuD6uV1zzAIPN2Dm/2qIqVkb20dQHYPs6jir99QzlgnU8hHYTu+7vHF9AsXoRhTsi2JMuEQ11Fhbs3TnD6QREZELna/2aO7ApN/L+roRwIWyBLpfJZxR5I9Brlkj4IatJXZRT3IH5TrtbvqkkqLBx32yHJNtfBvRYshE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=htgTJXYn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="htgTJXYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EC5C116C6;
	Wed,  4 Feb 2026 19:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770231816;
	bh=4KUokkhZQ5dLcVNcc5P779TdVCFyVhLmGjS/qhdiUTo=;
	h=Date:To:From:Subject:From;
	b=htgTJXYn5UbWBfDnXuql1d/Ki+6P1+7ksq4oQVAybNiHi7ViQtds32qklM5IPe/qd
	 kOI3DZt9Uuii8QNtr3i1P1Or0qP41LJD35A60l79OBAm2PzIGI7TNkGhqx6wcP2n7x
	 AoOznPPwURSuFvAqC6IS59EhRY+7thqSHlPhVpoY=
Date: Wed, 04 Feb 2026 11:03:35 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,sj@kernel.org,nphamcs@gmail.com,david@kernel.org,chandna.sahil@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-use-%pe-to-print-error-pointers.patch added to mm-unstable branch
Message-Id: <20260204190336.03EC5C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: use %pe to print error pointers
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-use-%pe-to-print-error-pointers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-use-%pe-to-print-error-pointers.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Sahil Chandna <chandna.sahil@gmail.com>
Subject: mm/zswap: use %pe to print error pointers
Date: Thu, 5 Feb 2026 00:24:08 +0530

Use the %pe printk format specifier to report error pointers directly
instead of printing PTR_ERR() as a long value.  This improves clarity,
produces more readable error messages.

This instance was flagged by the Coccinelle script
(misc/ptr_err_to_pe.cocci) as an opportunity to adopt %pe.

Found by: make coccicheck MODE=report M=mm/
No functional change intended.

Link: https://lkml.kernel.org/r/581a26f22fb4c6ce04aeb7ee0d703fe64454ac7f.1770230135.git.chandna.sahil@gmail.com
Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-use-%pe-to-print-error-pointers
+++ a/mm/zswap.c
@@ -749,8 +749,8 @@ static int zswap_cpu_comp_prepare(unsign
 
 	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
 	if (IS_ERR(acomp)) {
-		pr_err("could not alloc crypto acomp %s : %ld\n",
-				pool->tfm_name, PTR_ERR(acomp));
+		pr_err("could not alloc crypto acomp %s : %pe\n",
+				pool->tfm_name, acomp);
 		ret = PTR_ERR(acomp);
 		goto fail;
 	}
_

Patches currently in -mm which might be from chandna.sahil@gmail.com are

mm-vmscan-use-%pe-to-print-error-pointers.patch
mm-zswap-use-%pe-to-print-error-pointers.patch

