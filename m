Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B6031716C
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 14:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776953987; cv=none; b=cdMXR+4XRDPHihbMxJNKc7XLAXQJWN84FHlce28TuQd1BogrSVzTdpJYHgDYVoJbCll2RwsqLdafi7yljbzyrrgRhtWi2hAvU5Xq6Sn2KRGC5eyET51VYuABZQnZH9PsnHpxUTj7MqkoDKv/uyzZm+IRb3EbGpjdSz57uNjmS44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776953987; c=relaxed/simple;
	bh=4wgo+/kZJ+yqq4z2SAq53EfrzHdQqmavnrud/H9QrfU=;
	h=Date:To:From:Subject:Message-Id; b=jyeeoE9HU6B+vMtB812J3nnY/zoqapiCF6ubJ4X5Q5Uh8B55RM/PLTfgqlGGCuuT/IjQBWur9ex/N1BzEo1Q6DjZ4f0YVuSXkAwozQesARmA6yU1R003z1PbvBSbqW411desAs8Lswo+NMJyg1tQChZqDMMIYjNwpd9KWFrpjGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XfVm9vTg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XfVm9vTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02538C2BCAF;
	Thu, 23 Apr 2026 14:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776953987;
	bh=4wgo+/kZJ+yqq4z2SAq53EfrzHdQqmavnrud/H9QrfU=;
	h=Date:To:From:Subject:From;
	b=XfVm9vTgkSxDNvm4TWGadCY6YEfFNI+M7jK3GBmCSY8i93CX7VTOmF5jt4+OJTGo3
	 eFije+vLlCYbk++d5IedgVp8gLl9cb0yzHbqCWpgtdMwuQg7Ju5F4sU1ruVzGkXiBL
	 /uzfVndImAT7IU7SUUcwFoOO/kvcwgpjMXar/JTg=
Date: Thu, 23 Apr 2026 07:19:46 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20260423141947.02538C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free-fix
Date: Thu Apr 23 07:18:38 AM PDT 2026

s/__GPF_ZERO/__GFP_ZERO/, per David

Cc: "David Hildenbrand (Arm)" <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/gfp_types.h~mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free-fix
+++ a/include/linux/gfp_types.h
@@ -274,7 +274,7 @@ enum {
  * %__GFP_ZERO returns a zeroed page on success.
  *
  * %__GFP_ZEROTAGS zeroes memory tags at allocation time. Setting memory tags at
- * the same time as zeroing memory (e.g., with __GPF_ZERO) has minimal
+ * the same time as zeroing memory (e.g., with __GFP_ZERO) has minimal
  * additional performance impact. However, __GFP_ZEROTAGS also zeroes the tags
  * even if memory is not getting zeroed at allocation time (e.g.,
  * with init_on_free).
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free-fix.patch
proc-rewrite-next_tgid-fix.patch

