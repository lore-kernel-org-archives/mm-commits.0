Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01844399F1;
	Mon, 10 Aug 2026 18:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786387676; cv=none; b=BYjuz+VkmsKaPWiq53Hb6IHQWeDkJIRaZxIetDsZMcS0+zeezlJ0LfEudFZa9dO/C0gTYtXYiJqMvSWgJo11qCt0VFHG62p6AzhOhVBoVqFZE0HHO9SRFnH+rFKCTcnAX2AS6IVOSGRQgIGQB5aW2JG+ATQMqCtyOBgsLWEzBD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786387676; c=relaxed/simple;
	bh=/aZzg0H0U5SKGqC7+U/KTrxjJnstDAABM/+PycgWCaI=;
	h=Date:To:From:Subject:Message-Id; b=RIK6mnUMGQ91lxLSo0mzPvgkzcnbsygJj/0ThCJ+mn8K25u3Ekjgi9Du19LhWo36fzKXp5AxFlaeAEq813rmwRaVAQy+VacUOyy4NIRWRPJIR6lCkN5V6qV+v3A6uBMLFSvWuJWfNN9VvPbLl7ay9jFM0l4cMtBCgDY40Bg7NcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ePd8TpLJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ePd8TpLJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5506D1F00A3A;
	Mon, 10 Aug 2026 18:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786387674;
	bh=Y9YHIPKHxXm6mhUQspGSsMkSuSL0Gkbm37/CpTIbGKI=;
	h=Date:To:From:Subject;
	b=ePd8TpLJ2k10/oz/FfBdkgMKI2XVd5ZrVgPpnjRn25SYoxneo8ylmlEOkSEWswKts
	 qQMF+z2OLisoyJQQOZMtI1H2fI+oFo6YbNZrcXFhz/kWV1YzdjJCjBVubo/xN2pT0M
	 1C2l0/eCnHCUje2892h7Hso0exxfzFEOIa3mg5pc=
Date: Mon, 10 Aug 2026 11:47:53 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,zhangguopeng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-v1-fix-memorymemswfailcnt-accounting.patch added to mm-hotfixes-unstable branch
Message-Id: <20260810184754.5506D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg-v1: fix memory.memsw.failcnt accounting
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memcg-v1-fix-memorymemswfailcnt-accounting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-v1-fix-memorymemswfailcnt-accounting.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Johannes Weiner <hannes@cmpxchg.org>
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

mm-memcg-v1-fix-memorymemswfailcnt-accounting.patch
mm-memcg-stop-reclaim-when-a-limit-update-is-superseded.patch

