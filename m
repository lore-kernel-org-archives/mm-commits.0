From: akpm@linux-foundation.org
Subject: + get_maintainer-fix-help-warning.patch added to -mm tree
Date: Wed, 13 Jun 2012 12:23:33 -0700
Message-ID: <20120613192333.5D027A0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:60493 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab2FMTXg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 15:23:36 -0400
Received: by lbbgp10 with SMTP id gp10so110888lbb.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 12:23:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, pebolle@tiscali.nl


The patch titled
     Subject: get_maintainer: Fix --help warning
has been added to the -mm tree.  Its filename is
     get_maintainer-fix-help-warning.patch

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
Subject: get_maintainer: Fix --help warning

Using --help emits a concatenation error.  Fix it.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Joe Perches <joe@perches.com>
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
Subject: Subject: get_maintainer: Fix --help warning

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
get_maintainer-fix-help-warning.patch
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
checkpatch-update-alignment-check.patch

