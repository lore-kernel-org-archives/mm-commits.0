Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0749F21CFEF;
	Wed, 13 May 2026 16:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778688939; cv=none; b=jK2BdOIUxnd6O2W3aA3b/wn21yuW+9F0xio/M1J3GTirNOi6WsNvWNxMxmxTlfe9cFeL/2+Z3BVKV8T59/GrcLm5UysqZKP4egi5dEntsKy6bqvlRZ8+0NROBeob5vZbpRVvTLZJIAPMrUp3Dw65D7tGInIlYHKcdf3coeI/Zq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778688939; c=relaxed/simple;
	bh=cbJ7Fk1qRExO3cOO8INYXtIS7c6FE7qJysfC/R0Lb3w=;
	h=Date:To:From:Subject:Message-Id; b=DEmr6SNLQAg735jpFt+sM29DBhIE0RQxuV4oeoxs+5qRGbqWbJFe0UJbadUNF26tZn2I5R6KxqLOXESUM7mgZ0PYLEbQzwi4uX7o5TNLTRzjPtGNFxIJ6NwoU9ed8fm6S6ESyiX+78C1TZihq9jX2Qg4hJuFnGKxVDyl5gMxSs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XB0JlUC/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XB0JlUC/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E79C19425;
	Wed, 13 May 2026 16:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778688938;
	bh=cbJ7Fk1qRExO3cOO8INYXtIS7c6FE7qJysfC/R0Lb3w=;
	h=Date:To:From:Subject:From;
	b=XB0JlUC/K1YLZozoO7wy7uRALGjHDdmtrNEWxBp0LwctI9pANqzSTqE7xbtgFD2zo
	 sVWJmFOX9IyEELLrS0uZTySoFKSv7pinO1LI7fe8/DcEtcnl3H/enx5CiBl/AJlJTX
	 7ABaFRrb3GQoZfAtIpRXL/LW7/i8gTXKHFJgex14=
Date: Wed, 13 May 2026 09:15:37 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,hannes@cmpxchg.org,gourry@gourry.net,dan.j.williams@intel.com,chengming.zhou@linux.dev,contact.kartikn@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] zsmalloc-zero-initialize-zspage-memory-to-prevent-kmsan-uninit-reads.patch removed from -mm tree
Message-Id: <20260513161538.76E79C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zsmalloc: zero-initialize zspage memory to prevent KMSAN uninit reads
has been removed from the -mm tree.  Its filename was
     zsmalloc-zero-initialize-zspage-memory-to-prevent-kmsan-uninit-reads.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Kartik Nair <contact.kartikn@gmail.com>
Subject: zsmalloc: zero-initialize zspage memory to prevent KMSAN uninit reads
Date: Tue, 12 May 2026 03:06:58 +0530

Pages allocated via alloc_zpdesc() use alloc_pages_node() without
__GFP_ZERO, leaving physical memory uninitialized.  When a compressed
object spans two physical pages in a zspage, zs_obj_read_sg_begin() sets
up a scatterlist pointing directly at the raw second page.  If the second
page was freshly allocated and never written beyond the object boundary,
KMSAN detects reads of uninitialized memory downstream in the decompressor
(e.g.  sw842_decompress reading the CRC trailer).

Fix this by passing __GFP_ZERO to alloc_zpdesc() in alloc_zspage() so
all pages backing a zspage are zero-initialized at allocation time.

Link: https://lore.kernel.org/20260511213658.25273-1-contact.kartikn@gmail.com
Fixes: dc2e4982cb018 ("zsmalloc: introduce SG-list based object read API")
Reported-by: syzbot+8f77ff6144a73f0cf71b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8f77ff6144a73f0cf71b
Signed-off-by: Kartik Nair <contact.kartikn@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zsmalloc.c~zsmalloc-zero-initialize-zspage-memory-to-prevent-kmsan-uninit-reads
+++ a/mm/zsmalloc.c
@@ -951,7 +951,7 @@ static struct zspage *alloc_zspage(struc
 	for (i = 0; i < class->pages_per_zspage; i++) {
 		struct zpdesc *zpdesc;
 
-		zpdesc = alloc_zpdesc(gfp, nid);
+		zpdesc = alloc_zpdesc(gfp | __GFP_ZERO, nid);
 		if (!zpdesc) {
 			while (--i >= 0) {
 				zpdesc_dec_zone_page_state(zpdescs[i]);
_

Patches currently in -mm which might be from contact.kartikn@gmail.com are


