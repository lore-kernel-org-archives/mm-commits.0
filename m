Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB46617DFFF
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 19:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725908566; cv=none; b=uqK46r6RsO9pLwbEnk4BjuXiVwhojk4XaUcVJGaXSYEJn2xNRPF6wRS2niW8kgNkYLY05zKtjTAqCvJ9b8AWgGYM9Be0qNeT75pRrJfK4NXbJ8og73ipY5yFRfAhixVBm1F7Tas4nUuVn79W3JNL4PEtwuukQzmttG9EhUpcczw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725908566; c=relaxed/simple;
	bh=Q+K1dqWofEQUkvicrHMs77PXP/tmJ8pRb9QszOeItW4=;
	h=Date:To:From:Subject:Message-Id; b=WN9ElBwdvy2wHQbEqRKv87Xxf9hW/7udN1go/JcHm4NOOePPk06QVdwOP1Pt+lkcdyrheo3AYNChr8vSSx5Ojn/6rthBZ0LQYvI+XPAJQ/utzJqRuk6if+gszAPB2bcTUmeRc1+hpUYZb8ct3pIOoOL4H1d54DV6HHMlPkfdM+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Be4/aKPh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Be4/aKPh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6C9C4CEC5;
	Mon,  9 Sep 2024 19:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725908566;
	bh=Q+K1dqWofEQUkvicrHMs77PXP/tmJ8pRb9QszOeItW4=;
	h=Date:To:From:Subject:From;
	b=Be4/aKPh8kIlxYkYkR6s1flppjzGO/zKV+/DGRbqa60oxZewKiQcs+f1lmuAZfK2Y
	 Q56S/B5FfKkjB8fdg52kY3PDpplE3mW6y9bO7eSbU3e9P7nKhhwpvhZqMYkQKaHoep
	 sWe3aAKiffgt0NlGID3UPwY7JBr0ElFkLEioLO4o=
Date: Mon, 09 Sep 2024 12:02:45 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,longman@redhat.com,lizefan.x@bytedance.com,hannes@cmpxchg.org,chenridong@huawei.com,mkoutny@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + cgroup-do-not-report-unavailable-v1-controllers-in-proc-cgroups.patch added to mm-unstable branch
Message-Id: <20240909190246.5A6C9C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: cgroup: do not report unavailable v1 controllers in /proc/cgroups
has been added to the -mm mm-unstable branch.  Its filename is
     cgroup-do-not-report-unavailable-v1-controllers-in-proc-cgroups.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cgroup-do-not-report-unavailable-v1-controllers-in-proc-cgroups.patch

This patch will later appear in the mm-unstable branch at
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
From: Michal Koutný <mkoutny@suse.com>
Subject: cgroup: do not report unavailable v1 controllers in /proc/cgroups
Date: Mon, 9 Sep 2024 18:32:23 +0200

This is a followup to CONFIG-urability of cpuset and memory controllers
for v1 hierarchies.  Make the output in /proc/cgroups reflect that
!CONFIG_CPUSETS_V1 is like !CONFIG_CPUSETS and !CONFIG_MEMCG_V1 is like
!CONFIG_MEMCG.

The intended effect is that hiding the unavailable controllers will hint
users not to try mounting them on v1.

Link: https://lkml.kernel.org/r/20240909163223.3693529-5-mkoutny@suse.com
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Cc: Chen Ridong <chenridong@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup/cgroup-v1.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/cgroup/cgroup-v1.c~cgroup-do-not-report-unavailable-v1-controllers-in-proc-cgroups
+++ a/kernel/cgroup/cgroup-v1.c
@@ -681,11 +681,14 @@ int proc_cgroupstats_show(struct seq_fil
 	 * cgroup_mutex contention.
 	 */
 
-	for_each_subsys(ss, i)
+	for_each_subsys(ss, i) {
+		if (cgroup1_subsys_absent(ss))
+			continue;
 		seq_printf(m, "%s\t%d\t%d\t%d\n",
 			   ss->legacy_name, ss->root->hierarchy_id,
 			   atomic_read(&ss->root->nr_cgrps),
 			   cgroup_ssid_enabled(i));
+	}
 
 	return 0;
 }
_

Patches currently in -mm which might be from mkoutny@suse.com are

memcg-cleanup-with-config_memcg_v1.patch
cgroup-cpuset-expose-cpuset-filesystem-with-cpuset-v1-only.patch
cgroup-disallow-mounting-v1-hierarchies-without-controller-implementation.patch
cgroup-do-not-report-unavailable-v1-controllers-in-proc-cgroups.patch

