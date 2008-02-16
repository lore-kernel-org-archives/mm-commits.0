From: akpm@linux-foundation.org
Subject: - drivers-cpufreq-add-calls-to-cpufreq_cpu_put.patch removed from -mm tree
Date: Fri, 15 Feb 2008 19:52:05 -0800
Message-ID: <200802160352.m1G3q5tg007150@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46567 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758749AbYBPDwT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 22:52:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     drivers/cpufreq: add calls to cpufreq_cpu_put
has been removed from the -mm tree.  Its filename was
     drivers-cpufreq-add-calls-to-cpufreq_cpu_put.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/cpufreq: add calls to cpufreq_cpu_put
From: Julia Lawall <julia@diku.dk>

A call to cpufreq_cpu_get should be matched by a call to cpufreq_cpu_put.

The problem was fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
identifier E;
expression E1, E2;
int ret;
statement S;
@@

  T E;
  ... when any
(
  E = cpufreq_cpu_get(...);
  if (E == NULL) S
|
  if ((E = cpufreq_cpu_get(...)) == NULL) S
)
  ... when != E2 = E
      when strict
(
  cpufreq_cpu_put(E);
|
  E1 = E;
|
+ cpufreq_cpu_put(E);
  return;
|
+ cpufreq_cpu_put(E);
  return ret;
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/cpufreq/cpufreq.c~drivers-cpufreq-add-calls-to-cpufreq_cpu_put drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~drivers-cpufreq-add-calls-to-cpufreq_cpu_put
+++ a/drivers/cpufreq/cpufreq.c
@@ -676,8 +676,10 @@ static ssize_t show(struct kobject * kob
 	if (!policy)
 		return -EINVAL;
 
-	if (lock_policy_rwsem_read(policy->cpu) < 0)
+	if (lock_policy_rwsem_read(policy->cpu) < 0) {
+		cpufreq_cpu_put(policy);
 		return -EINVAL;
+	}
 
 	if (fattr->show)
 		ret = fattr->show(policy, buf);
@@ -700,8 +702,10 @@ static ssize_t store(struct kobject * ko
 	if (!policy)
 		return -EINVAL;
 
-	if (lock_policy_rwsem_write(policy->cpu) < 0)
+	if (lock_policy_rwsem_write(policy->cpu) < 0) {
+		cpufreq_cpu_put(policy);
 		return -EINVAL;
+	}
 
 	if (fattr->store)
 		ret = fattr->store(policy, buf, count);
_

Patches currently in -mm which might be from julia@diku.dk are

git-hid.patch
git-net.patch
drivers-net-mv643xx_ethc-use-field_sizeof.patch
drivers-block-viodasdc-use-field_sizeof.patch
