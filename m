Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCF35C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  1 Jul 2022 22:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbiGAWAR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Jul 2022 18:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiGAWAQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jul 2022 18:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C1A28737
        for <mm-commits@vger.kernel.org>; Fri,  1 Jul 2022 15:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DECB623AF
        for <mm-commits@vger.kernel.org>; Fri,  1 Jul 2022 22:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58AA7C341C8;
        Fri,  1 Jul 2022 22:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656712814;
        bh=PcKo5cLWeU0Hcs9u6aLeIPeD71l4SOKt8lS+lSr3h2g=;
        h=Date:To:From:Subject:From;
        b=biriGceWzNNtFi0pNRFCwgZWml0J9+dfrzgNWWPn/zREMzIr+Kehh6E1439bHuHzm
         DB+7uMVSrRWns/645o81647ovnlQgn3LRWFi7GcLjWuNtM5fykmibabQ6uJvLPUReu
         NrskMrXd7YXi/bEyapANnCRh3F+sjxRMNXj3SMHU=
Date:   Fri, 01 Jul 2022 15:00:13 -0700
To:     mm-commits@vger.kernel.org, nborisov@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-bloat-o-meter-switch-argument-parsing-to-using-argparse.patch added to mm-nonmm-unstable branch
Message-Id: <20220701220014.58AA7C341C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/bloat-o-meter: switch argument parsing to using argparse
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-bloat-o-meter-switch-argument-parsing-to-using-argparse.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-bloat-o-meter-switch-argument-parsing-to-using-argparse.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

scripts-bloat-o-meter-switch-argument-parsing-to-using-argparse.patch
scripts-bloat-o-meter-add-p-argument.patch

