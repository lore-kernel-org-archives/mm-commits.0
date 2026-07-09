Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5262E1EE0
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 01:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783561410; cv=none; b=kO/6TTzbCTRzAingHAlNdIWtAOo//01T3/4qMgZAd66GYMKaIuUy15tnMkmAir1UkXWn9kmxCaDhdLkgvssy+CVM8Y7WTeumeqRenEP+bDWYDxaGsjR5ig1dlX1jvUr+T0yDboPi2Cc/PO7fxnHt4vYJ2N9hA6+Ldk4t9mYCNr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783561410; c=relaxed/simple;
	bh=H1V/b84+Bv7FL1vphhScfw/c0sVzqHU/MLYNBB0CRYQ=;
	h=Date:To:From:Subject:Message-Id; b=mr5sVz47kP/QWHsEWLhLdrsSSHMZ1hE5GWB45rZ9ZdhWoCvcIrgDZttj3OGHXxdlkYDBUA+ILP7BrEQDId2h4zGMqVwxrTqVpZg4no4p44YlLF0cph2dCbborMDJYovVF8OvhOGDKOYKeNEw3GtXgKmupYf84tNktLIkKY//C3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X9ib7Tq3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X9ib7Tq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1F61F000E9;
	Thu,  9 Jul 2026 01:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783561409;
	bh=oBSPFppv3VLNcPKWaNu21fZRBJwXJ2OGUU3DcFX0cdY=;
	h=Date:To:From:Subject;
	b=X9ib7Tq3Nbu8iDYxsPI0vq6lv+Gp0gP2N0uMC++Lyi8muQguPD1pAKQrTffsKGP+i
	 z3Fy/oaEA3hy9PAwbzlMNLKuvTgCjRkidFRSmr/gZsWYEIwJMWrYQbJRCX+2c772vG
	 LUixO8wJoT9XzfB5QAygWhIPyp5Vv97TKQq7CArQ=
Date: Wed, 08 Jul 2026 18:43:28 -0700
To: mm-commits@vger.kernel.org,zhen.ni@easystack.cn,corbet@lwn.net,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-document-page_owner-filter-fix.patch added to mm-unstable branch
Message-Id: <20260709014328.EC1F61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: avoid docs build warning
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_owner-document-page_owner-filter-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-document-page_owner-filter-fix.patch

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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/page_owner: avoid docs build warning
Date: Wed, 8 Jul 2026 14:35:48 -0700

Fix literal block and indentation to prevent a docs build warning:

Documentation/mm/page_owner.rst:70: WARNING: Literal block expected; none found. [docutils]

Link: https://lore.kernel.org/20260708213548.469155-1-rdunlap@infradead.org
Fixes: c34eea8cecca ("mm/page_owner: document page_owner filter")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Zhen Ni <zhen.ni@easystack.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/page_owner.rst |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/Documentation/mm/page_owner.rst~mm-page_owner-document-page_owner-filter-fix
+++ a/Documentation/mm/page_owner.rst
@@ -65,14 +65,15 @@ un-tracking state.
 Usage
 =====
 
-1) Build user-space helpers::
+1) Build user-space helpers:
+::
 
-To filter page_owner output:
+   To filter page_owner output:
 
 	cd tools/mm
 	make page_owner_filter
 
-To sort and analyze page_owner output:
+   To sort and analyze page_owner output:
 
 	cd tools/mm
 	make page_owner_sort
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-page_owner-document-page_owner-filter-fix.patch
radix-tree-add-correct-some-kernel-doc.patch

