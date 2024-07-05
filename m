Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4525DBA47
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141622; cv=none; b=m2fy1kKXqEBR8r6J85jZ1KvSkVjO6qU5zkeZl72EppnCtfl/6bTCBt5TZp9h96eF0jmbod8Klp54j9fK2QlH6SxIiTqvXMP8KWJjghoAGdSN2gdwP9pht7hxmp6fZeAUcc0lj6zpjkCCGLd44+yzvtKYY3w+w48J+7dCqmqptY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141622; c=relaxed/simple;
	bh=QXM0iYyTE6Vx7+qrnU8O5jWGw/Hm8vct01y4UdJZkJk=;
	h=Date:To:From:Subject:Message-Id; b=uHpaA2a9QjobTSENVU+0vmmWI3jwahhqS1mQTQFtGgSyUBg+MdtQied8ifXDiUOJ7df1VXjnwfmOhzgUgiI3JRvSZN+3wNIF86OEQ2Yb5WxX44373Q5O6kE60CzlUSzWDXEHJxjvHzxv2BWkcdeUpbLeO2LlOykF+Uqq5HNIL6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K3AeH0SD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K3AeH0SD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E9DC3277B;
	Fri,  5 Jul 2024 01:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141622;
	bh=QXM0iYyTE6Vx7+qrnU8O5jWGw/Hm8vct01y4UdJZkJk=;
	h=Date:To:From:Subject:From;
	b=K3AeH0SDzQaOv1xGeWz6DkNUhwcbZN/7vZSXx0i4oHGK3Kyd5NpiNhXMKFJwTxUQr
	 Om7OWGtY42UpkbSXAK0gsk5nMNilYpDyZNcPF6KV1mkiOrGJcvqq4JZQ8FuXe5Q6bC
	 gPXN5/2YITV0uY8fBhjKLB7/paMBwMK5DlwQSnS4=
Date: Thu, 04 Jul 2024 18:07:01 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-guard-cgroup-v1-specific-code-in-mem_cgroup_print_oom_meminfo.patch removed from -mm tree
Message-Id: <20240705010702.19E9DC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: guard cgroup v1-specific code in mem_cgroup_print_oom_meminfo()
has been removed from the -mm tree.  Its filename was
     mm-memcg-guard-cgroup-v1-specific-code-in-mem_cgroup_print_oom_meminfo.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcg: guard cgroup v1-specific code in mem_cgroup_print_oom_meminfo()
Date: Fri, 28 Jun 2024 21:03:11 +0000

Put cgroup v1-specific code in mem_cgroup_print_oom_meminfo() under
CONFIG_MEMCG_V1.

Link: https://lkml.kernel.org/r/20240628210317.272856-4-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memcontrol.c~mm-memcg-guard-cgroup-v1-specific-code-in-mem_cgroup_print_oom_meminfo
+++ a/mm/memcontrol.c
@@ -1535,6 +1535,7 @@ void mem_cgroup_print_oom_meminfo(struct
 		pr_info("swap: usage %llukB, limit %llukB, failcnt %lu\n",
 			K((u64)page_counter_read(&memcg->swap)),
 			K((u64)READ_ONCE(memcg->swap.max)), memcg->swap.failcnt);
+#ifdef CONFIG_MEMCG_V1
 	else {
 		pr_info("memory+swap: usage %llukB, limit %llukB, failcnt %lu\n",
 			K((u64)page_counter_read(&memcg->memsw)),
@@ -1543,6 +1544,7 @@ void mem_cgroup_print_oom_meminfo(struct
 			K((u64)page_counter_read(&memcg->kmem)),
 			K((u64)memcg->kmem.max), memcg->kmem.failcnt);
 	}
+#endif
 
 	pr_info("Memory cgroup stats for ");
 	pr_cont_cgroup_path(memcg->css.cgroup);
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcg-drop-obsolete-cache-line-padding-in-struct-mem_cgroup.patch
mm-memcg-add-cache-line-padding-to-mem_cgroup_per_node.patch

