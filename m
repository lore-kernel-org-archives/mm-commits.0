From: akpm@linux-foundation.org
Subject: - mm-sparsec-improve-the-error-handling-for-sparse_add_one_section-fix.patch removed from -mm tree
Date: Thu, 13 Dec 2007 15:49:58 -0800
Message-ID: <200712132349.lBDNnwGA024689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35700 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753017AbXLMXvu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Dec 2007 18:51:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geoffrey.levand@am.sony.com, apw@shadowen.org, clameter@sgi.com, haveblue@us.ibm.com, riel@redhat.com, xiyou.wangcong@gmail.com, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     sparsemem: fix sparse_index_init return check
has been removed from the -mm tree.  Its filename was
     mm-sparsec-improve-the-error-handling-for-sparse_add_one_section-fix.patch

This patch was dropped because it was folded into mm-sparsec-improve-the-error-handling-for-sparse_add_one_section.patch

------------------------------------------------------
Subject: sparsemem: fix sparse_index_init return check
From: Geoff Levand <geoffrey.levand@am.sony.com>

sparse_index_init() returns -EEXIST to indicate the index has already been
created.  Exclude this from the error check on the return value.

Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/sparse.c~mm-sparsec-improve-the-error-handling-for-sparse_add_one_section-fix mm/sparse.c
--- a/mm/sparse.c~mm-sparsec-improve-the-error-handling-for-sparse_add_one_section-fix
+++ a/mm/sparse.c
@@ -384,7 +384,7 @@ int sparse_add_one_section(struct zone *
 	 * plus, it does a kmalloc
 	 */
 	ret = sparse_index_init(section_nr, pgdat->node_id);
-	if (ret < 0)
+	if (ret < 0 && ret != -EEXIST)
 		return ret;
 	memmap = kmalloc_section_memmap(section_nr, pgdat->node_id, nr_pages);
 	if (!memmap)
_

Patches currently in -mm which might be from geoffrey.levand@am.sony.com are

sparsemem-make-sparsemem_vmemmap-selectable.patch
mm-sparsec-improve-the-error-handling-for-sparse_add_one_section.patch
mm-sparsec-improve-the-error-handling-for-sparse_add_one_section-fix.patch
git-powerpc.patch
