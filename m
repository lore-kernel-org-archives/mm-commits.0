Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C6E3BBC1
	for <mm-commits@vger.kernel.org>; Thu, 13 Feb 2025 00:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739406752; cv=none; b=iRjoy2qTbhp5pexPTQS3ClHyrfEWlymSCKwOV+HZv0HWCPgljCmKzyCqznUc6xM21ub1qQl4rZXM2BWCSdjisBWOscWlNUxcZHvv8VRewTP/ECE6zcdG4BGzoW/Wx0pKFFda0xmBxZctKLFcH6MyFJgvcshzrsu8gGiBiGearbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739406752; c=relaxed/simple;
	bh=+f8udS+HA5tedYyXx6sBUBkrIEN/zfcG8u+ijaICIco=;
	h=Date:To:From:Subject:Message-Id; b=PpxmhqxGouU2iFdUG5Jf1NJbJ6WQZfx14KPjeuM3JNulWfskeWhQ+3lESaeJGcsHTcHHoxSQHpubkyjkR9eUpNZ1bazA/UzaGqqUxn24zte29+g83O+DoUfDnaJEtt3lMA0LtbRvzu656Z5B7QQdG1N5yurMsrGnhpWCITn2NkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FaKdUkiM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FaKdUkiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61A8C4CEDF;
	Thu, 13 Feb 2025 00:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739406751;
	bh=+f8udS+HA5tedYyXx6sBUBkrIEN/zfcG8u+ijaICIco=;
	h=Date:To:From:Subject:From;
	b=FaKdUkiMEaYe2bOEMB5jHGJZIvmPj+s1jMk2JffEEIME+rjlNcKQvQw2Aoel5YqMh
	 HL80paFW1MlG1D1OoBQIXGxWj5Ijiv8J5lagEoQe9BAkk2JOnJCX7fwtnP8MOO577S
	 Z1i0iMpixruvbjHOJXmRm4njBR4LhDqTmMF5Zomc=
Date: Wed, 12 Feb 2025 16:32:31 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xarray-add-xas_try_split-to-split-a-multi-index-entry-fix.patch added to mm-unstable branch
Message-Id: <20250213003231.D61A8C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: correct the function name
has been added to the -mm mm-unstable branch.  Its filename is
     xarray-add-xas_try_split-to-split-a-multi-index-entry-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-add-xas_try_split-to-split-a-multi-index-entry-fix.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: correct the function name
Date: Tue, 11 Feb 2025 20:48:55 -0500

Link: https://lkml.kernel.org/r/32DDC973-FAF8-48A8-831E-01E2ABA2966B@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_xarray.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_xarray.c~xarray-add-xas_try_split-to-split-a-multi-index-entry-fix
+++ a/lib/test_xarray.c
@@ -1868,7 +1868,7 @@ static void check_split_2(struct xarray
 	xa_set_mark(xa, index, XA_MARK_1);
 
 	xas_lock(&xas);
-	xas_try_halve(&xas, xa, order, GFP_KERNEL);
+	xas_try_split(&xas, xa, order, GFP_KERNEL);
 	if (((new_order / XA_CHUNK_SHIFT) < (order / XA_CHUNK_SHIFT)) &&
 	    new_order < order - 1) {
 		XA_BUG_ON(xa, !xas_error(&xas) || xas_error(&xas) != -EINVAL);
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-make-file-backed-thp-split-work-by-writing-pmd-size-data.patch
mm-huge_memory-allow-split-shmem-large-folio-to-any-lower-order.patch
selftests-mm-test-splitting-file-backed-thp-to-any-lower-order.patch
xarray-add-xas_try_split-to-split-a-multi-index-entry.patch
xarray-add-xas_try_split-to-split-a-multi-index-entry-fix.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split.patch
mm-huge_memory-move-folio-split-common-code-to-__folio_split.patch
mm-huge_memory-add-buddy-allocator-like-non-uniform-folio_split.patch
mm-huge_memory-remove-the-old-unused-__split_huge_page.patch
mm-huge_memory-add-folio_split-to-debugfs-testing-interface.patch
mm-truncate-use-buddy-allocator-like-folio-split-for-truncate-operation.patch
selftests-mm-add-tests-for-folio_split-buddy-allocator-like-split.patch

