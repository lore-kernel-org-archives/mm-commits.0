From: akpm@linux-foundation.org
Subject: [patch 054/111] checkpatch: improve 'bare use of' signed/unsigned types warning
Date: Tue, 02 Aug 2016 14:04:42 -0700
Message-ID: <57a10aea.ukEruGz1/uQYLiWo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60612 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060AbcHBVRI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:17:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com, alanjhd@gmail.com, apw@canonical.com

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
