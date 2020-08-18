Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A79C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C99E820786
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597790446;
	bh=4fcZ3NnqbK7id4HvRhdDD3sF2BWDwVFehZPCiVr8oSQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=wj6V1nRrCFy07mmCE4OnnWbqKa7FXOJEkIbIB74WLEk0+1SO6Yvgwa1v2PoSc2E5e
	 +bGdSQIyM++lMcXSQOBxZYSBtZGho6RdFF3+s0A69z3f3SWaPz1NvuxRn6oZu7rFP5
	 E5FKfxkue8G06Hb56dK9NQlJRwGwUuojm8BSmi1w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgHRWkq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:40:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727070AbgHRWko (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 18:40:44 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87DB120786;
        Tue, 18 Aug 2020 22:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597790443;
        bh=4fcZ3NnqbK7id4HvRhdDD3sF2BWDwVFehZPCiVr8oSQ=;
        h=Date:From:To:Subject:From;
        b=qJySdfTj0Vs+c871Q5hL0sm/LfNTFTv6mHbs56HXocWucJPkCaRJ2XT97nBCU8sgY
         lqaokGZCko0z7AP5ragpLz0T/A2kBNsa3xnAVhS2vRuTdr17RaEb0QrEIrkyxX6lmR
         WjDI7v30FnXW7MZDn7mzDemMtF6XrNFX7w8wXkGI=
Date:   Tue, 18 Aug 2020 15:40:43 -0700
From:   akpm@linux-foundation.org
To:     cai@lca.pw, catalin.marinas@arm.com, elver@google.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-kmemleak-silence-kcsan-splats-in-checksum.patch removed from -mm tree
Message-ID: <20200818224043.gkzKcDILS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kmemleak: silence KCSAN splats in checksum
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-silence-kcsan-splats-in-checksum.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: mm/kmemleak: silence KCSAN splats in checksum

Even if KCSAN is disabled for kmemleak, update_checksum() could still call
crc32() (which is outside of kmemleak.c) to dereference object->pointer. 
Thus, the value of object->pointer could be accessed concurrently as
noticed by KCSAN,

 BUG: KCSAN: data-race in crc32_le_base / do_raw_spin_lock

 write to 0xffffb0ea683a7d50 of 4 bytes by task 23575 on cpu 12:
  do_raw_spin_lock+0x114/0x200
  debug_spin_lock_after at kernel/locking/spinlock_debug.c:91
  (inlined by) do_raw_spin_lock at kernel/locking/spinlock_debug.c:115
  _raw_spin_lock+0x40/0x50
  __handle_mm_fault+0xa9e/0xd00
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 read to 0xffffb0ea683a7d50 of 4 bytes by task 839 on cpu 60:
  crc32_le_base+0x67/0x350
  crc32_le_base+0x67/0x350:
  crc32_body at lib/crc32.c:106
  (inlined by) crc32_le_generic at lib/crc32.c:179
  (inlined by) crc32_le at lib/crc32.c:197
  kmemleak_scan+0x528/0xd90
  update_checksum at mm/kmemleak.c:1172
  (inlined by) kmemleak_scan at mm/kmemleak.c:1497
  kmemleak_scan_thread+0xcc/0xfa
  kthread+0x1e0/0x200
  ret_from_fork+0x27/0x50

If a shattered value was returned due to a data race, it will be corrected
in the next scan.  Thus, let KCSAN ignore all reads in the region to
silence KCSAN in case the write side is non-atomic.

Link: http://lkml.kernel.org/r/20200317182754.2180-1-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Suggested-by: Marco Elver <elver@google.com>
Acked-by: Marco Elver <elver@google.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/kmemleak.c~mm-kmemleak-silence-kcsan-splats-in-checksum
+++ a/mm/kmemleak.c
@@ -1169,8 +1169,10 @@ static bool update_checksum(struct kmeml
 	u32 old_csum = object->checksum;
 
 	kasan_disable_current();
+	kcsan_disable_current();
 	object->checksum = crc32(0, (void *)object->pointer, object->size);
 	kasan_enable_current();
+	kcsan_enable_current();
 
 	return object->checksum != old_csum;
 }
_

Patches currently in -mm which might be from cai@lca.pw are

fork-silence-a-false-postive-warning-in-__mmdrop.patch

