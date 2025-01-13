Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9E225761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742148; cv=none; b=RCnlc3JaFKeTKyIc/4RvuT75xUTNhUnE7IiWe4SbsEmP9BzCTh6C6Tq2JfBBD+XW7gYIlUYB33HopC1w6yqgoPXrUQK0ky4ytymJdMfrvRxmdBw3ty9yQNf2tDPzda1pfG6NphcrKXlW0p7ck3g8t3sZaP6OR0U6TXoliB8Y08E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742148; c=relaxed/simple;
	bh=pwcmdz3avgJulbUHLflT0s/ucHeD91gjkCbxGBL8m50=;
	h=Date:To:From:Subject:Message-Id; b=D4XoYlBLuV7TyH0il7wuKk80FzFLWfKMcH9OHDpZycKYs3Dh2W/IxlkwoODp8egEoYfGCVNXtMgNeZ4CrmJk+vJ/wuXnTO2cb+LuwhdrtG9OaGsAxetLlky7Xqs259dGMJ5zVuUfGNs79m6OiY/TDdGZ7zQvsJr7F15+DDdjTdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cNPrZ5R3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cNPrZ5R3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A0CC4CED6;
	Mon, 13 Jan 2025 04:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742148;
	bh=pwcmdz3avgJulbUHLflT0s/ucHeD91gjkCbxGBL8m50=;
	h=Date:To:From:Subject:From;
	b=cNPrZ5R3hyyl/99TWZl57hgguJamO7S9K+SPZ0VQYstHhG29tK7u7o5G8rV05Gc+F
	 txX8emk1Fh4gpUCAmhrgy9ZC6Th0Gh46eLEQrkBir+x+KYLZIaPM3YvYZxMk46XEh7
	 9HUHTEOh0asrfeTMDcMeGAVFkRqZOX5s1C0D3r6A=
Date: Sun, 12 Jan 2025 20:22:28 -0800
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,corbet@lwn.net,apw@canonical.com,tamird@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-check-return-of-git_commit_info.patch removed from -mm tree
Message-Id: <20250113042228.A0A0CC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: check return of `git_commit_info`
has been removed from the -mm tree.  Its filename was
     checkpatch-check-return-of-git_commit_info.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: s/12 chars of sha1/12+ chars of sha1/, per Jon]
  Link: https://lkml.kernel.org/r/87o70kt232.fsf@trenco.lwn.net
Link: https://lkml.kernel.org/r/20241204-checkpatch-missing-commit-v1-1-68b34c94944e@gmail.com
Signed-off-by: Tamir Duberstein <tamird@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
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
+				     "Please use correct Fixes: style 'Fixes: <12+ chars of sha1> (\"<title line>\")' - ie: '$fixed'\n" . $herecurr) &&
 				    $fix) {
-					$fixed[$fixlinenr] = "Fixes: $cid (\"$ctitle\")";
+					$fixed[$fixlinenr] = $fixed;
 				}
 			}
 		}
_

Patches currently in -mm which might be from tamird@gmail.com are


