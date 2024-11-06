Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4479918B47E
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855668; cv=none; b=rHvcXUFM3397RuAAiDXF32tqFFHzvOdGUwpQCxKQj5cNzbEBwz+kr+Yq9dmsMoyj/VxHiRzJ/yq5G8WAaFCJjAEg+qr+CqxpfnwnLYQyHIh3Wr8CbI1Ee6j+xB2RZNq5h5whbO0juJ3XuLEIp4OvUhSt4zE7gMgL9Ai4n+j+Alc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855668; c=relaxed/simple;
	bh=8rnGQFhDBNvX+W/vY3XDTekpbUOGOHl5UJhArBgODuQ=;
	h=Date:To:From:Subject:Message-Id; b=BJrmrk7PCUZTkb1/mR9D4mMfHEMav0D9NXJtZT2bYRPSD2q/k8YwBL+xT8hc8u0I9DmndeRzTQwVLZ3x/1eSxqFgugC7113zI9HFlrAqtf4HEQxK9+h++7LOQiUO6+LTTCQ4ToCyYtXuTdjC4Q+DXTD+3ub5xuPI+8bghzHAsLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bsFG5aqh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bsFG5aqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197B2C4CECF;
	Wed,  6 Nov 2024 01:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855668;
	bh=8rnGQFhDBNvX+W/vY3XDTekpbUOGOHl5UJhArBgODuQ=;
	h=Date:To:From:Subject:From;
	b=bsFG5aqh6tWCcurdCxQsNLGdeAFn5lH9UOSpsBcsRJqirTnyC5b0TJam0SA65a9FU
	 wHlH4RNnfkn3XbWUpGb82aUPMke4Vv7DgBMBt8lGRLE2+TXwlc+I3hrOXxBFJWVKmR
	 WFKNooH4jHc8INZq2nS5j/HL2nGP83phomQd5uw0=
Date: Tue, 05 Nov 2024 17:14:27 -0800
To: mm-commits@vger.kernel.org,philippe.schenker@toradex.com,niklas.soderlund+renesas@ragnatech.se,lukas.bulwahn@gmail.com,louis.peens@corigine.com,joe@perches.com,horms@kernel.org,dwaipayanray1@gmail.com,apw@canonical.com,tamird@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-always-parse-orig_commit-in-fixes-tag.patch removed from -mm tree
Message-Id: <20241106011428.197B2C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: always parse orig_commit in fixes tag
has been removed from the -mm tree.  Its filename was
     checkpatch-always-parse-orig_commit-in-fixes-tag.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tamir Duberstein <tamird@gmail.com>
Subject: checkpatch: always parse orig_commit in fixes tag
Date: Fri, 25 Oct 2024 19:43:19 -0400

Do not require the presence of `$balanced_parens` to get the commit SHA;
this allows a `Fixes: deadbeef` tag to get a correct suggestion rather
than a suggestion containing a reference to HEAD.

Given this patch:

: From: Tamir Duberstein <tamird@gmail.com>
: Subject: Test patch
: Date: Fri, 25 Oct 2024 19:30:51 -0400
: 
: This is a test patch.
: 
: Fixes: bd17e036b495
: Signed-off-by: Tamir Duberstein <tamird@gmail.com>
: --- /dev/null
: +++ b/new-file
: @@ -0,0 +1 @@
: +Test.


Before:

WARNING: Please use correct Fixes: style 'Fixes: <12 chars of sha1> ("<title line>")' - ie: 'Fixes: c10a7d25e68f ("Test patch")'

After:

WARNING: Please use correct Fixes: style 'Fixes: <12 chars of sha1> ("<title line>")' - ie: 'Fixes: bd17e036b495 ("checkpatch: warn for non-standard fixes tag style")'



The prior behavior incorrectly suggested the patch's own SHA and title
line rather than the referenced commit's.  This fixes that.

Ironically this:

Fixes: bd17e036b495 ("checkpatch: warn for non-standard fixes tag style")
Signed-off-by: Tamir Duberstein <tamird@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Louis Peens <louis.peens@corigine.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Cc: Philippe Schenker <philippe.schenker@toradex.com>
Cc: Simon Horman <horms@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-always-parse-orig_commit-in-fixes-tag
+++ a/scripts/checkpatch.pl
@@ -3209,36 +3209,31 @@ sub process {
 
 # Check Fixes: styles is correct
 		if (!$in_header_lines &&
-		    $line =~ /^\s*fixes:?\s*(?:commit\s*)?[0-9a-f]{5,}\b/i) {
-			my $orig_commit = "";
-			my $id = "0123456789ab";
-			my $title = "commit title";
-			my $tag_case = 1;
-			my $tag_space = 1;
-			my $id_length = 1;
-			my $id_case = 1;
+		    $line =~ /^\s*(fixes:?)\s*(?:commit\s*)?([0-9a-f]{5,40})(?:\s*($balanced_parens))?/i) {
+			my $tag = $1;
+			my $orig_commit = $2;
+			my $title;
 			my $title_has_quotes = 0;
 			$fixes_tag = 1;
-
-			if ($line =~ /(\s*fixes:?)\s+([0-9a-f]{5,})\s+($balanced_parens)/i) {
-				my $tag = $1;
-				$orig_commit = $2;
-				$title = $3;
-
-				$tag_case = 0 if $tag eq "Fixes:";
-				$tag_space = 0 if ($line =~ /^fixes:? [0-9a-f]{5,} ($balanced_parens)/i);
-
-				$id_length = 0 if ($orig_commit =~ /^[0-9a-f]{12}$/i);
-				$id_case = 0 if ($orig_commit !~ /[A-F]/);
-
+			if (defined $3) {
 				# Always strip leading/trailing parens then double quotes if existing
-				$title = substr($title, 1, -1);
+				$title = substr($3, 1, -1);
 				if ($title =~ /^".*"$/) {
 					$title = substr($title, 1, -1);
 					$title_has_quotes = 1;
 				}
+			} else {
+				$title = "commit title"
 			}
 
+
+			my $tag_case = not ($tag eq "Fixes:");
+			my $tag_space = not ($line =~ /^fixes:? [0-9a-f]{5,40} ($balanced_parens)/i);
+
+			my $id_length = not ($orig_commit =~ /^[0-9a-f]{12}$/i);
+			my $id_case = not ($orig_commit !~ /[A-F]/);
+
+			my $id = "0123456789ab";
 			my ($cid, $ctitle) = git_commit_info($orig_commit, $id,
 							     $title);
 
_

Patches currently in -mm which might be from tamird@gmail.com are


