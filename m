From: akpm@linux-foundation.org
Subject: + dma-debug-make-locking-to-work-for-rt.patch added to -mm tree
Date: Thu, 13 Apr 2017 13:09:53 -0700
Message-ID: <58efdb11.CASprjHKfKpwrmrV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35158 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755452AbdDMUJz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Apr 2017 16:09:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pagupta@redhat.com, jroedel@suse.de, luto@kernel.org, miles.chen@mediatek.com, mingo@kernel.org, mtosatti@redhat.com, niklas.soderlund+renesas@ragnatech.se, sgruszka@redhat.com, ville.syrjala@linux.intel.com, vinod.koul@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/dma-debug.c: make locking work for RT
has been added to the -mm tree.  Its filename is
     dma-debug-make-locking-to-work-for-rt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-debug-make-locking-to-work-for-rt.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-debug-make-locking-to-work-for-rt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
