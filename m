Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20F339A048
	for <mm-commits@vger.kernel.org>; Sat, 19 Sep 2026 01:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789779981; cv=none; b=i32UMcfVFoQjLuJJjtBOownniKWVBtl/zWFgAv7TbqFobdjJx1bxpjS6KrjVcatlthCZGUSUYi7MnFT8YHGw4Rugz+A5oFH0MkvcJwJv0OyygvAMW05Gg7k+7rAE5F8hEg7BBEzGBZPKj5j2MaUGweAIiyrnnJKpAmQ5zlubgSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789779981; c=relaxed/simple;
	bh=jlefEhcwS2MaIiBcrfHTb2MnCuYFZGXJAEAxVzCTLow=;
	h=Date:To:From:Subject:Message-Id; b=tR82KUwpc6EpkwvoCvvFGY5WCMKyrQdWuT5zdUJbpkMbD0aqPBOqB1UPvyzQWkcrgzUF8cCqFC2PjauvKeBKscox4gXdjaODqyILdG3+QBSdvbjoNSHnhxvBV4gBJIa8Vme2uhWEBAvN11y57CshU+ekMD7ArYTIlOCScl+GusI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ff72GCIG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ff72GCIG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E601F000FF;
	Sat, 19 Sep 2026 01:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789779972;
	bh=BT7QlYMPwycTNNghEEtAYVEP3brtJL5vOxRU4V825cs=;
	h=Date:To:From:Subject;
	b=Ff72GCIGdPmqY1PEBayMOJtzDuZ0KBA/6M6EOg1rwuT+IOloTfuyxAqzsrWi+Ep0c
	 I97hTjlbu8/hu4gwZwiFM+A1sEvFhtc8Vmy8BzpXq1QUUuNXruu8GKBFD+Trd0mBzv
	 qAKXyHaLVr3FEaIyDkCwfib0G3MH9mByMUcHsJCs=
Date: Fri, 18 Sep 2026 18:06:12 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,sj@kernel.org,bigeasy@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-use-%p-for-pointer-formatting.patch added to mm-unstable branch
Message-Id: <20260919010612.72E601F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: Use %p for pointer formatting
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-use-%p-for-pointer-formatting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-use-%p-for-pointer-formatting.patch

This patch will later appear in the mm-unstable branch at
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
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm/vmalloc: Use %p for pointer formatting
Date: Fri, 18 Sep 2026 12:50:13 +0200

Commit 45ec16908e84e ("mm: use %pK for /proc/vmallocinfo") introduced the
%pK in order not to leak kernel pointers.  Since commit ad67b74d2469d
("printk: hash addresses printed with %p") pointers are hashed by default
and the behaviour can be controlled by `hash_pointers' boot argument.  The
policy on %p is to not introduce new ones.  Removing %pK makes it possible
to remove its handling from the library.

Looking at the output, having the pointer in the output makes it
possible to distinguish the individual entries.

Use %p instead %pK.

/proc/vmallocinfo has mode 0400, so this change doesn't make kernel
pointer information available to unprivileged userspace.

Link: https://lore.kernel.org/20260918105013.UpdykT6j@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Uladzislau Rezki <urezki@gmail.com>
---

 mm/vmalloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-use-%p-for-pointer-formatting
+++ a/mm/vmalloc.c
@@ -5337,7 +5337,7 @@ static void show_purge_info(struct seq_f
 	for_each_vmap_node(vn) {
 		spin_lock(&vn->lazy.lock);
 		list_for_each_entry(va, &vn->lazy.head, list) {
-			seq_printf(m, "0x%pK-0x%pK %7ld unpurged vm_area\n",
+			seq_printf(m, "0x%p-0x%p %7ld unpurged vm_area\n",
 				(void *)va->va_start, (void *)va->va_end,
 				va_size(va));
 		}
@@ -5360,7 +5360,7 @@ static void show_busy_info(struct seq_fi
 		list_for_each_entry(va, &vn->busy.head, list) {
 			if (!va->vm) {
 				if (va->flags & VMAP_RAM)
-					seq_printf(m, "0x%pK-0x%pK %7ld vm_map_ram\n",
+					seq_printf(m, "0x%p-0x%p %7ld vm_map_ram\n",
 						(void *)va->va_start, (void *)va->va_end,
 						va_size(va));
 
@@ -5374,7 +5374,7 @@ static void show_busy_info(struct seq_fi
 			/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
 			smp_rmb();
 
-			seq_printf(m, "0x%pK-0x%pK %7ld",
+			seq_printf(m, "0x%p-0x%p %7ld",
 				v->addr, v->addr + v->size, v->size);
 
 			if (v->caller)
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

mm-vmalloc-use-%p-for-pointer-formatting.patch

