From: akpm@linux-foundation.org
Subject: [merged] checkpatch-format-strings-should-not-have-brackets-in-macros.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:45:58 -0700
Message-ID: <200909222045.n8MKjwNu016779@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752217AbZIVUxA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:53:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: format strings should not have brackets in macros
has been removed from the -mm tree.  Its filename was
     checkpatch-format-strings-should-not-have-brackets-in-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: format strings should not have brackets in macros
From: Andy Whitcroft <apw@canonical.com>

We should not recommend braces for the following:

    #define pr_fmt(fmt)    "%s: " fmt, __func__

allow things with double quotes round them to avoid this check.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-format-strings-should-not-have-brackets-in-macros scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-format-strings-should-not-have-brackets-in-macros
+++ a/scripts/checkpatch.pl
@@ -2288,7 +2288,8 @@ sub process {
 				DECLARE_PER_CPU|
 				DEFINE_PER_CPU|
 				__typeof__\(|
-				\.$Ident\s*=\s*
+				\.$Ident\s*=\s*|
+				^\"|\"$
 			}x;
 			#print "REST<$rest> dstat<$dstat>\n";
 			if ($rest ne '') {
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch

