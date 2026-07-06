Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA363E51C8
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 16:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783356837; cv=none; b=NfJ4t2tc3y04oXhe0acxMDm3RJDLsH2rg7j5DBcgtOvF2jkW5uGg93r8w73l6LnOfPI9ak6aDGMPBREKgAlEsQ7VxE0/PUY/ltFqPaULuZjT7OnBf+pN5R7L8/sj46E803L1ZrBdQxOcDOE72jCPxFdNafwey4CrgZNZc3PEf6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783356837; c=relaxed/simple;
	bh=7T+ZAb60tCji1ElxYtLGVDCrea2ypflaDqfjUNLwLQU=;
	h=Date:To:From:Subject:Message-Id; b=N1Rg4fje8scAa6C9x1lI9kMeI3r3JPjM1ZKAAYMzIIp/zg1J4yVYBsMe+jkdxkOOiXUINeBamOV6pUPNnI3gw1DyFUE9wnMOYE/Cx2h35dIdH/7fVcAGY/cbZlXTmZebG642gHTJ6jO1VlunoHcFJcTbaBiBAVMVEeHSopGZVwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IGAaUj26; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IGAaUj26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0D21F000E9;
	Mon,  6 Jul 2026 16:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783356835;
	bh=kP27eRmBtxhsJfrMTl/ASRgE5cRxpbr9G/jc/R21UAw=;
	h=Date:To:From:Subject;
	b=IGAaUj26sjClgCcsQp12xHoW2Fd3mk53zMShGsL2TTXXLSOpCM1teAUXF3fgqmgLS
	 YiayjeFwQmVJ7EOt8G3KRExQsj33aBrPfTTknb3KIwPhoiOLpZndUTKrtvdh/jpXVt
	 78EE1RovDhtWZEFLM569DUGHMoWTgLVvXQk31N5Y=
Date: Mon, 06 Jul 2026 09:53:55 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shuah@kernel.org,a929244872@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-check-correct-path-in-ensure_file-not_exist-case.patch added to mm-new branch
Message-Id: <20260706165355.9A0D21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: check correct path in ensure_file() not_exist case
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-check-correct-path-in-ensure_file-not_exist-case.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-check-correct-path-in-ensure_file-not_exist-case.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: wang wei <a929244872@163.com>
Subject: selftests/damon: check correct path in ensure_file() not_exist case
Date: Mon, 6 Jul 2026 21:43:04 +0800

In the ensure_file() function, the "not_exist" code path checks whether
$dir exists as a regular file.  However, the intent is to verify that the
target file ($file) does not exist, not the $dir.  Testing $dir makes the
existence check effectively useless -- it tests the wrong path and thus
never catches the case where the file is unexpectedly present.

Replace $dir with $file so the not_exist verification targets the correct
path.

Link: https://lore.kernel.org/20260706134305.5224-1-a929244872@163.com
Signed-off-by: wang wei <a929244872@163.com>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/sysfs.sh~selftests-damon-check-correct-path-in-ensure_file-not_exist-case
+++ a/tools/testing/selftests/damon/sysfs.sh
@@ -67,7 +67,7 @@ ensure_file()
 			echo "$file permission: expected $permission but $perm"
 			exit 1
 		fi
-	elif [ "$to_ensure" = "not_exist" ] && [ -f "$dir" ]
+	elif [ "$to_ensure" = "not_exist" ] && [ -f "$file" ]
 	then
 		echo "$file is not expected but found"
 		exit 1
_

Patches currently in -mm which might be from a929244872@163.com are

selftests-damon-check-correct-path-in-ensure_file-not_exist-case.patch

