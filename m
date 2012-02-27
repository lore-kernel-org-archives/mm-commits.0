From: akpm@linux-foundation.org
Subject: + kexec-crash-dont-save-swapper_pg_dir-for-config_mmu-configurations.patch added to -mm tree
Date: Mon, 27 Feb 2012 15:57:45 -0800
Message-ID: <20120227235745.9FE5FA00B3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vw0-f74.google.com ([209.85.212.74]:51823 "EHLO
	mail-vw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab2B0X5q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2012 18:57:46 -0500
Received: by vbnl22 with SMTP id l22so332704vbn.1
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2012 15:57:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: will.deacon@arm.com, ebiederm@xmission.com, horms@verge.net.au


The patch titled
     Subject: kexec: crash: don't save swapper_pg_dir for !CONFIG_MMU configurations
has been added to the -mm tree.  Its filename is
     kexec-crash-dont-save-swapper_pg_dir-for-config_mmu-configurations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: kexec: crash: don't save swapper_pg_dir for !CONFIG_MMU configurations

Patches currently in -mm which might be from will.deacon@arm.com are

linux-next.patch
arm-use-set_current_blocked-and-block_sigmask.patch
kexec-crash-dont-save-swapper_pg_dir-for-config_mmu-configurations.patch

