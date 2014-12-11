From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-improve-warning-message-for-needless-if-case.patch removed from
 -mm tree
Date: Thu, 11 Dec 2014 11:05:26 -0800
Message-ID: <5489eaf6.VFFZLJwNOVZALW5s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45672 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081AbaLKTF1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:05:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabio.estevam@freescale.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve warning message for "needless if" case
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-warning-message-for-needless-if-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -4446,7 +4446,7 @@ sub process {
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
linux-next.patch

