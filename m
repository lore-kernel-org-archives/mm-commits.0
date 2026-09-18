Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561413AE1A6
	for <mm-commits@vger.kernel.org>; Fri, 18 Sep 2026 20:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789761947; cv=none; b=BhxA49UDXNi7r4pZSWw6DJSZq2/lPslYVFW9J4eQadFacDaBSQUIeLDDBZqlQdM8F+tQTmqBPG0zHN2q5OyqDbR8qSqfBBAoGpKdu0o3FG1ci8bDofABZUyX+2i08B6tK3cRPseUgzC4QYpxasuy/NxJWGUUndQLil6rMruxgiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789761947; c=relaxed/simple;
	bh=t5W70pZ3tXf3jcMTXyfPNM83aV2/+wCS2ed4Nhjz4d4=;
	h=Date:To:From:Subject:Message-Id; b=o9PxS0AwhSNGnpqJFlD47i5/lMPSpo8+klaGoHukvttuZRSEVMmhp0QJ0S1BZOM38TXP64xIlBXKYArMYQo5LiBLG/ziCD2cbejOgZg/4ITs3PPrCmAXTAqIXixT4N8dBz7UTp2r7ZYgMCQApdByfYYzeBB/Qv21NwUfko1Jg9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ogXPdK3B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ogXPdK3B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0B21F000FF;
	Fri, 18 Sep 2026 20:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789761945;
	bh=CCHkcmb1b4w2rD8M930SvSQH30oyu1sZJwpmSUMfOzI=;
	h=Date:To:From:Subject;
	b=ogXPdK3B6D+NhilKvL92bO/SwlS6YiDzcGQsFPz/OUTWNwadqNloATWjh1uFMJHmN
	 I38KH0RlVd3OmZNrxAE1dUM8trVrjf9xrbqkMrVZ+N7ECw5S+OxXfsDw+ymndRFzj+
	 IrdPqEWUbdmS1DNBS9ACAFjeprBR8RJQrW/yEmpo=
Date: Fri, 18 Sep 2026 13:05:45 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,bigeasy@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-use-%p-for-pointer-formatting.patch added to mm-unstable branch
Message-Id: <20260918200545.CC0B21F000FF@smtp.kernel.org>
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
and the behaviour can be controller by `hash_pointers' boot argument.  The
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
Cc: Uladzislau Rezki <urezki@gmail.com>
---

 mm/vmalloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-use-%p-for-pointer-formatting
+++ a/mm/vmalloc.c
@@ -5316,7 +5316,7 @@ static void show_purge_info(struct seq_f
 	for_each_vmap_node(vn) {
 		spin_lock(&vn->lazy.lock);
 		list_for_each_entry(va, &vn->lazy.head, list) {
-			seq_printf(m, "0x%pK-0x%pK %7ld unpurged vm_area\n",
+			seq_printf(m, "0x%p-0x%p %7ld unpurged vm_area\n",
 				(void *)va->va_start, (void *)va->va_end,
 				va_size(va));
 		}
@@ -5339,7 +5339,7 @@ static int vmalloc_info_show(struct seq_
 		list_for_each_entry(va, &vn->busy.head, list) {
 			if (!va->vm) {
 				if (va->flags & VMAP_RAM)
-					seq_printf(m, "0x%pK-0x%pK %7ld vm_map_ram\n",
+					seq_printf(m, "0x%p-0x%p %7ld vm_map_ram\n",
 						(void *)va->va_start, (void *)va->va_end,
 						va_size(va));
 
@@ -5353,7 +5353,7 @@ static int vmalloc_info_show(struct seq_
 			/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
 			smp_rmb();
 
-			seq_printf(m, "0x%pK-0x%pK %7ld",
+			seq_printf(m, "0x%p-0x%p %7ld",
 				v->addr, v->addr + v->size, v->size);
 
 			if (v->caller)
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

mm-vmalloc-use-%p-for-pointer-formatting.patch

