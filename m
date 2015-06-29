From: akpm@linux-foundation.org
Subject: [merged]
 get_maintainerpl-add-get_maintainerignore-file-capability.patch removed
 from -mm tree
Date: Mon, 29 Jun 2015 13:47:35 -0700
Message-ID: <5591aee7.8PcFh4rBqiqbAJT5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbbF2Urf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:47:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer.pl: add .get_maintainer.ignore file capability
has been removed from the -mm tree.  Its filename was
     get_maintainerpl-add-get_maintainerignore-file-capability.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: get_maintainer.pl: add .get_maintainer.ignore file capability

Some people prefer not to be cc'd on patches.  Add an ability to have a
file (.get_maintainer.ignore) with names and email addresses that are
excluded from being listed except when specifically listed as a maintainer
in a section.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff -puN scripts/get_maintainer.pl~get_maintainerpl-add-get_maintainerignore-file-capability scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainerpl-add-get_maintainerignore-file-capability
+++ a/scripts/get_maintainer.pl
@@ -186,6 +186,27 @@ if (-f $conf) {
     unshift(@ARGV, @conf_args) if @conf_args;
 }
 
+my @ignore_emails = ();
+my $ignore_file = which_conf(".get_maintainer.ignore");
+if (-f $ignore_file) {
+    open(my $ignore, '<', "$ignore_file")
+	or warn "$P: Can't find a readable .get_maintainer.ignore file $!\n";
+    while (<$ignore>) {
+	my $line = $_;
+
+	$line =~ s/\s*\n?$//;
+	$line =~ s/^\s*//;
+	$line =~ s/\s+$//;
+	$line =~ s/#.*$//;
+
+	next if ($line =~ m/^\s*$/);
+	if (rfc822_valid($line)) {
+	    push(@ignore_emails, $line);
+	}
+    }
+    close($ignore);
+}
+
 if (!GetOptions(
 		'email!' => \$email,
 		'git!' => \$email_git,
@@ -513,6 +534,16 @@ if ($web) {
 
 exit($exit);
 
+sub ignore_email_address {
+    my ($address) = @_;
+
+    foreach my $ignore (@ignore_emails) {
+	return 1 if ($ignore eq $address);
+    }
+
+    return 0;
+}
+
 sub range_is_maintained {
     my ($start, $end) = @_;
 
@@ -1868,6 +1899,7 @@ sub vcs_assign {
 	my $percent = $sign_offs * 100 / $divisor;
 
 	$percent = 100 if ($percent > 100);
+	next if (ignore_email_address($line));
 	$count++;
 	last if ($sign_offs < $email_git_min_signatures ||
 		 $count > $email_git_max_maintainers ||
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
maintainers-update-sound-soc-intel-patterns.patch
maintainers-update-brcm-dts-pattern.patch
maintainers-update-brcm-gpio-filename-pattern.patch
maintainers-remove-unused-nbdh-pattern.patch
maintainers-move-jens-osterkamp-to-credits.patch
maintainers-bcache-kent-overstreet-has-changed-email-address.patch

