From: akpm@linux-foundation.org
Subject: + tools-vm-slabinfo-sort-slabs-by-loss.patch added to -mm tree
Date: Fri, 16 Oct 2015 15:35:57 -0700
Message-ID: <56217bcd.ix46EK9CDstOZGo2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56710 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbbJPWf6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Oct 2015 18:35:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/slabinfo: sort slabs by loss
has been added to the -mm tree.  Its filename is
     tools-vm-slabinfo-sort-slabs-by-loss.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-vm-slabinfo-sort-slabs-by-loss.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-slabinfo-sort-slabs-by-loss.patch

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

