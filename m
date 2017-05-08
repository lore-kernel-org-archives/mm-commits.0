From: akpm@linux-foundation.org
Subject: [patch 026/114] checkpatch: improve
 MULTISTATEMENT_MACRO_USE_DO_WHILE test
Date: Mon, 08 May 2017 15:55:48 -0700
Message-ID: <20170508225548.q3BIBoorU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45958 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751036AbdEHWzt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:55:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alfonsolimaastor@gmail.com, andi@lisas.de, joe@perches.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve MULTISTATEMENT_MACRO_USE_DO_WHILE test

The logic currrently misses macros that start with an if statement.

e.g.:    #define foo(bar)   if (bar) baz;

Add a test for macro content that starts with if

Link: http://lkml.kernel.org/r/a9d41aafe1673889caf1a9850208fb7fd74107a0.1491783914.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Andreas Mohr <andi@lisas.de>
Original-patch-by: Alfonso Lima <alfonsolimaastor@gmail.com>
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
