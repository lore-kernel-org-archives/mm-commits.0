Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985B427293D
	for <mm-commits@vger.kernel.org>; Tue, 11 Feb 2025 23:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739315182; cv=none; b=b2s9VzskgA/4jVgzMc0/PHxs8sgOEziXCGEdvtlhSvIpOgikF526n95AW7pfcvoJdjfKslw7My5k8sIqaNiME/j0b6OAyTcAG4GvMkYFKl05/dGb3ci/BCAIPCxdNLGRE4r5C4fnsZjiWPBn6vYpPa8ZNIFswsQdMwXYk+ZGZLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739315182; c=relaxed/simple;
	bh=u7ayBRHOF9y0jMBLeFXaQqf+QFNraBofnYG11Hb598A=;
	h=Date:To:From:Subject:Message-Id; b=HVYZSM9cD/HWKT9De24Io3ffZhOATs1gh/SExv3/1DihYLCIrL+n6PJMjNlKsDpNlxfcxFc2hGnjjhNA6nyjQ2LFu2YKpfieD9QFdWVy9ccvG6qfg1n8OGNjtycCvegpLPJaS7oqX0u+pZ3Uxp5iFZzXQ28WofiZbv3KRQdZMCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FlGxsr44; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FlGxsr44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A86DC4CEE6;
	Tue, 11 Feb 2025 23:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739315182;
	bh=u7ayBRHOF9y0jMBLeFXaQqf+QFNraBofnYG11Hb598A=;
	h=Date:To:From:Subject:From;
	b=FlGxsr444ddcsABSBEYmKjdqFO+GA/wS25O915Fqg1fqM6PkXXe0RprcVOrgM9uve
	 Os9IeGslRej6sfqMB8rUk6rWgdk6fitzE17Utn/Zmr/BZtoYB7IjJVhKF933cCTAoa
	 ilhbB3y58z1Sz/ixoOvn+GSZiFtdko6pp7UzgPo4=
Date: Tue, 11 Feb 2025 15:06:21 -0800
To: mm-commits@vger.kernel.org,tytso@mit.edu,lorenzo.stoakes@oracle.com,linux@leemhuis.info,kees@kernel.org,joe@perches.com,bryan.odonoghue@linaro.org,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + get_maintainer-add-substatus-for-reporting-subsystem-status-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250211230622.5A86DC4CEE6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: get_maintainer: add --substatus for reporting subsystem status - fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     get_maintainer-add-substatus-for-reporting-subsystem-status-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/get_maintainer-add-substatus-for-reporting-subsystem-status-fix.patch

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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: get_maintainer: add --substatus for reporting subsystem status - fix
Date: Tue, 11 Feb 2025 16:16:11 +0100

The automatically enabled --substatus can break existing scripts that do
not disable --rolestats.  Require that script output goes to a terminal to
enable it automatically.

Link: https://lkml.kernel.org/r/66c2bf7a-9119-4850-b6b8-ac8f426966e1@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc: Joe Perches <joe@perches.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Thorsten Leemhuis <linux@leemhuis.info>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/get_maintainer.pl~get_maintainer-add-substatus-for-reporting-subsystem-status-fix
+++ a/scripts/get_maintainer.pl
@@ -317,7 +317,7 @@ $output_rolestats = 1 if ($interactive);
 $output_roles = 1 if ($output_rolestats);
 
 if (!defined $output_substatus) {
-    $output_substatus = $email && $output_roles;
+    $output_substatus = $email && $output_roles && -t STDOUT;
 }
 
 if ($sections || $letters ne "") {
@@ -1086,7 +1086,7 @@ MAINTAINER field selection options:
     --remove-duplicates => minimize duplicate email names/addresses
     --roles => show roles (status:subsystem, git-signer, list, etc...)
     --rolestats => show roles and statistics (commits/total_commits, %)
-    --substatus => show subsystem status if not Maintained (default: match --roles)"
+    --substatus => show subsystem status if not Maintained (default: match --roles when output is tty)"
     --file-emails => add email addresses found in -f file (default: 0 (off))
     --fixes => for patches, add signatures of commits with 'Fixes: <commit>' (default: 1 (on))
   --scm => print SCM tree(s) if any
_

Patches currently in -mm which might be from vbabka@suse.cz are

get_maintainer-add-substatus-for-reporting-subsystem-status.patch
get_maintainer-add-substatus-for-reporting-subsystem-status-fix.patch
get_maintainer-stop-reporting-subsystem-status-as-maintainer-role.patch

