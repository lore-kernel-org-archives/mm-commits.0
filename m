From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-some-foo_destroy-functions-to-needless_if-tests.patch
 removed from -mm tree
Date: Fri, 11 Sep 2015 11:12:17 -0700
Message-ID: <55f31981.dBQhWVWsjYNv8wFX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbbIKSMR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:12:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, julia.lawall@lip6.fr, rientjes@google.com, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add some <foo>_destroy functions to NEEDLESS_IF tests
has been removed from the -mm tree.  Its filename was
     checkpatch-add-some-foo_destroy-functions-to-needless_if-tests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add some <foo>_destroy functions to NEEDLESS_IF tests

Sergey Senozhatsky has modified several destroy functions that can
now be called with NULL values.

 - kmem_cache_destroy()
 - mempool_destroy()
 - dma_pool_destroy()

Update checkpatch to warn when those functions are preceded by an if.

Update checkpatch to --fix all the calls too only when the code style
form is using leading tabs.

from:
	if (foo)
		<func>(foo);
to:
	<func>(foo);

Signed-off-by: Joe Perches <joe@perches.com>
Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-some-foo_destroy-functions-to-needless_if-tests scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-some-foo_destroy-functions-to-needless_if-tests
+++ a/scripts/checkpatch.pl
@@ -4836,10 +4836,34 @@ sub process {
 
 # check for needless "if (<foo>) fn(<foo>)" uses
 		if ($prevline =~ /\bif\s*\(\s*($Lval)\s*\)/) {
-			my $expr = '\s*\(\s*' . quotemeta($1) . '\s*\)\s*;';
-			if ($line =~ /\b(kfree|usb_free_urb|debugfs_remove(?:_recursive)?)$expr/) {
-				WARN('NEEDLESS_IF',
-				     "$1(NULL) is safe and this check is probably not required\n" . $hereprev);
+			my $tested = quotemeta($1);
+			my $expr = '\s*\(\s*' . $tested . '\s*\)\s*;';
+			if ($line =~ /\b(kfree|usb_free_urb|debugfs_remove(?:_recursive)?|(?:kmem_cache|mempool|dma_pool)_destroy)$expr/) {
+				my $func = $1;
+				if (WARN('NEEDLESS_IF',
+					 "$func(NULL) is safe and this check is probably not required\n" . $hereprev) &&
+				    $fix) {
+					my $do_fix = 1;
+					my $leading_tabs = "";
+					my $new_leading_tabs = "";
+					if ($lines[$linenr - 2] =~ /^\+(\t*)if\s*\(\s*$tested\s*\)\s*$/) {
+						$leading_tabs = $1;
+					} else {
+						$do_fix = 0;
+					}
+					if ($lines[$linenr - 1] =~ /^\+(\t+)$func\s*\(\s*$tested\s*\)\s*;\s*$/) {
+						$new_leading_tabs = $1;
+						if (length($leading_tabs) + 1 ne length($new_leading_tabs)) {
+							$do_fix = 0;
+						}
+					} else {
+						$do_fix = 0;
+					}
+					if ($do_fix) {
+						fix_delete_line($fixlinenr - 1, $prevrawline);
+						$fixed[$fixlinenr] =~ s/^\+$new_leading_tabs/\+$leading_tabs/;
+					}
+				}
 			}
 		}
 
_

Patches currently in -mm which might be from joe@perches.com are

fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

