Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D7D19E99E
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 05:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741239466; cv=none; b=cnlClx2wZffALcW5hIVW9DcynPntsxyAMaBwzGbcAas8gOb8GsPmphEv88ZpSJzaGuinaWpUdOqnBE9v7+oziHomfpUuBVgX4TXGdOEXrOAP/95KllM2oEU8JDa+NP4VYbEcbaxawX42H6vJ2SgfGSipRPFyMjY0PMK39oFSADc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741239466; c=relaxed/simple;
	bh=L1nfz4rqufmCoLCkM0uUFJP/3Q23xCj5fhuyOEwDocs=;
	h=Date:To:From:Subject:Message-Id; b=HejedfGKVYOWTKDNhtkxnvHY79Z329CnYGp//l4Ci1MF6djVt5ZalpeT4jpW9PLBjKhSCPpkCAGJ6DhKQn5fGAUpuEIwqADXwx43sZiVeGg3r/2tNmJMc9lKHXJt75cMCwWLuq1ph1q92bwYglEWsTyK/4E2ytkoUScJSheK/k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rO+1nann; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rO+1nann"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E226CC4CEE4;
	Thu,  6 Mar 2025 05:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741239466;
	bh=L1nfz4rqufmCoLCkM0uUFJP/3Q23xCj5fhuyOEwDocs=;
	h=Date:To:From:Subject:From;
	b=rO+1nannh/Q234Lk6BsETcgjL8Bc0flcyqRcmDltFa+idE5lxs1EtbBMhtIWObM3K
	 pL6ObWzQmg20s+A5YvZt/I5YR5GVlWIv90z83E6w14DSIer0srUBs+ZOV4EffTRNH6
	 ahojPuYWjcBRAQNj7NuqkpW3yjXbR4ARE5HkqRrA=
Date: Wed, 05 Mar 2025 21:37:45 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,nphamcs@gmail.com,kanchana.p.sridhar@intel.com,hannes@cmpxchg.org,david@redhat.com,chengming.zhou@linux.dev,sunk67188@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-zswap-use-atomic_long_init-to-initialize-zswap_stored_pages.patch removed from -mm tree
Message-Id: <20250306053745.E226CC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: use ATOMIC_LONG_INIT to initialize zswap_stored_pages
has been removed from the -mm tree.  Its filename was
     mm-zswap-use-atomic_long_init-to-initialize-zswap_stored_pages.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sun YangKai <sunk67188@gmail.com>
Subject: mm: zswap: use ATOMIC_LONG_INIT to initialize zswap_stored_pages
Date: Wed, 26 Feb 2025 23:32:43 +0800

This is currently the only atomic_long_t variable initialized by
ATOMIC_INIT macro found in the kernel by using `grep -r atomic_long_t |
grep ATOMIC_INIT`

This was introduced in 6e1fa555ec77, in which we modified the type of
zswap_stored_pages to atomic_long_t, but didn't change the initialization.

Link: https://lkml.kernel.org/r/20250226153253.19179-1-sunk67188@gmail.com
Fixes: 6e1fa555ec77 ("mm: zswap: modify zswap_stored_pages to be atomic_long_t")
Signed-off-by: Sun YangKai <sunk67188@gmail.com>
Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-use-atomic_long_init-to-initialize-zswap_stored_pages
+++ a/mm/zswap.c
@@ -43,7 +43,7 @@
 * statistics
 **********************************/
 /* The number of compressed pages currently stored in zswap */
-atomic_long_t zswap_stored_pages = ATOMIC_INIT(0);
+atomic_long_t zswap_stored_pages = ATOMIC_LONG_INIT(0);
 
 /*
  * The statistics below are not protected from concurrent access for
_

Patches currently in -mm which might be from sunk67188@gmail.com are


