From: akpm@linux-foundation.org
Subject: [merged]
 ipc-sem-play-nicer-with-large-nsops-allocations.patch removed from -mm tree
Date: Mon, 11 Sep 2017 12:44:22 -0700
Message-ID: <20170911194422.xa3HkKHvY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50976 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751029AbdIKToX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:44:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem: play nicer with large nsops allocations
has been removed from the -mm tree.  Its filename was
     ipc-sem-play-nicer-with-large-nsops-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: ipc/sem: play nicer with large nsops allocations

Replacing semop()'s kmalloc for kvmalloc was originally proposed by
Manfred on the premise that it can be called for large (than order-1)
sizes.  For example, while Oracle recommends setting SEMOPM to a _minimum_
of 100, some distros[1] encourage the setting to be a factor of the amount
of db tasks (PROCESSES), which can get fishy for large systems (easily
going beyond 1000).

[1] An Example of Semaphore Settings
https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/5/html/Tuning_and_Optimizing_Red_Hat_Enterprise_Linux_for_Oracle_9i_and_10g_Databases/sect-Oracle_9i_and_10g_Tuning_Guide-Setting_Semaphores-An_Example_of_Semaphore_Settings.html

So let's just convert this to kvmalloc, just like the rest of the
allocations we do in ipc.  While the fallback vmalloc obviously involves
more overhead, this by far the uncommon path, and it's better for the user
than just erroring out with kmalloc.

Link: http://lkml.kernel.org/r/20170803184136.13855-2-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN ipc/sem.c~ipc-sem-play-nicer-with-large-nsops-allocations ipc/sem.c
--- a/ipc/sem.c~ipc-sem-play-nicer-with-large-nsops-allocations
+++ a/ipc/sem.c
@@ -1784,7 +1784,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 	if (nsops > ns->sc_semopm)
 		return -E2BIG;
 	if (nsops > SEMOPM_FAST) {
-		sops = kmalloc(sizeof(*sops)*nsops, GFP_KERNEL);
+		sops = kvmalloc(sizeof(*sops)*nsops, GFP_KERNEL);
 		if (sops == NULL)
 			return -ENOMEM;
 	}
@@ -2016,7 +2016,7 @@ out_unlock_free:
 	rcu_read_unlock();
 out_free:
 	if (sops != fast_sops)
-		kfree(sops);
+		kvfree(sops);
 	return error;
 }
 
_

Patches currently in -mm which might be from dave@stgolabs.net are


