From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-optionally-ignore-non-maintainer-signatures.patch added to -mm tree
Date: Mon, 10 May 2010 14:28:33 -0700
Message-ID: <201005102128.o4ALSYdS023706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753702Ab0EJV3B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 May 2010 17:29:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, florian@mickler.org


The patch titled
     scripts/get_maintainer.pl: optionally ignore non-maintainer signatures
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-optionally-ignore-non-maintainer-signatures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/get_maintainer.pl: optionally ignore non-maintainer signatures
From: Joe Perches <joe@perches.com>

When using --git to determine who to send a patch to, get_maintainers will
currently include all signatures.  This can include signers that simply
report an issue or test a patch.  Signers that use this tag are not
necessarily good candidates to review new patches.

This patch allows get_maintainers to optionally restrict output to only
signatures that use Signed-off-by:, Acked-by:, or Reviewed-by:.

Signed-off-by: is included because those are people who are responsible
for the code.

Acked-by: is questionable, but as signers that use this tag tend to be
active linux gatekeepers, false positives are tolerable.

Reviewed-by: is included because signers responsible for the code thought
that the review feedback for a changeset by that signer was valuable.

This patch has been modified from Florian's original submission to change
the supported signature types to the canonical forms and use slightly
different spacing.  A couple of spacing issues were also corrected in the
original source.  The command line argument was also renamed.

Original-patch-by: Florian Mickler <florian@mickler.org>
Signed-off-by: Florian Mickler <florian@mickler.org>
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-optionally-ignore-non-maintainer-signatures scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-optionally-ignore-non-maintainer-signatures
+++ a/scripts/get_maintainer.pl
@@ -25,6 +25,7 @@ my $email_list = 1;
 my $email_subscriber_list = 0;
 my $email_git_penguin_chiefs = 0;
 my $email_git = 1;
+my $email_git_all_signature_types = 1;
 my $email_git_blame = 0;
 my $email_git_min_signatures = 1;
 my $email_git_max_maintainers = 5;
@@ -51,9 +52,9 @@ my $help = 0;
 my $exit = 0;
 
 my @penguin_chief = ();
-push(@penguin_chief,"Linus Torvalds:torvalds\@linux-foundation.org");
+push(@penguin_chief, "Linus Torvalds:torvalds\@linux-foundation.org");
 #Andrew wants in on most everything - 2009/01/14
-#push(@penguin_chief,"Andrew Morton:akpm\@linux-foundation.org");
+#push(@penguin_chief, "Andrew Morton:akpm\@linux-foundation.org");
 
 my @penguin_chief_names = ();
 foreach my $chief (@penguin_chief) {
@@ -63,7 +64,16 @@ foreach my $chief (@penguin_chief) {
 	push(@penguin_chief_names, $chief_name);
     }
 }
-my $penguin_chiefs = "\(" . join("|",@penguin_chief_names) . "\)";
+my $penguin_chiefs = "\(" . join("|", @penguin_chief_names) . "\)";
+
+# Signature types of people who are either
+# 	a) responsible for the code in question, or
+# 	b) familiar enough with it to give relevant feedback
+my @signature_tags = ();
+push(@signature_tags, "Signed-off-by:");
+push(@signature_tags, "Reviewed-by:");
+push(@signature_tags, "Acked-by:");
+my $signaturePattern = "\(" . join("|", @signature_tags) . "\)";
 
 # rfc822 email address - preloaded methods go here.
 my $rfc822_lwsp = "(?:(?:\\r\\n)?[ \\t])";
@@ -100,6 +110,7 @@ my %VCS_cmds_hg = (
 if (!GetOptions(
 		'email!' => \$email,
 		'git!' => \$email_git,
+		'git-all-signature-types!' => \$email_git_all_signature_types,
 		'git-blame!' => \$email_git_blame,
 		'git-chief-penguins!' => \$email_git_penguin_chiefs,
 		'git-min-signatures=i' => \$email_git_min_signatures,
@@ -180,6 +191,10 @@ if (!top_of_kernel_tree($lk_path)) {
 	. "a linux kernel source tree.\n";
 }
 
+if ($email_git_all_signature_types) {
+    $signaturePattern = "(.+?)[Bb][Yy]:";
+}
+
 ## Read MAINTAINERS for type/value pairs
 
 my @typevalue = ();
@@ -497,13 +512,15 @@ version: $V
 MAINTAINER field selection options:
   --email => print email address(es) if any
     --git => include recent git \*-by: signers
+    --git-all-signature-types => include signers regardless of signature type
+        or use only ${signaturePattern} signers (default: $email_git_all_signature_types)
     --git-chief-penguins => include ${penguin_chiefs}
-    --git-min-signatures => number of signatures required (default: 1)
-    --git-max-maintainers => maximum maintainers to add (default: 5)
-    --git-min-percent => minimum percentage of commits required (default: 5)
+    --git-min-signatures => number of signatures required (default: $email_git_min_signatures)
+    --git-max-maintainers => maximum maintainers to add (default: $email_git_max_maintainers)
+    --git-min-percent => minimum percentage of commits required (default: $email_git_min_percent)
     --git-blame => use git blame to find modified commits for patch or file
-    --git-since => git history to use (default: 1-year-ago)
-    --hg-since => hg history to use (default: -365)
+    --git-since => git history to use (default: $email_git_since)
+    --hg-since => hg history to use (default: $email_hg_since)
     --m => include maintainer(s) if any
     --n => include name 'Full Name <addr\@domain.tld>'
     --l => include list(s) if any
@@ -964,7 +981,7 @@ sub vcs_find_signers {
 
     $commits = grep(/$pattern/, @lines);	# of commits
 
-    @lines = grep(/^[-_ 	a-z]+by:.*\@.*$/i, @lines);
+    @lines = grep(/^[ \t]*${signaturePattern}.*\@.*$/, @lines);
     if (!$email_git_penguin_chiefs) {
 	@lines = grep(!/${penguin_chiefs}/i, @lines);
     }
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
kernelh-add-pr_warn-for-symmetry-to-dev_warn-netdev_warn.patch
vsprintfc-use-noinline_for_stack.patch
scripts-get_maintainerpl-optionally-ignore-non-maintainer-signatures.patch
scripts-get_maintainerpl-add-get_maintainerconf-default-options-file.patch
lib-hexdumpc-reduce-stack-variable-size-and-cleanups.patch
lib-introduce-common-method-to-convert-hex-digits-fix-fix.patch
drivers-edac-convert-logging-messages-direct-uses-of-__file__-to-%s-__file.patch
drivers-edac-convert-logging-messages-direct-uses-of-__file__-to-%s-__file-checkpatch-fixes.patch

