From: akpm@linux-foundation.org
Subject: + mm-get_nid_for_pfn-returns-int.patch added to -mm tree
Date: Mon, 26 Jan 2009 22:34:01 -0800
Message-ID: <200901270634.n0R6Y15q024866@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60668 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751213AbZA0GeG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 01:34:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, garyhade@us.ibm.com


The patch titled
     mm: get_nid_for_pfn() returns int
has been added to the -mm tree.  Its filename is
     mm-get_nid_for_pfn-returns-int.patch

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
Subject: mm: get_nid_for_pfn() returns int
From: Roel Kluin <roel.kluin@gmail.com>

get_nid_for_pfn() returns int

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Gary Hade <garyhade@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/node.c~mm-get_nid_for_pfn-returns-int drivers/base/node.c
--- a/drivers/base/node.c~mm-get_nid_for_pfn-returns-int
+++ a/drivers/base/node.c
@@ -303,7 +303,7 @@ int unregister_mem_sect_under_nodes(stru
 	sect_start_pfn = section_nr_to_pfn(mem_blk->phys_index);
 	sect_end_pfn = sect_start_pfn + PAGES_PER_SECTION - 1;
 	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
-		unsigned int nid;
+		int nid;
 
 		nid = get_nid_for_pfn(pfn);
 		if (nid < 0)
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
paride-pgc-xs-confusion.patch
mm-get_nid_for_pfn-returns-int.patch
ufs-sector_t-cannot-be-negative.patch

