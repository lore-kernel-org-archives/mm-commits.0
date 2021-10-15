Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24C72C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 22:41:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 009CD611EE
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 22:41:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235908AbhJOWnU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Oct 2021 18:43:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234009AbhJOWnT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 15 Oct 2021 18:43:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C51E7611C2;
        Fri, 15 Oct 2021 22:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634337672;
        bh=4wN+Mb6Q95dHNEveelOwhcbJcV3FJe/+ZkVkxuKWYcI=;
        h=Date:From:To:Subject:From;
        b=mSZhDgzafBXAp8fY5vUWbZ84w1Sn0zl/ujwDHI/qzy0c9t7s0r/oAKkWug3La+c06
         uBC4NCYjZmRdmepkytW8EypxOmO4pP2o10UXmtglebWEce4z9DGlqTR4jp5aAyyVRF
         /eVLtyUzWmC07dJ6KJmU6JQaHXwGTVHFnGvu5mgs=
Date:   Fri, 15 Oct 2021 15:41:12 -0700
From:   akpm@linux-foundation.org
To:     joe@perches.com, mm-commits@vger.kernel.org,
        peter.ujfalusi@linux.intel.com
Subject:  +
 =?US-ASCII?Q?checkpatch-get-default-codespell-dictionary-path-from-packag?=
 =?US-ASCII?Q?e-location.patch?= added to -mm tree
Message-ID: <20211015224112.GeJwUAwHG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: get default codespell dictionary path from package location
has been added to the -mm tree.  Its filename is
     checkpatch-get-default-codespell-dictionary-path-from-package-location.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-get-default-codespell-dictionary-path-from-package-location.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-get-default-codespell-dictionary-path-from-package-location.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Subject: checkpatch: get default codespell dictionary path from package location

The standard location of dictionary.txt is under codespell's package, on
my machine atm (codespell 2.1, Artix Linux):
/usr/lib/python3.9/site-packages/codespell_lib/data/dictionary.txt

Since we enable the codespell by default for SOF I have constant:
No codespell typos will be found - \
file '/usr/share/codespell/dictionary.txt': No such file or directory

The patch proposes to try to fix up the path following the recommendation
found here: https://github.com/codespell-project/codespell/issues/1540

Link: https://lkml.kernel.org/r/29e25d1364c8ad7f7657cc0660f60c568074d438.camel@perches.com
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-get-default-codespell-dictionary-path-from-package-location
+++ a/scripts/checkpatch.pl
@@ -63,6 +63,7 @@ my $min_conf_desc_length = 4;
 my $spelling_file = "$D/spelling.txt";
 my $codespell = 0;
 my $codespellfile = "/usr/share/codespell/dictionary.txt";
+my $user_codespellfile = "";
 my $conststructsfile = "$D/const_structs.checkpatch";
 my $docsfile = "$D/../Documentation/dev-tools/checkpatch.rst";
 my $typedefsfile;
@@ -130,7 +131,7 @@ Options:
   --ignore-perl-version      override checking of perl version.  expect
                              runtime errors.
   --codespell                Use the codespell dictionary for spelling/typos
-                             (default:/usr/share/codespell/dictionary.txt)
+                             (default:$codespellfile)
   --codespellfile            Use this codespell dictionary
   --typedefsfile             Read additional types from this file
   --color[=WHEN]             Use colors 'always', 'never', or only when output
@@ -317,7 +318,7 @@ GetOptions(
 	'debug=s'	=> \%debug,
 	'test-only=s'	=> \$tst_only,
 	'codespell!'	=> \$codespell,
-	'codespellfile=s'	=> \$codespellfile,
+	'codespellfile=s'	=> \$user_codespellfile,
 	'typedefsfile=s'	=> \$typedefsfile,
 	'color=s'	=> \$color,
 	'no-color'	=> \$color,	#keep old behaviors of -nocolor
@@ -325,9 +326,32 @@ GetOptions(
 	'kconfig-prefix=s'	=> \${CONFIG_},
 	'h|help'	=> \$help,
 	'version'	=> \$help
-) or help(1);
+) or $help = 2;
 
-help(0) if ($help);
+if ($user_codespellfile) {
+	# Use the user provided codespell file unconditionally
+	$codespellfile = $user_codespellfile;
+} elsif (!(-f $codespellfile)) {
+	# If /usr/share/codespell/dictionary.txt is not present, try to find it
+	# under codespell's install directory: <codespell_root>/data/dictionary.txt
+	if (($codespell || $help) && which("codespell") ne "" && which("python") ne "") {
+		my $python_codespell_dict = << "EOF";
+
+import os.path as op
+import codespell_lib
+codespell_dir = op.dirname(codespell_lib.__file__)
+codespell_file = op.join(codespell_dir, 'data', 'dictionary.txt')
+print(codespell_file, end='')
+EOF
+
+		my $codespell_dict = `python -c "$python_codespell_dict" 2> /dev/null`;
+		$codespellfile = $codespell_dict if (-f $codespell_dict);
+	}
+}
+
+# $help is 1 if either -h, --help or --version is passed as option - exitcode: 0
+# $help is 2 if invalid option is passed - exitcode: 1
+help($help - 1) if ($help);
 
 die "$P: --git cannot be used with --file or --fix\n" if ($git && ($file || $fix));
 die "$P: --verbose cannot be used with --terse\n" if ($verbose && $terse);
_

Patches currently in -mm which might be from peter.ujfalusi@linux.intel.com are

checkpatch-get-default-codespell-dictionary-path-from-package-location.patch

