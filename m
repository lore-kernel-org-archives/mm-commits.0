From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-dont-deduplicate-unnamed-addresses-ie-mailing-lists.patch added to -mm tree
Date: Tue, 05 Oct 2010 14:09:57 -0700
Message-ID: <201010052109.o95L9vJa020218@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755222Ab0JEVK2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 17:10:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, florian@mickler.org


The patch titled
     scripts/get_maintainer.pl: don't deduplicate unnamed addresses ie: mailing lists
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-dont-deduplicate-unnamed-addresses-ie-mailing-lists.patch

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
Subject: scripts/get_maintainer.pl: don't deduplicate unnamed addresses ie: mailing lists
From: Joe Perches <joe@perches.com>

Fix a defect with the first mailing list address being used for each
subsequent mailing list.

Updated to 0.26-beta6.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Florian Mickler <florian@mickler.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-dont-deduplicate-unnamed-addresses-ie-mailing-lists scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-dont-deduplicate-unnamed-addresses-ie-mailing-lists
+++ a/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.26-beta5';
+my $V = '0.26-beta6';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -1036,7 +1036,7 @@ sub push_email_address {
 	push(@email_to, [format_email($name, $address, $email_usename), $role]);
     } elsif (!email_inuse($name, $address)) {
 	push(@email_to, [format_email($name, $address, $email_usename), $role]);
-	$email_hash_name{lc($name)}++;
+	$email_hash_name{lc($name)}++ if ($name ne "");
 	$email_hash_address{lc($address)}++;
     }
 
@@ -1659,7 +1659,7 @@ sub deduplicate_email {
 
     ($name, $address) = parse_email($email);
 
-    if ($deduplicate_name_hash{lc($name)}) {
+    if ($name ne "" && $deduplicate_name_hash{lc($name)}) {
 	$name = $deduplicate_name_hash{lc($name)}->[0];
 	$address = $deduplicate_name_hash{lc($name)}->[1];
 	$matched = 1;
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
kernelh-add-minmax3-macros.patch
kernelh-add-minmax3-macros-fix.patch
replace-nested-max-min-macros-with-maxmin3-macro.patch
vsprintfc-use-default-pointer-field-size-for-null-strings.patch
vsprintfc-use-default-pointer-field-size-for-null-strings-fix.patch
lib-fix-scnprintf-if-size-is-==-0.patch
scripts-get_maintainerpl-add-git-blame-rolestats-authored-lines-information.patch
scripts-get_maintainerpl-use-correct-indentation.patch
scripts-get_maintainerpl-dont-search-maintainers-for-keywords-or-emails.patch
scripts-get_maintainerpl-add-default-git-fallback-remove-default-git.patch
scripts-get_maintainerpl-use-get_maintainerconf-from-then-home-then-scripts.patch
scripts-get_maintainerpl-add-interactive-mode.patch
scripts-get_maintainerpl-improve-interactive-ui.patch
scripts-get_maintainerpl-update-interactive-ui-improve-hg-runtime.patch
scripts-get_maintainerpl-use-case-insensitive-name-de-duplication.patch
scripts-get_maintainerpl-fix-mailmap-handling.patch
scripts-get_maintainerpl-correct-indentation-in-a-few-places.patch
scripts-get_maintainerpl-use-mailmap-in-name-deduplication-and-other-updates.patch
scripts-get_maintainerpl-dont-deduplicate-unnamed-addresses-ie-mailing-lists.patch
maintainers-fix-colibri-pxa270-file-pattern.patch
maintainers-merge-imote2-and-stargate.patch
maintainers-merge-s3c-244x-sections.patch
maintainers-merge-s3c6400-and-6410-to-64xx.patch
maintainers-remove-usb-ov511-driver.patch
maintainers-remove-usb-zc0301-driver.patch
maintainers-use-t-git-and-whitespace-trivia.patch
checkpatch-add-check-for-space-after-struct-union-and-enum.patch
checkpatch-add-additional-attribute-defines.patch
scripts-checkpatchpl-add-warnings-for-static-char-that-could-be-static-const-char.patch

