Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DEFEACE
	for <mm-commits@vger.kernel.org>; Sat, 15 Feb 2025 02:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739588165; cv=none; b=cNSRwcKGE7NssnR3KCqpJuabDE/16JaaKxuR3Tj8t4vrapdte6NlL7tnxR+cQadpCp1setWJt9oH1o2vDK6i7GOeZlA1a2m4ZUu2e31pEb54Vij19Ilb0o+dGm/HZOjvVYi4dqaIQA0G+i96ObmZOjccSEyyH8Hclwp0msMq0js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739588165; c=relaxed/simple;
	bh=8k1zczGG4B+x/DcscHQVUAUu6wb56w3UnysJ5lD3JpY=;
	h=Date:To:From:Subject:Message-Id; b=u541jzoDOaEPtKalhDCyvVJfDobMPhkuJi0+wg4oNy0NF8Cs70qmxOLpy6ftkByAgpasmxvSPOTTb0VblK5RMAp/3A2uK6WiMuFSW3XyvWpgBcD/HqgaFYXOpadz+bBsatU7ZO7jLy3koxR/ZWs/qjpGIuLRghNHYy7SWxJIyoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OEAa+5jx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OEAa+5jx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6938BC4CED1;
	Sat, 15 Feb 2025 02:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739588164;
	bh=8k1zczGG4B+x/DcscHQVUAUu6wb56w3UnysJ5lD3JpY=;
	h=Date:To:From:Subject:From;
	b=OEAa+5jxOrVTGtbsW4mSswlRDVVB5mXkUfLwpNKFc5WBbgwOrfSSRZT/eJzC8BcKG
	 mcdsofoCKet2EoYIj5xuuvYGbwydG9s+/MGWXZwunV10wrXAC2I+kDkqTHTl7yLchT
	 bi4Xt04K02Osthf/P2fOzXZr4yyN2hbbo4kPakd8=
Date: Fri, 14 Feb 2025 18:56:03 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix-checkpatch-fixes.patch added to mm-unstable branch
Message-Id: <20250215025604.6938BC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix-checkpatch-fixes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix-checkpatch-fixes.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix-checkpatch-fixes
Date: Fri Feb 14 06:55:35 PM PST 2025

ERROR: trailing whitespace
#90: FILE: mm/huge_memory.c:3654:
+^I^I^I$

total: 1 errors, 0 warnings, 57 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix-checkpatch-fixes
+++ a/mm/huge_memory.c
@@ -3651,7 +3651,7 @@ after_split:
 
 			if (release == origin_folio)
 				continue;
-			
+
 			lru_add_page_tail(origin_folio, &release->page,
 						lruvec, list);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix-checkpatch-fixes.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch

