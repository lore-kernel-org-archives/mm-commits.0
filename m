From: akpm@linux-foundation.org
Subject: + cgroup-list-groupoom-in-cgroup-features.patch added to -mm tree
Date: Thu, 30 Nov 2017 12:40:01 -0800
Message-ID: <5a206ca1.cTHNvT5OTBMbhV7S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53610 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751197AbdK3UkC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2017 15:40:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, tj@kernel.org, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup: list groupoom in cgroup features
has been added to the -mm tree.  Its filename is
     cgroup-list-groupoom-in-cgroup-features.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cgroup-list-groupoom-in-cgroup-features.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cgroup-list-groupoom-in-cgroup-features.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: cgroup: list groupoom in cgroup features

List groupoom in cgroup features list (exported via
/sys/kernel/cgroup/features), which can be used by a userspace apps (most
likely, systemd) to get an idea which cgroup features are supported by
kernel.

Link: http://lkml.kernel.org/r/20171130152824.1591-8-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup/cgroup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/cgroup/cgroup.c~cgroup-list-groupoom-in-cgroup-features kernel/cgroup/cgroup.c
--- a/kernel/cgroup/cgroup.c~cgroup-list-groupoom-in-cgroup-features
+++ a/kernel/cgroup/cgroup.c
@@ -5922,7 +5922,8 @@ static struct kobj_attribute cgroup_dele
 static ssize_t features_show(struct kobject *kobj, struct kobj_attribute *attr,
 			     char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "nsdelegate\n");
+	return snprintf(buf, PAGE_SIZE, "nsdelegate\n"
+					"groupoom\n");
 }
 static struct kobj_attribute cgroup_features_attr = __ATTR_RO(features);
 
_

Patches currently in -mm which might be from guro@fb.com are

mm-show-total-hugetlb-memory-consumption-in-proc-meminfo.patch
mm-oom-refactor-the-oom_kill_process-function.patch
mm-implement-mem_cgroup_scan_tasks-for-the-root-memory-cgroup.patch
mm-oom-cgroup-aware-oom-killer.patch
mm-oom-introduce-memoryoom_group.patch
mm-oom-add-cgroup-v2-mount-option-for-cgroup-aware-oom-killer.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer.patch
cgroup-list-groupoom-in-cgroup-features.patch

