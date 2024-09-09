Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39BB188CC8
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 19:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725908563; cv=none; b=VOKEoXH/xfyMLEGnHFtBe6m74GETfWvDexo9mYeNMAZZZCz7qdOE79xD+fAVPnX9U8U4uohnvQpR09RdOYafJI+aHIglFbWDyjr/8r2P+nuL6tO59vx2+9PWEy4S8h2L5eEievgq0t8v8SdWUJCppOc3CucbgkI9s3tUbalhYIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725908563; c=relaxed/simple;
	bh=PUXTeHBKBQv6u8+ASxwMcKfeR2mlfWZQqYnJDdK0fPw=;
	h=Date:To:From:Subject:Message-Id; b=dRBt4WIyJd8IeUV8Myf5HK3kFkwDpX6/ec4/D+yv9A0fmg/x4hlEtcSSCTFfjIgD9BBRDdSiNI5SHjjGMckgXyignXkzIB1Tq0c2+PCNUwSvXk9Mutcfnqu378Rdw4XzgSBVUcmW/CtnA6MUNmflvKuXSd6rdaFw5/khONNpGDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v2WdoeP0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v2WdoeP0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496DCC4CEC5;
	Mon,  9 Sep 2024 19:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725908562;
	bh=PUXTeHBKBQv6u8+ASxwMcKfeR2mlfWZQqYnJDdK0fPw=;
	h=Date:To:From:Subject:From;
	b=v2WdoeP0hgDhR8bNN9NFyOzw7/RT1StIRxCnrK1/qMharTLvpq+lz1lIQkcNRYXWJ
	 zPGo5XJ2XpApIwDFXCb6Gw175PX4F2rIkzhBP61TaPGT/IqJLR6VuJrbpKNHj2Kkeh
	 XwFZrthwoI1krSimIij4Y7DbI8TV9JTutixZ72P8=
Date: Mon, 09 Sep 2024 12:02:41 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,longman@redhat.com,lizefan.x@bytedance.com,hannes@cmpxchg.org,chenridong@huawei.com,mkoutny@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + cgroup-cpuset-expose-cpuset-filesystem-with-cpuset-v1-only.patch added to mm-unstable branch
Message-Id: <20240909190242.496DCC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: cgroup/cpuset: expose cpuset filesystem with cpuset v1 only
has been added to the -mm mm-unstable branch.  Its filename is
     cgroup-cpuset-expose-cpuset-filesystem-with-cpuset-v1-only.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cgroup-cpuset-expose-cpuset-filesystem-with-cpuset-v1-only.patch

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
Subject: cgroup/cpuset: expose cpuset filesystem with cpuset v1 only
Date: Mon, 9 Sep 2024 18:32:21 +0200

The cpuset filesystem is a legacy interface to cpuset controller with
(pre-)v1 features. It makes little sense to co-mount it on systems
without cpuset v1, so do no build it when cpuset v1 is not built
neither.

Link: https://lkml.kernel.org/r/20240909163223.3693529-3-mkoutny@suse.com
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

 kernel/cgroup/cgroup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/cgroup/cgroup.c~cgroup-cpuset-expose-cpuset-filesystem-with-cpuset-v1-only
+++ a/kernel/cgroup/cgroup.c
@@ -2338,7 +2338,7 @@ static struct file_system_type cgroup2_f
 	.fs_flags		= FS_USERNS_MOUNT,
 };
 
-#ifdef CONFIG_CPUSETS
+#ifdef CONFIG_CPUSETS_V1
 static const struct fs_context_operations cpuset_fs_context_ops = {
 	.get_tree	= cgroup1_get_tree,
 	.free		= cgroup_fs_context_free,
@@ -6187,7 +6187,7 @@ int __init cgroup_init(void)
 	WARN_ON(register_filesystem(&cgroup_fs_type));
 	WARN_ON(register_filesystem(&cgroup2_fs_type));
 	WARN_ON(!proc_create_single("cgroups", 0, NULL, proc_cgroupstats_show));
-#ifdef CONFIG_CPUSETS
+#ifdef CONFIG_CPUSETS_V1
 	WARN_ON(register_filesystem(&cpuset_fs_type));
 #endif
 
_

Patches currently in -mm which might be from mkoutny@suse.com are

memcg-cleanup-with-config_memcg_v1.patch
cgroup-cpuset-expose-cpuset-filesystem-with-cpuset-v1-only.patch
cgroup-disallow-mounting-v1-hierarchies-without-controller-implementation.patch
cgroup-do-not-report-unavailable-v1-controllers-in-proc-cgroups.patch

