Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F221332A1;
	Thu, 31 Oct 2024 03:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730344524; cv=none; b=KxSwpmsNVf3s4mpHUrArcO6HO7JlaRdnbE5OaYddFy/+RDxPaa7Y9+Bu9mfBqpIgBntz+gKbXWZgc/RK+jP5gz/WPY0OzQsmAOKSINrOl3KXJ6TQmaQ3f+KWNU69pRfTmV5GVT9cbcrwlBBjgekXsCR7VT7Bu+jWr4C7HlDYVBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730344524; c=relaxed/simple;
	bh=sfaaZhViEqPmu1EZO7qR302jyZRd6F7CmCe3iM/nTuw=;
	h=Date:To:From:Subject:Message-Id; b=C7q73kJ9eN8CSsGtq4f42PRnIJNxvHEQSDpebX5obom7Zt5mmpX2xbdA1Z+UD/Y4TmbMZXNiwOH7Sc3TT1OPjuRMQrRWNJd75UNVCb154xNX1vtCpeQ92CBPXkCfy3fEyLC6b/UmVh/C8Is323CGWOxAG0uDZovi8avnlJtTQT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xoTy5Acm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xoTy5Acm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7B2C4CECE;
	Thu, 31 Oct 2024 03:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730344523;
	bh=sfaaZhViEqPmu1EZO7qR302jyZRd6F7CmCe3iM/nTuw=;
	h=Date:To:From:Subject:From;
	b=xoTy5AcmrrXwcfENkuQqnqg1pFxTuZRU02v+VhN/Rub7eAcRqC/XzruuhtPA2LLLe
	 93BNeaBQV0iItuQ88gtSjikti1M5usT426aZbheE6FlCyDow8w3h3uqp+XrIe8a9Rl
	 tKE3qKSGEx1QfVwzAOakp7Xcpwd2siesgJzsi0Q8=
Date: Wed, 30 Oct 2024 20:15:23 -0700
To: mm-commits@vger.kernel.org,yang@os.amperecomputing.com,stable@vger.kernel.org,riel@surriel.com,regressions@leemhuis.info,ptesarik@suse.com,matz@suse.de,matthias@bodenbinder.de,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jannh@google.com,gabriel@krisman.be,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mmap-limit-thp-aligment-of-anonymous-mappings-to-pmd-aligned-sizes.patch removed from -mm tree
Message-Id: <20241031031523.CA7B2C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, mmap: limit THP alignment of anonymous mappings to PMD-aligned sizes
has been removed from the -mm tree.  Its filename was
     mm-mmap-limit-thp-aligment-of-anonymous-mappings-to-pmd-aligned-sizes.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, mmap: limit THP alignment of anonymous mappings to PMD-aligned sizes
Date: Thu, 24 Oct 2024 17:12:29 +0200

Since commit efa7df3e3bb5 ("mm: align larger anonymous mappings on THP
boundaries") a mmap() of anonymous memory without a specific address hint
and of at least PMD_SIZE will be aligned to PMD so that it can benefit
from a THP backing page.

However this change has been shown to regress some workloads
significantly.  [1] reports regressions in various spec benchmarks, with
up to 600% slowdown of the cactusBSSN benchmark on some platforms.  The
benchmark seems to create many mappings of 4632kB, which would have merged
to a large THP-backed area before commit efa7df3e3bb5 and now they are
fragmented to multiple areas each aligned to PMD boundary with gaps
between.  The regression then seems to be caused mainly due to the
benchmark's memory access pattern suffering from TLB or cache aliasing due
to the aligned boundaries of the individual areas.

Another known regression bisected to commit efa7df3e3bb5 is darktable [2]
[3] and early testing suggests this patch fixes the regression there as
well.

To fix the regression but still try to benefit from THP-friendly anonymous
mapping alignment, add a condition that the size of the mapping must be a
multiple of PMD size instead of at least PMD size.  In case of many
odd-sized mapping like the cactusBSSN creates, those will stop being
aligned and with gaps between, and instead naturally merge again.

Link: https://lkml.kernel.org/r/20241024151228.101841-2-vbabka@suse.cz
Fixes: efa7df3e3bb5 ("mm: align larger anonymous mappings on THP boundaries")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Michael Matz <matz@suse.de>
Debugged-by: Gabriel Krisman Bertazi <gabriel@krisman.be>
Closes: https://bugzilla.suse.com/show_bug.cgi?id=1229012 [1]
Reported-by: Matthias Bodenbinder <matthias@bodenbinder.de>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219366 [2]
Closes: https://lore.kernel.org/all/2050f0d4-57b0-481d-bab8-05e8d48fed0c@leemhuis.info/ [3]
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Yang Shi <yang@os.amperecomputing.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Petr Tesarik <ptesarik@suse.com>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/mmap.c~mm-mmap-limit-thp-aligment-of-anonymous-mappings-to-pmd-aligned-sizes
+++ a/mm/mmap.c
@@ -900,7 +900,8 @@ __get_unmapped_area(struct file *file, u
 
 	if (get_area) {
 		addr = get_area(file, addr, len, pgoff, flags);
-	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)
+		   && IS_ALIGNED(len, PMD_SIZE)) {
 		/* Ensures that larger anonymous mappings are THP aligned. */
 		addr = thp_get_unmapped_area_vmflags(file, addr, len,
 						     pgoff, flags, vm_flags);
_

Patches currently in -mm which might be from vbabka@suse.cz are


