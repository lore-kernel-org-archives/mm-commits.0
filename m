From: akpm@linux-foundation.org
Subject: - ia64-alignment-bug-in-ldscript.patch removed from -mm tree
Date: Wed, 07 Feb 2007 11:51:44 -0800
Message-ID: <200702071951.l17JpiMV025184@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33609 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422742AbXBGTw3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 14:52:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dev@openvz.org, kenneth.w.chen@intel.com, kuznet@ms2.inr.ac.ru, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     IA64: alignment bug in ldscript
has been removed from the -mm tree.  Its filename was
     ia64-alignment-bug-in-ldscript.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: IA64: alignment bug in ldscript
From: Kirill Korotaev <dev@openvz.org>

Occasionally the FSYS_RETURN patch list can have an odd length, causing other
data structures to get out of alignment.  In OpenVZ it is odd and we get
misaligned kernel image, which does not boot.

Signed-off-by: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Signed-off-by: Kirill Korotaev <dev@openvz.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/vmlinux.lds.S |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/ia64/kernel/vmlinux.lds.S~ia64-alignment-bug-in-ldscript arch/ia64/kernel/vmlinux.lds.S
--- a/arch/ia64/kernel/vmlinux.lds.S~ia64-alignment-bug-in-ldscript
+++ a/arch/ia64/kernel/vmlinux.lds.S
@@ -157,6 +157,7 @@ SECTIONS
 	}
 #endif
 
+  . = ALIGN(8);
    __con_initcall_start = .;
   .con_initcall.init : AT(ADDR(.con_initcall.init) - LOAD_OFFSET)
 	{ *(.con_initcall.init) }
_

Patches currently in -mm which might be from dev@openvz.org are

origin.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
