Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D21184E
	for <mm-commits@vger.kernel.org>; Sat, 11 Jan 2025 01:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736557983; cv=none; b=h+/g20pcaQtGzXKNpKoaijiVYPo/7hIh2aXsEXo76dR8vTm90XJWi8Ei/1yO90Zs7QFPgv9d/MjEBnU78ZrinHTkAPgNwo0jKMhq15LR8sNIMUQjoxekXDg0oc0TeKuor3M4GhP2jj4ZrfZ5zLGP/HIDM4QwkRHYg1UZqZjrYnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736557983; c=relaxed/simple;
	bh=7R03OzRsA2rmymU+wVZnK1NoTkNafcWdO+qXO8o6wMM=;
	h=Date:To:From:Subject:Message-Id; b=KWnRO9ClDWWnGL2Utv0xB9/1tnBZU6NY5ilmt6GYYO7qCpu7I86aNgSGDgfBHP50umlXe91g6Dt8caJM26vlNcReBLZwUdz9m8ugaH2bZBL5HMUUykeI+fXjofjN/mzwYiMbRAOlVsFuV9zJi0lR83RUfOimA4CuXo2Hu7j1Zi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i1I8QUec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i1I8QUec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF41C4CED6;
	Sat, 11 Jan 2025 01:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736557982;
	bh=7R03OzRsA2rmymU+wVZnK1NoTkNafcWdO+qXO8o6wMM=;
	h=Date:To:From:Subject:From;
	b=i1I8QUecAchoC2fRpgZrzWO3FI21eMPeFq2re/3GUg9Lz0t9SVNBBcsxGBDQzXBLQ
	 Z8Wu3nZW87ci0l0EsIElQinY/M4LaNO1oM95aWITZYocZJhOL7RIPP0KVNf6vyXaC5
	 n61n+DhRu18x+yNaV12jrEIs5QnjGJmNofRT4XkM=
Date: Fri, 10 Jan 2025 17:13:02 -0800
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,gregkh@linuxfoundation.org,dwaipayanray1@gmail.com,apw@canonical.com,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-dont-warn-about-extra-parentheses-in-staging.patch added to mm-nonmm-unstable branch
Message-Id: <20250111011302.DBF41C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: don't warn about extra parentheses in staging/
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-dont-warn-about-extra-parentheses-in-staging.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-dont-warn-about-extra-parentheses-in-staging.patch

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

squashfs-convert-squashfs_copy_cache-to-take-a-folio-fix.patch
checkpatch-dont-warn-about-extra-parentheses-in-staging.patch

