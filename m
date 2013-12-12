From: akpm@linux-foundation.org
Subject: + doc-no-singing.patch added to -mm tree
Date: Wed, 11 Dec 2013 16:51:36 -0800
Message-ID: <52a90898.MKYdNrosH4De3UjX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab3LLAvh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Dec 2013 19:51:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, keescook@chromium.org

Subject: + doc-no-singing.patch added to -mm tree
To: keescook@chromium.org
From: akpm@linux-foundation.org
Date: Wed, 11 Dec 2013 16:51:36 -0800


The patch titled
     Subject: doc: no singing
has been added to the -mm tree.  Its filename is
     doc-no-singing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/doc-no-singing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/doc-no-singing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: doc: no singing

Stop that, stop that! You're not going to do a song while I'm here.

https://lkml.org/lkml/2013/12/4/786
http://www.youtube.com/watch?v=g3YiPC91QUk#t=62

(akpm: s/singed/signed/)

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/resource_counter.txt |    2 +-
 Documentation/video4linux/si476x.txt       |    2 +-
 arch/score/lib/checksum.S                  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/cgroups/resource_counter.txt~doc-no-singing Documentation/cgroups/resource_counter.txt
--- a/Documentation/cgroups/resource_counter.txt~doc-no-singing
+++ a/Documentation/cgroups/resource_counter.txt
@@ -95,7 +95,7 @@ to work with it.
 
  f. u64 res_counter_uncharge_until
 		(struct res_counter *rc, struct res_counter *top,
-		 unsinged long val)
+		 unsigned long val)
 
 	Almost same as res_cunter_uncharge() but propagation of uncharge
 	stops when rc == top. This is useful when kill a res_coutner in
diff -puN Documentation/video4linux/si476x.txt~doc-no-singing Documentation/video4linux/si476x.txt
--- a/Documentation/video4linux/si476x.txt~doc-no-singing
+++ a/Documentation/video4linux/si476x.txt
@@ -147,7 +147,7 @@ The drivers exposes following files:
   --------------------------------------------------------------------
   0x12		| readfreq	| Current tuned frequency
   --------------------------------------------------------------------
-  0x14		| freqoff	| Singed frequency offset in units of
+  0x14		| freqoff	| Signed frequency offset in units of
   		| 		| 2ppm
   --------------------------------------------------------------------
   0x15		| rssi		| Signed value of RSSI in dBuV
diff -puN arch/score/lib/checksum.S~doc-no-singing arch/score/lib/checksum.S
--- a/arch/score/lib/checksum.S~doc-no-singing
+++ a/arch/score/lib/checksum.S
@@ -137,7 +137,7 @@ ENTRY(csum_partial)
 	ldi r25, 0
 	mv r10, r5
 	cmpi.c	r5, 0x8
-	blt	small_csumcpy		/* < 8(singed) bytes to copy */
+	blt	small_csumcpy		/* < 8(signed) bytes to copy */
 	cmpi.c	r5, 0x0
 	beq	out
 	andri.c	r25, src, 0x1		/* odd buffer? */
_

Patches currently in -mm which might be from keescook@chromium.org are

test-add-minimal-module-for-verification-testing.patch
test-check-copy_to-from_user-boundary-validation.patch
test-check-copy_to-from_user-boundary-validation-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
doc-no-singing.patch
coredump-set_dumpable-fix-the-theoretical-race-with-itself.patch
coredump-kill-mmf_dumpable-and-mmf_dump_securely.patch
coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph.patch
exec-check_unsafe_exec-use-while_each_thread-rather-than-next_thread.patch
exec-check_unsafe_exec-kill-the-dead-eagain-and-clear_in_exec-logic.patch
exec-move-the-final-allow_write_access-fput-into-free_bprm.patch
exec-kill-task_struct-did_exec.patch
fs-proc-arrayc-change-do_task_stat-to-use-while_each_thread.patch
kernel-sysc-k_getrusage-can-use-while_each_thread.patch
kernel-signalc-change-do_signal_stop-do_sigaction-to-use-while_each_thread.patch
linux-next.patch

