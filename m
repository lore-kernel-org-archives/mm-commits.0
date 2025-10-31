Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA9D274B30;
	Fri, 31 Oct 2025 03:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761881393; cv=none; b=iozhhCNYaLbxV8Q4LP0rAZ22ZPPOC6aNXRwC1bD/1fwFapQtI7ouGqZS3xIO6pxQ08xINlM12E1N+atH5yeuO53djCT/xy3JngMZuSBC8dhooUz3pqJKyG9bFT/7jtvov6a0oUnFWDAPYMbAVxYVszH3WGa2gwSRzX6Ilwkjjys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761881393; c=relaxed/simple;
	bh=tOp+KRVH2sLltKtt6CMWxaH3Av4wegBgKUKCf/CTyEo=;
	h=Date:To:From:Subject:Message-Id; b=Qr/y/lZeJ4APpuUPHWKDhR3QwunSbfFi4cNXMoHTgtSMP8JMh8g5OXGX451waElaepA0r/+K4qfhpbKULPrMNhvE1kqOtX0JJl6uD9hXZg/B7zo+0SbwJF4yxvY1fPvdyJfIZn2swhkKhtgKeg568ZTI0WtKLSR1OkoZebJPQDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CkMI+lT5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CkMI+lT5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232E8C113D0;
	Fri, 31 Oct 2025 03:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761881393;
	bh=tOp+KRVH2sLltKtt6CMWxaH3Av4wegBgKUKCf/CTyEo=;
	h=Date:To:From:Subject:From;
	b=CkMI+lT5dKKfziI8gEoCOIod4BnOdLS6EuZdg4v0hwQ0INQsjScz5+JUfkHl+YyyW
	 28NuUGgzOsLmseXmgXOzCo2ISqSqwwgQN6y3LAdWuN/STEXyWAU+Z71QNHNKY2gbZZ
	 IK9OVV42BW2J7PhjFgdmQ/4NcTRZ0g0ApZpVTtAM=
Date: Thu, 30 Oct 2025 20:29:52 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,wangkefeng.wang@huawei.com,stable@vger.kernel.org,sj@kernel.org,yanquanmin1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-change-next_update_jiffies-to-a-global-variable.patch added to mm-hotfixes-unstable branch
Message-Id: <20251031032953.232E8C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: change next_update_jiffies to a global variable
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-sysfs-change-next_update_jiffies-to-a-global-variable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-change-next_update_jiffies-to-a-global-variable.patch

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
From: Quanmin Yan <yanquanmin1@huawei.com>
Subject: mm/damon/sysfs: change next_update_jiffies to a global variable
Date: Thu, 30 Oct 2025 10:07:46 +0800

In DAMON's damon_sysfs_repeat_call_fn(), time_before() is used to compare
the current jiffies with next_update_jiffies to determine whether to
update the sysfs files at this moment.

On 32-bit systems, the kernel initializes jiffies to "-5 minutes" to make
jiffies wrap bugs appear earlier. However, this causes time_before() in
damon_sysfs_repeat_call_fn() to unexpectedly return true during the first
5 minutes after boot on 32-bit systems (see [1] for more explanation,
which fixes another jiffies-related issue before). As a result, DAMON
does not update sysfs files during that period.

There is also an issue unrelated to the system's word size[2]: if the
user stops DAMON just after next_update_jiffies is updated and restarts
it after 'refresh_ms' or a longer delay, next_update_jiffies will retain
an older value, causing time_before() to return false and the update to
happen earlier than expected.

Fix these issues by making next_update_jiffies a global variable and
initializing it each time DAMON is started.

Link: https://lkml.kernel.org/r/20251030020746.967174-3-yanquanmin1@huawei.com
Link: https://lkml.kernel.org/r/20250822025057.1740854-1-ekffu200098@gmail.com [1]
Link: https://lore.kernel.org/all/20251029013038.66625-1-sj@kernel.org/ [2]
Fixes: d809a7c64ba8 ("mm/damon/sysfs: implement refresh_ms file internal work")
Suggested-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: ze zuo <zuoze1@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-change-next_update_jiffies-to-a-global-variable
+++ a/mm/damon/sysfs.c
@@ -1552,16 +1552,17 @@ static struct damon_ctx *damon_sysfs_bui
 	return ctx;
 }
 
+static unsigned long damon_sysfs_next_update_jiffies;
+
 static int damon_sysfs_repeat_call_fn(void *data)
 {
 	struct damon_sysfs_kdamond *sysfs_kdamond = data;
-	static unsigned long next_update_jiffies;
 
 	if (!sysfs_kdamond->refresh_ms)
 		return 0;
-	if (time_before(jiffies, next_update_jiffies))
+	if (time_before(jiffies, damon_sysfs_next_update_jiffies))
 		return 0;
-	next_update_jiffies = jiffies +
+	damon_sysfs_next_update_jiffies = jiffies +
 		msecs_to_jiffies(sysfs_kdamond->refresh_ms);
 
 	if (!mutex_trylock(&damon_sysfs_lock))
@@ -1607,6 +1608,9 @@ static int damon_sysfs_turn_damon_on(str
 	}
 	kdamond->damon_ctx = ctx;
 
+	damon_sysfs_next_update_jiffies =
+		jiffies + msecs_to_jiffies(kdamond->refresh_ms);
+
 	repeat_call_control->fn = damon_sysfs_repeat_call_fn;
 	repeat_call_control->data = kdamond;
 	repeat_call_control->repeat = true;
_

Patches currently in -mm which might be from yanquanmin1@huawei.com are

mm-damon-stat-change-last_refresh_jiffies-to-a-global-variable.patch
mm-damon-sysfs-change-next_update_jiffies-to-a-global-variable.patch
mm-damon-add-a-min_sz_region-parameter-to-damon_set_region_biggest_system_ram_default.patch
mm-damon-reclaim-use-min_sz_region-for-core-address-alignment-when-setting-regions.patch

