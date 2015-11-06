From: akpm@linux-foundation.org
Subject: [merged]
 tools-vm-slabinfo-limit-the-number-of-reported-slabs.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:06:44 -0800
Message-ID: <563d0854.fdfW+NmaPVwGtibw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48555 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033238AbbKFUGp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:06:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/slabinfo: limit the number of reported slabs
has been removed from the -mm tree.  Its filename was
     tools-vm-slabinfo-limit-the-number-of-reported-slabs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: tools/vm/slabinfo: limit the number of reported slabs

Introduce opt "-N|--lines=K" to limit the number of slabs
being reported in output_slabs().

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/slabinfo.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff -puN tools/vm/slabinfo.c~tools-vm-slabinfo-limit-the-number-of-reported-slabs tools/vm/slabinfo.c
--- a/tools/vm/slabinfo.c~tools-vm-slabinfo-limit-the-number-of-reported-slabs
+++ a/tools/vm/slabinfo.c
@@ -79,6 +79,7 @@ int sort_active = 0;
 int set_debug = 0;
 int show_ops = 0;
 int show_activity = 0;
+int output_lines = -1;
 
 /* Debug options */
 int sanity = 0;
@@ -124,6 +125,7 @@ static void usage(void)
 		"-v|--validate          Validate slabs\n"
 		"-z|--zero              Include empty slabs\n"
 		"-1|--1ref              Single reference\n"
+		"-N|--lines=K           Show the first K slabs\n"
 		"\nValid debug options (FZPUT may be combined)\n"
 		"a / A          Switch on all debug options (=FZUP)\n"
 		"-              Switch off all debug options\n"
@@ -1242,11 +1244,14 @@ static void output_slabs(void)
 {
 	struct slabinfo *slab;
 
-	for (slab = slabinfo; slab < slabinfo + slabs; slab++) {
+	for (slab = slabinfo; (slab < slabinfo + slabs) &&
+			output_lines != 0; slab++) {
 
 		if (slab->alias)
 			continue;
 
+		if (output_lines != -1)
+			output_lines--;
 
 		if (show_numa)
 			slab_numa(slab, 0);
@@ -1285,6 +1290,7 @@ struct option opts[] = {
 	{ "validate", no_argument, NULL, 'v' },
 	{ "zero", no_argument, NULL, 'z' },
 	{ "1ref", no_argument, NULL, '1'},
+	{ "lines", required_argument, NULL, 'N'},
 	{ NULL, 0, NULL, 0 }
 };
 
@@ -1296,7 +1302,7 @@ int main(int argc, char *argv[])
 
 	page_size = getpagesize();
 
-	while ((c = getopt_long(argc, argv, "aAd::Defhil1noprstvzTS",
+	while ((c = getopt_long(argc, argv, "aAd::Defhil1noprstvzTSN:",
 						opts, NULL)) != -1)
 		switch (c) {
 		case '1':
@@ -1358,7 +1364,13 @@ int main(int argc, char *argv[])
 		case 'S':
 			sort_size = 1;
 			break;
