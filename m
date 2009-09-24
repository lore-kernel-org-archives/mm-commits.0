From: akpm@linux-foundation.org
Subject: + nommu-fallback-for-is_vmalloc_or_module_addr-should-be-inline.patch added to -mm tree
Date: Thu, 24 Sep 2009 15:15:08 -0700
Message-ID: <200909242215.n8OMF8WV026289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751677AbZIXWQH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 18:16:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, gerg@snapgear.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     nommu: fallback for is_vmalloc_or_module_addr() should be inline
has been added to the -mm tree.  Its filename is
     nommu-fallback-for-is_vmalloc_or_module_addr-should-be-inline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
procfs-disable-per-task-stack-usage-on-nommu.patch
hugetlb_file_setup-use-c-not-cpp.patch
nommu-fix-map_private-mmap-of-objects-where-the-data-can-be-mapped-directly.patch
frv-flash-mappings-for-the-mb93090-mb00-motherboard.patch
nommu-fallback-for-is_vmalloc_or_module_addr-should-be-inline.patch
nommu-ignore-mmap-address-param-as-it-is-a-hint.patch
frv-duplicate-output_buffer-of-e03.patch
mutex-subsystem-synchro-test-module.patch

