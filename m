Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7044BC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AC3561288
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236250AbhKICgU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:36:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:51546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236249AbhKICgT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:36:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CA14611CC;
        Tue,  9 Nov 2021 02:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425214;
        bh=uOTkVoVo3uyNn/8KpIK3SmfjZI+UebQfkoV379sRU+k=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=iolVIcTUYcL39SXAsXkWKf2an0iGgymnai8Iacxx8Y3G4+/P4fwBd3FZNmJl4KbwD
         WD6QTANCUJ4qrfturBA1fLy3Hsu6UoybIjU/JaPzfaBpeoumZnrQEIbd5jAEezcLlD
         A7ozUyjvaa62Lz5pYFtkvyfVjo3XjzAjDCoVqj5U=
Date:   Mon, 08 Nov 2021 18:33:34 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peter.ujfalusi@linux.intel.com,
        torvalds@linux-foundation.org
Subject:  [patch 41/87] checkpatch: get default codespell
 dictionary path from package location
Message-ID: <20211109023334.MH-Zm5Brm%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
