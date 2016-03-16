From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-warn-on-bare-unsigned-or-signed-declarations-without-int.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:57:30 -0700
Message-ID: <56e9baaa.GQxxsZaVhz9z6p35%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39160 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934390AbcCPT5b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:57:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn on bare unsigned or signed declarations without int
has been removed from the -mm tree.  Its filename was
     checkpatch-warn-on-bare-unsigned-or-signed-declarations-without-int.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: warn on bare unsigned or signed declarations without int

Kernel style prefers "unsigned int <foo>" over "unsigned <foo>" and
"signed int <foo>" over "signed <foo>".

Emit a warning for these simple signed/unsigned <foo> declarations.
Fix it too if desired.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-warn-on-bare-unsigned-or-signed-declarations-without-int scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-on-bare-unsigned-or-signed-declarations-without-int
+++ a/scripts/checkpatch.pl
@@ -3239,6 +3239,26 @@ sub process {
 #ignore lines not being added
 		next if ($line =~ /^[^\+]/);
 
+# check for declarations of signed or unsigned without int
+		while ($line =~ m{($Declare++)\s*($Ident)\s*[=,;\[\)]}g) {
+			my $type = $1;
+			my $var = $2;
+			if ($type =~ /^((?:un)?signed)((?:\s*\*)*)\s*$/) {
+				my $sign = $1;
+				my $pointer = $2;
+
+				$pointer = "" if (!defined $pointer);
+
+				if (WARN("UNSPECIFIED_INT",
+					 "Prefer '" . trim($sign) . " int" . rtrim($pointer) . "' to bare use of '$sign" . rtrim($pointer) . "'\n" . $herecurr) &&
+				    $fix) {
+					my $decl = trim($sign) . " int ";
+					$decl .= trim($pointer) if (rtrim($pointer) ne "");
+					$fixed[$fixlinenr] =~ s@\b\Q$type\E\s*$var\b@$decl$var@;
+				}
+			}
+		}
+
 # TEST: allow direct testing of the type matcher.
 		if ($dbg_type) {
 			if ($line =~ /^.\s*$Declare\s*$/) {
_

Patches currently in -mm which might be from joe@perches.com are

mm-convert-pr_warning-to-pr_warn.patch
mm-coalesce-split-strings.patch
mm-convert-printkkern_level-to-pr_level.patch
mm-percpu-use-pr_fmt-to-prefix-output.patch
kernel-convert-pr_warning-to-pr_warn.patch

