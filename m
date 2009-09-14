From: akpm@linux-foundation.org
Subject: + checkpatch-add-some-common-blackfin-checks.patch added to -mm tree
Date: Mon, 14 Sep 2009 14:57:47 -0700
Message-ID: <200909142157.n8ELvlZN003362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933479AbZINWBW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Sep 2009 18:01:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, apw@shadowen.org, cooloney@kernel.org


The patch titled
     checkpatch: add some common Blackfin checks
has been added to the -mm tree.  Its filename is
     checkpatch-add-some-common-blackfin-checks.patch

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
Subject: checkpatch: add some common Blackfin checks
From: Mike Frysinger <vapier@gentoo.org>

Add checks for Blackfin-specific issues that seem to crop up from time to
time.  In particular, we have helper macros to break a 32bit address into
the hi/lo parts, and we want to make sure people use the csync/ssync
variant that includes fun anomaly workarounds.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-some-common-blackfin-checks scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-some-common-blackfin-checks
+++ a/scripts/checkpatch.pl
@@ -1378,6 +1378,18 @@ sub process {
 			WARN("adding a line without newline at end of file\n" . $herecurr);
 		}
 
+# Blackfin: use hi/lo macros
+		if ($realfile =~ m@arch/blackfin/.*\.S$@) {
+			if ($line =~ /\.[lL][[:space:]]*=.*&[[:space:]]*0x[fF][fF][fF][fF]/) {
+				my $herevet = "$here\n" . cat_vet($line) . "\n";
+				ERROR("use the LO() macro, not (... & 0xFFFF)\n" . $herevet);
+			}
+			if ($line =~ /\.[hH][[:space:]]*=.*>>[[:space:]]*16/) {
+				my $herevet = "$here\n" . cat_vet($line) . "\n";
+				ERROR("use the HI() macro, not (... >> 16)\n" . $herevet);
+			}
+		}
+
 # check we are in a valid source file C or perl if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c|pl)$/);
 
@@ -1397,6 +1409,16 @@ sub process {
 			WARN("CVS style keyword markers, these will _not_ be updated\n". $herecurr);
 		}
 
+# Blackfin: don't use __builtin_bfin_[cs]sync
+		if ($line =~ /__builtin_bfin_csync/) {
+			my $herevet = "$here\n" . cat_vet($line) . "\n";
+			ERROR("use the CSYNC() macro in asm/blackfin.h\n" . $herevet);
+		}
+		if ($line =~ /__builtin_bfin_ssync/) {
+			my $herevet = "$here\n" . cat_vet($line) . "\n";
+			ERROR("use the SSYNC() macro in asm/blackfin.h\n" . $herevet);
+		}
+
 # Check for potential 'bare' types
 		my ($stat, $cond, $line_nr_next, $remain_next, $off_next);
 		if ($realcnt && $line =~ /.\s*\S/) {
_

Patches currently in -mm which might be from vapier@gentoo.org are

ipc-shmc-fix-undefined-reference-to-user_shm_unlock.patch
linux-next.patch
md-dm-log-fix-cn_ulog_callback-declaration.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
blackfin-fix-read-buffer-overflow.patch
scripts-get_maintainerpl-add-remove-duplicates.patch
asm-sections-add-text-data-checking-functions-for-arches-to-override.patch
kallsyms-use-new-arch_is_kernel_text.patch
lockdep-use-new-arch_is_kernel_data.patch
blackfin-override-text-data-checking-functions.patch
checkpatch-add-some-common-blackfin-checks.patch
rtc-update-documentation-wrt-rtc_pie-irq_set_state.patch
rtc-bfin-do-not-share-rtc-irq.patch
fdpic-ignore-the-loaders-pt_gnu_stack-when-calculating-the-stack-size.patch
flat-use-is_err_value-helper-macro.patch
linux-futexh-place-kernel-types-behind-__kernel__.patch

