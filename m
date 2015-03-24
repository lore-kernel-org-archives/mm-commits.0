From: akpm@linux-foundation.org
Subject: + checkpatch-add-test-for-repeated-const-uses.patch added to -mm
 tree
Date: Tue, 24 Mar 2015 13:34:23 -0700
Message-ID: <5511ca4f.YXiuCZCuxO3n1P4Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36543 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbbCXUeY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Mar 2015 16:34:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add test for repeated const uses
has been added to the -mm tree.  Its filename is
     checkpatch-add-test-for-repeated-const-uses.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-test-for-repeated-const-uses.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-test-for-repeated-const-uses.patch

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
Subject: checkpatch: add test for repeated const uses

Using 'const <type> const *' is generally meant to be written 'const
<type> * const'.

Add a test for the miswritten form.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-test-for-repeated-const-uses scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-test-for-repeated-const-uses
+++ a/scripts/checkpatch.pl
@@ -323,6 +323,7 @@ our $Operators	= qr{
 
 our $c90_Keywords = qr{do|for|while|if|else|return|goto|continue|switch|default|case|break}x;
 
+our $BasicType;
 our $NonptrType;
 our $NonptrTypeMisordered;
 our $NonptrTypeWithAttr;
@@ -514,6 +515,11 @@ sub build_types {
 	my $Misordered = "(?x:  \n" . join("|\n  ", @typeListMisordered) . "\n)";
 	my $allWithAttr = "(?x:  \n" . join("|\n  ", @typeListWithAttr) . "\n)";
 	$Modifier	= qr{(?:$Attribute|$Sparse|$mods)};
+	$BasicType	= qr{
+				(?:$typeOtherOSTypedefs\b)|
+				(?:$typeTypedefs\b)|
+				(?:${all}\b)
+		}x;
 	$NonptrType	= qr{
 			(?:$Modifier\s+|const\s+)*
 			(?:
@@ -3192,6 +3198,18 @@ sub process {
 				$herecurr);
                }
 
+# check for const <foo> const where <foo> is not a pointer or array type
+		if ($sline =~ /\bconst\s+($BasicType)\s+const\b/) {
+			my $found = $1;
+			if ($sline =~ /\bconst\s+\Q$found\E\s+const\b\s*\*/) {
+				WARN("CONST_CONST",
+				     "'const $found const *' should probably be 'const $found * const'\n" . $herecurr);
+			} elsif ($sline !~ /\bconst\s+\Q$found\E\s+const\s+\w+\s*\[/) {
+				WARN("CONST_CONST",
+				     "'const $found const' should probably be 'const $found'\n" . $herecurr);
+			}
+		}
+
 # check for non-global char *foo[] = {"bar", ...} declarations.
 		if ($line =~ /^.\s+(?:static\s+|const\s+)?char\s+\*\s*\w+\s*\[\s*\]\s*=\s*\{/) {
 			WARN("STATIC_CONST_CHAR_ARRAY",
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-correct-rtc-armada38x-pattern-entry.patch
hfsplus-fix-b-tree-corruption-after-insertion-at-position-0.patch
proc-show-locks-in-proc-pid-fdinfo-x.patch
proc-show-locks-in-proc-pid-fdinfo-x-v2.patch
maintainers-use-tabs-consistently.patch
x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
power-wakeup-remove-use-of-seq_printf-return-value.patch
rtc-remove-use-of-seq_printf-return-value.patch
ipc-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value-fix.patch
nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
arm-plat-pxa-remove-use-of-seq_printf-return-value.patch
openrisc-remove-use-of-seq_printf-return-value.patch
cris-remove-use-of-seq_printf-return-value.patch
s390-remove-use-of-seq_printf-return-value.patch
i8k-remove-use-of-seq_printf-return-value.patch
watchdog-bcm281xx-remove-use-of-seq_printf-return-value.patch
proc-remove-use-of-seq_printf-return-value.patch
cgroup-remove-use-of-seq_printf-return-value.patch
tracing-remove-use-of-seq_printf-return-value.patch
lru_cache-remove-use-of-seq_printf-return-value.patch
parisc-remove-use-of-seq_printf-return-value.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
checkpatch-add-spell-checking-of-email-subject-line.patch
checkpatch-spell-check-reudce.patch
checkpatch-add-optional-codespell-dictionary-to-find-more-typos.patch
checkpatch-match-more-world-writable-permissions.patch
checkpatch-match-more-world-writable-permissions-fix.patch
checkpatch-improve-return-negative-errno-check.patch
checkpatch-add-test-for-repeated-const-uses.patch
adfs-returning-correct-return-values.patch
linux-next.patch

