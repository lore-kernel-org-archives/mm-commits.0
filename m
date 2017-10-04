From: akpm@linux-foundation.org
Subject: +
 tools-slabinfo-add-u-option-to-show-unreclaimable-slabs-only.patch added to -mm tree
Date: Wed, 04 Oct 2017 15:04:49 -0700
Message-ID: <59d55b01.JCXzUpSP7khnRiz+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44174 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdJDWEu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 18:04:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yang.s@alibaba-inc.com, cl@linux.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools: slabinfo: add "-U" option to show unreclaimable slabs only
has been added to the -mm tree.  Its filename is
     tools-slabinfo-add-u-option-to-show-unreclaimable-slabs-only.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-slabinfo-add-u-option-to-show-unreclaimable-slabs-only.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-slabinfo-add-u-option-to-show-unreclaimable-slabs-only.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -83,6 +83,7 @@ int output_lines = -1;
 int sort_loss;
 int extended_totals;
 int show_bytes;
+int unreclaim_only;
 
 /* Debug options */
 int sanity;
@@ -132,6 +133,7 @@ static void usage(void)
 		"-L|--Loss              Sort by loss\n"
 		"-X|--Xtotals           Show extended summary information\n"
 		"-B|--Bytes             Show size in bytes\n"
+		"-U|--Unreclaim		Show unreclaimable slabs only\n"
 		"\nValid debug options (FZPUT may be combined)\n"
 		"a / A          Switch on all debug options (=FZUP)\n"
 		"-              Switch off all debug options\n"
@@ -568,6 +570,9 @@ static void slabcache(struct slabinfo *s
 	if (strcmp(s->name, "*") == 0)
 		return;
 
+	if (unreclaim_only && s->reclaim_account)
+		return;
+
 	if (actual_slabs == 1) {
 		report(s);
 		return;
@@ -1346,6 +1351,7 @@ struct option opts[] = {
 	{ "Loss", no_argument, NULL, 'L'},
 	{ "Xtotals", no_argument, NULL, 'X'},
 	{ "Bytes", no_argument, NULL, 'B'},
+	{ "Unreclaim", no_argument, NULL, 'U'},
 	{ NULL, 0, NULL, 0 }
 };
 
@@ -1357,7 +1363,7 @@ int main(int argc, char *argv[])
 
 	page_size = getpagesize();
 
-	while ((c = getopt_long(argc, argv, "aAd::Defhil1noprstvzTSN:LXB",
+	while ((c = getopt_long(argc, argv, "aAd::Defhil1noprstvzTSN:LXBU",
 						opts, NULL)) != -1)
 		switch (c) {
 		case '1':
@@ -1438,6 +1444,9 @@ int main(int argc, char *argv[])
 		case 'B':
 			show_bytes = 1;
 			break;
+		case 'U':
+			unreclaim_only = 1;
+			break;
 		default:
 			fatal("%s: Invalid option '%c'\n", argv[0], optopt);
 
_

Patches currently in -mm which might be from yang.s@alibaba-inc.com are

mm-madvise-add-description-for-madv_wipeonfork-and-madv_keeponfork.patch
tools-slabinfo-add-u-option-to-show-unreclaimable-slabs-only.patch
mm-slabinfo-dump-config_slabinfo.patch
mm-oom-show-unreclaimable-slab-info-when-unreclaimable-slabs-user-memory.patch

