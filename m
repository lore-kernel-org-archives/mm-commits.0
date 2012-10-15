From: akpm@linux-foundation.org
Subject: + checkpatch-improve-network-block-comment-style-checking.patch added to -mm tree
Date: Mon, 15 Oct 2012 16:29:37 -0700
Message-ID: <20121015232937.A02DF1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:48916 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab2JOX3i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Oct 2012 19:29:38 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so700690ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 15 Oct 2012 16:29:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, Larry.Finger@lwfinger.net


The patch titled
     Subject: checkpatch: improve network block comment style checking
has been added to the -mm tree.  Its filename is
     checkpatch-improve-network-block-comment-style-checking.patch

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

checkpatch-improve-network-block-comment-style-checking.patch
kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch

