From: akpm@linux-foundation.org
Subject: +
 checkpatch-add-some-foo_destroy-functions-to-needless_if-tests.patch added
 to -mm tree
Date: Tue, 14 Jul 2015 16:05:03 -0700
Message-ID: <55a5959f.Ze0JpNjOe9rwe/J9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44473 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbbGNXFE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 19:05:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, julia.lawall@lip6.fr, rientjes@google.com, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add some <foo>_destroy functions to NEEDLESS_IF tests
has been added to the -mm tree.  Its filename is
     checkpatch-add-some-foo_destroy-functions-to-needless_if-tests.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-some-foo_destroy-functions-to-needless_if-tests.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-some-foo_destroy-functions-to-needless_if-tests.patch

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

checkpatch-fix-long-line-messages-about-patch-context.patch
hexdump-fix-for-non-aligned-buffers.patch
lindent-handle-missing-indent-gracefully.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-slab_common-allow-null-cache-pointer-in-kmem_cache_destroy.patch
mm-mempool-allow-null-pool-pointer-in-mempool_destroy.patch
mm-dmapool-allow-null-pool-pointer-in-dma_pool_destroy.patch
mm-zpool-allow-null-zpool-pointer-in-zpool_destroy_pool.patch
mm-zsmalloc-allow-null-pool-pointer-in-zs_destroy_pool.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable.patch
parse_integer-add-checkpatchpl-notice.patch
mm-utilc-add-kstrimdup.patch
checkpatch-warn-on-bare-sha-1-commit-ids-in-commit-logs.patch
checkpatch-add-warning-on-bug-bug_on-use.patch
checkpatch-improve-suspect_code_indent-test.patch
checkpatch-allow-longer-declaration-macros.patch
checkpatch-add-some-foo_destroy-functions-to-needless_if-tests.patch
hfs-fix-b-tree-corruption-after-insertion-at-position-0.patch
seq_file-provide-an-analogue-of-print_hex_dump.patch
crypto-qat-use-seq_hex_dump-to-dump-buffers.patch
parisc-use-seq_hex_dump-to-dump-buffers.patch
zcrypt-use-seq_hex_dump-to-dump-buffers.patch
kmemleak-use-seq_hex_dump-to-dump-buffers.patch
wil6210-use-seq_hex_dump-to-dump-buffers.patch
linux-next.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

