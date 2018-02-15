From: akpm@linux-foundation.org
Subject: +
 x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory-v4.patch added to -mm tree
Date: Thu, 15 Feb 2018 14:46:16 -0800
Message-ID: <5a860db8.GgP91vxRKYgfERNd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41818 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756359AbeBOWq7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Feb 2018 17:46:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pasha.tatashin@oracle.com, mhocko@suse.com, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory-v4
has been added to the -mm tree.  Its filename is
     x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory-v4

Addressed comments from Ingo Molnar and from Michal Hocko
Splitted 4th patch into three patches
Instead of using section table to save node ids, saving node id in
the first page of every section.
				
Link: http://lkml.kernel.org/r/20180215165920.8570-3-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/mm/init_64.c~x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory-v4 arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory-v4
+++ a/arch/x86/mm/init_64.c
@@ -1327,8 +1327,8 @@ int kern_addr_valid(unsigned long addr)
 }
 
 /*
- * Block size is the minimum quantum of memory which can be hot-plugged or
- * hot-removed. It must be power of two, and must be equal or larger than
+ * Block size is the minimum amount of memory which can be hotplugged or
+ * hotremoved. It must be power of two and must be equal or larger than
  * MIN_MEMORY_BLOCK_SIZE.
  */
 #define MAX_BLOCK_SIZE (2UL << 30)
_

Patches currently in -mm which might be from pasha.tatashin@oracle.com are

mm-initialize-pages-on-demand-during-boot.patch
mm-initialize-pages-on-demand-during-boot-fix-3.patch
mm-memory_hotplug-enforce-block-size-aligned-range-check.patch
x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory.patch
x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory-v4.patch
mm-uninitialized-struct-page-poisoning-sanity-checking.patch
mm-uninitialized-struct-page-poisoning-sanity-checking-v4.patch
mm-memory_hotplug-optimize-probe-routine.patch
mm-memory_hotplug-dont-read-nid-from-struct-page-during-hotplug.patch
mm-memory_hotplug-optimize-memory-hotplug.patch
sparc64-ng4-memset-32-bits-overflow.patch

