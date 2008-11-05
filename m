From: akpm@linux-foundation.org
Subject: - kexec-i386-remove-page_size-alignment-from-relocate_kernel.patch removed from -mm tree
Date: Wed, 05 Nov 2008 11:26:31 -0800
Message-ID: <200811051926.mA5JQVsa010184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49586 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753242AbYKET1M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Nov 2008 14:27:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, Ian.Campbell@citrix.com, ebiederm@xmission.com, horms@verge.net.au, magnus.damm@gmail.com, mingo@elte.hu, tglx@linutronix.de, vgoyal@redhat.com, mm-commits@vger.


The patch titled
     kexec/i386: remove PAGE_SIZE alignment from relocate_kernel
has been removed from the -mm tree.  Its filename was
     kexec-i386-remove-page_size-alignment-from-relocate_kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec/i386: remove PAGE_SIZE alignment from relocate_kernel
From: Huang Ying <ying.huang@intel.com>

Remove the PAGE_SIZE alignment from relocate_kernel().  Before kexec jump
patches are merged, control page is mapped to relocate_kernel in kexec
page tables, so relocate_kernel must be PAGE_SIZE aligned.  Now, control
page is mapped to identity mapped address, so relocate_kernel need not to
be PAGE_SIZE aligned any more.  This can reduce a few KB from kernel text
segement.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Reviewed-by: Simon Horman <horms@verge.net.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com> 
Cc: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/relocate_kernel_32.S |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/x86/kernel/relocate_kernel_32.S~kexec-i386-remove-page_size-alignment-from-relocate_kernel arch/x86/kernel/relocate_kernel_32.S
--- a/arch/x86/kernel/relocate_kernel_32.S~kexec-i386-remove-page_size-alignment-from-relocate_kernel
+++ a/arch/x86/kernel/relocate_kernel_32.S
@@ -39,7 +39,6 @@
 #define CP_PA_BACKUP_PAGES_MAP	DATA(0x1c)
 
 	.text
-	.align PAGE_SIZE
 	.globl relocate_kernel
 relocate_kernel:
 	/* Save the CPU context, used for jumping back */
_

Patches currently in -mm which might be from ying.huang@intel.com are

linux-next.patch
atomic_t-unify-all-arch-definitions.patch

