Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84901A01B9
	for <mm-commits@vger.kernel.org>; Thu, 10 Oct 2024 20:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728593832; cv=none; b=bMM3LaQUAZ6wX++jGxphI7sPYKEhCJQggvg0e7LhJbC5UKPnB5nnw1XAvvIJVzPr160Naw7mDjVwAeO+TmOKvtmyv/u3MNFhKgy26a4iIBH1WRXgOpsFU66RfvWDqxBRyGULCsCbTKht10VdK8n0EDFdWn3D72gW1OSyun81GMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728593832; c=relaxed/simple;
	bh=RdnnVeDJhz+4l2Am60DdCkwg0pKVxtclVMyLmW8y/0Y=;
	h=Date:To:From:Subject:Message-Id; b=hPA+tknM5fbiFVVbPjw7fESJ8rK1Rd2D1VzYK4Odik8WidZqsoIUUvz0vvnNmZqUXP80zMXzmLvnL8xlHxSiNJxF4HJPwdKfU9YeqhfUTy6NZEWSPyNDog6OiuNagwbCnXCkB1auNRuYxnJvrJ93sG6/1YeH/wwWzdaqm22WMV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NaTMlmD2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NaTMlmD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC34C4CEC5;
	Thu, 10 Oct 2024 20:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728593832;
	bh=RdnnVeDJhz+4l2Am60DdCkwg0pKVxtclVMyLmW8y/0Y=;
	h=Date:To:From:Subject:From;
	b=NaTMlmD2ZBzqxq/sTTflXSL924vdGJIFpEWXwK3iw8i+xvV05KoDGVDKJyX1QT2Tz
	 ndXaRTqNUPf2PC0rA3/neCD6j8qrYajJErMMDUahda1+6gfluOVeS891WOf054HqZw
	 Jl8v0n1sqAypomDCprThTIAwmPZKwd4h6TQhmmVg=
Date: Thu, 10 Oct 2024 13:57:11 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-fix-typo-in-object_no_scan-comment.patch added to mm-unstable branch
Message-Id: <20241010205712.3AC34C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     fix typo in object_no_scan() comment Date: Thu, 10 Oct 2024 18:54:39 +0300
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmemleak-fix-typo-in-object_no_scan-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-fix-typo-in-object_no_scan-comment.patch

This patch will later appear in the mm-unstable branch at
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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org> Subject: mm/kmemleak:
fix typo in object_no_scan() comment Date: Thu, 10 Oct 2024 18:54:39 +0300
Replace "corresponding to the give pointer" with "corresponding to the
given pointer"

Link: https://lkml.kernel.org/r/20241010155439.554416-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kmemleak.c~mm-kmemleak-fix-typo-in-object_no_scan-comment
+++ a/mm/kmemleak.c
@@ -1011,7 +1011,7 @@ static void object_set_excess_ref(unsign
 }
 
 /*
- * Set the OBJECT_NO_SCAN flag for the object corresponding to the give
+ * Set the OBJECT_NO_SCAN flag for the object corresponding to the given
  * pointer. Such object will not be scanned by kmemleak but references to it
  * are searched.
  */
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-vmalloc-group-declarations-depending-on-config_mmu-together.patch
mm-vmalloc-dont-account-for-number-of-nodes-for-huge_vmap-allocations.patch
asm-generic-introduce-text-patchingh.patch
module-prepare-to-handle-rox-allocations-for-text.patch
arch-introduce-set_direct_map_valid_noflush.patch
x86-module-perpare-module-loading-for-rox-allocations-of-text.patch
execmem-add-support-for-cache-of-large-rox-pages.patch
x86-module-enable-rox-caches-for-module-text.patch
mm-kmemleak-fix-typo-in-object_no_scan-comment.patch

