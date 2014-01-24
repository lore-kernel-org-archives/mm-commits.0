From: akpm@linux-foundation.org
Subject: [merged]
 logfs-check-for-the-return-value-after-calling-find_or_create_page.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 10:59:59 -0800
Message-ID: <52e2b82f.iaO4Orj68oR54uJY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXTAA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:00:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, younger.liucn@gmail.com, slava@dubeyko.com, prasadjoshi.linux@gmail.com, joern@logfs.org, liuyiyang@hisense.com

Subject: [merged] logfs-check-for-the-return-value-after-calling-find_or_create_page.patch removed from -mm tree
To: liuyiyang@hisense.com,joern@logfs.org,prasadjoshi.linux@gmail.com,slava@dubeyko.com,younger.liucn@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:59:59 -0800


The patch titled
     Subject: logfs: check for the return value after calling find_or_create_page()
has been removed from the -mm tree.  Its filename was
     logfs-check-for-the-return-value-after-calling-find_or_create_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Younger Liu <liuyiyang@hisense.com>
Subject: logfs: check for the return value after calling find_or_create_page()

In get_mapping_page(), after calling find_or_create_page(), the return
value should be checked.

 This patch has been provided:
http://www.spinics.net/lists/linux-fsdevel/msg66948.html but not been
applied now.

Signed-off-by: Younger Liu <liuyiyang@hisense.com>
Cc: Younger Liu <younger.liucn@gmail.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Reviewed-by: Prasad Joshi <prasadjoshi.linux@gmail.com>
Cc: Jörn Engel <joern@logfs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/logfs/segment.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/logfs/segment.c~logfs-check-for-the-return-value-after-calling-find_or_create_page fs/logfs/segment.c
--- a/fs/logfs/segment.c~logfs-check-for-the-return-value-after-calling-find_or_create_page
+++ a/fs/logfs/segment.c
@@ -62,7 +62,8 @@ static struct page *get_mapping_page(str
 		page = read_cache_page(mapping, index, filler, sb);
 	else {
 		page = find_or_create_page(mapping, index, GFP_NOFS);
-		unlock_page(page);
+		if (page)
+			unlock_page(page);
 	}
 	return page;
 }
_

Patches currently in -mm which might be from liuyiyang@hisense.com are

origin.patch

