From: akpm@linux-foundation.org
Subject: + checkpatch-match-more-world-writable-permissions.patch added to -mm tree
Date: Tue, 17 Mar 2015 15:28:15 -0700
Message-ID: <5508aa7f.KFMv+5GBx4zfBEns%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268AbbCQW2Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Mar 2015 18:28:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, hofrat@osadl.org, linux@roeck-us.net, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: match more world writable permissions
has been added to the -mm tree.  Its filename is
     checkpatch-match-more-world-writable-permissions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-match-more-world-writable-permissions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-match-more-world-writable-permissions.patch

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
Subject: checkpatch: match more world writable permissions

Currently checkpatch will fuss if one uses world writable settings in
debugfs files and DEVICE_ATTR uses by testing S_IWUGO but not testing
S_IWOTH, S_IRWXUGO or S_IALLUGO.

Extend the check to catch all cases exporting world writable permissions
including octal values.

Signed-off-by: Joe Perches <joe@perches.com>
Original-patch-by: Nicholas Mc Guire <hofrat@osadl.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-match-more-world-writable-permissions scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-match-more-world-writable-permissions
+++ a/scripts/checkpatch.pl
@@ -443,6 +443,14 @@ foreach my $entry (@mode_permission_func
 	$mode_perms_search .= $entry->[0];
 }
 
+$our $mode_perms_world_writable = qr{
+	S_IWUGO		|
+	S_IWOTH		|
+	S_IRWXUGO	|
+	S_IALLUGO	|
+	0[0-7][0-7][2367]
+}x;
+
 our $allowed_asm_includes = qr{(?x:
 	irq|
 	memory|
@@ -5356,8 +5364,8 @@ sub process {
 			}
 		}
 
-		if ($line =~ /debugfs_create_file.*S_IWUGO/ ||
-		    $line =~ /DEVICE_ATTR.*S_IWUGO/ ) {
+		if ($line =~ /debugfs_create_\w+.*\b$mode_perms_world_writable\b/ ||
+		    $line =~ /DEVICE_ATTR.*\b$mode_perms_world_writable\b/) {
 			WARN("EXPORTED_WORLD_WRITABLE",
 			     "Exporting world writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
 		}
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-correct-rtc-armada38x-pattern-entry.patch
proc-show-locks-in-proc-pid-fdinfo-x.patch
proc-show-locks-in-proc-pid-fdinfo-x-v2.patch
maintainers-use-tabs-consistently.patch
x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
power-wakeup-remove-use-of-seq_printf-return-value.patch
rtc-remove-use-of-seq_printf-return-value.patch
ipc-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value-fix.patch
nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
arm-plat-pxa-remove-use-of-seq_printf-return-value.patch
openrisc-remove-use-of-seq_printf-return-value.patch
cris-remove-use-of-seq_printf-return-value.patch
s390-remove-use-of-seq_printf-return-value.patch
i8k-remove-use-of-seq_printf-return-value.patch
watchdog-bcm281xx-remove-use-of-seq_printf-return-value.patch
proc-remove-use-of-seq_printf-return-value.patch
cgroup-remove-use-of-seq_printf-return-value.patch
tracing-remove-use-of-seq_printf-return-value.patch
lru_cache-remove-use-of-seq_printf-return-value.patch
parisc-remove-use-of-seq_printf-return-value.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
checkpatch-add-spell-checking-of-email-subject-line.patch
checkpatch-spell-check-reudce.patch
checkpatch-add-optional-codespell-dictionary-to-find-more-typos.patch
checkpatch-match-more-world-writable-permissions.patch
linux-next.patch

