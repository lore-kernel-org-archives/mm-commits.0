From: akpm@linux-foundation.org
Subject: +
 checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch
 added to -mm tree
Date: Wed, 02 Jul 2014 15:06:53 -0700
Message-ID: <53b4827d.MBmMKpPHRKfV+lHR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:39283 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbaGBWGy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2014 18:06:54 -0400
Received: by mail-ob0-f202.google.com with SMTP id va2so2732921obc.5
        for <mm-commits@vger.kernel.org>; Wed, 02 Jul 2014 15:06:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add test for commit id formatting style in commit log
has been added to the -mm tree.  Its filename is
     checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch

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
Subject: checkpatch: add test for commit id formatting style in commit log

Commit logs have various forms of commit id references.

Try to standardize on a 12 character long lower case commit id along with
a description of parentheses and the quoted subject line.

ie: commit 0123456789ab ("commit description")

If git and a git tree exists, look up the commit id and emit the
appropriate line as part of the message.

Signed-off-by: Joe Perches <joe@perches.com>
Requested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   54 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-test-for-commit-id-formatting-style-in-commit-log scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-test-for-commit-id-formatting-style-in-commit-log
+++ a/scripts/checkpatch.pl
@@ -550,6 +550,34 @@ sub seed_camelcase_includes {
 	}
 }
 
+sub git_commit_info {
+	my ($commit, $id, $desc) = @_;
+
+	return ($id, $desc) if ((which("git") eq "") || !(-e ".git"));
+
+	my $output = `git log --no-color --format='%H %s' -1 $commit 2>&1`;
+	$output =~ s/^\s*//gm;
+	my @lines = split("\n", $output);
+
+	if ($lines[0] =~ /^error: short SHA1 $commit is ambiguous\./) {
+# Maybe one day convert this block of bash into something that returns
+# all matching commit ids, but it's very slow...
+#
+#		echo "checking commits $1..."
+#		git rev-list --remotes | grep -i "^$1" |
+#		while read line ; do
+#		    git log --format='%H %s' -1 $line |
+#		    echo "commit $(cut -c 1-12,41-)"
+#		done
+	} elsif ($lines[0] =~ /^fatal: ambiguous argument '$commit': unknown revision or path not in the working tree\./) {
+	} else {
+		$id = substr($lines[0], 0, 12);
+		$desc = substr($lines[0], 41);
+	}
+
+	return ($id, $desc);
+}
+
 $chk_signoff = 0 if ($file);
 
 my @rawlines = ();
@@ -674,6 +702,18 @@ sub format_email {
 	return $formatted_email;
 }
 
+sub which {
+    my ($bin) = @_;
+
+    foreach my $path (split(/:/, $ENV{PATH})) {
+	if (-e "$path/$bin") {
+	    return "$path/$bin";
+	}
+    }
+
+    return "";
+}
+
 sub which_conf {
 	my ($conf) = @_;
 
@@ -1958,6 +1998,20 @@ sub process {
 			      "Remove Gerrit Change-Id's before submitting upstream.\n" . $herecurr);
 		}
 
+# Check for improperly formed commit descriptions
+		if ($in_commit_log &&
+		    $line =~ /\bcommit\s+[0-9a-f]{5,}/i &&
+		    $line !~ /\b[Cc]ommit [0-9a-f]{12,16} \("/) {
+			$line =~ /\b(c)ommit\s+([0-9a-f]{5,})/i;
+			my $init_char = $1;
+			my $orig_commit = lc($2);
+			my $id = '01234567890ab';
+			my $desc = 'commit description';
+		        ($id, $desc) = git_commit_info($orig_commit, $id, $desc);
+			ERROR("GIT_COMMIT_ID",
+			      "Please use 12 to 16 chars for the git commit ID like: '${init_char}ommit $id (\"$desc\")'\n" . $herecurr);
+		}
+
 # Check for wrappage within a valid hunk of the file
 		if ($realcnt != 0 && $line !~ m{^(?:\+|-| |\\ No newline|$)}) {
 			ERROR("CORRUPTED_PATCH",
_

Patches currently in -mm which might be from joe@perches.com are

fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-asus_atk0110-fix-define_simple_attribute-semicolon-definition-and-use.patch
printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch
printk-tweak-do_syslog-to-match-comments.patch
maintainers-remove-two-ancient-eata-sections.patch
mm-utilc-add-kstrimdup.patch
kernelh-remove-deprecated-pack_hex_byte.patch
checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch
checkpatch-warn-on-unnecessary-else-after-return-or-break.patch
checkpatch-fix-complex-macro-false-positive-for-escaped-constant-char.patch
checkpatch-fix-function-pointers-in-blank-line-needed-after-declarations-test.patch
checkpatch-ignore-email-headers-better.patch
checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch
checkpatch-add-test-for-blank-lines-after-function-struct-union-enum.patch
checkpatch-add-test-for-blank-lines-after-function-struct-union-enum-declarations.patch
checkpatch-add-a-multiple-blank-lines-test.patch
checkpatch-change-blank-line-after-declaration-type-to-line_spacing.patch
checkpatch-quiet-kconfig-help-message-checking.patch
checkpatch-warn-on-unnecessary-parentheses-around-references-of-foo-bar.patch
checkpatch-allow-multiple-const-types.patch
checkpatch-improve-no-space-after-cast-test.patch
checkpatch-emit-fewer-kmalloc_array-kcalloc-conversion-warnings.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch
fs-isofs-logging-clean-up.patch
proc-constify-seq_operations.patch
sysctl-remove-now-unused-typedef-ctl_table.patch
sysctl-remove-now-unused-typedef-ctl_table-fix.patch
adfs-add-__printf-verification-fix-format-argument-mismatches.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
scripts-coccinelle-free-add-null-test-before-freeing-functions.patch
linux-next.patch
pci-dma-compat-add-pci_zalloc_consistent-helper.patch
atm-use-pci_zalloc_consistent.patch
block-use-pci_zalloc_consistent.patch
crypto-use-pci_zalloc_consistent.patch
infiniband-use-pci_zalloc_consistent.patch
i810-use-pci_zalloc_consistent.patch
media-use-pci_zalloc_consistent.patch
amd-use-pci_zalloc_consistent.patch
atl1e-use-pci_zalloc_consistent.patch
enic-use-pci_zalloc_consistent.patch
sky2-use-pci_zalloc_consistent.patch
micrel-use-pci_zalloc_consistent.patch
qlogic-use-pci_zalloc_consistent.patch
irda-use-pci_zalloc_consistent.patch
ipw2100-use-pci_zalloc_consistent.patch
mwl8k-use-pci_zalloc_consistent.patch
rtl818x-use-pci_zalloc_consistent.patch
rtlwifi-use-pci_zalloc_consistent.patch
scsi-use-pci_zalloc_consistent.patch
staging-use-pci_zalloc_consistent.patch
synclink_gt-use-pci_zalloc_consistent.patch
vme-bridges-use-pci_zalloc_consistent.patch
amd-neaten-and-remove-unnecessary-oom-messages.patch

