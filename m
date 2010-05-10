From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-add-get_maintainerconf-default-options-file.patch added to -mm tree
Date: Mon, 10 May 2010 14:28:37 -0700
Message-ID: <201005102128.o4ALSbvl023713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753976Ab0EJV3D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 May 2010 17:29:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, florian@mickler.org


The patch titled
     scripts/get_maintainer.pl: add .get_maintainer.conf default options file
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-add-get_maintainerconf-default-options-file.patch

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
Subject: scripts/get_maintainer.pl: add .get_maintainer.conf default options file
From: Joe Perches <joe@perches.com>

Allow the use of a .get_maintainer.conf file to control the default
options applied when scripts/get_maintainer.pl is run.

.get_maintainer.conf can contain any valid command-line argument.

File contents are prepended to any additional command line arguments.

Multiple lines may be used, blank lines ignored, # is a comment.

Updated scripts/get_maintainer.pl version to 0.24

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Florian Mickler <florian@mickler.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-add-get_maintainerconf-default-options-file scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-add-get_maintainerconf-default-options-file
+++ a/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.23';
+my $V = '0.24';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -107,6 +107,30 @@ my %VCS_cmds_hg = (
     "blame_commit_pattern" => "^([0-9a-f]+):"
 );
 
+if (-f "${lk_path}.get_maintainer.conf") {
+    my @conf_args;
+    open(my $conffile, '<', "${lk_path}.get_maintainer.conf")
+	or warn "$P: Can't open .get_maintainer.conf: $!\n";
+    while (<$conffile>) {
+	my $line = $_;
+
+	$line =~ s/\s*\n?$//g;
+	$line =~ s/^\s*//g;
+	$line =~ s/\s+/ /g;
+
+	next if ($line =~ m/^\s*#/);
+	next if ($line =~ m/^\s*$/);
+
+	my @words = split(" ", $line);
+	foreach my $word (@words) {
+	    last if ($word =~ m/^#/);
+	    push (@conf_args, $word);
+	}
+    }
+    close($conffile);
+    unshift(@ARGV, @conf_args) if @conf_args;
+}
+
 if (!GetOptions(
 		'email!' => \$email,
 		'git!' => \$email_git,
@@ -573,6 +597,11 @@ Notes:
           --git-min-signatures, --git-max-maintainers, --git-min-percent, and
           --git-blame
       Use --hg-since not --git-since to control date selection
+  File ".get_maintainer.conf", if it exists in the linux kernel source root
+      directory, can change whatever get_maintainer defaults are desired.
+      Entries in this file can be any command line argument.
+      This file is prepended to any additional command line arguments.
+      Multiple lines and # comments are allowed.
 EOT
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

