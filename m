From: akpm@linux-foundation.org
Subject: [merged] ksm-fix-m68k-build-only-numa-needs-pfn_to_nid.patch removed from -mm tree
Date: Mon, 11 Mar 2013 13:16:48 -0700
Message-ID: <20130311201648.7B36C31C18B@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:60655 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab3CKUQt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Mar 2013 16:16:49 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so351986qcr.2
        for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2013 13:16:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, geert@linux-m68k.org, pholasek@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: fix m68k build: only NUMA needs pfn_to_nid
has been removed from the -mm tree.  Its filename was
     ksm-fix-m68k-build-only-numa-needs-pfn_to_nid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: ksm: fix m68k build: only NUMA needs pfn_to_nid

A CONFIG_DISCONTIGMEM=y m68k config gave

mm/ksm.c: In function `get_kpfn_nid':
mm/ksm.c:492: error: implicit declaration of function `pfn_to_nid'

linux/mmzone.h declares it for CONFIG_SPARSEMEM and CONFIG_FLATMEM, but
expects the arch's asm/mmzone.h to declare it for CONFIG_DISCONTIGMEM
(see arch/mips/include/asm/mmzone.h for example).

Or perhaps it is only expected when CONFIG_NUMA=y: too much of a maze,
and m68k got away without it so far, so fix the build in mm/ksm.c.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Petr Holasek <pholasek@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/ksm.c~ksm-fix-m68k-build-only-numa-needs-pfn_to_nid mm/ksm.c
--- a/mm/ksm.c~ksm-fix-m68k-build-only-numa-needs-pfn_to_nid
+++ a/mm/ksm.c
@@ -489,7 +489,7 @@ out:		page = NULL;
  */
 static inline int get_kpfn_nid(unsigned long kpfn)
 {
-	return ksm_merge_across_nodes ? 0 : pfn_to_nid(kpfn);
+	return ksm_merge_across_nodes ? 0 : NUMA(pfn_to_nid(kpfn));
 }
 
 static void remove_node_from_stable_tree(struct stable_node *stable_node)
_

Patches currently in -mm which might be from hughd@google.com are

mm-trace-filemap-add-and-del.patch
mm-trace-filemap-add-and-del-v2.patch
mm-shmemc-remove-an-ifdef.patch

