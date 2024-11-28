Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172DF7482;
	Thu, 28 Nov 2024 00:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732754457; cv=none; b=CZh4SmElDq7DF2yr/+f/eaqa3/tHnPP+3HENUa7hwsZ8ZEGpVygSwZpaiEccs/bqsiL3/z/xhqH1zNYSTehXbF+NfYrgW8YHsmuc4RRxo57Pa+X/QLwJMCyCBxTeXvKgAl5Dh3qlr3Mq8/6eD+gSEdxIUt8i/tKMPlebSYsLoJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732754457; c=relaxed/simple;
	bh=a/G0mIukmp13jLDB5EJOYQ4Xu4asbW72zH7Q6ih4/tU=;
	h=Date:To:From:Subject:Message-Id; b=N0w2TbYSEcsjJy4aI7L1q/8B5KHf1ohlcBVMYVNvq9E9QPHalDL5QP/hc6Oec3AcAcoX+XMe3oUzkqBIMA3jAmUkNqvRFPHrOXQFda3I4w8BRiEMxyAaw1eCBhxQQRgVAAWYvHN2MdycEPxmhhjeZ9UAQos9bZlgweNBARc01JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bCIQBGKZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bCIQBGKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DD2C4CECC;
	Thu, 28 Nov 2024 00:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732754456;
	bh=a/G0mIukmp13jLDB5EJOYQ4Xu4asbW72zH7Q6ih4/tU=;
	h=Date:To:From:Subject:From;
	b=bCIQBGKZvQZmhO+r9WMhaaRIwSVWb68cabEuCtmEpraUgMG2BrHHNhGcNWfCp3gdI
	 VzIBRIU24STo6eS1kFGIf95uXBZ7oF1flb3/r2opsnrb+zWrnROmseAHKNZ8Q2P17z
	 FcKFLHzTl8fPXIxWj5VzwfyOD00QEPaAMMewKaJg=
Date: Wed, 27 Nov 2024 16:40:56 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,shuah@kernel.org,mheyne@amazon.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-add-_damon_sysfspy-to-test_files.patch added to mm-hotfixes-unstable branch
Message-Id: <20241128004056.D1DD2C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: add _damon_sysfs.py to TEST_FILES
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-damon-add-_damon_sysfspy-to-test_files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-add-_damon_sysfspy-to-test_files.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Maximilian Heyne <mheyne@amazon.de>
Subject: selftests/damon: add _damon_sysfs.py to TEST_FILES
Date: Wed, 27 Nov 2024 12:08:53 +0000

When running selftests I encountered the following error message with
some damon tests:

 # Traceback (most recent call last):
 #   File "[...]/damon/./damos_quota.py", line 7, in <module>
 #     import _damon_sysfs
 # ModuleNotFoundError: No module named '_damon_sysfs'

Fix this by adding the _damon_sysfs.py file to TEST_FILES so that it
will be available when running the respective damon selftests.

Link: https://lkml.kernel.org/r/20241127-picks-visitor-7416685b-mheyne@amazon.de
Fixes: 306abb63a8ca ("selftests/damon: implement a python module for test-purpose DAMON sysfs controls")
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/Makefile~selftests-damon-add-_damon_sysfspy-to-test_files
+++ a/tools/testing/selftests/damon/Makefile
@@ -6,7 +6,7 @@ TEST_GEN_FILES += debugfs_target_ids_rea
 TEST_GEN_FILES += debugfs_target_ids_pid_leak
 TEST_GEN_FILES += access_memory access_memory_even
 
-TEST_FILES = _chk_dependency.sh _debugfs_common.sh
+TEST_FILES = _chk_dependency.sh _debugfs_common.sh _damon_sysfs.py
 
 # functionality tests
 TEST_PROGS = debugfs_attrs.sh debugfs_schemes.sh debugfs_target_ids.sh
_

Patches currently in -mm which might be from mheyne@amazon.de are

selftests-damon-add-_damon_sysfspy-to-test_files.patch

