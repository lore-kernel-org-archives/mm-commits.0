Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BA5BC001E0
	for <mm-commits@archiver.kernel.org>; Thu, 10 Aug 2023 16:35:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234769AbjHJQfl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Aug 2023 12:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234199AbjHJQfk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2023 12:35:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12F19C
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 09:35:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3131E6637A
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 16:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2AAC433C7;
        Thu, 10 Aug 2023 16:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691685338;
        bh=//itwt+RonLxCN2OtjAfzYxsqnjYB5C71KtuKdU3WRg=;
        h=Date:To:From:Subject:From;
        b=zacPGXKEVad4dzAxBsf6a/x+krYoywDPYVLQ4/Oivnbfbhuc30VMIfSEGR9uuQI/c
         0Vyvw0m/1J5DWW7SLe3vPai2OF0AyY14nrxzjQ6hRY0+NjLK3KpiwuRAP4YJnV1kdH
         7/uYG71zIn3xWRZfTp6gjYkSKUNTNb3c5GM085aI=
Date:   Thu, 10 Aug 2023 09:35:37 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        hannes@cmpxchg.org, fengwei.yin@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zswap-make-zswap_load-take-a-folio-fix.patch added to mm-unstable branch
Message-Id: <20230810163538.7C2AAC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zswap: don't warn if none swapcache folio is passed to zswap_load
has been added to the -mm mm-unstable branch.  Its filename is
     zswap-make-zswap_load-take-a-folio-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zswap-make-zswap_load-take-a-folio-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Yin Fengwei <fengwei.yin@intel.com>
Subject: zswap: don't warn if none swapcache folio is passed to zswap_load
Date: Thu, 10 Aug 2023 17:56:52 +0800

With mm-unstable branch, if trigger swap activity and it's possible
see following warning:
[  178.093511][  T651] WARNING: CPU: 2 PID: 651 at mm/zswap.c:1387 zswap_load+0x67/0x570
[  178.095155][  T651] Modules linked in:
[  178.096103][  T651] CPU: 2 PID: 651 Comm: gmain Not tainted 6.5.0-rc4-00492-gad3232df3e41 #148
[  178.098372][  T651] Hardware name: QEMU Standard PC (i440FX + PIIX,1996), BIOS 1.14.0-2 04/01/2014
[  178.101114][  T651] RIP: 0010:zswap_load+0x67/0x570
[  178.102359][  T651] Code: a0 78 4b 85 e8 ea db ff ff 48 8b 00 a8 01 0f 84 84 04 00 00 48 89 df e8 d7 db ff ff 48 8b 00 a9 00 00 08 00 0f 85 c4
[  178.106376][  T651] RSP: 0018:ffffc900011b3760 EFLAGS: 00010246
[  178.107675][  T651] RAX: 0017ffffc0080001 RBX: ffffea0004a991c0 RCX:ffffc900011b37dc
[  178.109242][  T651] RDX: 0000000000000000 RSI: 0000000000000001 RDI:ffffea0004a991c0
[  178.110916][  T651] RBP: ffffea0004a991c0 R08: 0000000000000243 R09:00000000c9a1aafc
[  178.112377][  T651] R10: 00000000c9657db3 R11: 000000003c9657db R12:0000000000014b9c
[  178.113698][  T651] R13: ffff88813501e710 R14: ffff88810d591000 R15:0000000000000000
[  178.115008][  T651] FS:  00007fb21a9ff700(0000) GS:ffff88813bc80000(0000) knlGS:0000000000000000
[  178.116423][  T651] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  178.117421][  T651] CR2: 00005632cbfc81f6 CR3: 0000000131450002 CR4:0000000000370ee0
[  178.118683][  T651] DR0: 0000000000000000 DR1: 0000000000000000 DR2:0000000000000000
[  178.119894][  T651] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:0000000000000400
[  178.121087][  T651] Call Trace:
[  178.121654][  T651]  <TASK>
[  178.122109][  T651]  ? zswap_load+0x67/0x570
[  178.122658][  T651]  ? __warn+0x81/0x170
[  178.123119][  T651]  ? zswap_load+0x67/0x570
[  178.123608][  T651]  ? report_bug+0x167/0x190
[  178.124150][  T651]  ? handle_bug+0x3c/0x70
[  178.124615][  T651]  ? exc_invalid_op+0x13/0x60
[  178.125192][  T651]  ? asm_exc_invalid_op+0x16/0x20
[  178.125753][  T651]  ? zswap_load+0x67/0x570
[  178.126231][  T651]  ? lock_acquire+0xbb/0x290
[  178.126745][  T651]  ? folio_add_lru+0x40/0x1c0
[  178.127261][  T651]  ? find_held_lock+0x2b/0x80
[  178.127776][  T651]  swap_readpage+0xc7/0x5c0
[  178.128273][  T651]  do_swap_page+0x86d/0xf50
[  178.128770][  T651]  ? __pte_offset_map+0x3e/0x290
[  178.129321][  T651]  ? __pte_offset_map+0x1c4/0x290
[  178.129883][  T651]  __handle_mm_fault+0x6ad/0xca0
[  178.130419][  T651]  handle_mm_fault+0x18b/0x410
[  178.130992][  T651]  do_user_addr_fault+0x1f1/0x820
[  178.132076][  T651]  exc_page_fault+0x63/0x1a0
[  178.132599][  T651]  asm_exc_page_fault+0x22/0x30

It's possible that swap_readpage() is called with none swapcache folio
in do_swap_page() and trigger this warning. So we shouldn't assume
zswap_load() always takes swapcache folio.

Link: https://lkml.kernel.org/r/20230810095652.3905184-1-fengwei.yin@intel.com
Signed-off-by: Yin Fengwei <fengwei.yin@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/zswap.c~zswap-make-zswap_load-take-a-folio-fix
+++ a/mm/zswap.c
@@ -1421,7 +1421,6 @@ bool zswap_load(struct folio *folio)
 	bool ret;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
-	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
 
 	/* find */
 	spin_lock(&tree->lock);
_

Patches currently in -mm which might be from fengwei.yin@intel.com are

madvise-madvise_cold_or_pageout_pte_range-dont-use-mapcount-against-large-folio-for-sharing-check.patch
madvise-madvise_free_huge_pmd-dont-use-mapcount-against-large-folio-for-sharing-check.patch
madvise-madvise_free_pte_range-dont-use-mapcount-against-large-folio-for-sharing-check.patch
zswap-make-zswap_load-take-a-folio-fix.patch
filemap-add-filemap_map_folio_range.patch
rmap-add-folio_add_file_rmap_range.patch
mm-convert-do_set_pte-to-set_pte_range.patch
filemap-batch-pte-mappings.patch

