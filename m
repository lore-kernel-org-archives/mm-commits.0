From: akpm@linux-foundation.org
Subject: + argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch added to -mm tree
Date: Tue, 31 Jul 2007 12:49:14 -0700
Message-ID: <200707311949.l6VJnEdv019178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54425 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756134AbXGaTuG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 15:50:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nhorman@tuxdriver.com, jeremy@goop.org, satyam@infradead.org


The patch titled
     argv_split: allow argv_split to handle NULL pointer in argcp parameter gracefully
has been added to the -mm tree.  Its filename is
     argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: argv_split: allow argv_split to handle NULL pointer in argcp parameter gracefully
From: Neil Horman <nhorman@tuxdriver.com>

It would be nice if the argv_split library function could gracefully handle
a NULL pointer in the argcp parameter, so as to allow functions using it
that did not care about the value of argc to not have to declare a useless
variable.  This patch accomplishes that.  Tested by me, with successful
results.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Satyam Sharma <satyam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/argv_split.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN lib/argv_split.c~argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully lib/argv_split.c
--- a/lib/argv_split.c~argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully
+++ a/lib/argv_split.c
@@ -75,7 +75,9 @@ char **argv_split(gfp_t gfp, const char 
 	if (argv == NULL)
 		goto out;
 
-	*argcp = argc;
+	if (argcp)
+		*argcp = argc;
+
 	argvp = argv;
 
 	while (*str) {
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe.patch
core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe-fix.patch
core_pattern-allow-passing-of-arguments-to-user-mode-helper-when-core_pattern-is-a-pipe.patch
core_pattern-fix-up-a-few-miscellaneous-bugs.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
