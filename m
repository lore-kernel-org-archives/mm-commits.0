From: akpm@linux-foundation.org
Subject: + mm-unrig-vma-cache-hit-ratio.patch added to -mm tree
Date: Mon, 22 Aug 2016 16:06:05 -0700
Message-ID: <57bb855d.viL/LVZuC1iy+tLO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56379 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754721AbcHVXGG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2016 19:06:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, dave@stgolabs.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: unrig VMA cache hit ratio
has been added to the -mm tree.  Its filename is
     mm-unrig-vma-cache-hit-ratio.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-unrig-vma-cache-hit-ratio.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-unrig-vma-cache-hit-ratio.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: mm: unrig VMA cache hit ratio

Current code doesn't count first FIND operation after VMA cache flush
(which happen surprisingly often) artificially increasing cache hit ratio.

On my regular setup the difference is:

		Before				After
	==========================================================

	* boot, login into KDE

	vmacache_find_calls 446216	vmacache_find_calls 492741
	vmacache_find_hits 277596	vmacache_find_hits 276096

		~62.2%				~56.0%

	* rebuild kernel (no changes to code, usual config)

	vmacache_find_calls 1943007	vmacache_find_calls 2083718
	vmacache_find_hits 1246123	vmacache_find_hits 1244146

		~64.1%				~59.7%

	* rebuild kernel (full rebuild, usual config)

	vmacache_find_calls 32163155	vmacache_find_calls 33677183
	vmacache_find_hits 27889956	vmacache_find_hits 27877591

		~88.2%				~84.3%

Total: ~4% cache hit ratio.

If someone is counting _relative_ cache _miss_ ratio, misreporting is much
higher.

Link: http://lkml.kernel.org/r/20160822225009.GA3934@p183.telecom.by
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmacache.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/vmacache.c~mm-unrig-vma-cache-hit-ratio mm/vmacache.c
--- a/mm/vmacache.c~mm-unrig-vma-cache-hit-ratio
+++ a/mm/vmacache.c
@@ -87,11 +87,11 @@ struct vm_area_struct *vmacache_find(str
 {
 	int i;
 
+	count_vm_vmacache_event(VMACACHE_FIND_CALLS);
+
 	if (!vmacache_valid(mm))
 		return NULL;
 
-	count_vm_vmacache_event(VMACACHE_FIND_CALLS);
-
 	for (i = 0; i < VMACACHE_SIZE; i++) {
 		struct vm_area_struct *vma = current->vmacache[i];
 
@@ -115,11 +115,11 @@ struct vm_area_struct *vmacache_find_exa
 {
 	int i;
 
+	count_vm_vmacache_event(VMACACHE_FIND_CALLS);
+
 	if (!vmacache_valid(mm))
 		return NULL;
 
-	count_vm_vmacache_event(VMACACHE_FIND_CALLS);
