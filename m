From: akpm@linux-foundation.org
Subject: [merged] mm-unrig-vma-cache-hit-ratio.patch removed from -mm tree
Date: Mon, 10 Oct 2016 15:43:50 -0700
Message-ID: <57fc19a6.LMfHDxv1xr94mEiG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36644 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752509AbcJJWnu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:43:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, dave@stgolabs.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: unrig VMA cache hit ratio
has been removed from the -mm tree.  Its filename was
     mm-unrig-vma-cache-hit-ratio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
