Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9370AC43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbiGRAcz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232819AbiGRAck (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:32:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DB913D3A
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:32:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94A0A60FAF
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2257C341C0;
        Mon, 18 Jul 2022 00:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658104358;
        bh=OrtxsP58wozVidFgp9n/ulw1mgSeqy3B2EwIcGTXjd8=;
        h=Date:To:From:Subject:From;
        b=YzsWHfh9MYRrrummtgM6dv2w7PiplywS4t5g1xSG2GQl4JbRNd2COfCmgwHPGA8An
         oqSpLMCl6nS9orDdhHSKxH1yRZVckPTKyYramGz6C48rfaq+yDjoO4ZyY17zyRAiNB
         XLd1CAqIBwj6vybtDNQphvC037HFyIPDEkm41elU=
Date:   Sun, 17 Jul 2022 17:32:37 -0700
To:     mm-commits@vger.kernel.org, nborisov@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-bloat-o-meter-switch-argument-parsing-to-using-argparse.patch removed from -mm tree
Message-Id: <20220718003237.E2257C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/bloat-o-meter: switch argument parsing to using argparse
has been removed from the -mm tree.  Its filename was
     scripts-bloat-o-meter-switch-argument-parsing-to-using-argparse.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nikolay Borisov <nborisov@suse.com>
Subject: scripts/bloat-o-meter: switch argument parsing to using argparse
Date: Fri, 1 Jul 2022 14:35:12 +0300

This will facilitate further extension to the arguments the script takes. 
As an added benefit it also produces saner usage output, where mutual
exclusivity of the c|d|t parameters is clearly visible:

./scripts/bloat-o-meter  -h
usage: bloat-o-meter [-h] [-c | -d | -t] file1 file2

Simple script used to compare the symbol sizes of 2 object files

positional arguments:
  file1       First file to compare
  file2       Second file to compare

optional arguments:
  -h, --help  show this help message and exit
  -c          categorize output based on symbol type
  -d          Show delta of Data Section
  -t          Show delta of text Section

Link: https://lkml.kernel.org/r/20220701113513.1938008-1-nborisov@suse.com
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/bloat-o-meter |   40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

--- a/scripts/bloat-o-meter~scripts-bloat-o-meter-switch-argument-parsing-to-using-argparse
+++ a/scripts/bloat-o-meter
@@ -7,18 +7,20 @@
 # This software may be used and distributed according to the terms
 # of the GNU General Public License, incorporated herein by reference.
 
-import sys, os, re
+import sys, os, re, argparse
 from signal import signal, SIGPIPE, SIG_DFL
 
 signal(SIGPIPE, SIG_DFL)
 
-if len(sys.argv) < 3:
-    sys.stderr.write("usage: %s [option] file1 file2\n" % sys.argv[0])
-    sys.stderr.write("The options are:\n")
-    sys.stderr.write("-c	categorize output based on symbol type\n")
-    sys.stderr.write("-d	Show delta of Data Section\n")
-    sys.stderr.write("-t	Show delta of text Section\n")
-    sys.exit(-1)
+parser = argparse.ArgumentParser(description="Simple script used to compare the symbol sizes of 2 object files")
+group = parser.add_mutually_exclusive_group()
+group.add_argument('-c', help='categorize output based on symbol type', action='store_true')
+group.add_argument('-d', help='Show delta of Data Section', action='store_true')
+group.add_argument('-t', help='Show delta of text Section', action='store_true')
+parser.add_argument('file1', help='First file to compare')
+parser.add_argument('file2', help='Second file to compare')
+
+args = parser.parse_args()
 
 re_NUMBER = re.compile(r'\.[0-9]+')
 
@@ -77,9 +79,9 @@ def calc(oldfile, newfile, format):
     delta.reverse()
     return grow, shrink, add, remove, up, down, delta, old, new, otot, ntot
 
-def print_result(symboltype, symbolformat, argc):
+def print_result(symboltype, symbolformat):
     grow, shrink, add, remove, up, down, delta, old, new, otot, ntot = \
-    calc(sys.argv[argc - 1], sys.argv[argc], symbolformat)
+    calc(args.file1, args.file2, symbolformat)
 
     print("add/remove: %s/%s grow/shrink: %s/%s up/down: %s/%s (%s)" % \
           (add, remove, grow, shrink, up, -down, up-down))
@@ -93,13 +95,13 @@ def print_result(symboltype, symbolforma
         percent = 0
     print("Total: Before=%d, After=%d, chg %+.2f%%" % (otot, ntot, percent))
 
-if sys.argv[1] == "-c":
-    print_result("Function", "tT", 3)
-    print_result("Data", "dDbB", 3)
-    print_result("RO Data", "rR", 3)
-elif sys.argv[1] == "-d":
-    print_result("Data", "dDbBrR", 3)
-elif sys.argv[1] == "-t":
-    print_result("Function", "tT", 3)
+if args.c:
+    print_result("Function", "tT")
+    print_result("Data", "dDbB")
+    print_result("RO Data", "rR")
+elif args.d:
+    print_result("Data", "dDbBrR")
+elif args.t:
+    print_result("Function", "tT")
 else:
-    print_result("Function", "tTdDbBrR", 2)
+    print_result("Function", "tTdDbBrR")
_

Patches currently in -mm which might be from nborisov@suse.com are


