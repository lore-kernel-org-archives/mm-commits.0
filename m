Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F632266F05;
	Wed, 16 Jul 2025 21:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752701611; cv=none; b=oNCMK6xOj/NXsCFp5aL9SrJvjE8pPKYJZKJtnKMiZWLyEljxi8nEyOEfYhQkqGG547CcJh96YZLO54fCSYLePz03mrplal0xrG7jrDArvvRVlYPp0IeGb7kdkBmVKUS6wzTzXiefDGUsY0qie+XHjdgLqnhjF7MJnBH/s4yxm9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752701611; c=relaxed/simple;
	bh=4dhREyYvxWITPwcJlpKpuCkixJrjrTpEX3Z1DqcQpMU=;
	h=Date:To:From:Subject:Message-Id; b=OCQeoOuLsYDUuTV1WRUsznoSjv/nI/xKmF5HPRoFJkILeEBCg8Cb5z/oegAmhIlmeThp6zGQ0/1xJLTzpj+CXYkO+io2tNg2Ndc5wnOOviGuhos30kNptapJ9x3sGuwHiNrBtVQcfiRFKsemKpynA2vxVgmZSGV6s8muOiXsa/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1UWIFd8o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1UWIFd8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E19EC4CEE7;
	Wed, 16 Jul 2025 21:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752701610;
	bh=4dhREyYvxWITPwcJlpKpuCkixJrjrTpEX3Z1DqcQpMU=;
	h=Date:To:From:Subject:From;
	b=1UWIFd8oo6DErpEipwK6chJ9LkOh43rvhjptcL8QXCA1IUfJfMAxTUWhE0GqgJN4k
	 xI910LeGOl6P29OT6U6ybwelDE3BjU83dweJoChoQg2FadqJf2lV+/7qcQaxGtix9I
	 6p2P753vnWbn8kfXRcG+9FswqOrZe9ehk42EQiMg=
Date: Wed, 16 Jul 2025 14:33:29 -0700
To: mm-commits@vger.kernel.org,ysk@kzalloc.com,yeoreum.yun@arm.com,urezki@gmail.com,stable@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,bigeasy@linutronix.de,andreyknvl@gmail.com,elver@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-use-vmalloc_dump_obj-for-vmalloc-error-reports.patch added to mm-hotfixes-unstable branch
Message-Id: <20250716213330.8E19EC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: use vmalloc_dump_obj() for vmalloc error reports
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-use-vmalloc_dump_obj-for-vmalloc-error-reports.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-use-vmalloc_dump_obj-for-vmalloc-error-reports.patch

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
From: Marco Elver <elver@google.com>
Subject: kasan: use vmalloc_dump_obj() for vmalloc error reports
Date: Wed, 16 Jul 2025 17:23:28 +0200

Since 6ee9b3d84775 ("kasan: remove kasan_find_vm_area() to prevent
possible deadlock"), more detailed info about the vmalloc mapping and the
origin was dropped due to potential deadlocks.

While fixing the deadlock is necessary, that patch was too quick in
killing an otherwise useful feature, and did no due-diligence in
understanding if an alternative option is available.

Restore printing more helpful vmalloc allocation info in KASAN reports
with the help of vmalloc_dump_obj().  Example report:

| BUG: KASAN: vmalloc-out-of-bounds in vmalloc_oob+0x4c9/0x610
| Read of size 1 at addr ffffc900002fd7f3 by task kunit_try_catch/493
|
| CPU: [...]
| Call Trace:
|  <TASK>
|  dump_stack_lvl+0xa8/0xf0
|  print_report+0x17e/0x810
|  kasan_report+0x155/0x190
|  vmalloc_oob+0x4c9/0x610
|  [...]
|
| The buggy address belongs to a 1-page vmalloc region starting at 0xffffc900002fd000 allocated at vmalloc_oob+0x36/0x610
| The buggy address belongs to the physical page:
| page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x126364
| flags: 0x200000000000000(node=0|zone=2)
| raw: 0200000000000000 0000000000000000 dead000000000122 0000000000000000
| raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
| page dumped because: kasan: bad access detected
|
| [..]

Link: https://lkml.kernel.org/r/20250716152448.3877201-1-elver@google.com
Fixes: 6ee9b3d84775 ("kasan: remove kasan_find_vm_area() to prevent possible deadlock")
Signed-off-by: Marco Elver <elver@google.com>
Suggested-by: Uladzislau Rezki <urezki@gmail.com>
Acked-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Yunseong Kim <ysk@kzalloc.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/kasan/report.c~kasan-use-vmalloc_dump_obj-for-vmalloc-error-reports
+++ a/mm/kasan/report.c
@@ -399,7 +399,9 @@ static void print_address_description(vo
 	}
 
 	if (is_vmalloc_addr(addr)) {
-		pr_err("The buggy address %px belongs to a vmalloc virtual mapping\n", addr);
+		pr_err("The buggy address belongs to a");
+		if (!vmalloc_dump_obj(addr))
+			pr_cont(" vmalloc virtual mapping\n");
 		page = vmalloc_to_page(addr);
 	}
 
_

Patches currently in -mm which might be from elver@google.com are

kasan-use-vmalloc_dump_obj-for-vmalloc-error-reports.patch

