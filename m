Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0939481FCF
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865938; cv=none; b=lHhnvWhASZgqRHuUGxACDmtGcfVMcJ3DUkChZDgUx9pbXeT79B0YGxOY81FSitPLvdh1l3DT9Zl2+qrPEVEpVMg7wuxMKTVIHky0+KypgkeEWFGpLX6NRgPoo874sThw4t6jXx1AjivP4KkDvWLaCx/GeXc0Dtuf38jFAdDi6l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865938; c=relaxed/simple;
	bh=tPVPnSZSIlFuJsgbzcdO95G3vyTh6+pcg5e8heAkrNY=;
	h=Date:To:From:Subject:Message-Id; b=OwF8cvSqcYtebE+HACTkiurbpUeBkyL3RI0Z5hdEW+JqWg90uAHHnZ4+1CtSslDAraBywLhvCH/MJ2v9b7/k3czjjXGfWuI7+sTFWW2ZDjZpqMcpmOSagSrVJ7ogwlH3AElCKyAlZJlLodhsZd6nZal/qNUf1Do6T/QBv00SQDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AERd3LoU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AERd3LoU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C811F00893;
	Tue, 13 Oct 2026 04:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865937;
	bh=NNjZK1PRmP69q3DGEMcj2oE7QqdHj1scZ4JgTZPpzGg=;
	h=Date:To:From:Subject;
	b=AERd3LoUCLH0thgT40DFcjH+9jE1ZetyHV4Nm1PJkNI9bzjGThMvWbe8RrJVr+rEk
	 c/qxUlCgCmJrTlKEdCV6OIfNQlwQk+YIHrxRDCUxert+HhWleFuRSZnzzXC3NB/2wt
	 X7/XOobiXmQgSEfuNu6rsdmO5wnSZnlBYEhdWmco=
Date: Mon, 12 Oct 2026 21:32:17 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,sj@kernel.org,bigeasy@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-use-%p-for-pointer-formatting.patch removed from -mm tree
Message-Id: <20261013043217.97C811F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: use %p for pointer formatting
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-use-%p-for-pointer-formatting.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm/vmalloc: use %p for pointer formatting
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
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---

 mm/vmalloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-use-%p-for-pointer-formatting
+++ a/mm/vmalloc.c
@@ -5323,7 +5323,7 @@ static void show_purge_info(struct seq_f
 	for_each_vmap_node(vn) {
 		spin_lock(&vn->lazy.lock);
 		list_for_each_entry(va, &vn->lazy.head, list) {
-			seq_printf(m, "0x%pK-0x%pK %7ld unpurged vm_area\n",
+			seq_printf(m, "0x%p-0x%p %7ld unpurged vm_area\n",
 				(void *)va->va_start, (void *)va->va_end,
 				va_size(va));
 		}
@@ -5346,7 +5346,7 @@ static void show_busy_info(struct seq_fi
 		list_for_each_entry(va, &vn->busy.head, list) {
 			if (!va->vm) {
 				if (va->flags & VMAP_RAM)
-					seq_printf(m, "0x%pK-0x%pK %7ld vm_map_ram\n",
+					seq_printf(m, "0x%p-0x%p %7ld vm_map_ram\n",
 						(void *)va->va_start, (void *)va->va_end,
 						va_size(va));
 
@@ -5360,7 +5360,7 @@ static void show_busy_info(struct seq_fi
 			/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
 			smp_rmb();
 
-			seq_printf(m, "0x%pK-0x%pK %7ld",
+			seq_printf(m, "0x%p-0x%p %7ld",
 				v->addr, v->addr + v->size, v->size);
 
 			if (v->caller)
_

Patches currently in -mm which might be from bigeasy@linutronix.de are


