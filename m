Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071762080C8;
	Tue,  4 Nov 2025 01:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762219302; cv=none; b=WJsCfHqcWCxueg0qeTYoYEG1fjHdW6QbTXG7tw2Jz5K/q38LX954f/LujS5Zp7OWCwK/CDA18ns3CVZsSoinDoS9T6iBBIAUUQI6Au0uX1YcC/XTVTXv7E1yVOC+M9XQIEPtLZYh4H8pZ4jxya4/JrTI7IJgsvaGSGLWCyWQTx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762219302; c=relaxed/simple;
	bh=zYIr3Y1Qwn8E5cDTMEfflgtvikzLeEfiA7PbWL+Yz+Y=;
	h=Date:To:From:Subject:Message-Id; b=tbkk2lV6RNYoQSBERDa8ycSn0k1gbKWcndDYUaGrzVsSBuSIleDBaqxBSPzbD53If9fY663GwuY/5FdxtFUht1EnCni1UeoPQ9rDRYvWkLIgN4HLNxTfqKuvvwV5ko+ovSqPgrNGXyKyIzF6HEViPIzoZ3tvQTgobB5Sy1ZLIsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CNPRS2Lg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CNPRS2Lg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECD5C4CEE7;
	Tue,  4 Nov 2025 01:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762219301;
	bh=zYIr3Y1Qwn8E5cDTMEfflgtvikzLeEfiA7PbWL+Yz+Y=;
	h=Date:To:From:Subject:From;
	b=CNPRS2LgNphVgeHu6dKol8lVKZVSku4fJEd6lJKbhZzQFaEEYBD1ErynUWlmg8dNP
	 JyLsCBf58bIvbl9SC2VVtEB8qnvI0bKYoJKv68vCKEXh/AVvlnDpAQCeouaMej4pET
	 Iy9UQiBelBUeMn/Y9qJXpa6S+B1BHm+F2+3JtWkI=
Date: Mon, 03 Nov 2025 17:21:41 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,bhe@redhat.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-warn-and-exit-when-unpreserved-page-wasnt-preserved.patch added to mm-hotfixes-unstable branch
Message-Id: <20251104012141.BECD5C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: warn and exit when unpreserved page wasn't preserved
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kho-warn-and-exit-when-unpreserved-page-wasnt-preserved.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-warn-and-exit-when-unpreserved-page-wasnt-preserved.patch

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
From: Pratyush Yadav <pratyush@kernel.org>
Subject: kho: warn and exit when unpreserved page wasn't preserved
Date: Mon, 3 Nov 2025 19:02:32 +0100

Calling __kho_unpreserve() on a pair of (pfn, end_pfn) that wasn't
preserved is a bug.  Currently, if that is done, the physxa or bits can be
NULL.  This results in a soft lockup since a NULL physxa or bits results
in redoing the loop without ever making any progress.

Return when physxa or bits are not found, but WARN first to loudly
indicate invalid behaviour.

Link: https://lkml.kernel.org/r/20251103180235.71409-3-pratyush@kernel.org
Fixes: fc33e4b44b271 ("kexec: enable KHO support for memory preservation")
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/kexec_handover.c~kho-warn-and-exit-when-unpreserved-page-wasnt-preserved
+++ a/kernel/kexec_handover.c
@@ -171,12 +171,12 @@ static void __kho_unpreserve(struct kho_
 		const unsigned long pfn_high = pfn >> order;
 
 		physxa = xa_load(&track->orders, order);
-		if (!physxa)
-			continue;
+		if (WARN_ON_ONCE(!physxa))
+			return;
 
 		bits = xa_load(&physxa->phys_bits, pfn_high / PRESERVE_BITS);
-		if (!bits)
-			continue;
+		if (WARN_ON_ONCE(!bits))
+			return;
 
 		clear_bit(pfn_high % PRESERVE_BITS, bits->preserve);
 
_

Patches currently in -mm which might be from pratyush@kernel.org are

kho-fix-out-of-bounds-access-of-vmalloc-chunk.patch
kho-fix-unpreservation-of-higher-order-vmalloc-preservations.patch
kho-warn-and-exit-when-unpreserved-page-wasnt-preserved.patch

