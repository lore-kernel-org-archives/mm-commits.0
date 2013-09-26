From: akpm@linux-foundation.org
Subject: + checkpatch-add-test-for-defines-of-arch_has_foo.patch added to
 -mm tree
Date: Thu, 26 Sep 2013 14:09:29 -0700
Message-ID: <5244a289.Upkak25C1iMldJVC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33264 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab3IZVJ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Sep 2013 17:09:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com

Subject: + checkpatch-add-test-for-defines-of-arch_has_foo.patch added to -mm tree
To: joe@perches.com,akpm@linux-foundation.org
From: akpm@linux-foundation.org
Date: Thu, 26 Sep 2013 14:09:29 -0700


The patch titled
     Subject: checkpatch: add test for #defines of ARCH_HAS_<foo>
has been added to the -mm tree.  Its filename is
     checkpatch-add-test-for-defines-of-arch_has_foo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-test-for-defines-of-arch_has_foo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-test-for-defines-of-arch_has_foo.patch

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
Subject: checkpatch: add test for #defines of ARCH_HAS_<foo>

Add a test for these #defines

Additionally, moved string_find_replace sub as it screws up subsequent
formatting when placed inside another sub.

Signed-off-by: Joe Perches <joe@perches.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-test-for-defines-of-arch_has_foo scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-test-for-defines-of-arch_has_foo
+++ a/scripts/checkpatch.pl
@@ -1514,6 +1514,14 @@ sub rtrim {
 	return $string;
 }
 
+sub string_find_replace {
+	my ($string, $find, $replace) = @_;
+
+	$string =~ s/$find/$replace/g;
+
+	return $string;
+}
+
 sub tabify {
 	my ($leading) = @_;
 
@@ -3733,14 +3741,6 @@ sub process {
 			}
 		}
 
-sub string_find_replace {
-	my ($string, $find, $replace) = @_;
-
-	$string =~ s/$find/$replace/g;
-
-	return $string;
-}
-
 # check for bad placement of section $InitAttribute (e.g.: __initdata)
 		if ($line =~ /(\b$InitAttribute\b)/) {
 			my $attr = $1;
@@ -4198,6 +4198,12 @@ sub string_find_replace {
 			     "usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc\n" . $herecurr);
 		}
 
+# Use of __ARCH_HAS_<FOO> or ARCH_HAVE_<BAR> is wrong.
+		if ($line =~ /\+\s*#\s*define\s+((?:__)?ARCH_(?:HAS|HAVE)\w*)\b/) {
+			ERROR("DEFINE_ARCH_HAS",
+			      "#define of '$1' is wrong - use Kconfig variables or standard guards instead\n" . $herecurr);
+		}
+
 # check for %L{u,d,i} in strings
 		my $string;
 		while ($line =~ /(?:^|")([X\t]*)(?:"|$)/g) {
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
kernel-modulec-use-pr_foo.patch
linux-next.patch

