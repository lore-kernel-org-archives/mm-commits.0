From: akpm@linux-foundation.org
Subject: + tools-vm-slabinfo-introduce-extended-totals-mode.patch added to -mm tree
Date: Fri, 16 Oct 2015 15:36:01 -0700
Message-ID: <56217bd1.YUJv2EJrs8nHUegb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56720 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbbJPWgC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Oct 2015 18:36:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/slabinfo: introduce extended totals mode
has been added to the -mm tree.  Its filename is
     tools-vm-slabinfo-introduce-extended-totals-mode.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-vm-slabinfo-introduce-extended-totals-mode.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-slabinfo-introduce-extended-totals-mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: tools/vm/slabinfo: introduce extended totals mode

Add "-X|--Xtotals" opt to output extended totals summary,
which includes:
-- totals summary
-- slabs sorted by size
-- slabs sorted by loss (waste)

Example:
=======

slabinfo --X -N 1
  Slabcache Totals
  ----------------
  Slabcaches :  91      Aliases  : 120->69  Active:  65
  Memory used: 568.3M   # Loss   :  30.4M   MRatio:     5%
  # Objects  : 920.1K   # PartObj: 161.2K   ORatio:    17%

  Per Cache    Average         Min         Max       Total
  ---------------------------------------------------------
  #Objects       14.1K           1      227.8K      920.1K
  #Slabs           533           1       11.7K       34.7K
  #PartSlab         86           0        4.3K        5.6K
  %PartSlab        24%          0%        100%         16%
  PartObjs          17           0      129.3K      161.2K
  % PartObj        17%          0%        100%         17%
  Memory          8.7M        8.1K      384.7M      568.3M
  Used            8.2M         160      366.5M      537.9M
  Loss          468.8K           0       18.2M       30.4M

  Per Object   Average         Min         Max
  ---------------------------------------------
  Memory           587           8        8.1K
  User             584           8        8.1K
  Loss               2           0          64

  Slabs sorted by size
  ----------------------
  Name                   Objects Objsize    Space Slabs/Part/Cpu  O/S O %Fr %Ef Flg
  ext4_inode_cache        211142    1736   384.7M    11732/40/10   18 3   0  95 a

  Slabs sorted by loss
  ----------------------
  Name                   Objects Objsize    Loss Slabs/Part/Cpu  O/S O %Fr %Ef Flg
  ext4_inode_cache        211142    1736    18.2M    11732/40/10   18 3   0  95 a

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/slabinfo.c |   54 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 44 insertions(+), 10 deletions(-)

diff -puN tools/vm/slabinfo.c~tools-vm-slabinfo-introduce-extended-totals-mode tools/vm/slabinfo.c
--- a/tools/vm/slabinfo.c~tools-vm-slabinfo-introduce-extended-totals-mode
+++ a/tools/vm/slabinfo.c
@@ -81,6 +81,7 @@ int show_ops = 0;
 int show_activity = 0;
 int output_lines = -1;
 int sort_loss;
+int extended_totals;
 
 /* Debug options */
 int sanity = 0;
@@ -128,6 +129,7 @@ static void usage(void)
 		"-1|--1ref              Single reference\n"
 		"-N|--lines=K           Show the first K slabs\n"
 		"-L|--Loss              Sort by loss\n"
+		"-X|--Xtotals           Show extended summary information\n"
 		"\nValid debug options (FZPUT may be combined)\n"
 		"a / A          Switch on all debug options (=FZUP)\n"
 		"-              Switch off all debug options\n"
@@ -615,8 +617,7 @@ static void slabcache(struct slabinfo *s
 			total_free ? (s->free_fastpath * 100 / total_free) : 0,
 			s->order_fallback, s->order, s->cmpxchg_double_fail,
 			s->cmpxchg_double_cpu_fail);
-	}
-	else
+	} else {
 		printf("%-21s %8ld %7d %8s %14s %4d %1d %3ld %3ld %s\n",
 			s->name, s->objects, s->object_size, size_str, dist_str,
 			s->objs_per_slab, s->order,
@@ -624,6 +625,7 @@ static void slabcache(struct slabinfo *s
 			s->slabs ? (s->objects * s->object_size * 100) /
 				(s->slabs * (page_size << s->order)) : 100,
 			flags);
+	}
 }
 
 /*
@@ -1256,15 +1258,16 @@ static void read_slab_dir(void)
 static void output_slabs(void)
 {
 	struct slabinfo *slab;
+	int lines = output_lines;
 
 	for (slab = slabinfo; (slab < slabinfo + slabs) &&
-			output_lines != 0; slab++) {
+			lines != 0; slab++) {
 
 		if (slab->alias)
 			continue;
 
-		if (output_lines != -1)
-			output_lines--;
+		if (lines != -1)
+			lines--;
 
 		if (show_numa)
 			slab_numa(slab, 0);
@@ -1285,6 +1288,30 @@ static void output_slabs(void)
 	}
 }
 
+static void xtotals(void)
+{
+	totals();
+
+	link_slabs();
+	rename_slabs();
+
+	printf("\nSlabs sorted by size\n");
+	printf("----------------------\n");
+	sort_loss = 0;
+	sort_size = 1;
+	sort_slabs();
+	output_slabs();
+
+	printf("\nSlabs sorted by loss\n");
+	printf("----------------------\n");
+	line = 0;
+	sort_loss = 1;
+	sort_size = 0;
+	sort_slabs();
+	output_slabs();
+	printf("\n");
+}
+
 struct option opts[] = {
 	{ "aliases", no_argument, NULL, 'a' },
 	{ "activity", no_argument, NULL, 'A' },
@@ -1307,6 +1334,7 @@ struct option opts[] = {
 	{ "1ref", no_argument, NULL, '1'},
 	{ "lines", required_argument, NULL, 'N'},
 	{ "Loss", no_argument, NULL, 'L'},
+	{ "Xtotals", no_argument, NULL, 'X'},
 	{ NULL, 0, NULL, 0 }
 };
 
@@ -1318,7 +1346,7 @@ int main(int argc, char *argv[])
 
 	page_size = getpagesize();
 
-	while ((c = getopt_long(argc, argv, "aAd::Defhil1noprstvzTSN:L",
+	while ((c = getopt_long(argc, argv, "aAd::Defhil1noprstvzTSN:LX",
 						opts, NULL)) != -1)
 		switch (c) {
 		case '1':
@@ -1390,6 +1418,11 @@ int main(int argc, char *argv[])
 		case 'L':
 			sort_loss = 1;
 			break;
+		case 'X':
+			if (output_lines == -1)
+				output_lines = 1;
+			extended_totals = 1;
+			break;
 		default:
 			fatal("%s: Invalid option '%c'\n", argv[0], optopt);
 
@@ -1409,12 +1442,13 @@ int main(int argc, char *argv[])
 		fatal("%s: Invalid pattern '%s' code %d\n",
 			argv[0], pattern_source, err);
 	read_slab_dir();
-	if (show_alias)
+	if (show_alias) {
 		alias();
-	else
-	if (show_totals)
+	} else if (extended_totals) {
+		xtotals();
+	} else if (show_totals) {
 		totals();
-	else {
+	} else {
 		link_slabs();
 		rename_slabs();
 		sort_slabs();
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

maintainers-add-myself-as-zsmalloc-reviewer.patch
tools-vm-slabinfo-use-getopt-no_argument-optional_argument.patch
tools-vm-slabinfo-limit-the-number-of-reported-slabs.patch
tools-vm-slabinfo-sort-slabs-by-loss.patch
tools-vm-slabinfo-fix-alternate-opts-names.patch
tools-vm-slabinfo-introduce-extended-totals-mode.patch
tools-vm-slabinfo-output-sizes-in-bytes.patch
tools-vm-slabinfo-cosmetic-globals-cleanup.patch
tools-vm-slabinfo-gnuplot-slabifo-extended-stat.patch
zram-keep-the-exact-overcommited-value-in-mem_used_max.patch
mm-zsmalloc-constify-struct-zs_pool-name.patch
zsmalloc-use-preempth-for-in_interrupt.patch

