From: akpm@linux-foundation.org
Subject: [patch 013/131] tools: slabinfo: add "-U" option to show
 unreclaimable slabs only
Date: Wed, 15 Nov 2017 17:31:59 -0800
Message-ID: <20171116013159.aqnkWS1q4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38394 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933442AbdKPBcB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:32:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, torvalds@linux-foundation.org, yang.s@alibaba-inc.com

From: "Yang Shi" <yang.s@alibaba-inc.com>
Subject: tools: slabinfo: add "-U" option to show unreclaimable slabs only

Patch series "oom: capture unreclaimable slab info in oom message", v10.

Recently we ran into a oom issue, kernel panic due to no killable process.
The dmesg shows huge unreclaimable slabs used almost 100% memory, but
kdump doesn't capture vmcore due to some reason.

So, it may sound better to capture unreclaimable slab info in oom message
when kernel panic to aid trouble shooting and cover the corner case. 
Since kernel already panic, so capturing more information sounds worthy
and doesn't bother normal oom killer.

With the patchset, tools/vm/slabinfo has a new option, "-U", to show
unreclaimable slab only.

And, oom will print all non zero (num_objs * size != 0) unreclaimable
slabs in oom killer message.


This patch (of 3):

Add "-U" option to show unreclaimable slabs only.

"-U" and "-S" together can tell us what unreclaimable slabs use the most
memory to help debug huge unreclaimable slabs issue.

Link: http://lkml.kernel.org/r/1507152550-46205-2-git-send-email-yang.s@alibaba-inc.com
Signed-off-by: Yang Shi <yang.s@alibaba-inc.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/slabinfo.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN tools/vm/slabinfo.c~tools-slabinfo-add-u-option-to-show-unreclaimable-slabs-only tools/vm/slabinfo.c
--- a/tools/vm/slabinfo.c~tools-slabinfo-add-u-option-to-show-unreclaimable-slabs-only
+++ a/tools/vm/slabinfo.c
@@ -84,6 +84,7 @@ int output_lines = -1;
 int sort_loss;
 int extended_totals;
 int show_bytes;
+int unreclaim_only;
 
 /* Debug options */
 int sanity;
@@ -133,6 +134,7 @@ static void usage(void)
 		"-L|--Loss              Sort by loss\n"
 		"-X|--Xtotals           Show extended summary information\n"
 		"-B|--Bytes             Show size in bytes\n"
+		"-U|--Unreclaim		Show unreclaimable slabs only\n"
 		"\nValid debug options (FZPUT may be combined)\n"
 		"a / A          Switch on all debug options (=FZUP)\n"
 		"-              Switch off all debug options\n"
@@ -569,6 +571,9 @@ static void slabcache(struct slabinfo *s
 	if (strcmp(s->name, "*") == 0)
 		return;
 
+	if (unreclaim_only && s->reclaim_account)
+		return;
+
 	if (actual_slabs == 1) {
 		report(s);
 		return;
@@ -1347,6 +1352,7 @@ struct option opts[] = {
 	{ "Loss", no_argument, NULL, 'L'},
 	{ "Xtotals", no_argument, NULL, 'X'},
 	{ "Bytes", no_argument, NULL, 'B'},
+	{ "Unreclaim", no_argument, NULL, 'U'},
 	{ NULL, 0, NULL, 0 }
 };
 
@@ -1358,7 +1364,7 @@ int main(int argc, char *argv[])
 
 	page_size = getpagesize();
 
-	while ((c = getopt_long(argc, argv, "aAd::Defhil1noprstvzTSN:LXB",
+	while ((c = getopt_long(argc, argv, "aAd::Defhil1noprstvzTSN:LXBU",
 						opts, NULL)) != -1)
 		switch (c) {
 		case '1':
@@ -1439,6 +1445,9 @@ int main(int argc, char *argv[])
 		case 'B':
 			show_bytes = 1;
 			break;
+		case 'U':
+			unreclaim_only = 1;
+			break;
 		default:
 			fatal("%s: Invalid option '%c'\n", argv[0], optopt);
 
_
