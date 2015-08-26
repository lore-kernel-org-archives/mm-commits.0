From: akpm@linux-foundation.org
Subject: +
 mm-check-if-section-present-during-memory-block-unregistering-v2.patch
 added to -mm tree
Date: Wed, 26 Aug 2015 13:48:07 -0700
Message-ID: <55de2607.gffFhhGBGIT9JpSl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbbHZUsI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Aug 2015 16:48:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, greg@kroah.com, mingo@kernel.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: Check if section present during memory block (un)registering
has been added to the -mm tree.  Its filename is
     mm-check-if-section-present-during-memory-block-unregistering-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-check-if-section-present-during-memory-block-unregistering-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-check-if-section-present-during-memory-block-unregistering-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-check-if-section-present-during-memory-block-unregistering.patch
mm-check-if-section-present-during-memory-block-unregistering-v2.patch
lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel.patch
lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2.patch

