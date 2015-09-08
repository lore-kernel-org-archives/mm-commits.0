From: akpm@linux-foundation.org
Subject: [folded-merged]
 zswap-update-docs-for-runtime-changeable-attributes-v2.patch removed from
 -mm tree
Date: Tue, 08 Sep 2015 14:47:46 -0700
Message-ID: <55ef5782.kp4aWx41KjmkvOgf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53592 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbbIHVrr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 17:47:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, sergey.senozhatsky.work@gmail.com, sjennings@variantweb.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: zswap: update docs for runtime-changeable attributes
has been removed from the -mm tree.  Its filename was
     zswap-update-docs-for-runtime-changeable-attributes-v2.patch

This patch was dropped because it was folded into zswap-update-docs-for-runtime-changeable-attributes.patch

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: zswap: update docs for runtime-changeable attributes

changes since v1:
  update doc on working of zbud per Vlastimil Babka's suggestion
  add explanation of how old pages are handled when changing zpool/compressor

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/zswap.txt |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff -puN Documentation/vm/zswap.txt~zswap-update-docs-for-runtime-changeable-attributes-v2 Documentation/vm/zswap.txt
--- a/Documentation/vm/zswap.txt~zswap-update-docs-for-runtime-changeable-attributes-v2
+++ a/Documentation/vm/zswap.txt
@@ -61,12 +61,11 @@ sysfs "zpool" attribute, e.g.
 echo zbud > /sys/module/zswap/parameters/zpool
 
 The zbud type zpool allocates exactly 1 page to store 2 compressed pages, which
-means the compression ratio will always be exactly 2:1 (not including half-full
-zbud pages), and any page that compresses to more than 1/2 page in size will be
-rejected (and written to the swap disk).  The zsmalloc type zpool has a more
-complex compressed page storage method, and it can achieve greater storage
-densities.  However, zsmalloc does not implement compressed page eviction, so
-once zswap fills it cannot evict the oldest page, it can only reject new pages.
+means the compression ratio will always be 2:1 or worse (because of half-full
+zbud pages).  The zsmalloc type zpool has a more complex compressed page
+storage method, and it can achieve greater storage densities.  However,
+zsmalloc does not implement compressed page eviction, so once zswap fills it
+cannot evict the oldest page, it can only reject new pages.
 
 When a swap page is passed from frontswap to zswap, zswap maintains a mapping
 of the swap entry, a combination of the swap type and swap offset, to the zpool
@@ -93,5 +92,11 @@ at runtime using the sysfs "compressor"
 
 echo lzo > /sys/module/zswap/parameters/compressor
 
+When the zpool and/or compressor parameter is changed at runtime, any existing
+compressed pages are not modified; they are left in their own zpool.  When a
+request is made for a page in an old zpool, it is uncompressed using its
+original compressor.  Once all pages are removed from an old zpool, the zpool
+and its compressor are freed.
+
 A debugfs interface is provided for various statistic about pool size, number
 of pages stored, and various counters for the reasons pages are rejected.
_

Patches currently in -mm which might be from ddstreet@ieee.org are

zpool-add-zpool_has_pool.patch
zswap-dynamic-pool-creation.patch
zswap-change-zpool-compressor-at-runtime.patch
zswap-update-docs-for-runtime-changeable-attributes.patch
zpool-remove-no-op-module-init-exit.patch

