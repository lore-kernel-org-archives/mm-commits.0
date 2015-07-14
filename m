From: akpm@linux-foundation.org
Subject: + checkpatch-allow-longer-declaration-macros.patch added to -mm
 tree
Date: Tue, 14 Jul 2015 15:31:56 -0700
Message-ID: <55a58ddc.MZB2U0y4ngi7qoMB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43409 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbbGNWb4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 18:31:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: Allow longer declaration macros
has been added to the -mm tree.  Its filename is
     checkpatch-allow-longer-declaration-macros.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-allow-longer-declaration-macros.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-allow-longer-declaration-macros.patch

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
Subject: checkpatch: Allow longer declaration macros

Some really long declaration macros exist.

For instance;
  	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
and
	DECLARE_DM_KCOPYD_THROTTLE_WITH_MODULE_PARM(name, description)

Increase the limit from 2 words to 6 after DECLARE/DEFINE uses.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-allow-longer-declaration-macros scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-allow-longer-declaration-macros
+++ a/scripts/checkpatch.pl
@@ -584,7 +584,7 @@ our $LvalOrFunc	= qr{((?:[\&\*]\s*)?$Lva
 our $FuncArg = qr{$Typecast{0,1}($LvalOrFunc|$Constant|$String)};
 
 our $declaration_macros = qr{(?x:
-	(?:$Storage\s+)?(?:[A-Z_][A-Z0-9]*_){0,2}(?:DEFINE|DECLARE)(?:_[A-Z0-9]+){1,2}\s*\(|
+	(?:$Storage\s+)?(?:[A-Z_][A-Z0-9]*_){0,2}(?:DEFINE|DECLARE)(?:_[A-Z0-9]+){1,6}\s*\(|
 	(?:$Storage\s+)?LIST_HEAD\s*\(|
 	(?:$Storage\s+)?${Type}\s+uninitialized_var\s*\(
 )};
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-fix-long-line-messages-about-patch-context.patch
hexdump-fix-for-non-aligned-buffers.patch
lindent-handle-missing-indent-gracefully.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable.patch
parse_integer-add-checkpatchpl-notice.patch
mm-utilc-add-kstrimdup.patch
checkpatch-warn-on-bare-sha-1-commit-ids-in-commit-logs.patch
checkpatch-add-warning-on-bug-bug_on-use.patch
checkpatch-improve-suspect_code_indent-test.patch
checkpatch-allow-longer-declaration-macros.patch
hfs-fix-b-tree-corruption-after-insertion-at-position-0.patch
seq_file-provide-an-analogue-of-print_hex_dump.patch
crypto-qat-use-seq_hex_dump-to-dump-buffers.patch
parisc-use-seq_hex_dump-to-dump-buffers.patch
zcrypt-use-seq_hex_dump-to-dump-buffers.patch
kmemleak-use-seq_hex_dump-to-dump-buffers.patch
wil6210-use-seq_hex_dump-to-dump-buffers.patch
linux-next.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

