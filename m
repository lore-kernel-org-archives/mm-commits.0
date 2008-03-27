From: akpm@linux-foundation.org
Subject: + net-remove-nr_cpus-arrays-in-net-core-devc-v2.patch added to -mm tree
Date: Thu, 27 Mar 2008 01:00:38 -0700
Message-ID: <200803270800.m2R80cSk024716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753730AbYC0IBf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Mar 2008 04:01:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, davem@davemloft.net, jmorris@namei.org, kaber@trash.net, kuznet@ms2.inr.ac.ru


The patch titled
     net: remove NR_CPUS arrays in net/core/dev.c
has been added to the -mm tree.  Its filename is
     net-remove-nr_cpus-arrays-in-net-core-devc-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net: remove NR_CPUS arrays in net/core/dev.c
From: Mike Travis <travis@sgi.com>

Remove the fixed size channels[NR_CPUS] array in net/core/dev.c and
dynamically allocate array based on nr_cpu_ids.

Cc: David S. Miller <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: James Morris <jmorris@namei.org>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/dev.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN net/core/dev.c~net-remove-nr_cpus-arrays-in-net-core-devc-v2 net/core/dev.c
--- a/net/core/dev.c~net-remove-nr_cpus-arrays-in-net-core-devc-v2
+++ a/net/core/dev.c
@@ -162,7 +162,7 @@ struct net_dma {
 	struct dma_client client;
 	spinlock_t lock;
 	cpumask_t channel_mask;
-	struct dma_chan *channels[NR_CPUS];
+	struct dma_chan **channels;
 };
 
 static enum dma_state_client
@@ -2444,7 +2444,7 @@ static struct netif_rx_stats *softnet_ge
 {
 	struct netif_rx_stats *rc = NULL;
 
-	while (*pos < NR_CPUS)
+	while (*pos < nr_cpu_ids)
 		if (cpu_online(*pos)) {
 			rc = &per_cpu(netdev_rx_stat, *pos);
 			break;
@@ -4318,7 +4318,7 @@ netdev_dma_event(struct dma_client *clie
 	spin_lock(&net_dma->lock);
 	switch (state) {
 	case DMA_RESOURCE_AVAILABLE:
-		for (i = 0; i < NR_CPUS; i++)
+		for (i = 0; i < nr_cpu_ids; i++)
 			if (net_dma->channels[i] == chan) {
 				found = 1;
 				break;
@@ -4333,7 +4333,7 @@ netdev_dma_event(struct dma_client *clie
 		}
 		break;
 	case DMA_RESOURCE_REMOVED:
-		for (i = 0; i < NR_CPUS; i++)
+		for (i = 0; i < nr_cpu_ids; i++)
 			if (net_dma->channels[i] == chan) {
 				found = 1;
 				pos = i;
@@ -4360,6 +4360,13 @@ netdev_dma_event(struct dma_client *clie
  */
 static int __init netdev_dma_register(void)
 {
+	net_dma.channels = kzalloc(nr_cpu_ids * sizeof(struct net_dma),
+								GFP_KERNEL);
+	if (unlikely(!net_dma.channels)) {
+		printk(KERN_NOTICE
+				"netdev_dma: no memory for net_dma.channels\n");
+		return -ENOMEM;
+	}
 	spin_lock_init(&net_dma.lock);
 	dma_cap_set(DMA_MEMCPY, net_dma.client.cap_mask);
 	dma_async_client_register(&net_dma.client);
_

Patches currently in -mm which might be from travis@sgi.com are

git-cpufreq.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
cpufreq-change-cpu-freq-arrays-to-per_cpu-variables.patch
acpi-change-processors-from-array-to-per_cpu-variable.patch
cpumask-add-cpumask_scnprintf_len-function.patch
cpu-change-cpu_sys_devices-from-array-to-per_cpu-variable.patch
net-remove-nr_cpus-arrays-in-net-core-devc-v2.patch
sched-remove-fixed-nr_cpus-sized-arrays-in-kernel_schedc.patch

