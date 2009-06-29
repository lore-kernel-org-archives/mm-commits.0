From: akpm@linux-foundation.org
Subject: + gcov-fix-documentation.patch added to -mm tree
Date: Mon, 29 Jun 2009 12:42:03 -0700
Message-ID: <200906291942.n5TJg3CY020237@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756672AbZF2TmC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jun 2009 15:42:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oberpar@linux.vnet.ibm.com


The patch titled
     gcov: fix documentation
has been added to the -mm tree.  Its filename is
     gcov-fix-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gcov: fix documentation
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

Commonly available versions of cp and tar don't work well with special
files created using seq_file.  Mention this problem in the gcov
documentation and update the helper script example to work around these
problems.

Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/gcov.txt |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff -puN Documentation/gcov.txt~gcov-fix-documentation Documentation/gcov.txt
--- a/Documentation/gcov.txt~gcov-fix-documentation
+++ a/Documentation/gcov.txt
@@ -188,13 +188,18 @@ Solution: Exclude affected source files 
           GCOV_PROFILE := n or GCOV_PROFILE_basename.o := n in the
           corresponding Makefile.
 
+Problem:  Files copied from sysfs appear empty or incomplete.
+Cause:    Due to the way seq_file works, some tools such as cp or tar
+          may not correctly copy files from sysfs.
+Solution: Use 'cat' to read .gcda files and 'cp -d' to copy links.
+          Alternatively use the mechanism shown in Appendix B.
+
 
 Appendix A: gather_on_build.sh
 ==============================
 
 Sample script to gather coverage meta files on the build machine
 (see 6a):
-
 #!/bin/bash
 
 KSRC=$1
@@ -226,7 +231,7 @@ Appendix B: gather_on_test.sh
 Sample script to gather coverage data files on the test machine
 (see 6b):
 
-#!/bin/bash
+#!/bin/bash -e
 
 DEST=$1
 GCDA=/sys/kernel/debug/gcov
@@ -236,11 +241,13 @@ if [ -z "$DEST" ] ; then
   exit 1
 fi
 
-find $GCDA -name '*.gcno' -o -name '*.gcda' | tar cfz $DEST -T -
+TEMPDIR=$(mktemp -d)
+echo Collecting data..
+find $GCDA -type d -exec mkdir -p $TEMPDIR/\{\} \;
+find $GCDA -name '*.gcda' -exec sh -c 'cat < $0 > '$TEMPDIR'/$0' {} \;
+find $GCDA -name '*.gcno' -exec sh -c 'cp -d $0 '$TEMPDIR'/$0' {} \;
+tar czf $DEST -C $TEMPDIR sys
+rm -rf $TEMPDIR
 
-if [ $? -eq 0 ] ; then
-  echo "$DEST successfully created, copy to build system and unpack with:"
-  echo "  tar xfz $DEST"
-else
-  echo "Could not create file $DEST"
-fi
+echo "$DEST successfully created, copy to build system and unpack with:"
+echo "  tar xfz $DEST"
_

Patches currently in -mm which might be from oberpar@linux.vnet.ibm.com are

gcov-fix-__ctors_start-alignment.patch
gcov-fix-documentation.patch

