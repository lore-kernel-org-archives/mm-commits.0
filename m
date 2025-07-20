Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05D98F6C;
	Sun, 20 Jul 2025 02:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752978962; cv=none; b=FQvahb8GT8IDe29YoamcXk0Ibe1Twnqr8x0rg/74FQHQMwCqTMoWD8PTmLUyC/C6FYsO7BDCOyui2AJDL/WlLEmpmynxm/g6YgCp3MQ7tZSMSvT2x6xvv51GMJ+DS1jj5aNB407WadgbcYdO8oPT3/8LbpUYckTmMYpxTsVh6Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752978962; c=relaxed/simple;
	bh=u71PyHMzkLJiXGKlAF+hxR4QkLxXLuRTlcwaqa0jg+c=;
	h=Date:To:From:Subject:Message-Id; b=dI+zKoBF5YY4IsxiY9m0yYZv2JS0pNuIZw4ZAI4g9E4FXkKYiXhyG39hFfHBBXP5aRcrOuchOMZr5hC4F0qryWPzqLCnn/A3AHuXGyDYoxnqzLEKYaHbC8AavZiSAhCU8+8JG1hHn2haPl14jNucy3nZECKeqp/EpSKbGAP65JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nHeRejHb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nHeRejHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BCAAC4CEE3;
	Sun, 20 Jul 2025 02:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752978962;
	bh=u71PyHMzkLJiXGKlAF+hxR4QkLxXLuRTlcwaqa0jg+c=;
	h=Date:To:From:Subject:From;
	b=nHeRejHb6+mbuE/Pb6EsD7q9qY4AaA9sw8nO4iN/XL6UMGlmkbdFqr01JaDcvEZbo
	 OHCnJbTdTr7q0i9/EeJif/EjyYM+Mr1q37v5mnislXZ7KNQcA1BjwgpmYOp2nZGmhs
	 xYC3g24EHN7SiAWqHTUxt7dLFTHkctT71q1D7leE=
Date: Sat, 19 Jul 2025 19:36:01 -0700
To: mm-commits@vger.kernel.org,ysk@kzalloc.com,yeoreum.yun@arm.com,urezki@gmail.com,stable@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,bigeasy@linutronix.de,andreyknvl@gmail.com,elver@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kasan-use-vmalloc_dump_obj-for-vmalloc-error-reports.patch removed from -mm tree
Message-Id: <20250720023602.1BCAAC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: use vmalloc_dump_obj() for vmalloc error reports
has been removed from the -mm tree.  Its filename was
     kasan-use-vmalloc_dump_obj-for-vmalloc-error-reports.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


