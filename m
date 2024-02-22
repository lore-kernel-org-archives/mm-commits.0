Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994DC73F3D
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 21:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708638390; cv=none; b=iOmEBBDSy0a3iWnRqaWd74v4KLGfZjkbXdAs/KpS1nRV7kxUV4dshd4mIuDH2LJsiKtq1szCFGNGF8LoiB8wpRHxE8hOyFqN/v+L4SKIm87gmEqJ1SjtougZAex4pLn9yO94czD+EBpZe/p34Ui/Z0x73WaAhXyk1sinoIlKeSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708638390; c=relaxed/simple;
	bh=xs+P7/8VA/Nxcamll8Av4V2X0UK7dzhDzihRctFewlA=;
	h=Date:To:From:Subject:Message-Id; b=f7nD4mOlbjlHsKNF5+auZNf9aOHTtIdRF+MPQRFFLzlMtarqR6kd15U9hxQi/LlPBF+au4oZNzW4nDTgoltiyMFBUQG4/MOQH/1vwRBwv1m9BdXeMxDezvurkSuOWcAUXIi/L2OH/AiiutxkfyHloeFCSITxyCnGsydjq/NFeH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XLl9bg/y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XLl9bg/y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64A8C433C7;
	Thu, 22 Feb 2024 21:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708638390;
	bh=xs+P7/8VA/Nxcamll8Av4V2X0UK7dzhDzihRctFewlA=;
	h=Date:To:From:Subject:From;
	b=XLl9bg/yO3CwsWzAwaYO6FarTO4ylmXFTw2n9OrIEXYWxhizhyNpa9PHaWF5h4mQx
	 EVYkSw+6gbWKNT9ZYddH6NUvQPV7XkL6ZY08LKzVLQv8z9E3WRfu5CkgIpVcTmCtvj
	 iEoLzCMAp8Bzsz5DYsSzPA2E5MkB7Rnef8ad/l2M=
Date: Thu, 22 Feb 2024 13:46:29 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,javier.carrasco.cruz@gmail.com,bernd.edlinger@hotmail.de,vincenzo.mezzela@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-damon-fix-minor-typos-in-test-logs.patch added to mm-unstable branch
Message-Id: <20240222214629.E64A8C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest: damon: fix minor typos in test logs
has been added to the -mm mm-unstable branch.  Its filename is
     selftest-damon-fix-minor-typos-in-test-logs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-damon-fix-minor-typos-in-test-logs.patch

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
From: Vincenzo Mezzela <vincenzo.mezzela@gmail.com>
Subject: selftest: damon: fix minor typos in test logs
Date: Wed, 21 Feb 2024 13:11:47 -0800

Patch series "selftests/damon: misc fixes".

Misc fixes for DAMON selftets on behalf of the original authors.


This patch (of 2):

This patch resolves a spelling error in the test log, preventing potential
confusion.

It is submitted as part of my application to the "Linux Kernel Bug Fixing
Spring Unpaid 2024" mentorship program of the Linux Foundation.

Link: https://lore.kernel.org/r/20240204122523.14160-1-vincenzo.mezzela@gmail.com
Link: https://lkml.kernel.org/r/20240221211148.46522-2-sj@kernel.org
Signed-off-by: Vincenzo Mezzela <vincenzo.mezzela@gmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py           |    2 +-
 tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py~selftest-damon-fix-minor-typos-in-test-logs
+++ a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py
@@ -20,7 +20,7 @@ def main():
 
     err = kdamonds.start()
     if err != None:
-        print('kdmaond start failed: %s' % err)
+        print('kdamond start failed: %s' % err)
         exit(1)
 
     while proc.poll() == None:
--- a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py~selftest-damon-fix-minor-typos-in-test-logs
+++ a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py
@@ -23,7 +23,7 @@ def main():
 
     err = kdamonds.start()
     if err != None:
-        print('kdmaond start failed: %s' % err)
+        print('kdamond start failed: %s' % err)
         exit(1)
 
     wss_collected = []
_

Patches currently in -mm which might be from vincenzo.mezzela@gmail.com are

selftest-damon-fix-minor-typos-in-test-logs.patch

