From: akpm@linux-foundation.org
Subject: [patch 141/142] mm: fix <linux/pagemap.h> stray kernel-doc
 notation
Date: Wed, 22 Feb 2017 15:46:48 -0800
Message-ID: <58ae22e8.VrpMipm9U563x3/D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49816 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933791AbdBVXqt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:46:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rdunlap@infradead.org, mawilcox@microsoft.com, mgorman@suse.de

From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm: fix <linux/pagemap.h> stray kernel-doc notation

Delete stray (second) function description in find_lock_page() kernel-doc
notation.

Note: scripts/kernel-doc just ignores the second function description.

Fixes: 2457aec63745e ("mm: non-atomically mark page accessed during page cache allocation where possible")
Link: http://lkml.kernel.org/r/b037e9a3-516c-ec02-6c8e-fa5479747ba6@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/pagemap.h~mm-fix-linux-pagemaph-stray-kernel-doc-notation include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-fix-linux-pagemaph-stray-kernel-doc-notation
+++ a/include/linux/pagemap.h
@@ -266,7 +266,6 @@ static inline struct page *find_get_page
 
 /**
  * find_lock_page - locate, pin and lock a pagecache page
- * pagecache_get_page - find and get a page reference
  * @mapping: the address_space to search
  * @offset: the page index
  *
_
