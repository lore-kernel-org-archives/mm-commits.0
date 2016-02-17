From: akpm@linux-foundation.org
Subject: +
 virtio_balloon-export-available-memory-to-balloon-statistics.patch added to -mm tree
Date: Tue, 16 Feb 2016 16:28:13 -0800
Message-ID: <56c3be9d.fBdx/+QgMH0Bkd6O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933538AbcBQA2O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Feb 2016 19:28:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: redkoi@virtuozzo.com, den@openvz.org, mst@redhat.com, rkagan@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: virtio_balloon: export 'available' memory to balloon statistics
has been added to the -mm tree.  Its filename is
     virtio_balloon-export-available-memory-to-balloon-statistics.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/virtio_balloon-export-available-memory-to-balloon-statistics.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/virtio_balloon-export-available-memory-to-balloon-statistics.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Igor Redko <redkoi@virtuozzo.com>
Subject: virtio_balloon: export 'available' memory to balloon statistics

Add a new field, VIRTIO_BALLOON_S_AVAIL, to virtio_balloon memory
statistics protocol, corresponding to 'Available' in /proc/meminfo.

It indicates to the hypervisor how big the balloon can be inflated without
pushing the guest system to swap.

Signed-off-by: Igor Redko <redkoi@virtuozzo.com>
Signed-off-by: Denis V. Lunev <den@openvz.org>
Reviewed-by: Roman Kagan <rkagan@virtuozzo.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_balloon.c     |    6 ++++++
 include/uapi/linux/virtio_balloon.h |    3 ++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/virtio/virtio_balloon.c~virtio_balloon-export-available-memory-to-balloon-statistics drivers/virtio/virtio_balloon.c
--- a/drivers/virtio/virtio_balloon.c~virtio_balloon-export-available-memory-to-balloon-statistics
+++ a/drivers/virtio/virtio_balloon.c
@@ -30,6 +30,7 @@
 #include <linux/balloon_compaction.h>
 #include <linux/oom.h>
 #include <linux/wait.h>
+#include <linux/mm.h>
 
 /*
  * Balloon device works in 4K page units.  So each page is pointed to by
@@ -229,10 +230,13 @@ static void update_balloon_stats(struct
 	unsigned long events[NR_VM_EVENT_ITEMS];
 	struct sysinfo i;
 	int idx = 0;
+	long available;
 
 	all_vm_events(events);
 	si_meminfo(&i);
 
+	available = si_mem_available();
+
 	update_stat(vb, idx++, VIRTIO_BALLOON_S_SWAP_IN,
 				pages_to_bytes(events[PSWPIN]));
 	update_stat(vb, idx++, VIRTIO_BALLOON_S_SWAP_OUT,
@@ -243,6 +247,8 @@ static void update_balloon_stats(struct
 				pages_to_bytes(i.freeram));
 	update_stat(vb, idx++, VIRTIO_BALLOON_S_MEMTOT,
 				pages_to_bytes(i.totalram));
+	update_stat(vb, idx++, VIRTIO_BALLOON_S_AVAIL,
+				pages_to_bytes(available));
 }
 
 /*
diff -puN include/uapi/linux/virtio_balloon.h~virtio_balloon-export-available-memory-to-balloon-statistics include/uapi/linux/virtio_balloon.h
--- a/include/uapi/linux/virtio_balloon.h~virtio_balloon-export-available-memory-to-balloon-statistics
+++ a/include/uapi/linux/virtio_balloon.h
@@ -51,7 +51,8 @@ struct virtio_balloon_config {
 #define VIRTIO_BALLOON_S_MINFLT   3   /* Number of minor faults */
 #define VIRTIO_BALLOON_S_MEMFREE  4   /* Total amount of free memory */
 #define VIRTIO_BALLOON_S_MEMTOT   5   /* Total amount of memory */
-#define VIRTIO_BALLOON_S_NR       6
+#define VIRTIO_BALLOON_S_AVAIL    6   /* Available memory as in /proc */
+#define VIRTIO_BALLOON_S_NR       7
 
 /*
  * Memory statistics structure.
_

Patches currently in -mm which might be from redkoi@virtuozzo.com are

calculate-available-memory-in-the-separate-function.patch
virtio_balloon-export-available-memory-to-balloon-statistics.patch

