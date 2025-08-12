Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77E61E3DFE
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 23:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755041183; cv=none; b=Xgo0005nYDVMeNMQbiEKOSFnZhz0Nbc1W6lDQfjf7z/uRxcB4Ph96FDgssOc49spJFqtf1CoBvHNz4xzsyIYOB/A9Nl8JaHjUjoWevLn/3CoGCQQVLOpLHRAg18kGJ6ksSWNA4ScPj05+NEUhBMfkRLfIqZQURKR39J8c2FvKDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755041183; c=relaxed/simple;
	bh=2Rt97Hb/o4pFuYkK0dmJzF0IxoH64DQvU94BUTdlWz8=;
	h=Date:To:From:Subject:Message-Id; b=Uwyaa59qdIFfxHA6M5ZWzW7YmCeeLAuQLoakaw+efvNBw4VlMCdjL6N2ShEaWju5SPFkQTueAszLdW7Od1NmCHEgOkgvwmTzzUtN7EU0hH9z3AkbzNqvaZjq4Jz3ZlG7/ukPMENbEZBdg1/4BtgdhuYk4gpKsFX6ocdEvWkNNYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=acpOT72z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="acpOT72z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185E2C4CEF0;
	Tue, 12 Aug 2025 23:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755041183;
	bh=2Rt97Hb/o4pFuYkK0dmJzF0IxoH64DQvU94BUTdlWz8=;
	h=Date:To:From:Subject:From;
	b=acpOT72zBVGW8FJ6baaS69votJQpObepeAba66sgksJ0vxDli90ZKL1S/R6oqU6Pe
	 zPr9hTqu7gphPQCqLBnf9qL+GCKtkjlKjxNhdYAJy1HHh0TPiynywgeXJN2/6ivPXh
	 QI3okrzEAa++nFb/8a/erN2S4kq4Cvdyb00z5Wcg=
Date: Tue, 12 Aug 2025 16:26:22 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shuah@kernel.org,lienze@kylinos.cn,ekffu200098@gmail.com,alexghiti@rivosinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-fix-damon-selftests-by-installing-_commonsh.patch added to mm-new branch
Message-Id: <20250812232623.185E2C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: fix damon selftests by installing _common.sh
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-fix-damon-selftests-by-installing-_commonsh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-fix-damon-selftests-by-installing-_commonsh.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: selftests/damon: fix damon selftests by installing _common.sh
Date: Tue, 12 Aug 2025 08:12:11 +0000

_common.sh was recently introduced but is not installed and then triggers
an error when trying to run the damon selftests:

selftests: damon: sysfs.sh
./sysfs.sh: line 4: _common.sh: No such file or directory

Install this file to avoid this error.

Link: https://lkml.kernel.org/r/20250812-alex-fixes_manual-v1-1-c4e99b1f80e4@rivosinc.com
Fixes: 511914506d19 ("selftests/damon: introduce _common.sh to host shared function")
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Tested-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Enze Li <lienze@kylinos.cn>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/damon/Makefile~selftests-damon-fix-damon-selftests-by-installing-_commonsh
+++ a/tools/testing/selftests/damon/Makefile
@@ -5,6 +5,7 @@ TEST_GEN_FILES += access_memory access_m
 
 TEST_FILES = _damon_sysfs.py
 TEST_FILES += drgn_dump_damon_status.py
+TEST_FILES += _common.sh
 
 # functionality tests
 TEST_PROGS += sysfs.sh
_

Patches currently in -mm which might be from alexghiti@rivosinc.com are

selftests-damon-fix-damon-selftests-by-installing-_commonsh.patch

