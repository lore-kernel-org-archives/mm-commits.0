From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-strict-preference-for-defines-using-bitfoo.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 11:05:39 -0800
Message-ID: <5489eb03.FUWOde7VQN0Cez5U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45692 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbaLKTFk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:05:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, davem@davemloft.net, jiri@resnulli.us, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add --strict preference for #defines using BIT(foo)
has been removed from the -mm tree.  Its filename was
     checkpatch-add-strict-preference-for-defines-using-bitfoo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add --strict preference for #defines using BIT(foo)

Using BIT(foo) and BIT_ULL(bar) is more common now.  Suggest using these
macros over #defines with 1<<value.

Add a --fix option too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-strict-preference-for-defines-using-bitfoo scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-strict-preference-for-defines-using-bitfoo
+++ a/scripts/checkpatch.pl
@@ -4975,6 +4975,17 @@ sub process {
 			}
 		}
 
+# check for #defines like: 1 << <digit> that could be BIT(digit)
+		if ($line =~ /#\s*define\s+\w+\s+\(?\s*1\s*([ulUL]*)\s*\<\<\s*(?:\d+|$Ident)\s*\)?/) {
+			my $ull = "";
+			$ull = "_ULL" if (defined($1) && $1 =~ /ll/i);
+			if (CHK("BIT_MACRO",
+				"Prefer using the BIT$ull macro\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$fixlinenr] =~ s/\(?\s*1\s*[ulUL]*\s*<<\s*(\d+|$Ident)\s*\)?/BIT${ull}($1)/;
+			}
+		}
+
 # check for case / default statements not preceded by break/fallthrough/switch
 		if ($line =~ /^.\s*(?:case\s+(?:$Ident|$Constant)\s*|default):/) {
 			my $has_break = 0;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
linux-next.patch

