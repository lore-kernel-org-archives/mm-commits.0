From: akpm@linux-foundation.org
Subject: - doc-update-xip-method-info.patch removed from -mm tree
Date: Thu, 13 Nov 2008 13:27:02 -0800
Message-ID: <200811132127.mADLR2I8027701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752827AbYKMV1T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 16:27:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marco.stornelli@gmail.com, cotte@de.ibm.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     DOC: update xip method info
has been removed from the -mm tree.  Its filename was
     doc-update-xip-method-info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: DOC: update xip method info
From: Marco Stornelli <marco.stornelli@gmail.com>

xip documentation updated:
- change "get_xip_page" to "get_xip_mem";
- explain changed function parameters

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/xip.txt |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN Documentation/filesystems/xip.txt~doc-update-xip-method-info Documentation/filesystems/xip.txt
--- a/Documentation/filesystems/xip.txt~doc-update-xip-method-info
+++ a/Documentation/filesystems/xip.txt
@@ -39,10 +39,11 @@ The block device operation is optional, 
 today:
 - dcssblk: s390 dcss block device driver
 
-An address space operation named get_xip_page is used to retrieve reference
-to a struct page. To address the target page, a reference to an address_space,
-and a sector number is provided. A 3rd argument indicates whether the
-function should allocate blocks if needed.
+An address space operation named get_xip_mem is used to retrieve references
+to a page frame number and a kernel address. To obtain these values a reference
+to an address_space is provided. This function assigns values to the kmem and
+pfn parameters. The third argument indicates whether the function should allocate
+blocks if needed.
 
 This address space operation is mutually exclusive with readpage&writepage that
 do page cache read/write operations.
_

Patches currently in -mm which might be from marco.stornelli@gmail.com are

origin.patch

