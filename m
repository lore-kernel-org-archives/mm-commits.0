Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EE918C03D;
	Thu, 10 Oct 2024 20:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728591890; cv=none; b=QDtWiVhm94A+7F3WM86bv6XIJiFNQuQwKlgBtJ/5gkCU+wlAZrNI6VgHU2kNQtUCS8EgMuy7SSqlQX6B7JTImRVJmSGmwHiJxj243vUzcriGFcyJ6yK1jBzc0lfxu8R5W//XdQ0hHzR4haArjixHSj0/6GPxZi0YV9RCOZLymvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728591890; c=relaxed/simple;
	bh=IWTNq7fFQedN+BbHAiMQNfXDmX3BvP2UTXL28YTkH5I=;
	h=Date:To:From:Subject:Message-Id; b=hYucW2MtIOaL+q1dj7N8za0UMIuBEVjp8/9w84nrFOuF4n6cjSOeHLeKmigW8MU7PKX46p2vKoLUbQv8vTrJze7PTs5aXMjEexXvHV3z/L6gBJgHNkq7SK+EHNVp10LRylwdcSBfM0aGbnye9Xs4l82BgjLWKITqWz3RtRjv29Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QRgXUFyr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QRgXUFyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14A8C4CEC5;
	Thu, 10 Oct 2024 20:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728591889;
	bh=IWTNq7fFQedN+BbHAiMQNfXDmX3BvP2UTXL28YTkH5I=;
	h=Date:To:From:Subject:From;
	b=QRgXUFyrHX24Fquav0YKWSMJaiy9I6IQ9MNcuc3rRYR0XnSAqlP/R1Upm/5nV81BJ
	 BAFyxNpW6V6CoMfsHVKtut7wn3sQyEOSng0280R8jdYT2uxII0gHnPv4dgTK37jlHa
	 oG60a4SGnKMwmU0pZzj+KbAG5GXRa2YN7uEZ8z+U=
Date: Thu, 10 Oct 2024 13:24:48 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,ruanjinjie@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-fix-memory-leak-in-damon_sysfs_test_add_targets.patch added to mm-hotfixes-unstable branch
Message-Id: <20241010202449.A14A8C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/sysfs-kunit.h: fix memory leak in damon_sysfs_test_add_targets()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-fix-memory-leak-in-damon_sysfs_test_add_targets.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-fix-memory-leak-in-damon_sysfs_test_add_targets.patch

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
From: Jinjie Ruan <ruanjinjie@huawei.com>
Subject: mm/damon/tests/sysfs-kunit.h: fix memory leak in damon_sysfs_test_add_targets()
Date: Thu, 10 Oct 2024 20:53:23 +0800

The sysfs_target->regions allocated in damon_sysfs_regions_alloc() is not
freed in damon_sysfs_test_add_targets(), which cause the following memory
leak, free it to fix it.

	unreferenced object 0xffffff80c2a8db80 (size 96):
	  comm "kunit_try_catch", pid 187, jiffies 4294894363
	  hex dump (first 32 bytes):
	    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
	    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
	  backtrace (crc 0):
	    [<0000000001e3714d>] kmemleak_alloc+0x34/0x40
	    [<000000008e6835c1>] __kmalloc_cache_noprof+0x26c/0x2f4
	    [<000000001286d9f8>] damon_sysfs_test_add_targets+0x1cc/0x738
	    [<0000000032ef8f77>] kunit_try_run_case+0x13c/0x3ac
	    [<00000000f3edea23>] kunit_generic_run_threadfn_adapter+0x80/0xec
	    [<00000000adf936cf>] kthread+0x2e8/0x374
	    [<0000000041bb1628>] ret_from_fork+0x10/0x20

Link: https://lkml.kernel.org/r/20241010125323.3127187-1-ruanjinjie@huawei.com
Fixes: b8ee5575f763 ("mm/damon/sysfs-test: add a unit test for damon_sysfs_set_targets()")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/sysfs-kunit.h |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/tests/sysfs-kunit.h~mm-damon-fix-memory-leak-in-damon_sysfs_test_add_targets
+++ a/mm/damon/tests/sysfs-kunit.h
@@ -67,6 +67,7 @@ static void damon_sysfs_test_add_targets
 	damon_destroy_ctx(ctx);
 	kfree(sysfs_targets->targets_arr);
 	kfree(sysfs_targets);
+	kfree(sysfs_target->regions);
 	kfree(sysfs_target);
 }
 
_

Patches currently in -mm which might be from ruanjinjie@huawei.com are

mm-damon-fix-memory-leak-in-damon_sysfs_test_add_targets.patch

