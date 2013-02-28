From: akpm@linux-foundation.org
Subject: [merged] kexec-export-pg_hwpoison-flag-into-vmcoreinfo.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:12:10 -0800
Message-ID: <20130228201210.B6A0F5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:39125 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212Ab3B1UML (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:12:11 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so245002yen.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:12:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mitsuhiro.tanino.gm@hitachi.com, ebiederm@xmission.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: export PG_hwpoison flag into vmcoreinfo
has been removed from the -mm tree.  Its filename was
     kexec-export-pg_hwpoison-flag-into-vmcoreinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
Subject: kexec: export PG_hwpoison flag into vmcoreinfo

This patch exports a PG_hwpoison into vmcoreinfo when
CONFIG_MEMORY_FAILURE is defined.  "makedumpfile" needs to read
information of memory, such as 'mem_section', 'zone', 'pageflags' from
vmcore.

We introduce a function into "makedumpfile" to exclude hwpoison page from
vmcore dump.  In order to introduce this function, PG_hwpoison flag have
to export into vmcoreinfo.

Signed-off-by: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/kexec.c~kexec-export-pg_hwpoison-flag-into-vmcoreinfo kernel/kexec.c
--- a/kernel/kexec.c~kexec-export-pg_hwpoison-flag-into-vmcoreinfo
+++ a/kernel/kexec.c
@@ -1537,6 +1537,9 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_NUMBER(PG_private);
 	VMCOREINFO_NUMBER(PG_swapcache);
 	VMCOREINFO_NUMBER(PG_slab);
+#ifdef CONFIG_MEMORY_FAILURE
+	VMCOREINFO_NUMBER(PG_hwpoison);
+#endif
 	VMCOREINFO_NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE);
 
 	arch_crash_save_vmcoreinfo();
_

Patches currently in -mm which might be from mitsuhiro.tanino.gm@hitachi.com are

origin.patch

