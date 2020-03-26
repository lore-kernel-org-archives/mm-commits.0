From: akpm@linux-foundation.org
Subject: [nacked]
 kernel-taskstats-fix-wrong-nla-type-for-cgrouptaskstats-policy.patch
 removed from -mm tree
Date: Thu, 26 Mar 2020 14:10:40 -0700
Message-ID: <20200326211040.hNgjZeDBN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728138AbgCZVKn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 26 Mar 2020 17:10:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bsingharora@gmail.com, davem@davemloft.net, dsahern@gmail.com, johannes@sipsolutions.net, laoar.shao@gmail.com, mm-commits@vger.kernel.org, stable@vger.kernel.org


The patch titled
     Subject: kernel/taskstats: fix wrong nla type for {cgroup,task}stats policy
has been removed from the -mm tree.  Its filename was
     kernel-taskstats-fix-wrong-nla-type-for-cgrouptaskstats-policy.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: kernel/taskstats: fix wrong nla type for {cgroup,task}stats policy

After our server is upgraded to a newer kernel, we found that it
continuesly print a warning in the kernel message.  The warning is,

[832984.946322] netlink: 'irmas.lc': attribute type 1 has an invalid length.

irmas.lc is one of our container monitor daemons, and it will use
CGROUPSTATS_CMD_GET to get the cgroupstats, that is similar with
tools/accounting/getdelays.c.  We can also produce this warning with
getdelays.  For example, after running below command

	$ ./getdelays -C /sys/fs/cgroup/memory

then you can find a warning in dmesg,
[61607.229318] netlink: 'getdelays': attribute type 1 has an invalid length.

This warning is introduced in commit 6e237d099fac ("netlink: Relax attr
validation for fixed length types"), which is used to check whether
attributes using types NLA_U* and NLA_S* have an exact length.

Regarding this issue, the root cause is cgroupstats_cmd_get_policy defines
a wrong type as NLA_U32, while it should be NLA_NESTED an its minimal
length is NLA_HDRLEN.  That is similar to taskstats_cmd_get_policy.

As this behavior change really breaks our application, we'd better cc
stable as well.

Link: http://lkml.kernel.org/r/1585191042-9935-1-git-send-email-laoar.shao@gmail.com
Fixes: 6e237d099fac ("netlink: Relax attr validation for fixed length types")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/taskstats.c~kernel-taskstats-fix-wrong-nla-type-for-cgrouptaskstats-policy
+++ a/kernel/taskstats.c
@@ -35,8 +35,8 @@ struct kmem_cache *taskstats_cache;
 static struct genl_family family;
 
 static const struct nla_policy taskstats_cmd_get_policy[TASKSTATS_CMD_ATTR_MAX+1] = {
-	[TASKSTATS_CMD_ATTR_PID]  = { .type = NLA_U32 },
-	[TASKSTATS_CMD_ATTR_TGID] = { .type = NLA_U32 },
+	[TASKSTATS_CMD_ATTR_PID]  = { .type = NLA_NESTED },
+	[TASKSTATS_CMD_ATTR_TGID] = { .type = NLA_NESTED },
 	[TASKSTATS_CMD_ATTR_REGISTER_CPUMASK] = { .type = NLA_STRING },
 	[TASKSTATS_CMD_ATTR_DEREGISTER_CPUMASK] = { .type = NLA_STRING },};
 
@@ -45,7 +45,7 @@ static const struct nla_policy taskstats
  * Make sure they are always aligned.
  */
 static const struct nla_policy cgroupstats_cmd_get_policy[TASKSTATS_CMD_ATTR_MAX+1] = {
-	[CGROUPSTATS_CMD_ATTR_FD] = { .type = NLA_U32 },
+	[CGROUPSTATS_CMD_ATTR_FD] = { .type = NLA_NESTED },
 };
 
 struct listener {
_

Patches currently in -mm which might be from laoar.shao@gmail.com are

mm-memcg-fix-build-error-around-the-usage-of-kmem_caches.patch
