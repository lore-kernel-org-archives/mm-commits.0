Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD84C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  6 May 2022 00:50:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233468AbiEFAyT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 May 2022 20:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387654AbiEFAyT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 May 2022 20:54:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2042227B16
        for <mm-commits@vger.kernel.org>; Thu,  5 May 2022 17:50:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 796FB61FE3
        for <mm-commits@vger.kernel.org>; Fri,  6 May 2022 00:50:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4993C385AE;
        Fri,  6 May 2022 00:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651798235;
        bh=W4VXSiR39ECBolwmnGUeB9o40RHdh/VmgIA9+plYKd8=;
        h=Date:To:From:Subject:From;
        b=OdhyNn0+YlRhdaz8PO1JoVU2dQeXl9B2VfJwNwy256lNGdJd12WfKEwqCr3RndOGF
         7X0Qxr8GCIjAd7lDChvzWg5YqwEv761uYfnUV+M3kFAsJSx7WrSgVUY4Vg40s6F5wS
         M//RxI27JVOyME51mLvQOg7LNgiS86u/JR2IRJD0=
Date:   Thu, 05 May 2022 17:50:35 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        42.hyeyoo@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kfence-reset-pg_slab-and-memcg_data-before-freeing-__kfence_pool.patch added to mm-hotfixes-unstable branch
Message-Id: <20220506005035.C4993C385AE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kfence: reset PG_slab and memcg_data before freeing __kfence_pool
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-kfence-reset-pg_slab-and-memcg_data-before-freeing-__kfence_pool.patch

This patch should soon appear in the mm-hotfixes-unstable branch at
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
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: mm/kfence: reset PG_slab and memcg_data before freeing __kfence_pool

When kfence fails to initialize kfence pool, it frees the pool.  But it
does not reset memcg_data and PG_slab flag.

Below is a BUG because of this. Let's fix it by resetting memcg_data
and PG_slab flag before free.

[    0.089149] BUG: Bad page state in process swapper/0  pfn:3d8e06
[    0.089149] page:ffffea46cf638180 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x3d8e06
[    0.089150] memcg:ffffffff94a475d1
[    0.089150] flags: 0x17ffffc0000200(slab|node=0|zone=2|lastcpupid=0x1fffff)
[    0.089151] raw: 0017ffffc0000200 ffffea46cf638188 ffffea46cf638188 0000000000000000
[    0.089152] raw: 0000000000000000 0000000000000000 00000000ffffffff ffffffff94a475d1
[    0.089152] page dumped because: page still charged to cgroup
[    0.089153] Modules linked in:
[    0.089153] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G    B   W         5.18.0-rc1+ #965
[    0.089154] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
[    0.089154] Call Trace:
[    0.089155]  <TASK>
[    0.089155]  dump_stack_lvl+0x49/0x5f
[    0.089157]  dump_stack+0x10/0x12
[    0.089158]  bad_page.cold+0x63/0x94
[    0.089159]  check_free_page_bad+0x66/0x70
[    0.089160]  __free_pages_ok+0x423/0x530
[    0.089161]  __free_pages_core+0x8e/0xa0
[    0.089162]  memblock_free_pages+0x10/0x12
[    0.089164]  memblock_free_late+0x8f/0xb9
[    0.089165]  kfence_init+0x68/0x92
[    0.089166]  start_kernel+0x789/0x992
[    0.089167]  x86_64_start_reservations+0x24/0x26
[    0.089168]  x86_64_start_kernel+0xa9/0xaf
[    0.089170]  secondary_startup_64_no_verify+0xd5/0xdb
[    0.089171]  </TASK>

Link: https://lkml.kernel.org/r/YnPG3pQrqfcgOlVa@hyeyoo
Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
Fixes: 8f0b36497303 ("mm: kfence: fix objcgs vector allocation")
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/kfence/core.c~mm-kfence-reset-pg_slab-and-memcg_data-before-freeing-__kfence_pool
+++ a/mm/kfence/core.c
@@ -621,6 +621,16 @@ static bool __init kfence_init_pool_earl
 	 * fails for the first page, and therefore expect addr==__kfence_pool in
 	 * most failure cases.
 	 */
+	for (char *p = (char *)addr; p < __kfence_pool + KFENCE_POOL_SIZE; p += PAGE_SIZE) {
+		struct slab *slab = virt_to_slab(p);
+
+		if (!slab)
+			continue;
+#ifdef CONFIG_MEMCG
+		slab->memcg_data = 0;
+#endif
+		__folio_clear_slab(slab_folio(slab));
+	}
 	memblock_free_late(__pa(addr), KFENCE_POOL_SIZE - (addr - (unsigned long)__kfence_pool));
 	__kfence_pool = NULL;
 	return false;
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are

mm-kfence-reset-pg_slab-and-memcg_data-before-freeing-__kfence_pool.patch

