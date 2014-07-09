From: akpm@linux-foundation.org
Subject: + x86-64-fix-vdso-build.patch added to -mm tree
Date: Wed, 09 Jul 2014 15:26:23 -0700
Message-ID: <53bdc18f.hJMsYwlTU3IgN975%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:48547 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbaGIW0Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jul 2014 18:26:24 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so223559obb.2
        for <mm-commits@vger.kernel.org>; Wed, 09 Jul 2014 15:26:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JBeulich@suse.com, boris.ostrovsky@oracle.com, hpa@zytor.com, jbeulich@suse.com, luto@amacapital.net, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86-64: fix vDSO build
has been added to the -mm tree.  Its filename is
     x86-64-fix-vdso-build.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-64-fix-vdso-build.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-64-fix-vdso-build.patch

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
Subject: x86-64: fix vDSO build

Certain ld versions (observed with 2.20.0) put an empty .rela.dyn section
into shared object files, breaking the assumption on the number of
sections to be copied to the final output.  Simply discard any empty
SHT_REL and SHT_RELA sections to address this.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/vdso/vdso2c.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/x86/vdso/vdso2c.h~x86-64-fix-vdso-build arch/x86/vdso/vdso2c.h
--- a/arch/x86/vdso/vdso2c.h~x86-64-fix-vdso-build
+++ a/arch/x86/vdso/vdso2c.h
@@ -93,6 +93,9 @@ static void BITSFUNC(copy_section)(struc
 	uint64_t flags = GET_LE(&in->sh_flags);
 
 	bool copy = flags & SHF_ALLOC &&
+		(GET_LE(&in->sh_size) ||
+		 (GET_LE(&in->sh_type) != SHT_RELA &&
+		  GET_LE(&in->sh_type) != SHT_REL)) &&
 		strcmp(name, ".altinstructions") &&
 		strcmp(name, ".altinstr_replacement");
 
_

Patches currently in -mm which might be from JBeulich@suse.com are

rtc-efi-check-for-invalid-data-coming-back-from-uefi.patch
initramfs-support-initramfs-that-is-bigger-than-2gib.patch
x86-64-fix-vdso-build.patch
ix86-fix-vdso-build.patch

