Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE7113D8A4
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 02:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754964964; cv=none; b=McWnoHVoy/MSmJM0lGJ+Up9l6Nfp+JjQSnsHQUnKxe8BavPBQGmk4Uywa7FAzpQeSWELE9Vj2fPyjk5hbTrVKFXYfwz2bVkjG2eLogYTMAjbgVlLUA7ONAftzWXEza+xyzrI80GsP1MXmG98pCrkip9FUdGnxkVeBVCdhzvt+T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754964964; c=relaxed/simple;
	bh=tVeEZOdttkTNXg+mwauNfd4qwoJWyYZLkeEJ9UZpGWI=;
	h=Date:To:From:Subject:Message-Id; b=qr6S4yl+3tro85GU8LY7JTDI/VA7Pl35+fLP+a/K/8qFF1o22xHbpY8hpRvEGsbYxvYCJU+WiKJCEn5knJM+Fsn5DDR4aijiQrDadp29q1CmONQmerADGlvd653fgs7TZ9rQNJmu4H256eLS/ENGtcUggIkYLkdqqudQAgiwU6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FEtTUGN5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FEtTUGN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FA0C4CEED;
	Tue, 12 Aug 2025 02:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754964964;
	bh=tVeEZOdttkTNXg+mwauNfd4qwoJWyYZLkeEJ9UZpGWI=;
	h=Date:To:From:Subject:From;
	b=FEtTUGN5TyhRe1eYVOqjWqj2nzOoEV6Ts4ZwgA/APd1uw7ZBDIoWrPY7+0qzILkXE
	 1dRPakF2nyS8ZC1Tt9DbikWSIY1FH+5X8DzAUKLRFDQVAc4+B68MA5gCHhjSVgNynH
	 lYxbDl/eRN8uvJEwtVdbF2ajGuD5jrpqBgWoh8bs=
Date: Mon, 11 Aug 2025 19:16:03 -0700
To: mm-commits@vger.kernel.org,linux@treblig.org,joe@perches.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-allow-http-links-of-any-length-in-commit-logs.patch added to mm-nonmm-unstable branch
Message-Id: <20250812021604.17FA0C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: allow http links of any length in commit logs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-allow-http-links-of-any-length-in-commit-logs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-allow-http-links-of-any-length-in-commit-logs.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Joe Perches <joe@perches.com>
Subject: checkpatch: allow http links of any length in commit logs
Date: Sat, 09 Aug 2025 21:31:10 -0700

Dave Gilbert noticed that checkpatch warns about URL links over 75 chars
in length in commit logs.

Fix that.

Link: https://lkml.kernel.org/r/3529faaf84a5a9a96c5c0ec4183ae0ba6e97673c.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Dave Gilbert <linux@treblig.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-allow-http-links-of-any-length-in-commit-logs
+++ a/scripts/checkpatch.pl
@@ -3294,7 +3294,7 @@ sub process {
 					# file delta changes
 		      $line =~ /^\s*(?:[\w\.\-\+]*\/)++[\w\.\-\+]+:/ ||
 					# filename then :
-		      $line =~ /^\s*(?:Fixes:|$link_tags_search|$signature_tags)/i ||
+		      $line =~ /^\s*(?:Fixes:|https?:|$link_tags_search|$signature_tags)/i ||
 					# A Fixes:, link or signature tag line
 		      $commit_log_possible_stack_dump)) {
 			WARN("COMMIT_LOG_LONG_LINE",
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-allow-http-links-of-any-length-in-commit-logs.patch

