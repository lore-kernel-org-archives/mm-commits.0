From: akpm@linux-foundation.org
Subject: + x86-vdso-fix-vdso2cs-special_pages-error-checking.patch added
 to -mm tree
Date: Wed, 30 Jul 2014 14:59:49 -0700
Message-ID: <53d96ad5.80ywqrbs33ZBCQej%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:50373 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbaG3V7u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Jul 2014 17:59:50 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so349122pab.2
        for <mm-commits@vger.kernel.org>; Wed, 30 Jul 2014 14:59:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@amacapital.net, hpa@zytor.com, mingo@elte.hu, peterz@infradead.org, sfr@canb.auug.org.au, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86, vdso: fix vdso2c's special_pages error checking
has been added to the -mm tree.  Its filename is
     x86-vdso-fix-vdso2cs-special_pages-error-checking.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-vdso-fix-vdso2cs-special_pages-error-checking.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-vdso-fix-vdso2cs-special_pages-error-checking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Lutomirski <luto@amacapital.net>
Subject: x86, vdso: fix vdso2c's special_pages error checking

Stephen Rothwell's compiler did something amazing: it unrolled a loop,
discovered that one iteration of that loop contained an always-true test,
and emitted a warning that will IMO only serve to convince people to
disable the warning.

That bogus warning caused me to wonder what prompted such an absurdity
from his compiler, and I discovered that the code in question was, in
fact, completely wrong -- I was looking things up in the wrong array.

This affects 3.16 as well, but the only effect is to screw up the
error checking a bit.  vdso2c's output is unaffected.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/vdso/vdso2c.h |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN arch/x86/vdso/vdso2c.h~x86-vdso-fix-vdso2cs-special_pages-error-checking arch/x86/vdso/vdso2c.h
--- a/arch/x86/vdso/vdso2c.h~x86-vdso-fix-vdso2cs-special_pages-error-checking
+++ a/arch/x86/vdso/vdso2c.h
@@ -109,16 +109,18 @@ static void BITSFUNC(go)(void *raw_addr,
 
 	/* Validate mapping addresses. */
 	for (i = 0; i < sizeof(special_pages) / sizeof(special_pages[0]); i++) {
-		if (!syms[i])
+		INT_BITS symval = syms[special_pages[i]];
+
+		if (!symval)
 			continue;  /* The mapping isn't used; ignore it. */
 
-		if (syms[i] % 4096)
+		if (symval % 4096)
 			fail("%s must be a multiple of 4096\n",
 			     required_syms[i].name);
-		if (syms[sym_vvar_start] > syms[i] + 4096)
-			fail("%s underruns begin_vvar\n",
+		if (symval + 4096 < syms[sym_vvar_start])
+			fail("%s underruns vvar_start\n",
 			     required_syms[i].name);
-		if (syms[i] + 4096 > 0)
+		if (symval + 4096 > 0)
 			fail("%s is on the wrong side of the vdso text\n",
 			     required_syms[i].name);
 	}
_

Patches currently in -mm which might be from luto@amacapital.net are

linux-next.patch
x86-vdso-fix-vdso2cs-special_pages-error-checking.patch
arm64ia64ppcs390shtileumx86mm-remove-default-gate-area.patch
mm-allow-drivers-to-prevent-new-writable-mappings.patch
shm-add-sealing-api.patch
shm-add-memfd_create-syscall.patch
selftests-add-memfd_create-sealing-tests.patch
selftests-add-memfd-sealing-page-pinning-tests.patch
shm-wait-for-pins-to-be-released-when-sealing.patch
bin2c-move-bin2c-in-scripts-basic.patch
kernel-build-bin2c-based-on-config-option-config_build_bin2c.patch
kexec-rename-unusebale_pages-to-unusable_pages.patch
kexec-move-segment-verification-code-in-a-separate-function.patch
kexec-use-common-function-for-kimage_normal_alloc-and-kimage_crash_alloc.patch
resource-provide-new-functions-to-walk-through-resources.patch
kexec-make-kexec_segment-user-buffer-pointer-a-union.patch
kexec-new-syscall-kexec_file_load-declaration.patch
kexec-implementation-of-new-syscall-kexec_file_load.patch
purgatory-sha256-provide-implementation-of-sha256-in-purgaotory-context.patch
purgatory-core-purgatory-functionality.patch
kexec-load-and-relocate-purgatory-at-kernel-load-time.patch
kexec-load-and-relocate-purgatory-at-kernel-load-time-fix.patch
kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry.patch
kexec-support-for-kexec-on-panic-using-new-system-call.patch
kexec-support-kexec-kdump-on-efi-systems.patch
kexec-verify-the-signature-of-signed-pe-bzimage.patch

