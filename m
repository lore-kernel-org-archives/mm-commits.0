From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-use-get_maintainerconf-from-then-home-then-scripts.patch added to -mm tree
Date: Thu, 16 Sep 2010 12:53:25 -0700
Message-ID: <201009161953.o8GJrPpk010341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753672Ab0IPTx1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Sep 2010 15:53:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, Valdis.Kletnieks@vt.edu


The patch titled
     scripts/get_maintainer.pl: use .get_maintainer.conf from . then $HOME then scripts
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-use-get_maintainerconf-from-then-home-then-scripts.patch

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
Subject: scripts/get_maintainer.pl: use .get_maintainer.conf from . then $HOME then scripts
From: Joe Perches <joe@perches.com>

On Mon, 2010-09-13 at 00:01 -0400, Valdis.Kletnieks@vt.edu wrote:
> Any chance of getting that to be ~/.get_maintainer.conf rather than
> ./.get_maintainer.conf? I've just gotten bit like the 3rd or 4th time by
> "oh but you didn't create that file in *this* tree"
> (I usually have a linus git tree, a linux-next tree, and 3-4 -mm trees)

Sure.

Add a search path for the .conf file.

3 paths are added:

.             customized per-tree configurations
$HOME         user global configuration when per-tree configs don't exist
./scripts     lk defaults to override script

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-use-get_maintainerconf-from-then-home-then-scripts scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-use-get_maintainerconf-from-then-home-then-scripts
+++ a/scripts/get_maintainer.pl
@@ -110,10 +110,12 @@ my %VCS_cmds_hg = (
     "blame_commit_pattern" => "^([0-9a-f]+):"
 );
 
-if (-f "${lk_path}.get_maintainer.conf") {
+my $conf = which_conf(".get_maintainer.conf");
+if (-f $conf) {
     my @conf_args;
-    open(my $conffile, '<', "${lk_path}.get_maintainer.conf")
-	or warn "$P: Can't open .get_maintainer.conf: $!\n";
+    open(my $conffile, '<', "$conf")
+	or warn "$P: Can't find a readable .get_maintainer.conf file $!\n";
+
     while (<$conffile>) {
 	my $line = $_;
 
@@ -961,6 +963,18 @@ sub which {
     return "";
 }
 
+sub which_conf {
+    my ($conf) = @_;
+
+    foreach my $path (split(/:/, ".:$ENV{HOME}:.scripts")) {
+	if (-e "$path/$conf") {
+	    return "$path/$conf";
+	}
+    }
+
+    return "";
+}
+
 sub mailmap {
     my (@lines) = @_;
     my %hash;
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-add-irq-subsystem.patch
kernelh-add-minmax3-macros.patch
kernelh-add-minmax3-macros-fix.patch
replace-nested-max-min-macros-with-maxmin3-macro.patch
scripts-get_maintainerpl-add-git-blame-rolestats-authored-lines-information.patch
scripts-get_maintainerpl-use-correct-indentation.patch
scripts-get_maintainerpl-dont-search-maintainers-for-keywords-or-emails.patch
scripts-get_maintainerpl-add-default-git-fallback-remove-default-git.patch
scripts-get_maintainerpl-use-get_maintainerconf-from-then-home-then-scripts.patch
checkpatch-add-check-for-space-after-struct-union-and-enum.patch
checkpatch-add-additional-attribute-defines.patch
scripts-checkpatchpl-add-warnings-for-static-char-that-could-be-static-const-char.patch

