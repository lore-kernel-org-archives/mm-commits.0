Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E54A3128B0
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 14:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776955195; cv=none; b=N8HgLkqnE9bpfn0nXTG36XLxq5DjPvQgGOJ1bS3jNb1pxrSvD3QgwNxV18Al05DoXUeWSRrucXKWWhXp/2cyQjpOz2xaaWb9xEsahxnPVsR7iphadc/RpzDvRF632uZa4RkGhNpmb5vLAVNSvOtBq+GQoogWAGab3t2F0DQWdH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776955195; c=relaxed/simple;
	bh=ZIEQoqOdUFd5pPs2pc38BBI9rdbPUMvNmM6EfgpfO+w=;
	h=Date:To:From:Subject:Message-Id; b=kAjZoHWPTQZPLIRAdOuPFXBv6W3JgKG8go51Z0sRmqopUdjge5PbFFO+aZ8I34kMD7/n8UQscJ1NjdhvrnHQ1BiZy/WkuMR6kR9az9JGD+5Xjf4QkjuaHR3xSKA2eQz697TAZGyZXRLBM5tIAAtSlksofZO+HHM+dKxe1BVpsEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cfG7bgJO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cfG7bgJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D61C2BCAF;
	Thu, 23 Apr 2026 14:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776955194;
	bh=ZIEQoqOdUFd5pPs2pc38BBI9rdbPUMvNmM6EfgpfO+w=;
	h=Date:To:From:Subject:From;
	b=cfG7bgJOoY1jVzXoIVSU3DKKJAEBW+LapwMcp2C8o0mg6XVlvuy/+0BWr5cdGlmpF
	 IJ0tVwiqRpQZacqNbzEpPjTfE8gUA+DAxeWE2CyJQTT+q8+4BFhW0ukPXH/LKsaGF4
	 yuI+vq7x0OJlOx1uqUJm7JjvxHPuLdTDJr+7BXNU=
Date: Thu, 23 Apr 2026 07:39:54 -0700
To: mm-commits@vger.kernel.org,sjg@chromium.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,pvorel@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-add-option-to-not-force-for-spdx.patch added to mm-nonmm-unstable branch
Message-Id: <20260423143954.D2D61C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: add option to not force /* */ for SPDX
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-add-option-to-not-force-for-spdx.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-add-option-to-not-force-for-spdx.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Petr Vorel <pvorel@suse.cz>
Subject: checkpatch: add option to not force /* */ for SPDX
Date: Tue, 21 Apr 2026 23:14:07 +0200

Add option --spdx-cxx-comments to not force C comments (/* */) for SPDX,
but allow also C++ comments (//).

As documented in aa19a176df95d6, this is required for some old toolchains
still have older assembler tools which cannot handle C++ style comments. 
This avoids forcing this for projects which vendored checkpatch.pl (e.g. 
LTP or u-boot).

Link: https://lore.kernel.org/20260421211408.383972-2-pvorel@suse.cz
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Reviewed-by: Simon Glass <sjg@chromium.org>
Acked-by: Joe Perches <joe@perches.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/checkpatch.rst |    7 +++++++
 scripts/checkpatch.pl                  |   23 ++++++++++++++++++-----
 2 files changed, 25 insertions(+), 5 deletions(-)

--- a/Documentation/dev-tools/checkpatch.rst~checkpatch-add-option-to-not-force-for-spdx
+++ a/Documentation/dev-tools/checkpatch.rst
@@ -184,6 +184,13 @@ Available options:
    Override checking of perl version.  Runtime errors may be encountered after
    enabling this flag if the perl version does not meet the minimum specified.
 
+ - --spdx-cxx-comments
+
+   Don't force C comments ``/* */`` for SPDX license (required by old
+   toolchains), allow also C++ comments ``//``.
+
+   NOTE: it should *not* be used for Linux mainline.
+
  - --codespell
 
    Use the codespell dictionary for checking spelling errors.
--- a/scripts/checkpatch.pl~checkpatch-add-option-to-not-force-for-spdx
+++ a/scripts/checkpatch.pl
@@ -62,6 +62,7 @@ my $def_configuration_dirs_help = '.:$HO
 my $env_config_dir = 'CHECKPATCH_CONFIG_DIR';
 my $max_line_length = 100;
 my $ignore_perl_version = 0;
+my $spdx_cxx_comments = 0;
 my $minimum_perl_version = 5.10.0;
 my $min_conf_desc_length = 4;
 my $spelling_file = "$D/spelling.txt";
@@ -138,6 +139,10 @@ Options:
                              file.  It's your fault if there's no backup or git
   --ignore-perl-version      override checking of perl version.  expect
                              runtime errors.
+  --spdx-cxx-comments        don't force C comments (/* */) for SPDX license
+                             (required by old toolchains), allow also C++
+                             comments (//).
+                             NOTE: it should *not* be used for Linux mainline.
   --codespell                Use the codespell dictionary for spelling/typos
                              (default:$codespellfile)
   --codespellfile            Use this codespell dictionary
@@ -347,6 +352,7 @@ GetOptions(
 	'fix!'		=> \$fix,
 	'fix-inplace!'	=> \$fix_inplace,
 	'ignore-perl-version!' => \$ignore_perl_version,
+	'spdx-cxx-comments!' => \$spdx_cxx_comments,
 	'debug=s'	=> \%debug,
 	'test-only=s'	=> \$tst_only,
 	'codespell!'	=> \$codespell,
@@ -3815,26 +3821,33 @@ sub process {
 				$checklicenseline = 2;
 			} elsif ($rawline =~ /^\+/) {
 				my $comment = "";
-				if ($realfile =~ /\.(h|s|S)$/) {
-					$comment = '/*';
-				} elsif ($realfile =~ /\.(c|rs|dts|dtsi)$/) {
+				if ($realfile =~ /\.(c|rs|dts|dtsi)$/) {
 					$comment = '//';
 				} elsif (($checklicenseline == 2) || $realfile =~ /\.(sh|pl|py|awk|tc|yaml)$/) {
 					$comment = '#';
 				} elsif ($realfile =~ /\.rst$/) {
 					$comment = '..';
 				}
+				my $pattern = qr{\Q$comment\E};
+				if ($realfile =~ /\.(h|s|S)$/) {
+					$comment = '/*';
+					$pattern = qr{/\*};
+					if ($spdx_cxx_comments) {
+						$comment = '// or /*';
+						$pattern = qr{//|/\*};
+					}
+				}
 
 # check SPDX comment style for .[chsS] files
 				if ($realfile =~ /\.[chsS]$/ &&
 				    $rawline =~ /SPDX-License-Identifier:/ &&
-				    $rawline !~ m@^\+\s*\Q$comment\E\s*@) {
+				    $rawline !~ m@^\+\s*$pattern\s*@) {
 					WARN("SPDX_LICENSE_TAG",
 					     "Improper SPDX comment style for '$realfile', please use '$comment' instead\n" . $herecurr);
 				}
 
 				if ($comment !~ /^$/ &&
-				    $rawline !~ m@^\+\Q$comment\E SPDX-License-Identifier: @) {
+				    $rawline !~ m@^\+$pattern SPDX-License-Identifier: @) {
 					WARN("SPDX_LICENSE_TAG",
 					     "Missing or malformed SPDX-License-Identifier tag in line $checklicenseline\n" . $herecurr);
 				} elsif ($rawline =~ /(SPDX-License-Identifier: .*)/) {
_

Patches currently in -mm which might be from pvorel@suse.cz are

checkpatch-allow-passing-config-directory.patch
checkpatch-add-option-to-not-force-for-spdx.patch

