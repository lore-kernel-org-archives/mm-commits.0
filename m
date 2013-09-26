From: akpm@linux-foundation.org
Subject: +
 checkpatch-add-rules-to-check-init-attribute-and-const-defects.patch added
 to -mm tree
Date: Thu, 26 Sep 2013 14:47:37 -0700
Message-ID: <5244ab79.ZirFUSQFoCqP+3L5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34301 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab3IZVrh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Sep 2013 17:47:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ak@linux.intel.com, joe@perches.com

Subject: + checkpatch-add-rules-to-check-init-attribute-and-const-defects.patch added to -mm tree
To: joe@perches.com,ak@linux.intel.com
From: akpm@linux-foundation.org
Date: Thu, 26 Sep 2013 14:47:37 -0700


The patch titled
     Subject: checkpatch: add rules to check init attribute and const defects
has been added to the -mm tree.  Its filename is
     checkpatch-add-rules-to-check-init-attribute-and-const-defects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-rules-to-check-init-attribute-and-const-defects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-rules-to-check-init-attribute-and-const-defects.patch

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
Subject: checkpatch: add rules to check init attribute and const defects

People get this regularly wrong and it breaks the LTO builds, as it causes
a section attribute conflict.

Add --fix capability too.

Based on a patch from Andi Kleen.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-rules-to-check-init-attribute-and-const-defects scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-rules-to-check-init-attribute-and-const-defects
+++ a/scripts/checkpatch.pl
@@ -241,8 +241,11 @@ our $Sparse	= qr{
 			__ref|
 			__rcu
 		}x;
-
-our $InitAttribute = qr{__(?:mem|cpu|dev|net_|)(?:initdata|initconst|init\b)};
+our $InitAttributePrefix = qr{__(?:mem|cpu|dev|net_|)};
+our $InitAttributeData = qr{$InitAttributePrefix(?:initdata\b)};
+our $InitAttributeConst = qr{$InitAttributePrefix(?:initconst\b)};
+our $InitAttributeInit = qr{$InitAttributePrefix(?:init\b)};
+our $InitAttribute = qr{$InitAttributeData|$InitAttributeConst|$InitAttributeInit};
 
 # Notes to $Attribute:
 # We need \b after 'init' otherwise 'initconst' will cause a false positive in a check
@@ -3759,6 +3762,35 @@ sub process {
 			}
 		}
 
+# check for $InitAttributeData (ie: __initdata) with const
+		if ($line =~ /\bconst\b/ && $line =~ /($InitAttributeData)/) {
+			my $attr = $1;
+			$attr =~ /($InitAttributePrefix)(.*)/;
+			my $attr_prefix = $1;
+			my $attr_type = $2;
+			if (ERROR("INIT_ATTRIBUTE",
+				  "Use of const init definition must use ${attr_prefix}initconst\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~
+				    s/$InitAttributeData/${attr_prefix}initconst/;
+			}
+		}
+
+# check for $InitAttributeConst (ie: __initconst) without const
+		if ($line !~ /\bconst\b/ && $line =~ /($InitAttributeConst)/) {
+			my $attr = $1;
+			if (ERROR("INIT_ATTRIBUTE",
+				  "Use of $attr requires a separate use of const\n" . $herecurr) &&
+			    $fix) {
+				my $lead = $fixed[$linenr - 1] =~
+				    /(^\+\s*(?:static\s+))/;
+				$lead = rtrim($1);
+				$lead = "$lead " if ($lead !~ /^\+$/);
+				$lead = "${lead}const ";
+				$fixed[$linenr - 1] =~ s/(^\+\s*(?:static\s+))/$lead/;
+			}
+		}
+
 # prefer usleep_range over udelay
 		if ($line =~ /\budelay\s*\(\s*(\d+)\s*\)/) {
 			# ignore udelay's < 10, however
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch
ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
printk-report-console-names-during-cut-over.patch
kernel-printk-printkc-convert-to-pr_foo.patch
checkpatch-report-missing-spaces-around-trigraphs-with-strict.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-update-seq_foo-tests.patch
checkpatch-find-camelcase-definitions-of-struct-union-enum.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
checkpatch-add-rules-to-check-init-attribute-and-const-defects.patch
kernel-modulec-use-pr_foo.patch
linux-next.patch

