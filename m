From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-support-for-floating-point-constants.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:07:07 -0800
Message-ID: <20121218200708.186CA200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:50846 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039Ab2LRUHK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:07:10 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so63334eei.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:07:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add support for floating point constants
has been removed from the -mm tree.  Its filename was
     checkpatch-add-support-for-floating-point-constants.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add support for floating point constants

Even though the kernel doesn't support using floating point constants,
add a regex for them.

Support forms like: 0x123p1, 123e-1, 1.23, 1.5e23f

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-support-for-floating-point-constants scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-support-for-floating-point-constants
+++ a/scripts/checkpatch.pl
@@ -230,7 +230,11 @@ our $Inline	= qr{inline|__always_inline|
 our $Member	= qr{->$Ident|\.$Ident|\[[^]]*\]};
 our $Lval	= qr{$Ident(?:$Member)*};
 
-our $Constant	= qr{(?i:(?:0x[0-9a-f]+|[0-9]+)[ul]*)};
+our $Float_hex	= qr{(?i:0x[0-9a-f]+p-?[0-9]+[fl]?)};
+our $Float_dec	= qr{(?i:((?:[0-9]+\.[0-9]*|[0-9]*\.[0-9]+)(?:e-?[0-9]+)?[fl]?))};
+our $Float_int	= qr{(?i:[0-9]+e-?[0-9]+[fl]?)};
+our $Float	= qr{$Float_hex|$Float_dec|$Float_int};
+our $Constant	= qr{(?:$Float|(?i:(?:0x[0-9a-f]+|[0-9]+)[ul]*))};
 our $Assignment	= qr{(?:\*\=|/=|%=|\+=|-=|<<=|>>=|&=|\^=|\|=|=)};
 our $Compare    = qr{<=|>=|==|!=|<|>};
 our $Operators	= qr{
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch

