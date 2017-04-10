From: akpm@linux-foundation.org
Subject: + checkpatch-improve-multistatement_macro_use_do_while-test.patch added to -mm tree
Date: Mon, 10 Apr 2017 15:14:08 -0700
Message-ID: <58ec03b0.TAWK8pNbAXv+Ph2T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59500 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752173AbdDJWOJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Apr 2017 18:14:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, alfonsolimaastor@gmail.com, andi@lisas.de, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve MULTISTATEMENT_MACRO_USE_DO_WHILE test
has been added to the -mm tree.  Its filename is
     checkpatch-improve-multistatement_macro_use_do_while-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-multistatement_macro_use_do_while-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-multistatement_macro_use_do_while-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve MULTISTATEMENT_MACRO_USE_DO_WHILE test

The logic currrently misses macros that start with an if statement.

e.g.:    #define foo(bar)   if (bar) baz;

Add a test for macro content that starts with if

Original-patch-by: Alfonso Lima <alfonsolimaastor@gmail.com>
Link: http://lkml.kernel.org/r/a9d41aafe1673889caf1a9850208fb7fd74107a0.1491783914.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Andreas Mohr <andi@lisas.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-multistatement_macro_use_do_while-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-multistatement_macro_use_do_while-test
+++ a/scripts/checkpatch.pl
@@ -4849,8 +4849,10 @@ sub process {
 			    $dstat !~ /^\(\{/ &&						# ({...
 			    $ctx !~ /^.\s*#\s*define\s+TRACE_(?:SYSTEM|INCLUDE_FILE|INCLUDE_PATH)\b/)
 			{
