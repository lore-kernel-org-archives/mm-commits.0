From: akpm@linux-foundation.org
Subject: [patch 037/127] mm: unrig VMA cache hit ratio
Date: Fri, 07 Oct 2016 16:58:39 -0700
Message-ID: <57f836af.FOarN5jFQQAB03oG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39007 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932726AbcJGX6k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:58:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, adobriyan@gmail.com, dave@stgolabs.net

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
