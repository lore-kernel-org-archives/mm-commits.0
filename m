Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC19E2C21D8;
	Tue, 11 Aug 2026 04:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786421258; cv=none; b=Macc0OR6g857EUVgBEalY8rckG0tEvncEF08hG9QEeZZ7mSBPc50P12uT1P6xDrfswcfWQ8UlOooW6MOvOiNAV8aW5+Vwh8vCKQy5xCY7Xq5StAo6UM3yKur2iN5xD3SczSI30w3CGD2DQyt4IniFdNDku+z/5VcXw3dQ1yY7qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786421258; c=relaxed/simple;
	bh=jz5fz4NPjN2piUiEBtEouGFGodLZj1P+I8+sA0dOPbY=;
	h=Date:To:From:Subject:Message-Id; b=hCyBegPC+NjxL+FBufEs8fK7FqUYr09hTG2LiwpOvXwtxgEquo5Ob1biHAvjhn0fXcR2ywXgd/hReEKd53i6hEXPMrqxd3Clc2bLT3JyfeD9jqeJ2LpKZqVECIgXujZOx+oX8HPa5Cep0/UgCBOZ+qpgdrC2yMHIvv4K3rlk7As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BhDA5rS7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BhDA5rS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EDB31F000E9;
	Tue, 11 Aug 2026 04:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786421257;
	bh=qVFd9N4FSfpwA0LSNRyINSskpxY0GQGXtW3t8hcwyFA=;
	h=Date:To:From:Subject;
	b=BhDA5rS7v9GjF34dZe1P49pttaQzaJzvPH3rI1NS3nBC0Mc5rL3MjmkMVLP4EJNOM
	 eZ2pQ/BYpKdub3FkR5Zpx3QQs4AUuzjg7VdpRxCJ/UtyE58Tk4TyqVvRO2O6fCs1ug
	 FSuCGFQYCiERV9KsdG2HpwLnGRLhC2dbLJR2YEvs=
Date: Mon, 10 Aug 2026 21:07:36 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,zhangguopeng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-v1-fix-memsw-and-tcp-failcnt-accounting.patch added to mm-hotfixes-unstable branch
Message-Id: <20260811040737.0EDB31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg-v1: fix memsw and TCP failcnt accounting
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memcg-v1-fix-memsw-and-tcp-failcnt-accounting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-v1-fix-memsw-and-tcp-failcnt-accounting.patch

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
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
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

mm-memcg-v1-fix-memsw-and-tcp-failcnt-accounting.patch
mm-memcg-v1-fix-memorymemswfailcnt-accounting.patch
mm-memcg-stop-reclaim-when-a-limit-update-is-superseded.patch

