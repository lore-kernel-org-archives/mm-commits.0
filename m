From: akpm@linux-foundation.org
Subject: + zbud-add-to-mm-init-under_reclaim.patch added to -mm tree
Date: Thu, 13 Jun 2013 12:25:03 -0700
Message-ID: <51ba1c8f.EesvsSQ4XHYyea6m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37306 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab3FMTZE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jun 2013 15:25:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, bob.liu@oracle.com, sjenning@linux.vnet.ibm.com

Subject: + zbud-add-to-mm-init-under_reclaim.patch added to -mm tree
To: sjenning@linux.vnet.ibm.com,bob.liu@oracle.com
From: akpm@linux-foundation.org
Date: Thu, 13 Jun 2013 12:25:03 -0700


The patch titled
     Subject: zswap: init under_reclaim
has been added to the -mm tree.  Its filename is
     zbud-add-to-mm-init-under_reclaim.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: zswap: init under_reclaim

Bob Liu reported a memory leak in zswap.  This was due to the
under_reclaim field in the zbud header not being initialized
to 0, which resulted in zbud_free() not freeing the page
under the false assumption that the page was undergoing
zbud reclaim.

This patch properly initializes the under_reclaim field.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Reported-by: Bob Liu <bob.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zbud.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/zbud.c~zbud-add-to-mm-init-under_reclaim mm/zbud.c
--- a/mm/zbud.c~zbud-add-to-mm-init-under_reclaim
+++ a/mm/zbud.c
@@ -138,6 +138,7 @@ static struct zbud_header *init_zbud_pag
 	zhdr->last_chunks = 0;
 	INIT_LIST_HEAD(&zhdr->buddy);
 	INIT_LIST_HEAD(&zhdr->lru);
+	zhdr->under_reclaim = 0;
 	return zhdr;
 }
 
_

Patches currently in -mm which might be from sjenning@linux.vnet.ibm.com are

linux-next.patch
mm-remove-compressed-copy-from-zram-in-memory.patch
mm-remove-compressed-copy-from-zram-in-memory-fix.patch
mm-remove-compressed-copy-from-zram-in-memory-fix-2.patch
mm-remove-compressed-copy-from-zram-in-memory-fix-2-fix.patch
zbud-add-to-mm.patch
zbud-add-to-mm-init-under_reclaim.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch

