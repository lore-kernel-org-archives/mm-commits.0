From: akpm@linux-foundation.org
Subject: + ix86-fix-vdso-build.patch added to -mm tree
Date: Wed, 09 Jul 2014 15:26:24 -0700
Message-ID: <53bdc190.gCcYuPpf21wykaRa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:64356 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaGIW0Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jul 2014 18:26:25 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so1794696pab.5
        for <mm-commits@vger.kernel.org>; Wed, 09 Jul 2014 15:26:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JBeulich@suse.com, boris.ostrovsky@oracle.com, hpa@zytor.com, jbeulich@suse.com, luto@amacapital.net, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ix86: fix vDSO build
has been added to the -mm tree.  Its filename is
     ix86-fix-vdso-build.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ix86-fix-vdso-build.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ix86-fix-vdso-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Jan Beulich" <JBeulich@suse.com>
Subject: ix86: fix vDSO build

Relying on static functions used just once to get inlined (and
subsequently have dead code paths eliminated) is wrong: Compilers are free
to decide whether they do this, regardless of optimization level.  With
this not happening for vdso_addr() (observed with gcc 4.1.x), an
unresolved reference to align_vdso_addr() causes the build to fail.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/vdso/vma.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/x86/vdso/vma.c~ix86-fix-vdso-build arch/x86/vdso/vma.c
--- a/arch/x86/vdso/vma.c~ix86-fix-vdso-build
+++ a/arch/x86/vdso/vma.c
@@ -62,6 +62,9 @@ struct linux_binprm;
    Only used for the 64-bit and x32 vdsos. */
 static unsigned long vdso_addr(unsigned long start, unsigned len)
 {
+#ifdef CONFIG_X86_32
+	return 0;
+#else
 	unsigned long addr, end;
 	unsigned offset;
 	end = (start + PMD_SIZE - 1) & PMD_MASK;
@@ -83,6 +86,7 @@ static unsigned long vdso_addr(unsigned
 	addr = align_vdso_addr(addr);
 
 	return addr;
+#endif
 }
 
 static int map_vdso(const struct vdso_image *image, bool calculate_addr)
_

Patches currently in -mm which might be from JBeulich@suse.com are

rtc-efi-check-for-invalid-data-coming-back-from-uefi.patch
initramfs-support-initramfs-that-is-bigger-than-2gib.patch
x86-64-fix-vdso-build.patch
ix86-fix-vdso-build.patch

