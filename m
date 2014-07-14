From: akpm@linux-foundation.org
Subject: [merged] x86-64-fix-vdso-build.patch removed from -mm tree
Date: Mon, 14 Jul 2014 11:50:04 -0700
Message-ID: <53c4265c.SFICL1iT5xEt/oKQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:32944 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492AbaGNSuG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jul 2014 14:50:06 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so778367pab.2
        for <mm-commits@vger.kernel.org>; Mon, 14 Jul 2014 11:50:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JBeulich@suse.com, boris.ostrovsky@oracle.com, hpa@zytor.com, jbeulich@suse.com, luto@amacapital.net, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86-64: fix vDSO build
has been removed from the -mm tree.  Its filename was
     x86-64-fix-vdso-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

