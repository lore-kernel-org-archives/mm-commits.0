Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADCE170826
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742273; cv=none; b=iod5y8j3zwzQlAOnCK7/bFNwaykhrMoKeUnSCxErnmyfqDq7pByGYLNLMWZhcipYnPac7er0v35Fl4Zoa9GO1xK/oXuKuj4NuvHKPVq4DNroyPdRXMWwZ19XXvrk/kFC9rAFaQ7Ym49GsJyo1NGJrTUu9bRA+eiy3fcVn5luzK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742273; c=relaxed/simple;
	bh=Xq/AR1ibb+n3i6LupDDEW7Up5PzNLIjWB5BtiMxoKeY=;
	h=Date:To:From:Subject:Message-Id; b=mzY5hiAwoqt7sIRe0ciSHcw/Z+7HaMPTt3hk7Yy8UPoAJHE484ksAMO9zZxV33lCOZEdhf89nhrfxPGYkGxhNnZMez+YMmnPgCRvkYL/eyZ9MBSszni48SbT2uj2tvNqSBkdN6TIHatT4XRY0E9JVx20AwYvgl4ai5XYBX5sJGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PxbbMMHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PxbbMMHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E53FC4CED6;
	Mon, 13 Jan 2025 04:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742273;
	bh=Xq/AR1ibb+n3i6LupDDEW7Up5PzNLIjWB5BtiMxoKeY=;
	h=Date:To:From:Subject:From;
	b=PxbbMMHa4e+s6QhuExxN6r55+JKDdocl/XOjd4ntdqKBWanpZetOCgI6Je3l6MPGk
	 rc6AgbNzqd+3d9bcuBRRZ90NJGulUJ8d6rpcoj5M1HpC2+QCS4PVIASyyuV+S6AUuP
	 8IXfVwHdoosR0NKVeJzo7jFxEeFXcI/XTfdAxNxY=
Date: Sun, 12 Jan 2025 20:24:33 -0800
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,gregkh@linuxfoundation.org,dwaipayanray1@gmail.com,apw@canonical.com,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-dont-warn-about-extra-parentheses-in-staging.patch removed from -mm tree
Message-Id: <20250113042433.8E53FC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: don't warn about extra parentheses in staging/
has been removed from the -mm tree.  Its filename was
     checkpatch-dont-warn-about-extra-parentheses-in-staging.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: checkpatch: don't warn about extra parentheses in staging/
Date: Fri, 10 Jan 2025 10:12:17 +0300

This "Unnecessary parentheses" warning is disabled for drivers/staging
unless the --strict option is used.  Really, we don't want it at all even
if the --strict option is used.

Link: https://lkml.kernel.org/r/c7278d21-d96c-4c1e-b3bf-f82b8decc5df@stanley.mountain
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-dont-warn-about-extra-parentheses-in-staging
+++ a/scripts/checkpatch.pl
@@ -5503,9 +5503,9 @@ sub process {
 			}
 		}
 
-# check for unnecessary parentheses around comparisons in if uses
-# when !drivers/staging or command-line uses --strict
-		if (($realfile !~ m@^(?:drivers/staging/)@ || $check_orig) &&
+# check for unnecessary parentheses around comparisons
+# except in drivers/staging
+		if (($realfile !~ m@^(?:drivers/staging/)@) &&
 		    $perl_version_ok && defined($stat) &&
 		    $stat =~ /(^.\s*if\s*($balanced_parens))/) {
 			my $if_stat = $1;
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are


