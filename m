Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5C5283C9C;
	Thu, 10 Jul 2025 04:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752120559; cv=none; b=M21qk8W07aLvOeCoVFTgIU1ykc5r7LJ2AhvGs/kIw1GX458Dy/EKPfiaav4NZPhKNF8JYCbCgNFvwPMsXtiEYm7LWms3UP3vj/Gknt+TwXZYzKz+fmZrQ8rz/kmqlx8FMyrzkN6If6XXvOmFvyS7o1gtcMOslGg0mtl4v6AhTac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752120559; c=relaxed/simple;
	bh=pzhwqPznC/Xf36ItroQkxv6qtOU8kyDNDd4ow7ZRJiU=;
	h=Date:To:From:Subject:Message-Id; b=lc9PzLZb1oPwu9So8PE+is06uCE+vfykZ2btvizvBaL6+YDaZ5G5TLlBqqk+xlQNsGV6oL53YbkpqEEjJP2OJpifJbhIAVi4LTE63XSHaOf74gRpycdVBrM7H4rn/IEQoCzkf+XxD+l6FUVJKDkUp41mB93KhyeHrPjZC6IXC50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hMO2Rsk2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hMO2Rsk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1FDC4CEE3;
	Thu, 10 Jul 2025 04:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752120559;
	bh=pzhwqPznC/Xf36ItroQkxv6qtOU8kyDNDd4ow7ZRJiU=;
	h=Date:To:From:Subject:From;
	b=hMO2Rsk2SwRc8F4D8BVZOeg7g0bjYcyQmlDM1DCHSLFGOZTq0+A3l5Wx76Qjk4OUm
	 FwxyVTRbT4w/oRJFR+V7qYYsJ4FtYw0EI8lOnT+XVSMjXwrT6CtlQa2lvgyfK6ywQ1
	 nhqoPVK777Es8KthrPwdzohoTq5o3IEAT6pmId5Y=
Date: Wed, 09 Jul 2025 21:09:18 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,honggyu.kim@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] samples-damon-fix-damon-sample-prcl-for-start-failure.patch removed from -mm tree
Message-Id: <20250710040919.5B1FDC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon: fix damon sample prcl for start failure
has been removed from the -mm tree.  Its filename was
     samples-damon-fix-damon-sample-prcl-for-start-failure.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Honggyu Kim <honggyu.kim@sk.com>
Subject: samples/damon: fix damon sample prcl for start failure
Date: Wed, 2 Jul 2025 09:02:01 +0900

Patch series "mm/damon: fix divide by zero and its samples", v3.

This series includes fixes against damon and its samples to make it safer
when damon sample starting fails.

It includes the following changes.
- fix unexpected divide by zero crash for zero size regions
- fix bugs for damon samples in case of start failures


This patch (of 4):

The damon_sample_prcl_start() can fail so we must reset the "enable"
parameter to "false" again for proper rollback.

In such cases, setting Y to "enable" then N triggers the following crash
because damon sample start failed but the "enable" stays as Y.

  [ 2441.419649] damon_sample_prcl: start
  [ 2454.146817] damon_sample_prcl: stop
  [ 2454.146862] ------------[ cut here ]------------
  [ 2454.146865] kernel BUG at mm/slub.c:546!
  [ 2454.148183] Oops: invalid opcode: 0000 [#1] SMP NOPTI
  	...
  [ 2454.167555] Call Trace:
  [ 2454.167822]  <TASK>
  [ 2454.168061]  damon_destroy_ctx+0x78/0x140
  [ 2454.168454]  damon_sample_prcl_enable_store+0x8d/0xd0
  [ 2454.168932]  param_attr_store+0xa1/0x120
  [ 2454.169315]  module_attr_store+0x20/0x50
  [ 2454.169695]  sysfs_kf_write+0x72/0x90
  [ 2454.170065]  kernfs_fop_write_iter+0x150/0x1e0
  [ 2454.170491]  vfs_write+0x315/0x440
  [ 2454.170833]  ksys_write+0x69/0xf0
  [ 2454.171162]  __x64_sys_write+0x19/0x30
  [ 2454.171525]  x64_sys_call+0x18b2/0x2700
  [ 2454.171900]  do_syscall_64+0x7f/0x680
  [ 2454.172258]  ? exit_to_user_mode_loop+0xf6/0x180
  [ 2454.172694]  ? clear_bhb_loop+0x30/0x80
  [ 2454.173067]  ? clear_bhb_loop+0x30/0x80
  [ 2454.173439]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Link: https://lkml.kernel.org/r/20250702000205.1921-1-honggyu.kim@sk.com
Link: https://lkml.kernel.org/r/20250702000205.1921-2-honggyu.kim@sk.com
Fixes: 2aca254620a8 ("samples/damon: introduce a skeleton of a smaple DAMON module for proactive reclamation")
Signed-off-by: Honggyu Kim <honggyu.kim@sk.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/prcl.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/samples/damon/prcl.c~samples-damon-fix-damon-sample-prcl-for-start-failure
+++ a/samples/damon/prcl.c
@@ -122,8 +122,12 @@ static int damon_sample_prcl_enable_stor
 	if (enable == enabled)
 		return 0;
 
-	if (enable)
-		return damon_sample_prcl_start();
+	if (enable) {
+		err = damon_sample_prcl_start();
+		if (err)
+			enable = false;
+		return err;
+	}
 	damon_sample_prcl_stop();
 	return 0;
 }
_

Patches currently in -mm which might be from honggyu.kim@sk.com are

samples-damon-change-enable-parameters-to-enabled.patch

