Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C711805A
	for <mm-commits@vger.kernel.org>; Thu,  6 Jun 2024 02:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717640410; cv=none; b=sBQg9S+Xs7g26ZGQp2uhdUuBVkoMxIyukdkVvb0+s+SZG2DUjr4IOOiSkvWzTqbIDScNqQ7fgcvUnXA/zcME1W6lAnzZKtNh4BgAPlC295jSyFChrQOwO0yvjhoEkIndPGiGp/HzMckYHP0blgBrBVMihl/BCp/HboCMzXLXK0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717640410; c=relaxed/simple;
	bh=03xhrz0fvLPFVzPiQs0AmAT3YerK3NxP/G5gDNuXuf8=;
	h=Date:To:From:Subject:Message-Id; b=T764BXHmPq+mnavL0ej6FbRJn3vC31zR+0fWtPaSPx9yu3OdQmECSqFtafP28Cwmk82KUkjvt9VfYhhJGAya9pRG8THzwEUrzAOFiCBKQM/dkNXnZqhOBfIwrRfp2SQyXhJ/juHcLem1Qy8TRvZ2VeWo7umUoe1lXmYOtL/KPCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FmXiAvdw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FmXiAvdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A7CC4AF1D;
	Thu,  6 Jun 2024 02:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717640408;
	bh=03xhrz0fvLPFVzPiQs0AmAT3YerK3NxP/G5gDNuXuf8=;
	h=Date:To:From:Subject:From;
	b=FmXiAvdwZcKGyVxa1D21YbZriTl19Mdjt7g1H5CXguHObHT7aFf15OaqtOgaG4Wf4
	 1eR0TUC/T4jqXNyhGtlwg49XQ+ork5ry96cpp4zZGEW2LU19vymicG0N3+gYLc6WuX
	 +2mI7wFmz7Qntb2nHyqWwJLqGmSRkfCN0QSKOCF0=
Date: Wed, 05 Jun 2024 19:20:08 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tglx@linutronix.de,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,bigeasy@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] memcg-remove-the-lockdep-assert-from-__mod_objcg_mlstate.patch removed from -mm tree
Message-Id: <20240606022008.D7A7CC4AF1D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: remove the lockdep assert from __mod_objcg_mlstate()
has been removed from the -mm tree.  Its filename was
     memcg-remove-the-lockdep-assert-from-__mod_objcg_mlstate.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: 91882c1617c1 ("memcg: simple cleanup of stats update functions")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
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


