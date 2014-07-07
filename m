From: akpm@linux-foundation.org
Subject: +
 bio-integrity-remove-the-needless-fail-handle-of-bip_slab-creating.patch
 added to -mm tree
Date: Mon, 07 Jul 2014 13:36:38 -0700
Message-ID: <53bb04d6.kgiPUwlfpXmw3jJ/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:52412 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaGGUgj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 16:36:39 -0400
Received: by mail-pd0-f202.google.com with SMTP id r10so1043224pdi.5
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 13:36:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guz.fnst@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bio-integrity: remove the needless fail handle of bip_slab creating
has been added to the -mm tree.  Its filename is
     bio-integrity-remove-the-needless-fail-handle-of-bip_slab-creating.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bio-integrity-remove-the-needless-fail-handle-of-bip_slab-creating.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bio-integrity-remove-the-needless-fail-handle-of-bip_slab-creating.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: bio-integrity: remove the needless fail handle of bip_slab creating

bip_slab is created with SLAB_PANIC, so the fail handler is unneeded.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/bio-integrity.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN block/bio-integrity.c~bio-integrity-remove-the-needless-fail-handle-of-bip_slab-creating block/bio-integrity.c
--- a/block/bio-integrity.c~bio-integrity-remove-the-needless-fail-handle-of-bip_slab-creating
+++ a/block/bio-integrity.c
@@ -652,6 +652,4 @@ void __init bio_integrity_init(void)
 				     sizeof(struct bio_integrity_payload) +
 				     sizeof(struct bio_vec) * BIP_INLINE_VECS,
 				     0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
-	if (!bip_slab)
-		panic("Failed to create slab\n");
 }
_

Patches currently in -mm which might be from guz.fnst@cn.fujitsu.com are

x86mem-hotplug-pass-sync_global_pgds-a-correct-argument-in-remove_pagetable.patch
x86mem-hotplug-modify-pgd-entry-when-removing-memory.patch
bio-integrity-remove-the-needless-fail-handle-of-bip_slab-creating.patch
mem-hotplug-avoid-illegal-state-prefixed-with-legal-state-when-changing-state-of-memory_block.patch
mem-hotplug-introduce-mmop_offline-to-replace-the-hard-coding-1.patch
linux-next.patch

