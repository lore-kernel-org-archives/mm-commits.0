Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686CC154C00;
	Fri, 15 Nov 2024 06:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653064; cv=none; b=PNSEDHvyKTCgLi9WA/2NjCtWzaqCQwXCkNzjX0kZUWEj1/gWmFgY8FYG3Uk95ImMce5WD7LjwQqwtA2bJjTHx2b1Q47rAsrl+vzIiJEz85nU8Os29DVZvkBGo320D6yam8mOl41jUrgd0ltDWmFAtFVafECybhGw8DUt02KDDPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653064; c=relaxed/simple;
	bh=qG1wWQLwoEcg+AgQinDXT064/kVQQ3T3l4EyhaInNWU=;
	h=Date:To:From:Subject:Message-Id; b=ryOi44m3kzdh23eE5I4nZadYWx75RE2QHlZB3eZqDpImH8gRveiM6bwqRkLu5Fg33/wZ0YRjMoVAXFbj3hv841/577SkSI7d4Z7qtMiTcAAO6Ni6tJJf2d8ByTQwjcz56/LVmCHSZvn4rnNc6R9TEBBMBZKPfYpr8blHN1Qrxww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yGhI+S/V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yGhI+S/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A182FC4CED2;
	Fri, 15 Nov 2024 06:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731653064;
	bh=qG1wWQLwoEcg+AgQinDXT064/kVQQ3T3l4EyhaInNWU=;
	h=Date:To:From:Subject:From;
	b=yGhI+S/VNWZ0zNHI+dO3+aJjmgiLC+qnBHNteVd0Ih0KxA8kYTLI7KeDheRkgLsL5
	 VWHJl8Wi7JCxAg+MOBvCbKH8zWJdXs8qL9T0kHVw9DJH7CZ+SLnk+3UbnsrHnxEEjS
	 Ma9BNNHLODgrC568RjRczv+s2KGYjLrzqpmgowhA=
Date: Thu, 14 Nov 2024 22:44:20 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,pasha.tatashin@soleen.com,matthias.bgg@gmail.com,kent.overstreet@linux.dev,chinwen.chang@mediatek.com,catalin.marinas@arm.com,casper.li@mediatek.com,angelogioacchino.delregno@collabora.com,andrew.yang@mediatek.com,qun-wei.lin@mediatek.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] sched-task_stack-fix-object_is_on_stack-for-kasan-tagged-pointers.patch removed from -mm tree
Message-Id: <20241115064423.A182FC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sched/task_stack: fix object_is_on_stack() for KASAN tagged pointers
has been removed from the -mm tree.  Its filename was
     sched-task_stack-fix-object_is_on_stack-for-kasan-tagged-pointers.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qun-Wei Lin <qun-wei.lin@mediatek.com>
Subject: sched/task_stack: fix object_is_on_stack() for KASAN tagged pointers
Date: Wed, 13 Nov 2024 12:25:43 +0800

When CONFIG_KASAN_SW_TAGS and CONFIG_KASAN_STACK are enabled, the
object_is_on_stack() function may produce incorrect results due to the
presence of tags in the obj pointer, while the stack pointer does not have
tags.  This discrepancy can lead to incorrect stack object detection and
subsequently trigger warnings if CONFIG_DEBUG_OBJECTS is also enabled.

Example of the warning:

ODEBUG: object 3eff800082ea7bb0 is NOT on stack ffff800082ea0000, but annotated.
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at lib/debugobjects.c:557 __debug_object_init+0x330/0x364
Modules linked in:
CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.12.0-rc5 #4
Hardware name: linux,dummy-virt (DT)
pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __debug_object_init+0x330/0x364
lr : __debug_object_init+0x330/0x364
sp : ffff800082ea7b40
x29: ffff800082ea7b40 x28: 98ff0000c0164518 x27: 98ff0000c0164534
x26: ffff800082d93ec8 x25: 0000000000000001 x24: 1cff0000c00172a0
x23: 0000000000000000 x22: ffff800082d93ed0 x21: ffff800081a24418
x20: 3eff800082ea7bb0 x19: efff800000000000 x18: 0000000000000000
x17: 00000000000000ff x16: 0000000000000047 x15: 206b63617473206e
x14: 0000000000000018 x13: ffff800082ea7780 x12: 0ffff800082ea78e
x11: 0ffff800082ea790 x10: 0ffff800082ea79d x9 : 34d77febe173e800
x8 : 34d77febe173e800 x7 : 0000000000000001 x6 : 0000000000000001
x5 : feff800082ea74b8 x4 : ffff800082870a90 x3 : ffff80008018d3c4
x2 : 0000000000000001 x1 : ffff800082858810 x0 : 0000000000000050
Call trace:
 __debug_object_init+0x330/0x364
 debug_object_init_on_stack+0x30/0x3c
 schedule_hrtimeout_range_clock+0xac/0x26c
 schedule_hrtimeout+0x1c/0x30
 wait_task_inactive+0x1d4/0x25c
 kthread_bind_mask+0x28/0x98
 init_rescuer+0x1e8/0x280
 workqueue_init+0x1a0/0x3cc
 kernel_init_freeable+0x118/0x200
 kernel_init+0x28/0x1f0
 ret_from_fork+0x10/0x20
---[ end trace 0000000000000000 ]---
ODEBUG: object 3eff800082ea7bb0 is NOT on stack ffff800082ea0000, but annotated.
------------[ cut here ]------------

Link: https://lkml.kernel.org/r/20241113042544.19095-1-qun-wei.lin@mediatek.com
Signed-off-by: Qun-Wei Lin <qun-wei.lin@mediatek.com>
Cc: Andrew Yang <andrew.yang@mediatek.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Casper Li <casper.li@mediatek.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/task_stack.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/sched/task_stack.h~sched-task_stack-fix-object_is_on_stack-for-kasan-tagged-pointers
+++ a/include/linux/sched/task_stack.h
@@ -9,6 +9,7 @@
 #include <linux/sched.h>
 #include <linux/magic.h>
 #include <linux/refcount.h>
+#include <linux/kasan.h>
 
 #ifdef CONFIG_THREAD_INFO_IN_TASK
 
@@ -89,6 +90,7 @@ static inline int object_is_on_stack(con
 {
 	void *stack = task_stack_page(current);
 
+	obj = kasan_reset_tag(obj);
 	return (obj >= stack) && (obj < (stack + THREAD_SIZE));
 }
 
_

Patches currently in -mm which might be from qun-wei.lin@mediatek.com are


