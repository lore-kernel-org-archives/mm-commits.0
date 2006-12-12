From: akpm@osdl.org
Subject: - whinge-in-paging_init-if-noexec-is-on-with-a-non-pae-kernel.patch removed from -mm tree
Date: Tue, 12 Dec 2006 12:39:13 -0800
Message-ID: <200612122039.kBCKdDQT015072@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:39092 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932353AbWLLUjV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 15:39:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kyle@ubuntu.com, ak@suse.de, kyle@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Whinge in paging_init if noexec is on with a non-PAE kernel
has been removed from the -mm tree.  Its filename was
     whinge-in-paging_init-if-noexec-is-on-with-a-non-pae-kernel.patch

This patch was dropped because it is obsolete

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

