Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF7A3B5F63;
	Fri,  7 Aug 2026 02:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068095; cv=none; b=J2zcVtvAjDj83Uq00Ej8lCp7kH72LmtnSLIIJZgjhWaNFse5iYkuyvZrmQGf/C3kDyuQUEPesihCQySymAwc3eRYlcbW0wbXcmohGjiDLI/yEjYNFzAlW2w1aAx4659O0AXvqzX1JzPtPhMg004JG8ArcfjeyMSY6tdq5L17nS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068095; c=relaxed/simple;
	bh=DCjYREOveDBoE3Dq3n4GGd+qzrEPH90KO6I5zO+AhHk=;
	h=Date:To:From:Subject:Message-Id; b=Uj5JxGa8GswfWC0wx1j2s1xoEOm9wMAlBiPuojJazqQ6EPlaDaQQXBOX7gG23qmbfEeh+Wtl6CAJL2M5hdvTc72oTgXVPo5XDovbRCDOvvDG9koVDY0FIQ1RKF9vyzOllgcpbTAp2Cw63dbiCnw1Bqo04aj0Rja7AX3M3P5eFdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Kc03GHwf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Kc03GHwf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867C81F00A3D;
	Fri,  7 Aug 2026 02:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068085;
	bh=3yeDW5WxAaH4SQWXRv0MFoBb6me4MUV1nC8wcDmUY7g=;
	h=Date:To:From:Subject;
	b=Kc03GHwfvBkIVl++va5MkJ86xTL1cb/Gr0GJdL5Wt/fM4UgoIgAB+u7cQpSoFOErk
	 gidq5loXoAkWgscX0JKtGxKxoq0ZEPlbiHAsPdw62M0OwNBotdoglxkekFKxU2Ff7T
	 3mJyu/pFqyfI/z+DCKVvjZpravqxsX6hnSF7lrJk=
Date: Thu, 06 Aug 2026 19:01:25 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,rostedt@goodmis.org,mhocko@suse.com,harry@kernel.org,hannes@cmpxchg.org,brendan.jackman@linux.dev,bigeasy@linutronix.de,ast@kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-dont-spin_trylock-in-nmi-on-up.patch removed from -mm tree
Message-Id: <20260807020125.867C81F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: don't spin_trylock() in NMI on UP
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-dont-spin_trylock-in-nmi-on-up.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/page_alloc: don't spin_trylock() in NMI on UP
Date: Wed, 15 Jul 2026 09:03:58 +0000

Patch series "mm/page_alloc: fixes for free_pages_nolock() on RT/UP".

Pre-existing bugs found by Sashiko during review of this other series:
https://lore.kernel.org/all/20260703-alloc-trylock-v5-0-c87b714e19d3@google.com/

I have not reproduced these bugs, and I suspect there is no real-world
user that is affected by them.


This patch (of 2):

As noted in can_spin_trylock(), using this is unsafe in this context. 
commit 620b46ed6ae17 ("mm/page_alloc: return NULL early from
alloc_frozen_pages_nolock() in NMI on UP") fixed this on the alloc side
but missed the free side.

Impact: If BPF programs using these features in NMI (probably tracing) are
present on non-SMP builds this might crash the kernel and is probably
exploitable by local attackers for privilege escalation.

Link: https://lore.kernel.org/20260715-alloc-nolock-fixes-v1-0-fadc49952dda@google.com
Link: https://lore.kernel.org/20260715-alloc-nolock-fixes-v1-1-fadc49952dda@google.com
Fixes: 8c57b687e833 ("mm, bpf: Introduce free_pages_nolock()")
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260703-alloc-trylock-v5-0-c87b714e19d3%40google.com?part=18
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-dont-spin_trylock-in-nmi-on-up
+++ a/mm/page_alloc.c
@@ -2979,8 +2979,7 @@ static void __free_frozen_pages(struct p
 		migratetype = MIGRATE_MOVABLE;
 	}
 
-	if (unlikely((fpi_flags & FPI_TRYLOCK) && IS_ENABLED(CONFIG_PREEMPT_RT)
-		     && (in_nmi() || in_hardirq()))) {
+	if (unlikely((fpi_flags & FPI_TRYLOCK) && !can_spin_trylock())) {
 		add_page_to_zone_llist(zone, page, order);
 		return;
 	}
_

Patches currently in -mm which might be from jackmanb@google.com are


