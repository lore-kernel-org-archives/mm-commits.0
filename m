From: akpm@linux-foundation.org
Subject: +
 checkpatch-cache-last-camelcase-hash-as-checkpatch-camelcasecommit.patch
 added to -mm tree
Date: Fri, 28 Jun 2013 13:19:33 -0700
Message-ID: <51cdefd5.SVKYp1LhtHeOeyjG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab3F1UTe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jun 2013 16:19:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-cache-last-camelcase-hash-as-checkpatch-camelcasecommit.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Fri, 28 Jun 2013 13:19:33 -0700


The patch titled
     Subject: checkpatch: cache last camelcase hash as .checkpatch-camelcase.<commit>
has been added to the -mm tree.  Its filename is
     checkpatch-cache-last-camelcase-hash-as-checkpatch-camelcasecommit.patch

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
Subject: checkpatch: cache last camelcase hash as .checkpatch-camelcase.<commit>

Add a file to cache the CamelCase variables found by <commit> to reduce
the time it takes to scan the include/ directory.

Filename is '.checkpatch-camelcase.<commit>' and it is created only only
if a .git directory exists.

<commit> is determined by the last non-merge commit id in the
include/ path.

Reduces checkpatch run time by ~12 cpu seconds on my little netbook.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-cache-last-camelcase-hash-as-checkpatch-camelcasecommit scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-cache-last-camelcase-hash-as-checkpatch-camelcasecommit
+++ a/scripts/checkpatch.pl
@@ -399,7 +399,23 @@ sub seed_camelcase_includes {
 	return if ($camelcase_seeded);
 
 	my $files;
+	my $camelcase_git_file = "";
+
 	if (-d ".git") {
+		my $git_last_include_commit = `git log --no-merges --pretty=format:"%h%n" -1 -- include`;
+		chomp $git_last_include_commit;
+		$camelcase_git_file = ".checkpatch-camelcase.$git_last_include_commit";
+		if (-f $camelcase_git_file) {
+			open(my $camelcase_file, '<', "$camelcase_git_file")
+			    or warn "$P: Can't read '$camelcase_git_file' $!\n";
+			while (<$camelcase_file>) {
+				chomp;
+				$camelcase{$_} = 1;
+			}
+			close($camelcase_file);
+
+			return;
+		}
 		$files = `git ls-files include`;
 	} else {
 		$files = `find $root/include -name "*.h"`;
@@ -409,6 +425,16 @@ sub seed_camelcase_includes {
 		seed_camelcase_file($file);
 	}
 	$camelcase_seeded = 1;
+
+	if ($camelcase_git_file ne "") {
+		unlink glob ".checkpatch-camelcase.*";
+		open(my $camelcase_file, '>', "$camelcase_git_file")
+		    or warn "$P: Can't write '$camelcase_git_file' $!\n";
+		foreach (sort { lc($a) cmp lc($b) } keys(%camelcase)) {
+			print $camelcase_file ("$_\n");
+		}
+		close($camelcase_file);
+	}
 }
 
 $chk_signoff = 0 if ($file);
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch
mm-remove-unused-vm_readfoo-macros-and-expand-other-in-place.patch
checkpatch-change-camelcase-test-and-make-it-strict.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
checkpatch-add-strict-preference-for-p-=-kmallocsizeofp.patch
checkpatch-remove-quote-from-camelcase-test.patch
checkpatch-improve-network-block-comment-test-and-message.patch
checkpatch-warn-when-networking-block-comment-lines-dont-start-with.patch
checkpatch-warn-on-comparisons-to-jiffies.patch
checkpatch-warn-on-comparisons-to-get_jiffies_64.patch
checkpatch-reduce-false-positive-rate-of-complex-macros.patch
checkpatch-add-a-placeholder-to-check-blank-lines-before-declarations.patch
checkpatch-dont-warn-on-blank-lines-before-after-braces-as-often.patch
checkpatch-add-a-strict-test-for-comparison-to-true-false.patch
checkpatch-improve-no-space-after-cast-test.patch
checkpatch-create-an-experimental-fix-option-to-correct-patches.patch
checkpatch-move-test-for-space-before-semicolon-after-operator-spacing.patch
checkpatch-ignore-si-unit-camelcase-variants-like-_uv.patch
checkpatch-ignore-existing-camelcase-uses-from-include.patch
checkpatch-allow-longer-logging-function-names.patch
checkpatch-cache-last-camelcase-hash-as-checkpatch-camelcasecommit.patch

