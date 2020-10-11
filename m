Return-Path: <SRS0=Y9qB=DS=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34056C433DF
	for <mm-commits@archiver.kernel.org>; Sun, 11 Oct 2020 03:38:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5531207D3
	for <mm-commits@archiver.kernel.org>; Sun, 11 Oct 2020 03:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602387514;
	bh=2i9qwRA3z3EC6XNGoBmqZc1GtrrF85kp86Qx/FcI7aQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ji73qbQ78YrouYH4jxcboNVyC/wa3u3kJSL1HbxYVK+Db3N9sq30agwV9u33uQa98
	 17ZfVjDL1gj7heKcUWkZo57HG7KVyqYE9N9UkuxU5lbJb+sifgrTNYkSAQHTq78d8w
	 2g+/awI1xE9HsJD8PakrxymWXbQNZvUI+pSnratg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbgJKDie (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 10 Oct 2020 23:38:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728715AbgJKDie (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 10 Oct 2020 23:38:34 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D203A20781;
        Sun, 11 Oct 2020 03:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602387513;
        bh=2i9qwRA3z3EC6XNGoBmqZc1GtrrF85kp86Qx/FcI7aQ=;
        h=Date:From:To:Subject:From;
        b=AgPTJNmO+/3vwqv6qVkPvRYDS49uGZUUY1+WJb5KwdH+9ihfgkIFjJQEF/4AJb5pE
         k0xtW52368TfKaG4mQODFIxioFUSlmbuJ0zUMe0n5x7XWd9tiDermNm4dNkUP6xbyE
         DxpALLDm4d4zTIAE8SeYKVNR7hC/JZJ1gVn1CHM0=
Date:   Sat, 10 Oct 2020 20:38:32 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, aquini@redhat.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        willy@infradead.org, ying.huang@intel.com
Subject:  + mm-fix-a-race-during-split-thp.patch added to -mm tree
Message-ID: <20201011033832.09IJxJjTd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: Fix a race during THP splitting
has been added to the -mm tree.  Its filename is
     mm-fix-a-race-during-split-thp.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-a-race-during-split-thp.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-a-race-during-split-thp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm: Fix a race during THP splitting

It is reported that the following bug is triggered if the HDD is used as
swap device,

[ 5758.157556] BUG: kernel NULL pointer dereference, address: 0000000000000007
[ 5758.165331] #PF: supervisor write access in kernel mode
[ 5758.171161] #PF: error_code(0x0002) - not-present page
[ 5758.176894] PGD 0 P4D 0
[ 5758.179721] Oops: 0002 [#1] SMP PTI
[ 5758.183614] CPU: 10 PID: 316 Comm: kswapd1 Kdump: loaded Tainted: G S               --------- ---  5.9.0-0.rc3.1.tst.el8.x86_64 #1
[ 5758.196717] Hardware name: Intel Corporation S2600CP/S2600CP, BIOS SE5C600.86B.02.01.0002.082220131453 08/22/2013
[ 5758.208176] RIP: 0010:split_swap_cluster+0x47/0x60
[ 5758.213522] Code: c1 e3 06 48 c1 eb 0f 48 8d 1c d8 48 89 df e8 d0 20 6a 00 80 63 07 fb 48 85 db 74 16 48 89 df c6 07 00 66 66 66 90 31 c0 5b c3 <80> 24 25 07 00 00 00 fb 31 c0 5b c3 b8 f0 ff ff ff 5b c3 66 0f 1f
[ 5758.234478] RSP: 0018:ffffb147442d7af0 EFLAGS: 00010246
[ 5758.240309] RAX: 0000000000000000 RBX: 000000000014b217 RCX: ffffb14779fd9000
[ 5758.248281] RDX: 000000000014b217 RSI: ffff9c52f2ab1400 RDI: 000000000014b217
[ 5758.256246] RBP: ffffe00c51168080 R08: ffffe00c5116fe08 R09: ffff9c52fffd3000
[ 5758.264208] R10: ffffe00c511537c8 R11: ffff9c52fffd3c90 R12: 0000000000000000
[ 5758.272172] R13: ffffe00c51170000 R14: ffffe00c51170000 R15: ffffe00c51168040
[ 5758.280134] FS:  0000000000000000(0000) GS:ffff9c52f2a80000(0000) knlGS:0000000000000000
[ 5758.289163] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5758.295575] CR2: 0000000000000007 CR3: 0000000022a0e003 CR4: 00000000000606e0
[ 5758.303538] Call Trace:
[ 5758.306273]  split_huge_page_to_list+0x88b/0x950
[ 5758.311433]  deferred_split_scan+0x1ca/0x310
[ 5758.316202]  do_shrink_slab+0x12c/0x2a0
[ 5758.320491]  shrink_slab+0x20f/0x2c0
[ 5758.324482]  shrink_node+0x240/0x6c0
[ 5758.328469]  balance_pgdat+0x2d1/0x550
[ 5758.332652]  kswapd+0x201/0x3c0
[ 5758.336157]  ? finish_wait+0x80/0x80
[ 5758.340147]  ? balance_pgdat+0x550/0x550
[ 5758.344525]  kthread+0x114/0x130
[ 5758.348126]  ? kthread_park+0x80/0x80
[ 5758.352214]  ret_from_fork+0x22/0x30
[ 5758.356203] Modules linked in: fuse zram rfkill sunrpc intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp mgag200 iTCO_wdt crct10dif_pclmul iTCO_vendor_support drm_kms_helper crc32_pclmul ghash_clmulni_intel syscopyarea sysfillrect sysimgblt fb_sys_fops cec rapl joydev intel_cstate ipmi_si ipmi_devintf drm intel_uncore i2c_i801 ipmi_msghandler pcspkr lpc_ich mei_me i2c_smbus mei ioatdma ip_tables xfs libcrc32c sr_mod sd_mod cdrom t10_pi sg igb ahci libahci i2c_algo_bit crc32c_intel libata dca wmi dm_mirror dm_region_hash dm_log dm_mod
[ 5758.412673] CR2: 0000000000000007
[    0.000000] Linux version 5.9.0-0.rc3.1.tst.el8.x86_64 (mockbuild@x86-vm-15.build.eng.bos.redhat.com) (gcc (GCC) 8.3.1 20191121 (Red Hat 8.3.1-5), GNU ld version 2.30-79.el8) #1 SMP Wed Sep 9 16:03:34 EDT 2020

After further digging it's found that the following race condition exists in the
original implementation,

CPU1                                                             CPU2
----                                                             ----
deferred_split_scan()
  split_huge_page(page) /* page isn't compound head */
    split_huge_page_to_list(page, NULL)
      __split_huge_page(page, )
        ClearPageCompound(head)
        /* unlock all subpages except page (not head) */
                                                                 add_to_swap(head)  /* not THP */
                                                                   get_swap_page(head)
                                                                   add_to_swap_cache(head, )
                                                                     SetPageSwapCache(head)
     if PageSwapCache(head)
       split_swap_cluster(/* swap entry of head */)
         /* Deref sis->cluster_info: NULL accessing! */

So, in split_huge_page_to_list(), PageSwapCache() is called for the already
split and unlocked "head", which may be added to swap cache in another CPU.  So
split_swap_cluster() may be called wrongly.

To fix the race, the call to split_swap_cluster() is moved to
__split_huge_page() before all subpages are unlocked.  So that the
PageSwapCache() is stable.

Link: https://lkml.kernel.org/r/20201009073647.1531083-1-ying.huang@intel.com
Fixes: 59807685a7e77 ("mm, THP, swap: support splitting THP for THP swap out")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reported-by: Rafael Aquini <aquini@redhat.com>
Tested-by: Rafael Aquini <aquini@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-fix-a-race-during-split-thp
+++ a/mm/huge_memory.c
@@ -2475,6 +2475,12 @@ static void __split_huge_page(struct pag
 
 	remap_page(head, nr);
 
+	if (PageSwapCache(head)) {
+		swp_entry_t entry = { .val = page_private(head) };
+
+		split_swap_cluster(entry);
+	}
+
 	for (i = 0; i < nr; i++) {
 		struct page *subpage = head + i;
 		if (subpage == page)
@@ -2710,12 +2716,7 @@ int split_huge_page_to_list(struct page
 		}
 
 		__split_huge_page(page, list, end, flags);
-		if (PageSwapCache(head)) {
-			swp_entry_t entry = { .val = page_private(head) };
-
-			ret = split_swap_cluster(entry);
-		} else
-			ret = 0;
+		ret = 0;
 	} else {
 		if (IS_ENABLED(CONFIG_DEBUG_VM) && mapcount) {
 			pr_alert("total_mapcount: %u, page_count(): %u\n",
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-fix-a-race-during-split-thp.patch

