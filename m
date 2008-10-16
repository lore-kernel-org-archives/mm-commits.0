From: akpm@linux-foundation.org
Subject: + kdump-add-vmlistaddr-to-vmcoreinfo-for-x86-vmalloc-translation.patch added to -mm tree
Date: Thu, 16 Oct 2008 15:37:25 -0700
Message-ID: <200810162237.m9GMbQ3Y031883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755401AbYJPWh5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 18:37:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oomichi@mxs.nes.nec.co.jp


The patch titled
     kdump: add vmlist.addr to vmcoreinfo for x86 vmalloc translation.
has been added to the -mm tree.  Its filename is
     kdump-add-vmlistaddr-to-vmcoreinfo-for-x86-vmalloc-translation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kdump: add vmlist.addr to vmcoreinfo for x86 vmalloc translation.
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>

Add the symbols 'vmlist' and offset 'vm_struct.addr' to the vmcoreinfo[1]
data for i386 vmalloc translation.

makedumpfile[2] needs VMALLOC_START value for distinguishing a vmalloc
address or not, because it should choose suitable translation method.  If
applying this patch, makedumpfile will be able to take VMALLOC_START value
from 'vmlist.addr'.

vmcoreinfo[1]:
The vmcoreinfo data has the minimum debugging information only for dump
filtering. makedumpfile[2] uses it to distinguish unnecessary pages and
creates a small dumpfile.

makedumpfile[2]:
dump filtering command
https://sourceforge.net/projects/makedumpfile/

Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/kexec.c~kdump-add-vmlistaddr-to-vmcoreinfo-for-x86-vmalloc-translation kernel/kexec.c
--- a/kernel/kexec.c~kdump-add-vmlistaddr-to-vmcoreinfo-for-x86-vmalloc-translation
+++ a/kernel/kexec.c
@@ -1371,6 +1371,7 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_SYMBOL(node_online_map);
 	VMCOREINFO_SYMBOL(swapper_pg_dir);
 	VMCOREINFO_SYMBOL(_stext);
+	VMCOREINFO_SYMBOL(vmlist);
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 	VMCOREINFO_SYMBOL(mem_map);
@@ -1406,6 +1407,7 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_OFFSET(free_area, free_list);
 	VMCOREINFO_OFFSET(list_head, next);
 	VMCOREINFO_OFFSET(list_head, prev);
+	VMCOREINFO_OFFSET(vm_struct, addr);
 	VMCOREINFO_LENGTH(zone.free_area, MAX_ORDER);
 	VMCOREINFO_LENGTH(free_area.free_list, MIGRATE_TYPES);
 	VMCOREINFO_NUMBER(NR_FREE_PAGES);
_

Patches currently in -mm which might be from oomichi@mxs.nes.nec.co.jp are

ia64-fix-the-difference-between-node_mem_map-and-node_start_pfn.patch
kdump-add-vmlistaddr-to-vmcoreinfo-for-x86-vmalloc-translation.patch

