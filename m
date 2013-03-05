From: akpm@linux-foundation.org
Subject: + ksm-fix-m68k-build-only-numa-needs-pfn_to_nid.patch added to -mm tree
Date: Tue, 05 Mar 2013 15:54:39 -0800
Message-ID: <20130305235439.759C531C266@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:54777 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab3CEXyk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 18:54:40 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so421689qaj.5
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 15:54:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, geert@linux-m68k.org, pholasek@redhat.com


The patch titled
     Subject: ksm: fix m68k build: only NUMA needs pfn_to_nid
has been added to the -mm tree.  Its filename is
     ksm-fix-m68k-build-only-numa-needs-pfn_to_nid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Petr Holasek <pholasek@redhat.com
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

mm-mempolicyc-fix-wrong-sp_node-insertion.patch
mm-mempolicyc-fix-sp_node_init-argument-ordering.patch
ksm-fix-m68k-build-only-numa-needs-pfn_to_nid.patch
mm-trace-filemap-add-and-del.patch
mm-shmemc-remove-an-ifdef.patch

