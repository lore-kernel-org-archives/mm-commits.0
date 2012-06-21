From: akpm@linux-foundation.org
Subject: [merged] get_maintainer-fix-help-warning.patch removed from -mm tree
Date: Thu, 21 Jun 2012 12:25:36 -0700
Message-ID: <20120621192536.5830AA00B0@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:33530 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760108Ab2FUTZi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 15:25:38 -0400
Received: by eaao13 with SMTP id o13so62854eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 12:25:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, pebolle@tiscali.nl, mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer: Fix --help warning
has been removed from the -mm tree.  Its filename was
     get_maintainer-fix-help-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: get_maintainer: Fix --help warning

Using --help emits a concatenation error.  Fix it.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Paul Bolle <pebolle@tiscali.nl>
Tested-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/get_maintainer.pl~get_maintainer-fix-help-warning scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainer-fix-help-warning
+++ a/scripts/get_maintainer.pl
@@ -83,6 +83,8 @@ push(@signature_tags, "Signed-off-by:");
 push(@signature_tags, "Reviewed-by:");
 push(@signature_tags, "Acked-by:");
 
+my $signature_pattern = "\(" . join("|", @signature_tags) . "\)";
+
 # rfc822 email address - preloaded methods go here.
 my $rfc822_lwsp = "(?:(?:\\r\\n)?[ \\t])";
 my $rfc822_char = '[\\000-\\377]';
@@ -473,7 +475,6 @@ my @subsystem = ();
 my @status = ();
 my %deduplicate_name_hash = ();
 my %deduplicate_address_hash = ();
-my $signature_pattern;
 
 my @maintainers = get_maintainers();
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
printk-add-generic-functions-to-find-kern_level-headers.patch
printk-add-kern_levelsh-to-make-kern_level-available-for-asm-use.patch
arch-remove-direct-definitions-of-kern_level-uses.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
sound-use-printk_get_level-and-printk_skip_level.patch
printk-convert-the-format-for-kern_level-to-a-2-byte-pattern.patch
printk-only-look-for-prefix-levels-in-kernel-messages.patch
printk-remove-the-now-unnecessary-c-annotation-for-kern_cont.patch
vsprintf-add-%pmr-for-bluetooth-mac-address.patch
vsprintf-add-%pmr-for-bluetooth-mac-address-fix.patch
checkpatch-update-alignment-check.patch
checkpatch-test-for-non-standard-signatures.patch

