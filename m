From: akpm@osdl.org
Subject: + whinge-in-paging_init-if-noexec-is-on-with-a-non-pae-kernel.patch added to -mm tree
Date: Mon, 11 Dec 2006 16:47:28 -0800
Message-ID: <200612120047.kBC0lSpV014614@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54972 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbWLLArl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 19:47:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyle@ubuntu.com, ak@suse.de, kyle@canonical.com


The patch titled
     Whinge in paging_init if noexec is on with a non-PAE kernel
has been added to the -mm tree.  Its filename is
     whinge-in-paging_init-if-noexec-is-on-with-a-non-pae-kernel.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Whinge in paging_init if noexec is on with a non-PAE kernel
From: Kyle McMartin <kyle@ubuntu.com>

Signed-off-by: Kyle McMartin <kyle@canonical.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/mm/init.c |    3 +++
 1 files changed, 3 insertions(+)

diff -puN arch/i386/mm/init.c~whinge-in-paging_init-if-noexec-is-on-with-a-non-pae-kernel arch/i386/mm/init.c
--- a/arch/i386/mm/init.c~whinge-in-paging_init-if-noexec-is-on-with-a-non-pae-kernel
+++ a/arch/i386/mm/init.c
@@ -512,6 +512,9 @@ void __init paging_init(void)
 	set_nx();
 	if (nx_enabled)
 		printk("NX (Execute Disable) protection: active\n");
+#else
+	if (!disable_nx)
+		printk("NX (Execute Disable) only supported with CONFIG_HIGHMEM64G\n");
 #endif
 
 	pagetable_init();
_

Patches currently in -mm which might be from kyle@ubuntu.com are

whinge-in-paging_init-if-noexec-is-on-with-a-non-pae-kernel.patch

