From: akpm@linux-foundation.org
Subject: [merged] checkpatch-list_head-is-also-declaration.patch
 removed from -mm tree
Date: Tue, 11 Jul 2017 12:26:54 -0700
Message-ID: <20170711192654.nGePKnCs-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48570 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755637AbdGKT0z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:26:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, maier@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: [HLP]LIST_HEAD is also declaration
has been removed from the -mm tree.  Its filename was
     checkpatch-list_head-is-also-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: checkpatch: [HLP]LIST_HEAD is also declaration

Fixes the following false warning among others for LLIST_HEAD and
PLIST_HEAD:

    WARNING: Missing a blank line after declarations
    #71: FILE: drivers/s390/scsi/zfcp_fsf.c:422:
    +	struct hlist_node *tmp;
    +	HLIST_HEAD(remove_queue);

Link: http://lkml.kernel.org/r/20170614133512.89425-1-maier@linux.vnet.ibm.com
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-list_head-is-also-declaration scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-list_head-is-also-declaration
+++ a/scripts/checkpatch.pl
@@ -733,7 +733,7 @@ our $FuncArg = qr{$Typecast{0,1}($LvalOr
 
 our $declaration_macros = qr{(?x:
 	(?:$Storage\s+)?(?:[A-Z_][A-Z0-9]*_){0,2}(?:DEFINE|DECLARE)(?:_[A-Z0-9]+){1,6}\s*\(|
-	(?:$Storage\s+)?LIST_HEAD\s*\(|
+	(?:$Storage\s+)?[HLP]?LIST_HEAD\s*\(|
 	(?:$Storage\s+)?${Type}\s+uninitialized_var\s*\(
 )};
 
_

Patches currently in -mm which might be from maier@linux.vnet.ibm.com are


