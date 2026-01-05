Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7E4236A8B
	for <mm-commits@vger.kernel.org>; Mon,  5 Jan 2026 22:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767652689; cv=none; b=sPksyJkF1//2kbmBXnd8aSJTYFC1MtVWWYiOu2THe1+vuacPqaG0xVxDgWmbXeE+TYG6F7yk6nks3QeCWzVg+LfHvEcF3OY930B1ohCO+AUedlLP4iUw+IJNiJqA/fUf6qiVYiFCQcT95sdnXSAFDj3HYLA/PkDebtSla4mebe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767652689; c=relaxed/simple;
	bh=OorB48cEKq1GPjhe6KTulifSZWXttP17icbie6+X+Vw=;
	h=Date:To:From:Subject:Message-Id; b=I0CewGKthafOpK9CkuCbRF2bKnsofetXY65K/A0jsxqczceMdB/Apihs7X9OonFBZ6bbM7+bnSKXAHFMzZcQdv1O2uPdH9rq5NCxEocc5QFkCErfsutnj9hX2EoXnvl2iR0a4QaUBF/765pKp4imwvVXhWhu+ifXNWos0Iwceaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IY06sQDF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IY06sQDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4466FC116D0;
	Mon,  5 Jan 2026 22:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767652688;
	bh=OorB48cEKq1GPjhe6KTulifSZWXttP17icbie6+X+Vw=;
	h=Date:To:From:Subject:From;
	b=IY06sQDFxlsw0FmQab3Fx5g/6iR3zpdwm4kbPAaMrUmTXb2kH3g3/oqZpCetuo8AW
	 51+a4y2yGuuYOlk0EUOnT9NgK/IEY0sTV4PNfe6kJSGiaciqsORAglDSuqezFvCWky
	 9pRNqQLMd17fNnh2zKBEoKawBN3nJWRmHYHiGfVM=
Date: Mon, 05 Jan 2026 14:38:07 -0800
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + list-add-primitives-for-private-list-manipulations-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20260105223808.4466FC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: list-add-primitives-for-private-list-manipulations-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     list-add-primitives-for-private-list-manipulations-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/list-add-primitives-for-private-list-manipulations-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: list-add-primitives-for-private-list-manipulations-fix
Date: Mon Jan  5 02:36:38 PM PST 2026

fix kerneldoc

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lkml.kernel.org/r/20260105160459.013ffb1e@canb.auug.org.au
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_private.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/list_private.h~list-add-primitives-for-private-list-manipulations-fix
+++ a/include/linux/list_private.h
@@ -81,7 +81,7 @@
 	list_private_entry(ACCESS_PRIVATE(pos, member).prev, typeof(*(pos)), member)
 
 /**
- * list_prev_entry_circular - get the prev element in list
+ * list_private_prev_entry_circular - get the prev element in list
  * @pos:	the type * to cursor.
  * @head:	the list head to take the element from.
  * @member:	the name of the list_head within the struct.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free-fix.patch
mm-add-basic-tests-for-lazy_mmu-fix.patch
mm-vmscanc-shrink_folio_list-save-a-tabstop.patch
mm-block-fs-remove-laptop_mode-fix.patch
mm-fix-minor-spelling-mistakes-in-comments-fix.patch
list-add-primitives-for-private-list-manipulations-fix.patch

