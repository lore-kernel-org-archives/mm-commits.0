Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D7D70821
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 01:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733794293; cv=none; b=AgW9xLeFyUxztX+PhfSmiup/oUt8S2abLffj4viaOSM2kd2DHMtDqzy8DnrKgSSXW4Ygf/ST4PYqSaMl+NsbsUYxswo3t9wwmXV+D+X57giq6tVk9ccZay2reF5Dkk8YLf/q6xcc8MNST5zpOlbCNHRaP6CGsUyB75sYxxOZc3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733794293; c=relaxed/simple;
	bh=d7fO5UZjlmYell09ZQ9qvpPeOwWtS/lK+8PV6M54YG8=;
	h=Date:To:From:Subject:Message-Id; b=PFNZoQcBNUsqorS5c7730yUPJmpS6oq5ruDMEJJe/fn3TgeOIvsVFdIhZPuJmW7++tyOg5+8YWNxhNKeeuvH2T/Xt3EZyHWeDXDsBJEXH4AwatAdd5g88WYmvEENRFuzlZUmS9Vs9hssF+mn+y1XeQxsGVP7UOBamh1s5HMa4CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M8oYtE2a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M8oYtE2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79FCC4CED1;
	Tue, 10 Dec 2024 01:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733794293;
	bh=d7fO5UZjlmYell09ZQ9qvpPeOwWtS/lK+8PV6M54YG8=;
	h=Date:To:From:Subject:From;
	b=M8oYtE2aVFdnIQTy0X9jUcZBQZhFLyjRlsBIgf1yr/dl2A8dV0MD4j1EMKENIyVH8
	 xEdpFgMq2kBSJHEc0F5fi0ZTKy2PaAdNCkGTVixsilJI/I5NrJxd8C++HUzbQDuVKd
	 TYm5TA6FpTmxFb9+7Y1U1aBpzl21Bgg/LFE6Ou8I=
Date: Mon, 09 Dec 2024 17:31:32 -0800
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,tamird@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-check-return-of-git_commit_info.patch added to mm-nonmm-unstable branch
Message-Id: <20241210013132.E79FCC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: check return of `git_commit_info`
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-check-return-of-git_commit_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-check-return-of-git_commit_info.patch

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
From: Tamir Duberstein <tamird@gmail.com>
Subject: checkpatch: check return of `git_commit_info`
Date: Wed, 04 Dec 2024 13:41:06 -0500

Avoid string concatenation with an undefined variable when a reference to
a missing commit is contained in a `Fixes` tag.

Given this patch:

: From: Tamir Duberstein <tamird@gmail.com>
: Subject: Test patch
: Date: Fri, 25 Oct 2024 19:30:51 -0400
:
: This is a test patch.
:
: Fixes: deadbeef111
: Signed-off-by: Tamir Duberstein <tamird@gmail.com>
: --- /dev/null
: +++ b/new-file
: @@ -0,0 +1 @@
: +Test.

Before:

WARNING: Please use correct Fixes: style 'Fixes: <12 chars of sha1> ("<title line>")' - ie: 'Fixes:  ("commit title")'
WARNING: Unknown commit id 'deadbeef111', maybe rebased or not pulled?
Use of uninitialized value $cid in concatenation (.) or string at scripts/checkpatch.pl line 3242.

After:

WARNING: Unknown commit id 'deadbeef111', maybe rebased or not pulled?

This patch also reduce duplication slightly.

Link: https://lkml.kernel.org/r/20241204-checkpatch-missing-commit-v1-1-68b34c94944e@gmail.com
Signed-off-by: Tamir Duberstein <tamird@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-check-return-of-git_commit_info
+++ a/scripts/checkpatch.pl
@@ -3237,12 +3237,12 @@ sub process {
 			my ($cid, $ctitle) = git_commit_info($orig_commit, $id,
 							     $title);
 
-			if ($ctitle ne $title || $tag_case || $tag_space ||
-			    $id_length || $id_case || !$title_has_quotes) {
+			if (defined($cid) && ($ctitle ne $title || $tag_case || $tag_space || $id_length || $id_case || !$title_has_quotes)) {
+				my $fixed = "Fixes: $cid (\"$ctitle\")";
 				if (WARN("BAD_FIXES_TAG",
-				     "Please use correct Fixes: style 'Fixes: <12 chars of sha1> (\"<title line>\")' - ie: 'Fixes: $cid (\"$ctitle\")'\n" . $herecurr) &&
+				     "Please use correct Fixes: style 'Fixes: <12 chars of sha1> (\"<title line>\")' - ie: '$fixed'\n" . $herecurr) &&
 				    $fix) {
-					$fixed[$fixlinenr] = "Fixes: $cid (\"$ctitle\")";
+					$fixed[$fixlinenr] = $fixed;
 				}
 			}
 		}
_

Patches currently in -mm which might be from tamird@gmail.com are

xarray-extract-xa_zero_to_null.patch
xarray-extract-helper-from-__xa_insertcmpxchg.patch
xarray-extract-helper-from-__xa_insertcmpxchg-fix.patch
xarray-port-tests-to-kunit.patch
checkpatch-check-return-of-git_commit_info.patch

