Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3D31411DE
	for <mm-commits@vger.kernel.org>; Tue,  7 Jan 2025 02:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736216382; cv=none; b=qul3YgEPjk4tAeaTdbErjUhjRkomkRtuaji8oNaP6NK0nS/8ZPUe4DSVgTQCHFiOb08sufL1hDgsGQOjRfq0P6ouHrd84tPBrqD959i4bid6VuBQTQhWVSz5iBel4IYAMEDtPwvwmHkBFOeB4a8PuizHXh0x6MEoSWo2nhhLXDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736216382; c=relaxed/simple;
	bh=D5o9NmgDUG0RRFU0EaoNF1Dh5/phKT1h9/evbjR3hA4=;
	h=Date:To:From:Subject:Message-Id; b=cBtjacBbZPRdN68JlqJVvNBfxbHLD6XN1aSBhSoISPgTSIE9FhZHg7ZXbEaQAr+jzQ5PR87rzdBk19KnMnfFqOapavZtJJ4usPbC9h9N+SZMikWSERCXFMeORZ2FbxpxGW7W3Tgb8xRXyfrb5jJMlkMwd5XbCpFvyoNZSucBwq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b5mAyBfN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b5mAyBfN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358C6C4CEE5;
	Tue,  7 Jan 2025 02:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736216382;
	bh=D5o9NmgDUG0RRFU0EaoNF1Dh5/phKT1h9/evbjR3hA4=;
	h=Date:To:From:Subject:From;
	b=b5mAyBfNKRLSrG0a68PfccawXvlmYaMeLBAhmIJ0LXB8QRWvvo+yeCkmoljfZy3cl
	 HSjfqLPuOmTg3sP9kk2kOg76x9xgOImCm2mJkSn/70y2ro4XAmebEO6Lhc9vjOZJfT
	 Av2KQTRvEyMyz+KpvYGNMHlJrpIsB1IDWENik7sc=
Date: Mon, 06 Jan 2025 18:19:41 -0800
To: mm-commits@vger.kernel.org,tamird@gmail.com,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,corbet@lwn.net,apw@canonical.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-check-return-of-git_commit_info-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250107021942.358C6C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch-check-return-of-git_commit_info-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-check-return-of-git_commit_info-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-check-return-of-git_commit_info-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: checkpatch-check-return-of-git_commit_info-fix
Date: Mon Jan  6 06:16:23 PM PST 2025

s/12 chars of sha1/12+ chars of sha1/, per Jon

Link: https://lkml.kernel.org/r/87o70kt232.fsf@trenco.lwn.net
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Tamir Duberstein <tamird@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-check-return-of-git_commit_info-fix
+++ a/scripts/checkpatch.pl
@@ -3240,7 +3240,7 @@ sub process {
 			if (defined($cid) && ($ctitle ne $title || $tag_case || $tag_space || $id_length || $id_case || !$title_has_quotes)) {
 				my $fixed = "Fixes: $cid (\"$ctitle\")";
 				if (WARN("BAD_FIXES_TAG",
-				     "Please use correct Fixes: style 'Fixes: <12 chars of sha1> (\"<title line>\")' - ie: '$fixed'\n" . $herecurr) &&
+				     "Please use correct Fixes: style 'Fixes: <12+ chars of sha1> (\"<title line>\")' - ie: '$fixed'\n" . $herecurr) &&
 				    $fix) {
 					$fixed[$fixlinenr] = $fixed;
 				}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch
mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless-fix.patch
mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch
mm-huge_memoryc-rename-shadowed-local.patch
replace-free-hugepage-folios-after-migration-fix.patch
xarray-port-tests-to-kunit-fix.patch
checkpatch-check-return-of-git_commit_info-fix.patch
fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix.patch

