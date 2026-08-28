Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC42917BED0
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 03:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787888381; cv=none; b=h+H40QkHq14M4rNbX9ocRZ46Mbo4sL+8jqIuOUAwRjOBhtbtb517OLf+joawcpkGmVKyfIJtacFy3EsmbrHkYke+aFBoQBZsd4aDktLfULsRyfOIE7c2dDlZBP6bBZLJ0/h2X20/QNLLIeUEi8nNs30t1XVtVZXdZixffKHBS7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787888381; c=relaxed/simple;
	bh=XlrvjiLKjtq6TxcFwoT12RNLObiilQ1AaiziGtkAha8=;
	h=Date:To:From:Subject:Message-Id; b=TaVQy4uMsL7VdBbkMBQmSWLSyhIcBo1eeYoPaYSKm2gcQ0UyF6+LNrmbeYZ0yNHmoLjpBYm4Kl5iCVQv+LNeFpcKjwD9bABA7XMoDsLcBBpxd69voLvqKAjSc4WG2IWwlTz/Dq9HCQmBeTGciK5fDbgYTRb+xgp2Og4YgwPSbi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hhcf06cv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hhcf06cv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB9B1F00A3A;
	Fri, 28 Aug 2026 03:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787888380;
	bh=nOT2eCc6QsZIasoOoz4HP3ov7znJaGd0uQhYxfrHqP0=;
	h=Date:To:From:Subject;
	b=Hhcf06cvJiIfafqkhOXl+0CbkuVi9QDq+/GtzGQ/9298SXMTY31XYPy6UiMzeJewc
	 BZUjq07WhYnop/PwotN1tDCfdOXr/IKlyvhk6pTlg1RfVCtJX8VdVyDjP7wKot4b6v
	 pL3JC21xheBRePnX1RXO+6qh09ehQYQlJswMtgo0=
Date: Thu, 27 Aug 2026 20:39:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.arif@linux.dev,ljs@kernel.org,lance.yang@linux.dev,dev.jain@arm.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,anshumantewari123@gmail.com,akpm@linux-foundation.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-khugepaged-remove-str_dup-usage.patch added to mm-new branch
Message-Id: <20260828033940.1CB9B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: khugepaged: remove str_dup() usage
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-khugepaged-remove-str_dup-usage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-khugepaged-remove-str_dup-usage.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: selftests/mm: khugepaged: remove str_dup() usage
Date: Tue, 25 Aug 2026 13:20:59 +0200

We don't check str_dup() return value and never free it.  While both
things are irrelevant in practice, let's just clean it up by working on
argv[0] directly and avoiding the str_dup().

Nobody after us needs these parts of the argv[0] string anyway.

This patch is inspired by previous work from Anshuman Tewari [1].

Link: https://lore.kernel.org/r/20260821114416.12255-1-anshumantewari123@gmail.com [1]
Link: https://lore.kernel.org/20260825-remove_str_dup-v1-1-0ba2121a820c@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Anshuman Tewari <anshumantewari123@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-khugepaged-remove-str_dup-usage
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -1227,7 +1227,7 @@ static void parse_test_type(int argc, ch
 		return;
 	}
 
-	buf = strdup(argv[0]);
+	buf = argv[0];
 	token = strsep(&buf, ":");
 
 	if (!strcmp(token, "all")) {
_

Patches currently in -mm which might be from david@kernel.org are

selftests-mm-khugepaged-remove-str_dup-usage.patch

