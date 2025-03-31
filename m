Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C983DDBC
	for <mm-commits@vger.kernel.org>; Mon, 31 Mar 2025 21:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743457030; cv=none; b=GBO/3lBcrwaNuqFQ5+0NWRyZ691fqx4n8Wa5XTr/q5Nt9+j+xuOkgdBwqHRY+YokbjeeW1i1CBDk3Pd7zUDZB7K7qaL4vBiEnCmw41/Um3UtPFdGPmXnrOFps18XzEoAkNB5MQc+VM9M6TY7YvPL/eBWmLNwnKDeGHs267BNgio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743457030; c=relaxed/simple;
	bh=0lRUUAb7RRxAt+DATOH0ZNqhSg4Q/BJdI+FWzEZ7BAs=;
	h=Date:To:From:Subject:Message-Id; b=N+xPCRvgw6dTilftmXYqkcT3QmLaYNl9+WLoVHt6Bn4MyQaxSoHBguEhYkwRuqvw+D3FCCUlVHFEI+DDCp+UCd3FFW3gDDwygGn41/sxIi9k2EHrIj5GfQguD1phDDJuMnoEyK1awz9GSV9CD5ACibu71K0Rv/rVWx2t4bFnpHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vBktFsnv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vBktFsnv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A67C4CEE5;
	Mon, 31 Mar 2025 21:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743457030;
	bh=0lRUUAb7RRxAt+DATOH0ZNqhSg4Q/BJdI+FWzEZ7BAs=;
	h=Date:To:From:Subject:From;
	b=vBktFsnvLaGejffCv9la26E/Uvi8ccVhKzX7s5X9pGTeUrP99oTon91V8tk0iozn1
	 cb+tXaHh0fESI6+C7PFx8m7BcaJ9CEkHbNiUBy1ndXhdu1tifRXjIgpch2yT545+TS
	 3FRZZXTm+UDKvGtkcR83PsaytVmMUKMFConkaySw=
Date: Mon, 31 Mar 2025 14:37:09 -0700
To: mm-commits@vger.kernel.org,yanjun.zhu@linux.dev,x86@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable.patch added to mm-new branch
Message-Id: <20250331213709.E1A67C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: fix wrongly calculated returned value in fault_in_safe_writeable()
has been added to the -mm mm-new branch.  Its filename is
     mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable.patch

This patch will later appear in the mm-new branch at
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
From: Baoquan He <bhe@redhat.com>
Subject: mm/gup: fix wrongly calculated returned value in fault_in_safe_writeable()
Date: Mon, 31 Mar 2025 16:13:21 +0800

Patch series "mm/gup: Minor fix, cleanup and improvements", v2.

These were made when I explored code in mm/gup.c.


This patch (of 7):

Not like fault_in_readable() or fault_in_writeable(), in
fault_in_safe_writeable() local variable 'start' is increased page by page
to loop till the whole address range is handled.  However, it mistakenly
calcalates the size of handled range with 'uaddr - start'.

Fix it here.

Link: https://lkml.kernel.org/r/20250331081327.256412-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Yanjun.Zhu <yanjun.zhu@linux.dev>
Cc: <x86@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/gup.c~mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable
+++ a/mm/gup.c
@@ -2207,8 +2207,8 @@ size_t fault_in_safe_writeable(const cha
 	} while (start != end);
 	mmap_read_unlock(mm);
 
-	if (size > (unsigned long)uaddr - start)
-		return size - ((unsigned long)uaddr - start);
+	if (size > start - (unsigned long)uaddr)
+		return size - (start - (unsigned long)uaddr);
 	return 0;
 }
 EXPORT_SYMBOL(fault_in_safe_writeable);
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable.patch
mm-gup-check-if-both-gup_get-and-gup_pin-are-set-in-__get_user_pages-earlier.patch
mm-gup-fix-the-outdated-code-comments-above-get_user_pages_unlocked.patch
mm-gup-remove-gup_fast_pgd_leaf-and-clean-up-the-relevant-codes.patch
x86-mm-remove-pgd_leaf-definition-in-arch.patch
x86-mm-remove-p4d_leaf-definition.patch
mm-pgtable-remove-unneeded-pgd_devmap.patch

