From: akpm@linux-foundation.org
Subject: + tools-vm-slabinfo-fix-alternate-opts-names.patch added to -mm
 tree
Date: Fri, 16 Oct 2015 15:35:59 -0700
Message-ID: <56217bcf./j/z829WpG+5zm4k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56715 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbbJPWgA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Oct 2015 18:36:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/slabinfo: fix alternate opts names
has been added to the -mm tree.  Its filename is
     tools-vm-slabinfo-fix-alternate-opts-names.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-vm-slabinfo-fix-alternate-opts-names.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-slabinfo-fix-alternate-opts-names.patch

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
Subject: tools/vm/slabinfo: fix alternate opts names

Fix mismatches between usage() output and real opts[] options.  Add
missing alternative opt names, e.g., '-S' had no '--Size' opts[] entry,
etc.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/slabinfo.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN tools/vm/slabinfo.c~tools-vm-slabinfo-fix-alternate-opts-names tools/vm/slabinfo.c
--- a/tools/vm/slabinfo.c~tools-vm-slabinfo-fix-alternate-opts-names
+++ a/tools/vm/slabinfo.c
@@ -1294,12 +1294,14 @@ struct option opts[] = {
 	{ "first-alias", no_argument, NULL, 'f' },
 	{ "help", no_argument, NULL, 'h' },
 	{ "inverted", no_argument, NULL, 'i'},
+	{ "slabs", no_argument, NULL, 'l' },
 	{ "numa", no_argument, NULL, 'n' },
 	{ "ops", no_argument, NULL, 'o' },
-	{ "report", no_argument, NULL, 'r' },
 	{ "shrink", no_argument, NULL, 's' },
-	{ "slabs", no_argument, NULL, 'l' },
-	{ "track", no_argument, NULL, 't'},
+	{ "report", no_argument, NULL, 'r' },
+	{ "Size", no_argument, NULL, 'S'},
+	{ "tracking", no_argument, NULL, 't'},
+	{ "Totals", no_argument, NULL, 'T'},
 	{ "validate", no_argument, NULL, 'v' },
 	{ "zero", no_argument, NULL, 'z' },
 	{ "1ref", no_argument, NULL, '1'},
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

