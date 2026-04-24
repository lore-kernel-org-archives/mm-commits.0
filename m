Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3B34F5E0
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 16:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777048712; cv=none; b=qlZUI187VIydvlA/X+k0NGLKvWzFq0aKSXQJ4bGGP9LiKixyTuxCGhbHJBDAoPyw7gbC6mzqGv3sGiheSFDnyNqyNRoUOWwJQ0CaV3MNkyzyQV9dmYAv1NIup8MmhVKLb0qUSEYTNqg/wHiaT/gzIis2XeeCJrhTp5IuG8DQK60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777048712; c=relaxed/simple;
	bh=OR6dU4aNkdcccTZIdOOhA8bGzMQBeCA8dHNwxdOzmjQ=;
	h=Date:To:From:Subject:Message-Id; b=N05LLUp0hIk3CefyGemNu3rEZWu+gBrxTVGUhF5onW4cGkQsBjyZ2UzkUDWseeXCSNiDrC+zabUrR9UG63MfG9HNShgJjpD/aPzpc1CGe6l2Kgkzt5P9uJ/3NvfJUwPazfGVR8F7vc0ms/VFDpxWu1ALr2NcIWOoxK6Y3YEHj/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lba9QTF7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lba9QTF7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7F6C19425;
	Fri, 24 Apr 2026 16:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777048711;
	bh=OR6dU4aNkdcccTZIdOOhA8bGzMQBeCA8dHNwxdOzmjQ=;
	h=Date:To:From:Subject:From;
	b=Lba9QTF7s2rjSeluLRIyAJdNiYCQ/zcAKY1vdvStn+tzBOFwS5L1fXJu14LKr+jfR
	 vSWOLNfgB0eFEvzG1gsAHZ08JKli8YB54PmJFRwvO8rOEvkuXfrlKHG59NteLOOq5b
	 /8AUV6iV5vi30E1V/VOI8x8EWZtZueXfID7MuooU=
Date: Fri, 24 Apr 2026 09:38:31 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,mingo@kernel.org,bvanassche@acm.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + clang-format-fix-formatting-of-guard-and-scoped_guard-statements.patch added to mm-nonmm-unstable branch
Message-Id: <20260424163831.DC7F6C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: clang-format: fix formatting of guard() and scoped_guard() statements
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     clang-format-fix-formatting-of-guard-and-scoped_guard-statements.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/clang-format-fix-formatting-of-guard-and-scoped_guard-statements.patch

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
From: Bart Van Assche <bvanassche@acm.org>
Subject: clang-format: fix formatting of guard() and scoped_guard() statements
Date: Mon, 13 Apr 2026 11:23:48 -0700

Without this patch clang-format formats guard() and scoped_guard()
statements as follows:

	guard(...)(...)
	{
		...
	}

With this patch clang-format formats guard() and scoped_guard()
statements as follows:

	guard(...)(...) {
		...
	}

Link: https://lore.kernel.org/20260413182348.1865138-1-bvanassche@acm.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .clang-format |    2 ++
 1 file changed, 2 insertions(+)

--- a/.clang-format~clang-format-fix-formatting-of-guard-and-scoped_guard-statements
+++ a/.clang-format
@@ -481,6 +481,7 @@ ForEachMacros:
   - 'genradix_for_each'
   - 'genradix_for_each_from'
   - 'genradix_for_each_reverse'
+  - 'guard'
   - 'hash_for_each'
   - 'hash_for_each_possible'
   - 'hash_for_each_possible_rcu'
@@ -674,6 +675,7 @@ ForEachMacros:
   - 'rq_list_for_each'
   - 'rq_list_for_each_safe'
   - 'sample_read_group__for_each'
+  - 'scoped_guard'
   - 'scsi_for_each_prot_sg'
   - 'scsi_for_each_sg'
   - 'sctp_for_each_hentry'
_

Patches currently in -mm which might be from bvanassche@acm.org are

clang-format-fix-formatting-of-guard-and-scoped_guard-statements.patch

