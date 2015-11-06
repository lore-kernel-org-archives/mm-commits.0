From: akpm@linux-foundation.org
Subject: [merged] tools-vm-slabinfo-sort-slabs-by-loss.patch removed from
 -mm tree
Date: Fri, 06 Nov 2015 12:06:46 -0800
Message-ID: <563d0856.4KtsWBvBmkUTW0jl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48557 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033238AbbKFUGr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:06:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/slabinfo: sort slabs by loss
has been removed from the -mm tree.  Its filename was
     tools-vm-slabinfo-sort-slabs-by-loss.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: tools/vm/slabinfo: sort slabs by loss

Introduce opt "-L|--sort-loss" to sort and output slabs by
loss (waste) in slabcache().

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/slabinfo.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff -puN tools/vm/slabinfo.c~tools-vm-slabinfo-sort-slabs-by-loss tools/vm/slabinfo.c
--- a/tools/vm/slabinfo.c~tools-vm-slabinfo-sort-slabs-by-loss
+++ a/tools/vm/slabinfo.c
@@ -80,6 +80,7 @@ int set_debug = 0;
 int show_ops = 0;
 int show_activity = 0;
 int output_lines = -1;
+int sort_loss;
 
 /* Debug options */
 int sanity = 0;
@@ -126,6 +127,7 @@ static void usage(void)
 		"-z|--zero              Include empty slabs\n"
 		"-1|--1ref              Single reference\n"
 		"-N|--lines=K           Show the first K slabs\n"
+		"-L|--Loss              Sort by loss\n"
 		"\nValid debug options (FZPUT may be combined)\n"
 		"a / A          Switch on all debug options (=FZUP)\n"
 		"-              Switch off all debug options\n"
@@ -301,8 +303,9 @@ static void first_line(void)
 	if (show_activity)
 		printf("Name                   Objects      Alloc       Free   %%Fast Fallb O CmpX   UL\n");
 	else
-		printf("Name                   Objects Objsize    Space "
-			"Slabs/Part/Cpu  O/S O %%Fr %%Ef Flg\n");
+		printf("Name                   Objects Objsize    %s "
+			"Slabs/Part/Cpu  O/S O %%Fr %%Ef Flg\n",
+			sort_loss ? "Loss" : "Space");
 }
 
 /*
@@ -335,6 +338,11 @@ static unsigned long slab_activity(struc
 		s->alloc_slowpath + s->free_slowpath;
 }
 
+static unsigned long slab_waste(struct slabinfo *s)
+{
+	return	slab_size(s) - s->objects * s->object_size;
+}
+
 static void slab_numa(struct slabinfo *s, int mode)
 {
 	int node;
@@ -563,7 +571,10 @@ static void slabcache(struct slabinfo *s
 	if (show_empty && s->slabs)
 		return;
 
-	store_size(size_str, slab_size(s));
+	if (sort_loss == 0)
+		store_size(size_str, slab_size(s));
+	else
+		store_size(size_str, slab_waste(s));
 	snprintf(dist_str, 40, "%lu/%lu/%d", s->slabs - s->cpu_slabs,
 						s->partial, s->cpu_slabs);
 
@@ -1013,6 +1024,8 @@ static void sort_slabs(void)
 				result = slab_size(s1) < slab_size(s2);
 			else if (sort_active)
 				result = slab_activity(s1) < slab_activity(s2);
+			else if (sort_loss)
+				result = slab_waste(s1) < slab_waste(s2);
 			else
 				result = strcasecmp(s1->name, s2->name);
 
@@ -1291,6 +1304,7 @@ struct option opts[] = {
 	{ "zero", no_argument, NULL, 'z' },
 	{ "1ref", no_argument, NULL, '1'},
 	{ "lines", required_argument, NULL, 'N'},
+	{ "Loss", no_argument, NULL, 'L'},
 	{ NULL, 0, NULL, 0 }
 };
 
@@ -1302,7 +1316,7 @@ int main(int argc, char *argv[])
 
 	page_size = getpagesize();
 
-	while ((c = getopt_long(argc, argv, "aAd::Defhil1noprstvzTSN:",
+	while ((c = getopt_long(argc, argv, "aAd::Defhil1noprstvzTSN:L",
 						opts, NULL)) != -1)
 		switch (c) {
 		case '1':
@@ -1371,6 +1385,9 @@ int main(int argc, char *argv[])
 					output_lines = 1;
 			}
 			break;
+		case 'L':
+			sort_loss = 1;
+			break;
 		default:
 			fatal("%s: Invalid option '%c'\n", argv[0], optopt);
 
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-keep-the-exact-overcommited-value-in-mem_used_max.patch
mm-zsmalloc-constify-struct-zs_pool-name.patch
zsmalloc-use-preempth-for-in_interrupt.patch

