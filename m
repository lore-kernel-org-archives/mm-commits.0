From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 72/93] maccess: unexport probe_kernel_write()
Date: Mon, 08 Jun 2020 21:33:58 -0700
Message-ID: <20200609043358.kHEutRZ0V%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbgFIEeA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:34:00 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ast@kernel.org, daniel@iogearbox.net, hch@lst.de, hpa@zytor.com, linux-mm@kvack.org, mhiramat@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, sfr@canb.auug.org.au, tglx@linutronix.de, torvalds@linux-foundation.org

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
