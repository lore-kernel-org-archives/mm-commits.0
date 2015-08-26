From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-check-if-section-present-during-memory-block-unregistering-v2.patch
 removed from -mm tree
Date: Wed, 26 Aug 2015 14:06:21 -0700
Message-ID: <55de2a4d.4KCk4YoS+RrYCOuW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42190 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbbHZVGW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Aug 2015 17:06:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, greg@kroah.com, mingo@kernel.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: Check if section present during memory block (un)registering
has been removed from the -mm tree.  Its filename was
     mm-check-if-section-present-during-memory-block-unregistering-v2.patch

This patch was dropped because it was folded into ocfs2-direct-write-will-call-ocfs2_rw_unlock-twice-when-doing-aiodio.patch

------------------------------------------------------
From: Yinghai Lu <yinghai@kernel.org>
Subject: mm: Check if section present during memory block (un)registering

-v2: add fixes and comment.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/base/node.c~mm-check-if-section-present-during-memory-block-unregistering-v2 drivers/base/node.c
--- a/drivers/base/node.c~mm-check-if-section-present-during-memory-block-unregistering-v2
+++ a/drivers/base/node.c
@@ -392,12 +392,17 @@ int register_mem_sect_under_node(struct
 	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
 		int page_nid, scn_nr;
 
+		/*
+		 * memory block could have several absent sections from start.
+		 * skip pfn range from absent section
+		 */
 		scn_nr = pfn_to_section_nr(pfn);
 		if (!present_section_nr(scn_nr)) {
 			pfn = round_down(pfn + PAGES_PER_SECTION,
 					 PAGES_PER_SECTION) - 1;
 			continue;
 		}
+
 		page_nid = get_nid_for_pfn(pfn);
 		if (page_nid < 0)
 			continue;
@@ -438,6 +443,10 @@ int unregister_mem_sect_under_nodes(stru
 	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
 		int nid, scn_nr;
 
+		/*
+		 * memory block could have several absent sections from start.
+		 * skip pfn range from absent section
+		 */
 		scn_nr = pfn_to_section_nr(pfn);
 		if (!present_section_nr(scn_nr)) {
 			pfn = round_down(pfn + PAGES_PER_SECTION,
_

Patches currently in -mm which might be from yinghai@kernel.org are

ocfs2-direct-write-will-call-ocfs2_rw_unlock-twice-when-doing-aiodio.patch
lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel.patch
lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2.patch

