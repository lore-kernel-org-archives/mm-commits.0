From: akpm@linux-foundation.org
Subject: +
 kernel-taskstats-fix-wrong-nla-type-for-cgrouptaskstats-policy.patch added
 to -mm tree
Date: Thu, 26 Mar 2020 13:05:02 -0700
Message-ID: <20200326200502.2a5joA7oB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727612AbgCZUFD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 26 Mar 2020 16:05:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bsingharora@gmail.com, davem@davemloft.net, dsahern@gmail.com, johannes@sipsolutions.net, laoar.shao@gmail.com, mm-commits@vger.kernel.org, stable@vger.kernel.org


The patch titled
     Subject: kernel/taskstats: fix wrong nla type for {cgroup,task}stats policy
has been added to the -mm tree.  Its filename is
     kernel-taskstats-fix-wrong-nla-type-for-cgrouptaskstats-policy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-taskstats-fix-wrong-nla-type-for-cgrouptaskstats-policy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-taskstats-fix-wrong-nla-type-for-cgrouptaskstats-policy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: kernel/taskstats: fix wrong nla type for {cgroup,task}stats policy

After our server is upgraded to a newer kernel, we found that it
continuesly print a warning in the kernel message.  The warning is,

[832984.946322] netlink: 'irmas.lc': attribute type 1 has an invalid length.

irmas.lc is one of our container monitor daemons, and it will use
CGROUPSTATS_CMD_GET to get the cgroupstats, that is similar with
tools/accounting/getdelays.c.  We can also produce this warning with
getdelays.  For example, after running bellow command

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

kernel-taskstats-fix-wrong-nla-type-for-cgrouptaskstats-policy.patch
mm-memcg-fix-build-error-around-the-usage-of-kmem_caches.patch
