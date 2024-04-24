Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F273A15D5AD
	for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2024 21:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713995976; cv=none; b=ktUIasscylJ0xQfP1lOvopDhFsF+YW/xHuJT5ik8XU1ECwcKZU9nkosQZwwiPPuxIBEpn2tNQvXPJhJd27mOQVNPxEuB+CSiZEqWqWRb+2pYHUYjbOVxoPndocVxeU2pYrZfQL7WmT+ZCGL3HJSiR8JFLQcB6EboLz7QQTLK/x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713995976; c=relaxed/simple;
	bh=6LezawdzV8zhuHn2Pyqe8D+tN5Yzaf2520oydBkg/Cs=;
	h=Date:To:From:Subject:Message-Id; b=RNtNBco+gEMWeySokm6Z9bK3juuJU/rJasSmNKWRsNIAcSVPEW0e2rcVBji0XjUNeDG3yDQc0seGf6pSWc9kM+VAU6noEq6PYHbc3iCHeBP8KrjlwcOn6hQfhqptCpik/kZMQPd4WUKKKIKFLBviH8zQhpIgqAF2xoSA2UMOVzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SXX7s1lq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SXX7s1lq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD9EC113CD;
	Wed, 24 Apr 2024 21:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713995975;
	bh=6LezawdzV8zhuHn2Pyqe8D+tN5Yzaf2520oydBkg/Cs=;
	h=Date:To:From:Subject:From;
	b=SXX7s1lquvVajN5vYLhz72IYyWHVv8c+x+39HH7HcMgvDGDIxx6+lcQaRjYnTJnrB
	 /M7V+Z/wsClQxt72M7+cloEWPy5tujd18LN2GOfD4O9aAgsutp1isTXT4bEXZRiDRJ
	 9oTL8eG1ZlxewBYi6ZAXzE4f7c+dnL3QfiAgXyhc=
Date: Wed, 24 Apr 2024 14:59:34 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,p.raghav@samsung.com,Liam.Howlett@oracle.com,djwong@kernel.org,david@fromorbit.com,da.gomez@samsung.com,mcgrof@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-fix-userspace-compilation-with-new-test_xarray-changes.patch added to mm-hotfixes-unstable branch
Message-Id: <20240424215935.6FD9EC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools: fix userspace compilation with new test_xarray changes
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tools-fix-userspace-compilation-with-new-test_xarray-changes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-fix-userspace-compilation-with-new-test_xarray-changes.patch

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
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: tools: fix userspace compilation with new test_xarray changes
Date: Tue, 23 Apr 2024 12:22:20 -0700

Patch series "test_xarray: couple of fixes for v6-9-rc6", v2.

Here are a couple of fixes which should be merged into the queue for
v6.9-rc6.  The first one was reported by Liam, after fixing that I noticed
an issue with a test, and a fix for that is in the second patch.


This patch (of 2):

Liam reported that compiling the test_xarray on userspace was broken.  I
was not even aware that was possible but you can via and you can run these
tests in userspace with:

make -C tools/testing/radix-tree
./tools/testing/radix-tree/xarray

Add the two helpers we need to fix compilation.  We don't need a userspace
schedule() so just make it do nothing.

Link: https://lkml.kernel.org/r/20240423192221.301095-1-mcgrof@kernel.org
Link: https://lkml.kernel.org/r/20240423192221.301095-2-mcgrof@kernel.org
Fixes: a60cc288a1a2 ("test_xarray: add tests for advanced multi-index use")
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Reported-by: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/linux/kernel.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/radix-tree/linux/kernel.h~tools-fix-userspace-compilation-with-new-test_xarray-changes
+++ a/tools/testing/radix-tree/linux/kernel.h
@@ -18,6 +18,8 @@
 #define pr_info printk
 #define pr_debug printk
 #define pr_cont printk
+#define schedule()
+#define PAGE_SHIFT	12
 
 #define __acquires(x)
 #define __releases(x)
_

Patches currently in -mm which might be from mcgrof@kernel.org are

tools-fix-userspace-compilation-with-new-test_xarray-changes.patch
lib-test_xarrayc-fix-error-assumptions-on-check_xa_multi_store_adv_add.patch

