From: akpm@linux-foundation.org
Subject: [merged] kexec-crash-dont-save-swapper_pg_dir-for-config_mmu-configurations.patch removed from -mm tree
Date: Thu, 29 Mar 2012 12:13:46 -0700
Message-ID: <20120329191346.69D21A01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:61777 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933735Ab2C2TNr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 15:13:47 -0400
Received: by qcsp5 with SMTP id p5so302652qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 12:13:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.deacon@arm.com, ebiederm@xmission.com, horms@verge.net.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: crash: don't save swapper_pg_dir for !CONFIG_MMU configurations
has been removed from the -mm tree.  Its filename was
     kexec-crash-dont-save-swapper_pg_dir-for-config_mmu-configurations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Will Deacon <will.deacon@arm.com>
Subject: kexec: crash: don't save swapper_pg_dir for !CONFIG_MMU configurations

nommu platforms don't have very interesting swapper_pg_dir pointers and
usually just #define them to NULL, meaning that we can't include them in
the vmcoreinfo on the kexec crash path.

This patch only saves the swapper_pg_dir if we have an MMU.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Reviewed-by: Simon Horman <horms@verge.net.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/kexec.c~kexec-crash-dont-save-swapper_pg_dir-for-config_mmu-configurations kernel/kexec.c
--- a/kernel/kexec.c~kexec-crash-dont-save-swapper_pg_dir-for-config_mmu-configurations
+++ a/kernel/kexec.c
@@ -1462,7 +1462,9 @@ static int __init crash_save_vmcoreinfo_
 
 	VMCOREINFO_SYMBOL(init_uts_ns);
 	VMCOREINFO_SYMBOL(node_online_map);
+#ifdef CONFIG_MMU
 	VMCOREINFO_SYMBOL(swapper_pg_dir);
+#endif
 	VMCOREINFO_SYMBOL(_stext);
 	VMCOREINFO_SYMBOL(vmlist);
 
_

Patches currently in -mm which might be from will.deacon@arm.com are

origin.patch
linux-next.patch

