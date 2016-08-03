From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-improve-bare-use-of-signed-unsigned-types-warning.patch removed
 from -mm tree
Date: Wed, 03 Aug 2016 11:12:43 -0700
Message-ID: <57a2341b.yX8YR2RUFHk/u4tH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273AbcHCSNj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, alanjhd@gmail.com, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve 'bare use of' signed/unsigned types warning
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-bare-use-of-signed-unsigned-types-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve 'bare use of' signed/unsigned types warning

Fix false positive warning of identifiers ending in signed with an =
assignment of WARNING: Prefer 'signed int' to bare use of 'signed'.

Link: http://lkml.kernel.org/r/6a0e24c3e9102337528ecfcbbe91a0eb5b4820ed.1469529497.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Alan Douglas <alanjhd@gmail.com>
Acked-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-bare-use-of-signed-unsigned-types-warning scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-bare-use-of-signed-unsigned-types-warning
+++ a/scripts/checkpatch.pl
@@ -3347,7 +3347,7 @@ sub process {
 		next if ($line =~ /^[^\+]/);
 
 # check for declarations of signed or unsigned without int
-		while ($line =~ m{($Declare)\s*(?!char\b|short\b|int\b|long\b)\s*($Ident)?\s*[=,;\[\)\(]}g) {
+		while ($line =~ m{\b($Declare)\s*(?!char\b|short\b|int\b|long\b)\s*($Ident)?\s*[=,;\[\)\(]}g) {
 			my $type = $1;
 			my $var = $2;
 			$var = "" if (!defined $var);
_

Patches currently in -mm which might be from joe@perches.com are


