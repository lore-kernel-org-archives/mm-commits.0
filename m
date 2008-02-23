From: akpm@linux-foundation.org
Subject: + ntp-make-the-kernel-ntp-code-hand-64-bit-unsigned-values-to-do_div.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:35:53 -0800
Message-ID: <200802230736.m1N7agLB018461@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:47589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933978AbYBWILA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:11:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org


The patch titled
     ntp: make the kernel NTP code hand 64-bit *unsigned* values to do_div()
has been added to the -mm tree.  Its filename is
     ntp-make-the-kernel-ntp-code-hand-64-bit-unsigned-values-to-do_div.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ntp: make the kernel NTP code hand 64-bit *unsigned* values to do_div()
From: David Howells <dhowells@redhat.com>

The kernel NTP code shouldn't hand 64-bit *signed* values to do_div().  Make it
instead hand 64-bit unsigned values.  This gets rid of a couple of warnings.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/ntp.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN kernel/time/ntp.c~ntp-make-the-kernel-ntp-code-hand-64-bit-unsigned-values-to-do_div kernel/time/ntp.c
--- a/kernel/time/ntp.c~ntp-make-the-kernel-ntp-code-hand-64-bit-unsigned-values-to-do_div
+++ a/kernel/time/ntp.c
@@ -342,14 +342,16 @@ int do_adjtimex(struct timex *txc)
 		    freq_adj = shift_right(freq_adj, time_constant * 2 +
 					   (SHIFT_PLL + 2) * 2 - SHIFT_NSEC);
 		    if (mtemp >= MINSEC && (time_status & STA_FLL || mtemp > MAXSEC)) {
+			u64 utemp64;
 			temp64 = time_offset << (SHIFT_NSEC - SHIFT_FLL);
 			if (time_offset < 0) {
-			    temp64 = -temp64;
-			    do_div(temp64, mtemp);
-			    freq_adj -= temp64;
+			    utemp64 = -temp64;
+			    do_div(utemp64, mtemp);
+			    freq_adj -= utemp64;
 			} else {
-			    do_div(temp64, mtemp);
-			    freq_adj += temp64;
+			    utemp64 = temp64;
+			    do_div(utemp64, mtemp);
+			    freq_adj += utemp64;
 			}
 		    }
 		    freq_adj += time_freq;
_

Patches currently in -mm which might be from dhowells@redhat.com are

mn10300-define-hz-as-a-config-option.patch
mn10300-define-so_mark.patch
nommu-is_vmalloc_addr-wont-compile-if-mmu.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
ntp-make-the-kernel-ntp-code-hand-64-bit-unsigned-values-to-do_div.patch
keys-increase-the-payload-size-when-instantiating-a-key.patch
keys-check-starting-keyring-as-part-of-search.patch
keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch
keys-add-keyctl-function-to-get-a-security-label.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
mutex-subsystem-synchro-test-module.patch
