Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99AF1F4180
	for <mm-commits@vger.kernel.org>; Mon,  5 Jan 2026 22:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767652795; cv=none; b=KhCjLewE/YbaHPhijIH/TPCSlkiHFyvLBXfTM3lkAYn01GHL7GxGLbiqvojObx5NPrM25XinVsRDLYklwMgDj6WmgU0hOsPqlix9o8HzTCWHrO7+Azzee2Xih4RB5k+fqu4PYCtCkV0/tIM+XUlhmvJRf7wBYVBT4y05a8kEnKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767652795; c=relaxed/simple;
	bh=OorB48cEKq1GPjhe6KTulifSZWXttP17icbie6+X+Vw=;
	h=Date:To:From:Subject:Message-Id; b=rKSdKBUzZsFDWRu0bdeD6g81sN1NJ8ddKGqcBAx0lJl2aqNlv17FVdp6UW1xefFKXiWFlRIvBWIy7jew4KUhtgdj9YIY0vTTLTK5RxlMZGW25zg5yAmutam3+C8VQYzzhHduFgYIbPi6XFiAwfNr1mgUjymx93ZeDbmhOVTSrRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=diT/7Q6S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="diT/7Q6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5944CC116D0;
	Mon,  5 Jan 2026 22:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767652795;
	bh=OorB48cEKq1GPjhe6KTulifSZWXttP17icbie6+X+Vw=;
	h=Date:To:From:Subject:From;
	b=diT/7Q6STnlWmJCVfn0Dfj5XhBeEY0jFMlN5YOJ7YUukkzgyo/n4XvWOdP0BEv+HP
	 Bs+YwWlX+gC/tNuqgn5uKPmwo6FgfHQg6seoKtrKNQFcXFrGg/cHMfOHRWl+haNYv2
	 ckYuMPrPUL5rXzJSfXzLVXmdontOkbAAuky4flGM=
Date: Mon, 05 Jan 2026 14:39:54 -0800
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + list-add-primitives-for-private-list-manipulations-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20260105223955.5944CC116D0@smtp.kernel.org>
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

