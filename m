Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000084C7C
	for <mm-commits@vger.kernel.org>; Fri, 25 Apr 2025 00:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745540461; cv=none; b=RYkQPDsSwQYHxRp/Jyht22quTE/o+WpkI1hLk4DxQdPTKKtHo9e3fJvqcI+diUQFLOV1La8x11pJS70lt7Du//+W1cEhEUOLXwhxOTyEsFlRzGAQgRCX0vzjxy33N956oNYlhfXiV1jWUUnvL4bhLklo24p8gKmgydmR9kTrydE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745540461; c=relaxed/simple;
	bh=gKZxxcAuBZjb0S7eDQhHBEJ5gJsKBEz0UvhG1xZFuGI=;
	h=Date:To:From:Subject:Message-Id; b=htxhwdq43dDvnVCXXW0VG3DbMCB16y0R2Z0EAlD3Vgy24f1hTeaML0wUwqgyNVRmeM+NROnINqRkY6DMRshP4tVHZ0BMfxAu1THB+IJOAh1EoBUYnJMAGMCBK9D1XUlfRLV5eEUzaq0vJLxRKxL7L1ptuZWOwLuacFkJtAfa0UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ljGFPGfe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ljGFPGfe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A294C4CEE3;
	Fri, 25 Apr 2025 00:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745540460;
	bh=gKZxxcAuBZjb0S7eDQhHBEJ5gJsKBEz0UvhG1xZFuGI=;
	h=Date:To:From:Subject:From;
	b=ljGFPGfes3NRiMpNqI3w4G5Bhy22vI9jP9cAvkst2eEwTSCMc2h+nFaGTstkevoNz
	 kH+4iSZGEj64hMHeHqdMr329rJNU544i8XDBR3dOGBGjI0J3ToSKDd6k4sfdlUzzvH
	 VdsDHd9g8LrgsK5kNVQWAzAM7cujdai9SpMAi8Cs=
Date: Thu, 24 Apr 2025 17:20:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,ryan.roberts@arm.com,npache@redhat.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-mm-thp-section-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20250425002100.5A294C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add Dev Jain as THP reviewer
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-mm-thp-section-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-mm-thp-section-fix.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add Dev Jain as THP reviewer
Date: Thu, 24 Apr 2025 12:33:35 +0100

Link: https://lkml.kernel.org/r/327e6f2f-0f0f-48af-9ca2-3f8cadf0d8bf@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-mm-thp-section-fix
+++ a/MAINTAINERS
@@ -15582,6 +15582,7 @@ R:	Lorenzo Stoakes <lorenzo.stoakes@orac
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
 R:	Nico Pache <npache@redhat.com>
 R:	Ryan Roberts <ryan.roberts@arm.com>
+R:	Dev Jain <dev.jain@arm.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-reverse-mapping-section.patch
maintainers-add-core-mm-section.patch
maintainers-add-mm-thp-section.patch
maintainers-add-mm-thp-section-fix.patch
mm-vma-fix-incorrectly-disallowed-anonymous-vma-merges.patch
tools-testing-add-procmap_query-helper-functions-in-mm-self-tests.patch
tools-testing-selftests-assert-that-anon-merge-cases-behave-as-expected.patch
mm-move-mmap-vma-locking-logic-into-specific-files.patch

