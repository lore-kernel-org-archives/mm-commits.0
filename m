Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D68515B158
	for <mm-commits@vger.kernel.org>; Wed, 29 May 2024 19:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717009950; cv=none; b=h3S83ot2FId9lVqQE4YLXgpMoURRsDaqGHUWA2XzxfL3z7qtl9jypZoYXjZ97FlWIywVilAogoTkCNJMZAgdVg8p8CDN59MhkW6DNsoqsTTEVsba11JTZBgUfFa0lXtfVB2dADGKZCNeFWDndmQG0y5c2Ck7/0Z3rg6r9a59UP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717009950; c=relaxed/simple;
	bh=B5x8GuQcPmiWDl5d7tgjAe1mbnOabl1XjbvwhNdkaJg=;
	h=Date:To:From:Subject:Message-Id; b=Pzzc1CHHpCo2F18+3e1k8gWia8XODU9GXFoAAuZ9yyW5yAW0tKu4IFUWPpVMxl3qnSrIcSyoWOoVxPyyhDXX61N1JuTZUs21CqLYp5KH9538FqTQDHnzrI3RifM9G1iVc4HC+SAA6yVHAF3WJQcSiWFq1nvft9820mn1TkrqCgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nMj5lIym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nMj5lIym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA44C113CC;
	Wed, 29 May 2024 19:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717009949;
	bh=B5x8GuQcPmiWDl5d7tgjAe1mbnOabl1XjbvwhNdkaJg=;
	h=Date:To:From:Subject:From;
	b=nMj5lIymiGqJaMBCH22+dlNUq3hwCYP+jS6Vl5jHE2TcqgVAWnKfVhm9jXpW1iQUU
	 XE/vtEctv33uYRLA2wwJV2u62AOEknyVwz4j028TtdaIAv2ormedKQkBzKi0KpaEP3
	 Xjpn+RXeMgoDTVkMEAexIpl9UbHImZNWBzPFvFMM=
Date: Wed, 29 May 2024 12:12:29 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tglx@linutronix.de,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,bigeasy@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-remove-the-lockdep-assert-from-__mod_objcg_mlstate.patch added to mm-hotfixes-unstable branch
Message-Id: <20240529191229.DBA44C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: remove the lockdep assert from __mod_objcg_mlstate()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     memcg-remove-the-lockdep-assert-from-__mod_objcg_mlstate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-remove-the-lockdep-assert-from-__mod_objcg_mlstate.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: memcg: remove the lockdep assert from __mod_objcg_mlstate()
Date: Tue, 28 May 2024 16:13:41 +0200

The assert was introduced in the commit cited below as an insurance that
the semantic is the same after the local_irq_save() has been removed and
the function has been made static.

The original requirement to disable interrupt was due the modification
of per-CPU counters which require interrupts to be disabled because the
counter update operation is not atomic and some of the counters are
updated from interrupt context.

All callers of __mod_objcg_mlstate() acquire a lock
(memcg_stock.stock_lock) which disables interrupts on !PREEMPT_RT and
the lockdep assert is satisfied. On PREEMPT_RT the interrupts are not
disabled and the assert triggers.

The safety of the counter update is already ensured by
VM_WARN_ON_IRQS_ENABLED() which is part of __mod_memcg_lruvec_state() and
does not require yet another check.

Remove the lockdep assert from __mod_objcg_mlstate().

Link: https://lkml.kernel.org/r/20240528141341.rz_rytN_@linutronix.de
Link: https://lore.kernel.org/r/20240528121928.i-Gu7Jvg@linutronix.de
Fixes: 91882c1617c15 ("memcg: simple cleanup of stats update functions")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/memcontrol.c~memcg-remove-the-lockdep-assert-from-__mod_objcg_mlstate
+++ a/mm/memcontrol.c
@@ -3147,8 +3147,6 @@ static inline void __mod_objcg_mlstate(s
 	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 
-	lockdep_assert_irqs_disabled();
-
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

memcg-remove-the-lockdep-assert-from-__mod_objcg_mlstate.patch

