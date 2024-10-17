Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B9B1C32EB;
	Thu, 17 Oct 2024 07:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729150130; cv=none; b=X0pmncwov7QO+/Z8pnwO9JR0+D126u/bpNg4tzmcB5ko3bgibBuP0IkfuujAsjxsIKNTJ9pmCWFOJMsgKwrR4OsYCW4Zh50vv6MewTl3Hsr2Hkvobnr7W75YTBUGV/kLR7/SaBmLUY6BoJnPvaqc+521PzccWDPq7g2ldAwMLHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729150130; c=relaxed/simple;
	bh=KXYKNEoyCR9y/8ZrswmZwno/cJ0KqVQHK1X2M9icTzk=;
	h=Date:To:From:Subject:Message-Id; b=bi8PUZDjIVp4vn/bylbnvYIpiKT8XJeXa7OabWNdg0yobRQ1JyOxlz+3+HblHl3wMbs9EwP7rmF9r+yqN8T3lm6egPtmXZpye2MsYEJQGsUMteaU8S2mmGatePmZD9nLYngjzzc86ZiyWzaa/xt7kEOxohdlKLHoeYyjn9dE3d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FpDj+NTP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FpDj+NTP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5EE5C4CEC7;
	Thu, 17 Oct 2024 07:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729150129;
	bh=KXYKNEoyCR9y/8ZrswmZwno/cJ0KqVQHK1X2M9icTzk=;
	h=Date:To:From:Subject:From;
	b=FpDj+NTPFt7PQv1nBhirMzcuNFqddw8XAJ6mPcqKybFrhYJZRgH6a9bBM6hx2P7Nd
	 2Mm4qQmZkAkXeMJAxnPh7ObWpverQFcWlfYbu/tV2q1NyPs3qxRE+hTZ24hNv2atK/
	 eqOtAczit1TZV/Xwe13d72K3iR5gYMe+PHhw2Ztw=
Date: Thu, 17 Oct 2024 00:28:49 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,ruanjinjie@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-fix-memory-leak-in-damon_sysfs_test_add_targets.patch removed from -mm tree
Message-Id: <20241017072849.B5EE5C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/sysfs-kunit.h: fix memory leak in damon_sysfs_test_add_targets()
has been removed from the -mm tree.  Its filename was
     mm-damon-fix-memory-leak-in-damon_sysfs_test_add_targets.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


