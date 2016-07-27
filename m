From: akpm@linux-foundation.org
Subject: [merged]
 page-flags-relax-policy-for-pg_mappedtodisk-and-pg_reclaim.patch removed
 from -mm tree
Date: Wed, 27 Jul 2016 12:02:42 -0700
Message-ID: <57990552.Itix85JIcBEmbfh5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955AbcG0TCn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:02:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: page-flags: relax policy for PG_mappedtodisk and PG_reclaim
has been removed from the -mm tree.  Its filename was
     page-flags-relax-policy-for-pg_mappedtodisk-and-pg_reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: page-flags: relax policy for PG_mappedtodisk and PG_reclaim

These flags are in use for file THP.

Link: http://lkml.kernel.org/r/1466021202-61880-23-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/page-flags.h~page-flags-relax-policy-for-pg_mappedtodisk-and-pg_reclaim include/linux/page-flags.h
--- a/include/linux/page-flags.h~page-flags-relax-policy-for-pg_mappedtodisk-and-pg_reclaim
+++ a/include/linux/page-flags.h
@@ -295,11 +295,11 @@ PAGEFLAG(OwnerPriv1, owner_priv_1, PF_AN
  */
 TESTPAGEFLAG(Writeback, writeback, PF_NO_COMPOUND)
 	TESTSCFLAG(Writeback, writeback, PF_NO_COMPOUND)
-PAGEFLAG(MappedToDisk, mappedtodisk, PF_NO_COMPOUND)
+PAGEFLAG(MappedToDisk, mappedtodisk, PF_NO_TAIL)
 
 /* PG_readahead is only used for reads; PG_reclaim is only for writes */
-PAGEFLAG(Reclaim, reclaim, PF_NO_COMPOUND)
-	TESTCLEARFLAG(Reclaim, reclaim, PF_NO_COMPOUND)
+PAGEFLAG(Reclaim, reclaim, PF_NO_TAIL)
+	TESTCLEARFLAG(Reclaim, reclaim, PF_NO_TAIL)
 PAGEFLAG(Readahead, reclaim, PF_NO_COMPOUND)
 	TESTCLEARFLAG(Readahead, reclaim, PF_NO_COMPOUND)
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


