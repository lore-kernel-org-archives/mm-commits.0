Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74101DD0C9;
	Fri, 25 Oct 2024 23:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729899541; cv=none; b=WF6y5UNJHfg7x6K/w8HhQ1vCTNN6+GzXRWmlwb2pDXIXy7oBx7syNLBqXjJa/0FWAMxAkIuic6N/rZMUpkI3Io7wWlESJlaoiG9kDTnG6hdEnKyyYPohIHakNdFLtPIxI6WECHBgLH+twQVZ3yhYi+MdTeTC3lXFfTVoBtUVvok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729899541; c=relaxed/simple;
	bh=u9ACUQRhZbG23uyI+jfIQN0tCk/bmxxl/VQSY8/Yrtg=;
	h=Date:To:From:Subject:Message-Id; b=jTiZn/K2/Lt98muDesk1317zR4cY6s2/FAv3ye9HOcKYeMsXh0XAB1XmKvLgWgo3ZyNlx3/UPKSfPKvt4e5x0e0OpkqJl2qEmNDc8L5WPu/oF+1s7zA35gxiMvLKNTK4agcYRGYVpkYwgn+2Gsjn+T5jUJ38B57x31W336AsNGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1/4qwMUk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1/4qwMUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F0FC4CEC3;
	Fri, 25 Oct 2024 23:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729899541;
	bh=u9ACUQRhZbG23uyI+jfIQN0tCk/bmxxl/VQSY8/Yrtg=;
	h=Date:To:From:Subject:From;
	b=1/4qwMUkssdhsGzFdyrYnHAYCmLLLTwzurQHDkYNwd7XLQeXqXGxIYSm86P8VdfJ0
	 h4UsepuiI5NYlRuZa0WaT5d9xu2ijD06MjWYaclqAdxAkSQvgMvryFM3OFi+0y9MPf
	 aG97WIExlizN5xJ+DksNcJUDhHQlWDNUE4nSl+TM=
Date: Fri, 25 Oct 2024 16:39:00 -0700
To: mm-commits@vger.kernel.org,yang@os.amperecomputing.com,stable@vger.kernel.org,riel@surriel.com,regressions@leemhuis.info,ptesarik@suse.com,matz@suse.de,matthias@bodenbinder.de,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jannh@google.com,gabriel@krisman.be,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-limit-thp-aligment-of-anonymous-mappings-to-pmd-aligned-sizes.patch added to mm-hotfixes-unstable branch
Message-Id: <20241025233901.48F0FC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, mmap: limit THP aligment of anonymous mappings to PMD-aligned sizes
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mmap-limit-thp-aligment-of-anonymous-mappings-to-pmd-aligned-sizes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-limit-thp-aligment-of-anonymous-mappings-to-pmd-aligned-sizes.patch

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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, mmap: limit THP aligment of anonymous mappings to PMD-aligned sizes
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
Cc: Rik van Riel <riel@surriel.com>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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

mm-mmap-limit-thp-aligment-of-anonymous-mappings-to-pmd-aligned-sizes.patch

