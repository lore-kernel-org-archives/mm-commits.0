From: akpm@linux-foundation.org
Subject: [merged] cpuset-simplify-cpuset_node_allowed-api-fix.patch
 removed from -mm tree
Date: Wed, 29 Oct 2014 11:23:07 -0700
Message-ID: <5451308b.BpiWRGY2Kz4oJZs5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093AbaJ2SXG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Oct 2014 14:23:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, lizefan@huawei.com, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cpuset: lock vs unlock typo
has been removed from the -mm tree.  Its filename was
     cpuset-simplify-cpuset_node_allowed-api-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: cpuset: lock vs unlock typo

This will deadlock instead of unlocking.

Fixes: f73eae8d8384 ('cpuset: simplify cpuset_node_allowed API')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Zefan Li <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cpuset.c~cpuset-simplify-cpuset_node_allowed-api-fix kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-simplify-cpuset_node_allowed-api-fix
+++ a/kernel/cpuset.c
@@ -1992,7 +1992,7 @@ static int cpuset_css_online(struct cgro
 	spin_lock_irq(&callback_lock);
 	cs->mems_allowed = parent->mems_allowed;
 	cpumask_copy(cs->cpus_allowed, parent->cpus_allowed);
-	spin_lock_irq(&callback_lock);
+	spin_unlock_irq(&callback_lock);
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
 	return 0;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-fix.patch
ocfs2-fix-an-off-by-one-bug_on-statement.patch
rtc-pcf8563-remove-leftover-code.patch
rtc-pcf8563-fix-write-of-invalid-bits-to-st2-reg.patch
rtc-pcf8563-fix-wrong-time-from-read_alarm.patch
rtc-pcf8563-handle-consequeces-of-lacking-second-alarm-reg.patch
rtc-pcf8563-save-battery-power.patch
rtc-pcf8563-clear-expired-alarm-at-boot-time.patch
decompress_bunzip2-off-by-one-in-get_next_block.patch
linux-next.patch

