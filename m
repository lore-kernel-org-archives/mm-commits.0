From: akpm@linux-foundation.org
Subject: [merged] checkpatch-improve-network-block-comment-style-checking.patch removed from -mm tree
Date: Mon, 12 Nov 2012 13:09:13 -0800
Message-ID: <20121112210914.351BC20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:55758 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608Ab2KLVJQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Nov 2012 16:09:16 -0500
Received: by mail-we0-f202.google.com with SMTP id x43so429742wey.1
        for <mm-commits@vger.kernel.org>; Mon, 12 Nov 2012 13:09:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, Larry.Finger@lwfinger.net, davem@davemloft.net, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve network block comment style checking
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-network-block-comment-style-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve network block comment style checking

Some comment styles in net and drivers/net are flagged inappropriately.

Avoid proclaiming inline comments like:
	int a = b;	/* some comment */
and block comments like:
	/*********************
	 * some comment
	 ********************/
are defective.

Tested with
$ cat drivers/net/t.c
/* foo */

/*
 * foo
 */

/* foo
 */

/* foo
 * bar */

/****************************
 * some long block comment
 ***************************/

struct foo {
	int bar;	/* another test */
};
$

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: David Miller <davem@davemloft.net>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-network-block-comment-style-checking scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-network-block-comment-style-checking
+++ a/scripts/checkpatch.pl
@@ -1890,8 +1890,10 @@ sub process {
 		}
 
 		if ($realfile =~ m@^(drivers/net/|net/)@ &&
-		    $rawline !~ m@^\+[ \t]*(\/\*|\*\/)@ &&
-		    $rawline =~ m@^\+[ \t]*.+\*\/[ \t]*$@) {
+		    $rawline !~ m@^\+[ \t]*\*/[ \t]*$@ &&	#trailing */
+		    $rawline !~ m@^\+.*/\*.*\*/[ \t]*$@ &&	#inline /*...*/
+		    $rawline !~ m@^\+.*\*{2,}/[ \t]*$@ &&	#trailing **/
+		    $rawline =~ m@^\+[ \t]*.+\*\/[ \t]*$@) {	#non blank */
 			WARN("NETWORKING_BLOCK_COMMENT_STYLE",
 			     "networking block comments put the trailing */ on a separate line\n" . $herecurr);
 		}
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
checkpatch-warn-on-unnecessary-line-continuations.patch
kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch

