From: akpm@linux-foundation.org
Subject: - argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:54:19 -0700
Message-ID: <200710180654.l9I6sJkr030513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37580 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932380AbXJRHn0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:43:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nhorman@tuxdriver.com, jeremy@goop.org, satyam@infradead.org, mm-commits@vger.kernel.org


The patch titled
     argv_split: allow argv_split to handle NULL pointer in argcp parameter gracefully
has been removed from the -mm tree.  Its filename was
     argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 3 insertions(+), 1 deletion(-)

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

origin.patch
proc-export-a-processes-resource-limits-via-proc-pid.patch
