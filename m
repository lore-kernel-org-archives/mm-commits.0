From: akpm@linux-foundation.org
Subject: + scripts-checkpatchpl-add-check-for-declaration-of-pci_device_id.patch added to -mm tree
Date: Thu, 21 Oct 2010 23:38:54 -0700
Message-ID: <201010220638.o9M6cbID031355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752906Ab0JVGik (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Oct 2010 02:38:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@canonical.com


The patch titled
     scripts/checkpatch.pl: add check for declaration of pci_device_id
has been added to the -mm tree.  Its filename is
     scripts-checkpatchpl-add-check-for-declaration-of-pci_device_id.patch

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
Subject: scripts/checkpatch.pl: add check for declaration of pci_device_id
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN scripts/checkpatch.pl~scripts-checkpatchpl-add-check-for-declaration-of-pci_device_id scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~scripts-checkpatchpl-add-check-for-declaration-of-pci_device_id
+++ a/scripts/checkpatch.pl
@@ -1881,6 +1881,11 @@ sub process {
 				$herecurr);
                }
 
+# check for declarations of struct pci_device_id
+		if ($line =~ /\bstruct\s+pci_device_id\s+\w+\s*\[\s*\]\s*\=\s*\{/) {
+			WARN("Use DEFINE_PCI_DEVICE_TABLE for struct pci_device_id\n" . $herecurr);
+		}
+
 # check for new typedefs, only function parameters and sparse annotations
 # make sense.
 		if ($line =~ /\btypedef\s/ &&
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
scripts-checkpatchpl-add-check-for-declaration-of-pci_device_id.patch
gpio-add-topcliff-pch-gpio-driver.patch
gpio-add-topcliff-pch-gpio-driver-fix.patch

