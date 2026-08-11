Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA64267B89;
	Tue, 11 Aug 2026 04:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786421281; cv=none; b=VQKgdTERSVO2/mCkOMTeJUI8WvhOt8Mya11bj/NlldJqgY0Isn0wdLK22zWX3p6vGVSLgOGLZyCIuqqnzLZNLohGGiscgk9xqRB/my7jcaLLglGEMfO0Qle1xv+JFjrXFqr1V2N3pbqZ5BXZuv+OQJxfH7QQ5U5ENFMHo9vmdwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786421281; c=relaxed/simple;
	bh=GH5m6+Ldts+SGo6QuZO4Ij8ymzr3iZQxTQjWfoWF/KE=;
	h=Date:To:From:Subject:Message-Id; b=o1H8epQ/MIuP/KLLZ5DD/SMXNXLZFogQ2f+RhJMGuysNqiMP2q8e34z5pTo8yq1ZE0+lVQrkP/OuU3JGLYRn5Tuc8+iSN9mblM2ITd8lNMXlc8Oc83zggmFXdIRRUrccIYH/UgAzz9rxE5+dsBlPzeaFXQjFVsmtnx3EHiZSCWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h+uJPtI7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h+uJPtI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7FC1F000E9;
	Tue, 11 Aug 2026 04:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786421279;
	bh=zF64x0wmm+8aHcV8TP9oXcETL4UoaYCDC1GtVOnzhzo=;
	h=Date:To:From:Subject;
	b=h+uJPtI7yB34/gLAmi6IUGaZra+HuJFl8Pkp1fl6re7UvxqUXAGKZwSrFasv6wJw3
	 0RHgIaar24KTZxpb72dbCuIQCcc1gVAkZ4JjWRZt37TGmbLugoJNxux/WxGOrkD3U5
	 lisI4vfHI9oPDtiyGzgcfzq4ESXnjpuQHy3JGJUI=
Date: Mon, 10 Aug 2026 21:07:58 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,zhangguopeng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memcg-v1-fix-memorymemswfailcnt-accounting.patch removed from -mm tree
Message-Id: <20260811040759.2F7FC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg-v1: fix memory.memsw.failcnt accounting
has been removed from the -mm tree.  Its filename was
     mm-memcg-v1-fix-memorymemswfailcnt-accounting.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: mm: memcg-v1: fix memory.memsw.failcnt accounting
Date: Mon, 10 Aug 2026 15:42:47 +0800

Commit 0e2759afcaf9 ("page_counter: track failcnt only for legacy
cgroups") made failcnt accounting conditional on track_failcnt.  It
enabled the flag for memcg->memory, but not for memcg->memsw.

Consequently, memory.memsw.failcnt remains zero when the memory+swap limit
is hit.  Enable failcnt accounting for the v1 memsw counter.

Reproducer:

    CG=/sys/fs/cgroup/memory/memsw-test
    LIMIT=33554432
    mkdir "$CG"
    echo "$LIMIT" > "$CG/memory.limit_in_bytes"
    echo "$LIMIT" > "$CG/memory.memsw.limit_in_bytes"

Start a child process in the cgroup and make it allocate and touch 96 MiB
of memory, causing a memcg OOM.

    cat "$CG/memory.memsw.failcnt"

Without the patch, memory.memsw.failcnt is 0.  With the patch,
memory.memsw.failcnt is greater than 0.

Link: https://lore.kernel.org/20260810074247.52747-1-guopeng.zhang@linux.dev
Fixes: 0e2759afcaf9 ("page_counter: track failcnt only for legacy cgroups")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memcontrol.c~mm-memcg-v1-fix-memorymemswfailcnt-accounting
+++ a/mm/memcontrol.c
@@ -4180,6 +4180,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 		page_counter_init(&memcg->swap, &parent->swap, false);
 #ifdef CONFIG_MEMCG_V1
 		memcg->memory.track_failcnt = !memcg_on_dfl;
+		memcg->memsw.track_failcnt = !memcg_on_dfl;
 		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
 		page_counter_init(&memcg->kmem, &parent->kmem, false);
 		page_counter_init(&memcg->tcpmem, &parent->tcpmem, false);
_

Patches currently in -mm which might be from zhangguopeng@kylinos.cn are

mm-memcg-v1-fix-memsw-and-tcp-failcnt-accounting.patch
mm-memcg-stop-reclaim-when-a-limit-update-is-superseded.patch

