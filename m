Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC90B17741
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127164; cv=none; b=Dq3UgDgMWpAe2tK6mWTak3FVC08pRzsI3pWBPyAm6RPebJNwF4x6jgiJOxpw3Ls5iX81wXLvrCnGOz1aOEa6WwRBhx1g9zvEGZbfAOPm4DRDxoFxMMjpiCVlSFd4p+uKo1o3ZSmA7PZPfE2/MEYVNopGFJqWCnocfou6xneuzFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127164; c=relaxed/simple;
	bh=zjvgnSyFWCh3Jmqh0pJyXakkvoHxQcPeK7jh2Poc/GY=;
	h=Date:To:From:Subject:Message-Id; b=iPI9dSUEOSKtRCVUBXOS9QCpiI0kX8rCfaZ27hxB2GxsuPH3cgD06qr+h8NICzyhMjjL3jqRNCz4JgLhe548WnSVjusL4H5EOKtyVLYUEesi/tKf8GLSDqGlqgJqZ/NMQlsnkI+GpOMRzUpur6qRTj5avGHYQv7p3BRsc9Ht4pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fmNvSyor; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fmNvSyor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A13C4CEE3;
	Thu, 10 Jul 2025 05:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127163;
	bh=zjvgnSyFWCh3Jmqh0pJyXakkvoHxQcPeK7jh2Poc/GY=;
	h=Date:To:From:Subject:From;
	b=fmNvSyorKtZh+hg5WtpejEgZ8PxVLPNPuFP8/q0XzWAikbo0zwvFesI9bAV7tqL2k
	 j9iKMmXC2r2Sdw0Q8Bz07n3dpXuey+SBEdwqNGRudQwn+aT8xUoWi5nI5mMKNnJ8Mv
	 KG8ha3NWDfwktUc40FgQLSvzClqyXoDipIU+QcOc=
Date: Wed, 09 Jul 2025 22:59:23 -0700
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,clement.legoffic@foss.st.com,apw@canonical.com,antonio.borneo@foss.st.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-use-utf-8-match-for-spell-checking.patch removed from -mm tree
Message-Id: <20250710055923.C0A13C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: use utf-8 match for spell checking
has been removed from the -mm tree.  Its filename was
     checkpatch-use-utf-8-match-for-spell-checking.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Antonio Borneo <antonio.borneo@foss.st.com>
Subject: checkpatch: use utf-8 match for spell checking
Date: Mon, 16 Jun 2025 09:59:13 +0200

The current code that checks for misspelling verifies, in a more
complex regex, if $rawline matches [^\w]($misspellings)[^\w]

Being $rawline a byte-string, a utf-8 character in $rawline can
match the non-word-char [^\w].
E.g.:
	./scripts/checkpatch.pl --git 81c2f059ab9
	WARNING: 'ment' may be misspelled - perhaps 'meant'?
	#36: FILE: MAINTAINERS:14360:
	+M:     Clément Léger <clement.leger@bootlin.com>
	            ^^^^

Use a utf-8 version of $rawline for spell checking.

Link: https://lkml.kernel.org/r/20250616-b4-checkpatch-upstream-v2-1-5600ce4a3b43@foss.st.com
Signed-off-by: Antonio Borneo <antonio.borneo@foss.st.com>
Signed-off-by: Clément Le Goffic <clement.legoffic@foss.st.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-use-utf-8-match-for-spell-checking
+++ a/scripts/checkpatch.pl
@@ -3502,9 +3502,10 @@ sub process {
 # Check for various typo / spelling mistakes
 		if (defined($misspellings) &&
 		    ($in_commit_log || $line =~ /^(?:\+|Subject:)/i)) {
-			while ($rawline =~ /(?:^|[^\w\-'`])($misspellings)(?:[^\w\-'`]|$)/gi) {
+			my $rawline_utf8 = decode("utf8", $rawline);
+			while ($rawline_utf8 =~ /(?:^|[^\w\-'`])($misspellings)(?:[^\w\-'`]|$)/gi) {
 				my $typo = $1;
-				my $blank = copy_spacing($rawline);
+				my $blank = copy_spacing($rawline_utf8);
 				my $ptr = substr($blank, 0, $-[1]) . "^" x length($typo);
 				my $hereptr = "$hereline$ptr\n";
 				my $typo_fix = $spelling_fix{lc($typo)};
_

Patches currently in -mm which might be from antonio.borneo@foss.st.com are


