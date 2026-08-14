Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4F028B7DA;
	Fri, 14 Aug 2026 01:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786669724; cv=none; b=EsD4l8CYi57mVfWdZv3lKVouB64+nli/bChnmp+a7HA8yrNwSDuxOw2mv4KMC4E7l5+a/hSNnSbQriqe5cBjoqUqZ753KbivLIHWRBU7AUOfDQ2Z5pPytMlutZH3A48CDoEJl/Q5QFFUIxRHJoyr1F8sTJiqeDAZX3EIMks4bJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786669724; c=relaxed/simple;
	bh=FkX7hfYzDAO875NrbG+0fplVj8ythYAVgAtqGNV8r7Y=;
	h=Date:To:From:Subject:Message-Id; b=e2kGkOo6eJtfte6cWryQWkXGwjyXjpjKzqP+aYJTbIz0JbALyxAT6y+nlYwUyJQ0KMdMDBiHm1Ot7Zqapvsf8mmfC29k56x8CPkEl76TBeQPpqT5fDOPr/HYVjX1Q8jR8WSoZGQ22vtC1/FIfgav2XJDXWDeCu517Pi/JrtDxvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vu1h/it1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vu1h/it1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BFE1F00A3A;
	Fri, 14 Aug 2026 01:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786669722;
	bh=mAFg6Mv5n4LO5mDjWGG5dwgLV9mdovqnkicwiJMkw7Y=;
	h=Date:To:From:Subject;
	b=vu1h/it1MFOh4IDVxh5OB2PnbFsR6+H5gKtU+lD1njKpgHpLvMGWvIlnAuXUpiB5d
	 +GeaB7rxqk7qULv2c0RFPyRqN2v+ExUxIbnkFYLLWuhdJEto9eKzeWFJt6D2P7aWPe
	 znOMYTNxd7QruUMYYgcUvzKkzMcxO2s/b1FSzYIc=
Date: Thu, 13 Aug 2026 18:08:42 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,cuitao@kylinos.cn,zhangguopeng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memcg-v1-fix-memsw-and-tcp-failcnt-accounting.patch removed from -mm tree
Message-Id: <20260814010842.C9BFE1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg-v1: fix memsw and TCP failcnt accounting
has been removed from the -mm tree.  Its filename was
     mm-memcg-v1-fix-memsw-and-tcp-failcnt-accounting.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: mm: memcg-v1: fix memsw and TCP failcnt accounting
Date: Tue, 11 Aug 2026 11:08:43 +0800

Commit 0e2759afcaf9 ("page_counter: track failcnt only for legacy
cgroups") made failcnt accounting conditional on track_failcnt.  It
enabled the flag for memcg->memory, but not for memcg->memsw or
memcg->tcpmem.

Consequently, memory.memsw.failcnt remains zero when the memory+swap limit
is hit.  memory.kmem.tcp.limit_in_bytes still sets memcg->tcpmem.max, but
TCP charge failures are not reflected in memory.kmem.tcp.failcnt.

Enable failcnt accounting for both v1 counters.

To reproduce memory.memsw.failcnt:

    CG=/sys/fs/cgroup/memory/memsw-test
    LIMIT=33554432
    mkdir "$CG"
    echo "$LIMIT" > "$CG/memory.limit_in_bytes"
    echo "$LIMIT" > "$CG/memory.memsw.limit_in_bytes"

Start a child process in the cgroup and make it allocate and touch 96 MiB
of memory, causing a memcg OOM.

    cat "$CG/memory.memsw.failcnt"

Without the patch, memory.memsw.failcnt is 0. With the patch,
memory.memsw.failcnt is greater than 0.

To reproduce memory.kmem.tcp.failcnt:

    CG=/sys/fs/cgroup/memory/tcpmem-test
    LIMIT=65536
    mkdir "$CG"
    echo "$LIMIT" > "$CG/memory.kmem.tcp.limit_in_bytes"

Start a child process in the cgroup, create a TCP socket, and reserve
1 MiB of socket memory with SO_RESERVE_MEM. The reservation fails with
ENOMEM.

    cat "$CG/memory.kmem.tcp.failcnt"

Without the patch, memory.kmem.tcp.failcnt is 0.  With the patch,
memory.kmem.tcp.failcnt is greater than 0.

Link: https://lore.kernel.org/20260811030843.109104-1-guopeng.zhang@linux.dev
Closes: https://sashiko.dev/#/patchset/20260810074247.52747-1-guopeng.zhang@linux.dev?part=1
Fixes: 0e2759afcaf9 ("page_counter: track failcnt only for legacy cgroups")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Tao Cui <cuitao@kylinos.cn>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memcontrol.c~mm-memcg-v1-fix-memsw-and-tcp-failcnt-accounting
+++ a/mm/memcontrol.c
@@ -4180,9 +4180,11 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 		page_counter_init(&memcg->swap, &parent->swap, false);
 #ifdef CONFIG_MEMCG_V1
 		memcg->memory.track_failcnt = !memcg_on_dfl;
+		memcg->memsw.track_failcnt = !memcg_on_dfl;
 		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
 		page_counter_init(&memcg->kmem, &parent->kmem, false);
 		page_counter_init(&memcg->tcpmem, &parent->tcpmem, false);
+		memcg->tcpmem.track_failcnt = !memcg_on_dfl;
 #endif
 	} else {
 		init_memcg_stats();
_

Patches currently in -mm which might be from zhangguopeng@kylinos.cn are

mm-memcg-stop-reclaim-when-a-limit-update-is-superseded.patch

