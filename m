Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DDB1CFAE
	for <mm-commits@vger.kernel.org>; Wed,  3 Jan 2024 20:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NcGqdroA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF35C433C7;
	Wed,  3 Jan 2024 20:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704312659;
	bh=YNXcr4WxJcl8Y6NVnIkMOjhIuUixx+4MRSMos5KZTDU=;
	h=Date:To:From:Subject:From;
	b=NcGqdroA5PLjdHExIRE0x2BZoo381RpgquwKaiW9gihMP5XhumFps5tv7X9xB6w6N
	 2FUzgLs2JvFIPizFZoawt+wvYueevYQoIq3ycSBUnFqka/shtITekTbCHzQcDxLtWu
	 fIdX6YdeW26Qwe57iqo9LNWKJQPp0MBIcUqjf5Q8=
Date: Wed, 03 Jan 2024 12:10:58 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,nphamcs@gmail.com,hannes@cmpxchg.org,ddstreet@ieee.org,hezhongkun.hzk@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-zswap-fix-the-lack-of-page-lru-flag-in-zswap_writeback_entry.patch removed from -mm tree
Message-Id: <20240103201059.8CF35C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: fix the lack of page lru flag in zswap_writeback_entry
has been removed from the -mm tree.  Its filename was
     mm-zswap-fix-the-lack-of-page-lru-flag-in-zswap_writeback_entry.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Zhongkun He <hezhongkun.hzk@bytedance.com>
Subject: mm: zswap: fix the lack of page lru flag in zswap_writeback_entry
Date: Tue, 24 Oct 2023 22:27:06 +0800

The zswap_writeback_entry() will add a page to the swap cache, decompress
the entry data into the page, and issue a bio write to write the page back
to the swap device.  Move the page to the tail of lru list through
SetPageReclaim(page) and folio_rotate_reclaimable().

Currently, about half of the pages will fail to move to the tail of lru
list because there is no LRU flag in page which is not in the LRU list but
the cpu_fbatches.  So fix it.

Link: https://lkml.kernel.org/r/20231024142706.195517-1-hezhongkun.hzk@bytedance.com
Signed-off-by: Zhongkun He <hezhongkun.hzk@bytedance.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/zswap.c~mm-zswap-fix-the-lack-of-page-lru-flag-in-zswap_writeback_entry
+++ a/mm/zswap.c
@@ -1454,6 +1454,11 @@ static int zswap_writeback_entry(struct
 	/* move it to the tail of the inactive list after end_writeback */
 	folio_set_reclaim(folio);
 
+	if (!folio_test_lru(folio)) {
+		/* drain lru cache to help folio_rotate_reclaimable() */
+		lru_add_drain();
+	}
+
 	/* start writeback */
 	__swap_writepage(folio, &wbc);
 	folio_put(folio);
_

Patches currently in -mm which might be from hezhongkun.hzk@bytedance.com are


