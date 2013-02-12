From: akpm@linux-foundation.org
Subject: + kexec-export-pg_hwpoison-flag-into-vmcoreinfo.patch added to -mm tree
Date: Tue, 12 Feb 2013 14:50:09 -0800
Message-ID: <20130212225009.A80A931C102@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:56470 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab3BLWuM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Feb 2013 17:50:12 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so64241yhr.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Feb 2013 14:50:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mitsuhiro.tanino.gm@hitachi.com, ebiederm@xmission.com, vgoyal@redhat.com


The patch titled
     Subject: kexec: export PG_hwpoison flag into vmcoreinfo
has been added to the -mm tree.  Its filename is
     kexec-export-pg_hwpoison-flag-into-vmcoreinfo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kexec-export-pg_hwpoison-flag-into-vmcoreinfo.patch

