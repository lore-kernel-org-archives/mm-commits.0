Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3331422CF
	for <mm-commits@vger.kernel.org>; Mon, 10 Jun 2024 16:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718037144; cv=none; b=CQmRj3WaCWTBpz3dK+QBYnMSV/5C6y9T+xugTRi9lKOCEf6ZcTUw0rhavWJKZOzyZDZ0XT3fX6oqivK9J0y2HCaCT4MCqB0OVYjy0CdN3pc7Fv29drdB4scILYKp4EIYaKOUbiRmM+13C/+5BcLaoRZtz7ltVwzgmJX/63GUwpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718037144; c=relaxed/simple;
	bh=7g5O0msvoSvxapCHn1RLdcrc2wbYcLV40VsC9OhX2fg=;
	h=Date:To:From:Subject:Message-Id; b=haBBzfQWALPPrJnvfgM7FdbYBr+hIjO+UNTkElk7vx8s+YcnD67IM8Y0C43K4610C8hAEMqJugDFSpq0zo/2EDHuxRbJZ1vnm64DqjA5r//zAkSOKvbNvdfiTN6hd6/OkhPbzfHKBuf92AEZxE8Tz+7Pd1vqmjMmFsRvDAefHJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jGlld8jj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jGlld8jj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8426C2BBFC;
	Mon, 10 Jun 2024 16:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718037143;
	bh=7g5O0msvoSvxapCHn1RLdcrc2wbYcLV40VsC9OhX2fg=;
	h=Date:To:From:Subject:From;
	b=jGlld8jjiIjYr/ruC7TWxIBpeuch9pnuFQJIKkL/QbcuuHqwwPZ1GGBxcug5aU0hI
	 5yFyEg+h9QGMaR1VRrpqGLTTA6G304lFgbyjwFO9QyPmyEpRTYuf+XbYwFcZO+qsoY
	 O8+NmBFN++wfQZBp1bqBkTmsuu6wc/LrCgA62xkQ=
Date: Mon, 10 Jun 2024 09:32:23 -0700
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,wsa+renesas@sang-engineering.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-really-skip-long_line_-when-long_line-is-ignored.patch added to mm-nonmm-unstable branch
Message-Id: <20240610163223.A8426C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: really skip LONG_LINE_* when LONG_LINE is ignored
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-really-skip-long_line_-when-long_line-is-ignored.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-really-skip-long_line_-when-long_line-is-ignored.patch

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
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: checkpatch: really skip LONG_LINE_* when LONG_LINE is ignored
Date: Mon, 10 Jun 2024 17:02:09 +0200

For a printout to happen, all types must be set to "show".  So, AND is
needed for the flags, not OR, if we want to ignore something.

Link: https://lkml.kernel.org/r/20240610150420.2279-2-wsa+renesas@sang-engineering.com
Fixes: 47e0c88b37a5 ("checkpatch: categorize some long line length checks")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-really-skip-long_line_-when-long_line-is-ignored
+++ a/scripts/checkpatch.pl
@@ -3858,7 +3858,7 @@ sub process {
 			}
 
 			if ($msg_type ne "" &&
-			    (show_type("LONG_LINE") || show_type($msg_type))) {
+			    show_type("LONG_LINE") && show_type($msg_type)) {
 				my $msg_level = \&WARN;
 				$msg_level = \&CHK if ($file);
 				&{$msg_level}($msg_type,
_

Patches currently in -mm which might be from wsa+renesas@sang-engineering.com are

checkpatch-really-skip-long_line_-when-long_line-is-ignored.patch

