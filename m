From: akpm@linux-foundation.org
Subject: + checkpatch-add-strict-preference-for-defines-using-bitfoo.patch added to -mm tree
Date: Mon, 10 Nov 2014 15:37:00 -0800
Message-ID: <54614c1c.7jRAwSCk+U8fxTjC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45307 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbaKJXg7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Nov 2014 18:36:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, davem@davemloft.net, jiri@resnulli.us, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add --strict preference for #defines using BIT(foo)
has been added to the -mm tree.  Its filename is
     checkpatch-add-strict-preference-for-defines-using-bitfoo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-strict-preference-for-defines-using-bitfoo.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-strict-preference-for-defines-using-bitfoo.patch

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

printk-remove-used-once-early_vprintk.patch
tile-neaten-early_printk-uses.patch
tile-use-pr_warn-instead-of-pr_warning.patch
printk-add-and-use-loglevel_level-defines-for-kern_level-equivalents.patch
maintainers-update-ivtv-mailing-lists-as-subscriber-only.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-an-error-test-for-no-space-before-comma.patch
checkpatch-add-error-on-use-of-attributeweak-or-__weak-declarations.patch
checkpatch-improve-test-for-no-space-after-cast.patch
checkpatch-improve-warning-message-for-needless-if-case.patch
checkpatch-fix-use-via-symlink-make-missing-spelling-file-non-fatal.patch
checkpatch-try-to-avoid-mask-and-shift-errors.patch
checkpatch-reduce-maintainers-update-message-frequency.patch
checkpatch-add-strict-test-for-function-pointer-calling-style.patch
checkpatch-allow-certain-si-units-with-three-characters.patch
checkpatch-add-strict-preference-for-defines-using-bitfoo.patch
binfmt_misc-add-comments-debug-logs.patch
binfmt_misc-clean-up-code-style-a-bit.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
linux-next.patch

