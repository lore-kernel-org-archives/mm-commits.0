From: akpm@linux-foundation.org
Subject: [merged] checkpatch-find-hex-constants-as-a-single-ident.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:07:03 -0800
Message-ID: <20121218200704.172BC200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f201.google.com ([209.85.217.201]:41209 "EHLO
	mail-lb0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039Ab2LRUHG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:07:06 -0500
Received: by mail-lb0-f201.google.com with SMTP id m4so69551lbo.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:07:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: find hex constants as a single IDENT
has been removed from the -mm tree.  Its filename was
     checkpatch-find-hex-constants-as-a-single-ident.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: find hex constants as a single IDENT

Hexadecimal values are current found in 2 parts.  A hex constant like
0x123456abcdef is found as 0 and then x123456abcdef and later coalesced.

Instead, reverse the order of the 2 searches in $Constant to find 0x
first, then 0 so that the entire hex constant is found all at once.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-find-hex-constants-as-a-single-ident scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-find-hex-constants-as-a-single-ident
+++ a/scripts/checkpatch.pl
@@ -230,7 +230,7 @@ our $Inline	= qr{inline|__always_inline|
 our $Member	= qr{->$Ident|\.$Ident|\[[^]]*\]};
 our $Lval	= qr{$Ident(?:$Member)*};
 
-our $Constant	= qr{(?i:(?:[0-9]+|0x[0-9a-f]+)[ul]*)};
+our $Constant	= qr{(?i:(?:0x[0-9a-f]+|[0-9]+)[ul]*)};
 our $Assignment	= qr{(?:\*\=|/=|%=|\+=|-=|<<=|>>=|&=|\^=|\|=|=)};
 our $Compare    = qr{<=|>=|==|!=|<|>};
 our $Operators	= qr{
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch

