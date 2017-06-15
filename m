From: akpm@linux-foundation.org
Subject: + checkpatch-list_head-is-also-declaration.patch added to -mm
 tree
Date: Thu, 15 Jun 2017 12:31:20 -0700
Message-ID: <5942e088.Aw+sgAC887PtuLgz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60216 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750727AbdFOTbV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 15:31:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maier@linux.vnet.ibm.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: [HLP]LIST_HEAD is also declaration
has been added to the -mm tree.  Its filename is
     checkpatch-list_head-is-also-declaration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-list_head-is-also-declaration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-list_head-is-also-declaration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -732,7 +732,7 @@ our $FuncArg = qr{$Typecast{0,1}($LvalOr
 
 our $declaration_macros = qr{(?x:
 	(?:$Storage\s+)?(?:[A-Z_][A-Z0-9]*_){0,2}(?:DEFINE|DECLARE)(?:_[A-Z0-9]+){1,6}\s*\(|
-	(?:$Storage\s+)?LIST_HEAD\s*\(|
+	(?:$Storage\s+)?[HLP]?LIST_HEAD\s*\(|
 	(?:$Storage\s+)?${Type}\s+uninitialized_var\s*\(
 )};
 
_

Patches currently in -mm which might be from maier@linux.vnet.ibm.com are

checkpatch-list_head-is-also-declaration.patch

