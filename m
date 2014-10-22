From: akpm@linux-foundation.org
Subject: + checkpatch-improve-warning-message-for-needless-if-case.patch
 added to -mm tree
Date: Wed, 22 Oct 2014 16:21:49 -0700
Message-ID: <54483c0d.gPQP0uOai3fNerFv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60192 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850AbaJVXVs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Oct 2014 19:21:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabio.estevam@freescale.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve warning message for "needless if" case
has been added to the -mm tree.  Its filename is
     checkpatch-improve-warning-message-for-needless-if-case.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-warning-message-for-needless-if-case.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-warning-message-for-needless-if-case.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabio Estevam <fabio.estevam@freescale.com>
Subject: checkpatch: improve warning message for "needless if" case

Add an 'and' to the sentence so that it looks better:

WARNING: debugfs_remove(NULL) is safe and this check is probably not required

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-warning-message-for-needless-if-case scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-warning-message-for-needless-if-case
+++ a/scripts/checkpatch.pl
@@ -4426,7 +4426,7 @@ sub process {
 			my $expr = '\s*\(\s*' . quotemeta($1) . '\s*\)\s*;';
 			if ($line =~ /\b(kfree|usb_free_urb|debugfs_remove(?:_recursive)?)$expr/) {
 				WARN('NEEDLESS_IF',
-				     "$1(NULL) is safe this check is probably not required\n" . $hereprev);
+				     "$1(NULL) is safe and this check is probably not required\n" . $hereprev);
 			}
 		}
 
_

Patches currently in -mm which might be from fabio.estevam@freescale.com are

origin.patch
checkpatch-improve-warning-message-for-needless-if-case.patch
linux-next.patch

