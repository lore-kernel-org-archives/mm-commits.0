From: akpm@linux-foundation.org
Subject: [merged] nommu-fallback-for-is_vmalloc_or_module_addr-should-be-inline.patch removed from -mm tree
Date: Fri, 25 Sep 2009 12:53:38 -0700
Message-ID: <200909251953.n8PJrcxq003324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084AbZIYTx6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Sep 2009 15:53:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, gerg@snapgear.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     nommu: fallback for is_vmalloc_or_module_addr() should be inline
has been removed from the -mm tree.  Its filename was
     nommu-fallback-for-is_vmalloc_or_module_addr-should-be-inline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: fallback for is_vmalloc_or_module_addr() should be inline
From: David Howells <dhowells@redhat.com>

The NOMMU fallback for is_vmalloc_or_module_addr() should be static inline,
not just static, in linux/mm.h.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mm.h~nommu-fallback-for-is_vmalloc_or_module_addr-should-be-inline include/linux/mm.h
--- a/include/linux/mm.h~nommu-fallback-for-is_vmalloc_or_module_addr-should-be-inline
+++ a/include/linux/mm.h
@@ -288,7 +288,7 @@ static inline int is_vmalloc_addr(const 
 #ifdef CONFIG_MMU
 extern int is_vmalloc_or_module_addr(const void *x);
 #else
-static int is_vmalloc_or_module_addr(const void *x)
+static inline int is_vmalloc_or_module_addr(const void *x)
 {
 	return 0;
 }
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
frv-duplicate-output_buffer-of-e03.patch
mutex-subsystem-synchro-test-module.patch

