Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48C18C07
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600530; cv=none; b=ENiD3cXEHQ330dnYzfUXwUrA9T4/3RuLfcOTO73Pyv6xs5nAjXF6bNJqvYgelzqzeCiIoBD4tbYRrKYzUAJB866P/G6AZHlE9iCkB3LGk0Igy5B6nLpyi0gAR9NzgntU5AnkWvMgj+qnT7odP6NYHuCTg1LnXfq7XlPFnEWhRdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600530; c=relaxed/simple;
	bh=7lu4Rehf0Rz1q703maMG6Tv8D7LQz1txJoFGKeLRND8=;
	h=Date:To:From:Subject:Message-Id; b=NifxtMJ+a2HyNLaKQWr9cY0jM5RbKnr5+xTL3Ty883oiLJT1Q1X7at96YbE0nny4Zs/JdNxY4SluOb8/bPbY2e+gQNVL+XpfufWY5COkhB4ACuP1rTTbUdOMljStGBhF0TEA5fVReDbRO0VTxfFiuos4yTzrGBarOSsJUOe/EX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mI20FQxF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mI20FQxF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777C2C433C7;
	Tue,  5 Mar 2024 01:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600530;
	bh=7lu4Rehf0Rz1q703maMG6Tv8D7LQz1txJoFGKeLRND8=;
	h=Date:To:From:Subject:From;
	b=mI20FQxFuYJR9Qy4jfiqB9cfyPL89AA9z/KE/00XSWCLRHOj5XPxYOfKYXakozjU/
	 m5kfUNBxJdLbBGqjBxPNDu7OEbYeTBJdNv76d2NWASGcBHct8WngcCw+YFApbx8HPz
	 zYC6CSC1lwVESvetLzBN5PKrfFakIBN/XUvSahXo=
Date: Mon, 04 Mar 2024 17:02:10 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,javier.carrasco.cruz@gmail.com,bernd.edlinger@hotmail.de,vincenzo.mezzela@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftest-damon-fix-minor-typos-in-test-logs.patch removed from -mm tree
Message-Id: <20240305010210.777C2C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftest: damon: fix minor typos in test logs
has been removed from the -mm tree.  Its filename was
     selftest-damon-fix-minor-typos-in-test-logs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


