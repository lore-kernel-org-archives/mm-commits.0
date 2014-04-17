From: akpm@linux-foundation.org
Subject: + kexec-save-pg_head_mask-in-vmcoreinfo.patch added to -mm tree
Date: Thu, 17 Apr 2014 14:18:18 -0700
Message-ID: <5350451a.ZNebe8okRoeL8ttB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60259 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaDQVST (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Apr 2014 17:18:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgoyal@redhat.com, shli@kernel.org, sasha.levin@oracle.com, paulus@samba.org, fengguang.wu@intel.com, ebiederm@xmission.com, benh@kernel.crashing.org, aik@ozlabs.ru, ptesarik@suse.cz

Subject: + kexec-save-pg_head_mask-in-vmcoreinfo.patch added to -mm tree
To: ptesarik@suse.cz,aik@ozlabs.ru,benh@kernel.crashing.org,ebiederm@xmission.com,fengguang.wu@intel.com,paulus@samba.org,sasha.levin@oracle.com,shli@kernel.org,vgoyal@redhat.com
From: akpm@linux-foundation.org
Date: Thu, 17 Apr 2014 14:18:18 -0700


The patch titled
     Subject: kexec: save PG_head_mask in VMCOREINFO
has been added to the -mm tree.  Its filename is
     kexec-save-pg_head_mask-in-vmcoreinfo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-save-pg_head_mask-in-vmcoreinfo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-save-pg_head_mask-in-vmcoreinfo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Petr Tesarik <ptesarik@suse.cz>
Subject: kexec: save PG_head_mask in VMCOREINFO

To allow filtering of huge pages, makedumpfile must be able to identify
them in the dump.  This can be done by checking the appropriate page flag,
so communicate its value to makedumpfile through the VMCOREINFO interface.

There's only one small catch.  Depending on how many page flags are
available on a given architecture, this bit can be called PG_head or
PG_compound.

I sent a similar patch back in 2012, but Eric Biederman did not like using
an #ifdef.  So, this time I'm adding a common symbol (PG_head_mask)
instead.

See https://lkml.org/lkml/2012/11/28/91 for the previous version.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Shaohua Li <shli@kernel.org>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    3 +++
 kernel/kexec.c             |    1 +
 2 files changed, 4 insertions(+)

diff -puN include/linux/page-flags.h~kexec-save-pg_head_mask-in-vmcoreinfo include/linux/page-flags.h
--- a/include/linux/page-flags.h~kexec-save-pg_head_mask-in-vmcoreinfo
+++ a/include/linux/page-flags.h
@@ -348,6 +348,9 @@ static inline void ClearPageCompound(str
 	ClearPageHead(page);
 }
 #endif
+
+#define PG_head_mask ((1L << PG_head))
+
 #else
 /*
  * Reduce page flag use as much as possible by overlapping
diff -puN kernel/kexec.c~kexec-save-pg_head_mask-in-vmcoreinfo kernel/kexec.c
--- a/kernel/kexec.c~kexec-save-pg_head_mask-in-vmcoreinfo
+++ a/kernel/kexec.c
@@ -1622,6 +1622,7 @@ static int __init crash_save_vmcoreinfo_
 #ifdef CONFIG_MEMORY_FAILURE
 	VMCOREINFO_NUMBER(PG_hwpoison);
 #endif
+	VMCOREINFO_NUMBER(PG_head_mask);
 	VMCOREINFO_NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE);
 
 	arch_crash_save_vmcoreinfo();
_

Patches currently in -mm which might be from ptesarik@suse.cz are

kexec-save-pg_head_mask-in-vmcoreinfo.patch

