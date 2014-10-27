From: akpm@linux-foundation.org
Subject: + cpuset-simplify-cpuset_node_allowed-api-fix.patch added to -mm
 tree
Date: Mon, 27 Oct 2014 15:24:31 -0700
Message-ID: <544ec61f.Z8JqGUhCoZxIN2ie%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40897 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbaJ0WYa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Oct 2014 18:24:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, lizefan@huawei.com, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cpuset: lock vs unlock typo
has been added to the -mm tree.  Its filename is
     cpuset-simplify-cpuset_node_allowed-api-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cpuset-simplify-cpuset_node_allowed-api-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cpuset-simplify-cpuset_node_allowed-api-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

rtc-pm8xxx-rework-to-support-pm8941-rtc-fix.patch
ocfs2-fix-an-off-by-one-bug_on-statement.patch
cpuset-simplify-cpuset_node_allowed-api-fix.patch
decompress_bunzip2-off-by-one-in-get_next_block.patch
linux-next.patch

