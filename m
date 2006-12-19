From: akpm@osdl.org
Subject: + ia64-alignment-bug-in-ldscript.patch added to -mm tree
Date: Mon, 18 Dec 2006 16:31:32 -0800
Message-ID: <200612190031.kBJ0VWjs017885@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35482 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932488AbWLSAcH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Dec 2006 19:32:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dev@openvz.org, kenneth.w.chen@intel.com, kuznet@ms2.inr.ac.ru, tony.luck@intel.com


The patch titled
     IA64: alignment bug in ldscript
has been added to the -mm tree.  Its filename is
     ia64-alignment-bug-in-ldscript.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/ia64/kernel/vmlinux.lds.S |    1 +
 1 files changed, 1 insertion(+)

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

ia64-alignment-bug-in-ldscript.patch

