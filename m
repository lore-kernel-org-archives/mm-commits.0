Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F305786C
	for <mm-commits@vger.kernel.org>; Tue, 16 Jan 2024 20:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705435773; cv=none; b=pLruKOI09nRnKt9Npjv5vabHINOLDzOnIKd4cJDLzIPZwryQ0p+gZl0TOMXxPcpI89qZcMqVBPIRhfSR4ewUoNoTruqQog8VJPOOnroiwuvZuQyB+uiqLseOXWXcPsDakV0l/6fXixm6BN+RUATlfBsdiPsSbTsvfrmyk7FnqcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705435773; c=relaxed/simple;
	bh=nhHI3vFlsM8hSt/fDAMSSWWvNH/HFJoFRr5FFCwJtKw=;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id; b=E6lkesh7m363tdmLvhVQshNhjoBwVV5x6+G+PJ38onyUamYw5c1fAUXB37/hqNYaVKMKelQjO/twIpW6y2WJsGAypfeUp2jtKKidbbxICXebzqITHMnkXrGAqa3Yl98yK5V3vl+ygSruaAegg9WFOedn4vM/dtEdTWaOPp8VW/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W56ra+wY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W56ra+wY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA97C433C7;
	Tue, 16 Jan 2024 20:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705435772;
	bh=nhHI3vFlsM8hSt/fDAMSSWWvNH/HFJoFRr5FFCwJtKw=;
	h=Date:To:From:Subject:From;
	b=W56ra+wYhAvmKqivIWp0okmkx2HbTole/EOPp6Xb2qsY1CfRfP/ZCf19MNb2j7Jk8
	 mQWSDQkstOKpKECRnvxxjL53lMelcncXRQi1Xfl36KoAs3slB+GK6RyXRPmSaFccCn
	 Q/HWBBA2MrKeQmHu0bNCKr1n53pHyJQxkxnu4EWo=
Date: Tue, 16 Jan 2024 12:09:29 -0800
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-sort-optimize-heapsort-for-equal-elements-in-sift-down-path.patch added to mm-nonmm-unstable branch
Message-Id: <20240116200932.3DA97C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/sort: optimize heapsort for equal elements in sift-down path
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-sort-optimize-heapsort-for-equal-elements-in-sift-down-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-sort-optimize-heapsort-for-equal-elements-in-sift-down-path.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib/sort: optimize heapsort for equal elements in sift-down path
Date: Sat, 13 Jan 2024 11:13:51 +0800

Patch series "lib/sort: Optimize the number of swaps and comparisons".

This patch series aims to optimize the heapsort algorithm, specifically
targeting a reduction in the number of swaps and comparisons required.


This patch (of 2):

Currently, when searching for the sift-down path and encountering equal
elements, the algorithm chooses the left child.  However, considering that
the height of the right subtree may be one less than that of the left
subtree, selecting the right child in such cases can potentially reduce
the number of comparisons and swaps.

For instance, when sorting an array of 10,000 identical elements, the
current implementation requires 247,209 comparisons.  With this patch, the
number of comparisons can be reduced to 227,241.

Link: https://lkml.kernel.org/r/20240113031352.2395118-1-visitorckw@gmail.com
Link: https://lkml.kernel.org/r/20240113031352.2395118-2-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/sort.c~lib-sort-optimize-heapsort-for-equal-elements-in-sift-down-path
+++ a/lib/sort.c
@@ -262,7 +262,7 @@ void sort_r(void *base, size_t num, size
 		 * average, 3/4 worst-case.)
 		 */
 		for (b = a; c = 2*b + size, (d = c + size) < n;)
-			b = do_cmp(base + c, base + d, cmp_func, priv) >= 0 ? c : d;
+			b = do_cmp(base + c, base + d, cmp_func, priv) > 0 ? c : d;
 		if (d == n)	/* Special case last leaf with no sibling */
 			b = c;
 
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-min_heap-optimize-number-of-calls-to-min_heapify.patch
lib-min_heap-optimize-number-of-comparisons-in-min_heapify.patch
lib-sort-optimize-heapsort-for-equal-elements-in-sift-down-path.patch
lib-sort-optimize-heapsort-with-double-pop-variation.patch

