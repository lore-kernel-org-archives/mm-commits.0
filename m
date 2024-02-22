Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD4173F3D
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 21:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708638391; cv=none; b=eqrsvqqVpQ11PotvZ43+NsUGe3d/ER7/Qv+Qmt3fwdV5iDOULNUcTYHaHaBbzG2ujLArg2qOtgDjFaSzvefbt5lYvFxd2e+mFXbwCmf4tYJRuHBXJ3kO/AAUySDzGQuYdD2hqbcvnbNKSJVgKVXErrOsm2gsKB1kM3JyjIgM9rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708638391; c=relaxed/simple;
	bh=2LOfWfYED2MuzNwhDC1AKIQHKJWBx+d5EZUZaiO5ykI=;
	h=Date:To:From:Subject:Message-Id; b=CJgEmop0F34b+C1+ip6FPkBs5IjCKNIsmkmEzFAitSaqWaRSYgZ5070ZwExRADujSF9xVdgK9pQVnKbeAkh+AsCvkYlqripVdaNsOP9MEI1UmVS3QdcfbsFgC77W0ew2m1a5/F7StEn8XL3PP2eD2/eieoJKs2iNvvKKX/FCKwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PNy1RFfI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PNy1RFfI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33780C433F1;
	Thu, 22 Feb 2024 21:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708638391;
	bh=2LOfWfYED2MuzNwhDC1AKIQHKJWBx+d5EZUZaiO5ykI=;
	h=Date:To:From:Subject:From;
	b=PNy1RFfI4LBRTYEIrqM+JZSqb/S17hisv7X5szK4yyjLcEHaodpSCLAzOlXZp7RVG
	 kMdoe+SK2Hj5Rdv5TEBq1Lz49K4vL9akKHPNxVqzRRGPFVNqE9iawXIyfCIBKAkN/e
	 Ypi2lp3VkkX/VbVo0Y20f0xcjiMSkEijxDj+crJ0=
Date: Thu, 22 Feb 2024 13:46:30 -0800
To: mm-commits@vger.kernel.org,vincenzo.mezzela@gmail.com,sj@kernel.org,bernd.edlinger@hotmail.de,javier.carrasco.cruz@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-add-access_memory-to-gitignore.patch added to mm-unstable branch
Message-Id: <20240222214631.33780C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: damon: add access_memory to .gitignore
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-add-access_memory-to-gitignore.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-add-access_memory-to-gitignore.patch

This patch will later appear in the mm-unstable branch at
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
From: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Subject: selftests: damon: add access_memory to .gitignore
Date: Wed, 21 Feb 2024 13:11:48 -0800

This binary is missing in the .gitignore and stays as an untracked file.

Link: https://lore.kernel.org/r/20240214-damon_selftest_gitignore-v1-1-f517d0f9f783@gmail.com
Link: https://lkml.kernel.org/r/20240221211148.46522-3-sj@kernel.org
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Singed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
Closes: https://lore.kernel.org/all/AS8P193MB1285C963658008F1B2702AF7E4792@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM/
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Vincenzo Mezzela <vincenzo.mezzela@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/damon/.gitignore~selftests-damon-add-access_memory-to-gitignore
+++ a/tools/testing/selftests/damon/.gitignore
@@ -2,3 +2,4 @@
 huge_count_read_write
 debugfs_target_ids_read_before_terminate_race
 debugfs_target_ids_pid_leak
+access_memory
_

Patches currently in -mm which might be from javier.carrasco.cruz@gmail.com are

selftests-damon-add-access_memory-to-gitignore.patch

