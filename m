From: akpm@linux-foundation.org
Subject: [merged]
 maccess-unexport-probe_kernel_write-and-probe_user_write.patch removed from
 -mm tree
Date: Tue, 09 Jun 2020 17:39:50 -0700
Message-ID: <20200610003950.Tm2C5_TPD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726072AbgFJAjv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:39:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net, hch@lst.de, hpa@zytor.com, mhiramat@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, sfr@canb.auug.org.au, tglx@linutronix.de


The patch titled
     Subject: maccess: unexport probe_kernel_write()
has been removed from the -mm tree.  Its filename was
     maccess-unexport-probe_kernel_write-and-probe_user_write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: maccess: unexport probe_kernel_write()

Patch series "clean up and streamline probe_kernel_* and friends", v4.

This series start cleaning up the safe kernel and user memory probing
helpers in mm/maccess.c, and then allows architectures to implement the
kernel probing without overriding the address space limit and temporarily
allowing access to user memory.  It then switches x86 over to this new
mechanism by reusing the unsafe_* uaccess logic.

This version also switches to the saner copy_{from,to}_kernel_nofault
naming suggested by Linus.

I kept the x86 helpers as-is without calling unsage_{get,put}_user as that
avoids a number of hard to trace casts, and it will still work with the
asm-goto based version easily.


This patch (of 20):

probe_kernel_write() is not used by any modular code.

[sfr@canb.auug.org.au: turns out that probe_user_write is used in modular code]
  Link: http://lkml.kernel.org/r/20200602195741.4faaa348@canb.auug.org.au
Link: http://lkml.kernel.org/r/20200521152301.2587579-1-hch@lst.de
Link: http://lkml.kernel.org/r/20200521152301.2587579-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/maccess.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/maccess.c~maccess-unexport-probe_kernel_write-and-probe_user_write
+++ a/mm/maccess.c
@@ -121,7 +121,6 @@ long __probe_kernel_write(void *dst, con
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(probe_kernel_write);
 
 /**
  * probe_user_write(): safely attempt to write to a user-space location
_

Patches currently in -mm which might be from hch@lst.de are

amdgpu-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch
kernel-move-use_mm-unuse_mm-to-kthreadc.patch
kernel-move-use_mm-unuse_mm-to-kthreadc-v2.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract-v2.patch
kernel-set-user_ds-in-kthread_use_mm.patch
