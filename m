From: akpm@linux-foundation.org
Subject: [patch 001/102] lib/dma-debug.c: make locking work for RT
Date: Wed, 03 May 2017 14:51:28 -0700
Message-ID: <20170503215128.zDg9v9xnB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47108 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751198AbdECVva (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:51:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jroedel@suse.de, luto@kernel.org, miles.chen@mediatek.com, mingo@kernel.org, mm-commits@vger.kernel.org, mtosatti@redhat.com, niklas.soderlund+renesas@ragnatech.se, pagupta@redhat.com, sgruszka@redhat.com, torvalds@linux-foundation.org, ville.syrjala@linux.intel.com, vinod.koul@intel.com

From: Pankaj Gupta <pagupta@redhat.com>
Subject: lib/dma-debug.c: make locking work for RT

Interrupt enable/disabled with spinlock is not a valid operation for RT as
it can make executing tasks sleep from a non-sleepable context.  So
convert it to spin_lock_irq[save, restore].

Link: http://lkml.kernel.org/r/1492065666-3816-1-git-send-email-pagupta@redhat.com
Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ville Syrjl <ville.syrjala@linux.intel.com>
Cc: Miles Chen <miles.chen@mediatek.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN lib/dma-debug.c~dma-debug-make-locking-to-work-for-rt lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-make-locking-to-work-for-rt
+++ a/lib/dma-debug.c
@@ -942,21 +942,17 @@ static int device_dma_allocations(struct
 	unsigned long flags;
 	int count = 0, i;
 
-	local_irq_save(flags);
-
 	for (i = 0; i < HASH_SIZE; ++i) {
-		spin_lock(&dma_entry_hash[i].lock);
+		spin_lock_irqsave(&dma_entry_hash[i].lock, flags);
 		list_for_each_entry(entry, &dma_entry_hash[i].list, list) {
 			if (entry->dev == dev) {
 				count += 1;
 				*out_entry = entry;
 			}
 		}
-		spin_unlock(&dma_entry_hash[i].lock);
+		spin_unlock_irqrestore(&dma_entry_hash[i].lock, flags);
 	}
 
-	local_irq_restore(flags);
