From: akpm@linux-foundation.org
Subject: [merged] checkpatch-allow-longer-declaration-macros.patch removed from -mm tree
Date: Fri, 11 Sep 2015 11:12:15 -0700
Message-ID: <55f3197f.LkK5t76l4tuauSuq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbbIKSMP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:12:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: Allow longer declaration macros
has been removed from the -mm tree.  Its filename was
     checkpatch-allow-longer-declaration-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

