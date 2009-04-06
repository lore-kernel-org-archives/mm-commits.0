From: akpm@linux-foundation.org
Subject: [merged] sgi-gru-exclude-uv-definitions-on-32-bit-x86.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:37:15 -0700
Message-ID: <200904061937.n36JbF32012835@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752518AbZDFTpU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:45:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     sgi-gru: exclude UV definitions on 32-bit x86
has been removed from the -mm tree.  Its filename was
     sgi-gru-exclude-uv-definitions-on-32-bit-x86.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-gru: exclude UV definitions on 32-bit x86
From: Jack Steiner <steiner@sgi.com>

Eliminate compile errors on 32-bit X86 caused by UV.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/uv/uv_hub.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/x86/include/asm/uv/uv_hub.h~sgi-gru-exclude-uv-definitions-on-32-bit-x86 arch/x86/include/asm/uv/uv_hub.h
--- a/arch/x86/include/asm/uv/uv_hub.h~sgi-gru-exclude-uv-definitions-on-32-bit-x86
+++ a/arch/x86/include/asm/uv/uv_hub.h
@@ -11,6 +11,7 @@
 #ifndef _ASM_X86_UV_UV_HUB_H
 #define _ASM_X86_UV_UV_HUB_H
 
+#ifdef CONFIG_X86_64
 #include <linux/numa.h>
 #include <linux/percpu.h>
 #include <linux/timer.h>
@@ -405,4 +406,5 @@ static inline void uv_set_cpu_scir_bits(
 	}
 }
 
+#endif /* CONFIG_X86_64 */
 #endif /* _ASM_X86_UV_UV_HUB_H */
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

