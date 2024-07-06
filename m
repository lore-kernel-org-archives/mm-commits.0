Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D2C13C80F
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720292062; cv=none; b=SpgtI4QMHmnX1MZEWOD8jeFNbZxtBT6cak3jceMD33grzOSHpFGBVinuD1ozC1Liiro/ai8ztF9K7ojk7G1L9A+BvHNzlDtZdikNunmhbducS17L5xPTUFf2+MaTFFqZwK/GcQI3/hkYFeuObqfpYz434lqDMZUMEMJAhfAd1SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720292062; c=relaxed/simple;
	bh=XtYLnPEToBA6VkC8SFnOKctaymluNZ+/MXPMPzweal4=;
	h=Date:To:From:Subject:Message-Id; b=UsUDW53winBaf6HePxBO1wpHylF+aK8jlW+F4NMhjejdiw6t/j4/xAE48HwYv3PkxIPIZ0a8X43NojdZbqDjo9Jien1x9iN5JHsyu9GBrHnZLYWUTDpMuVqRNtcXAXg6II0/p5gafZB1NnkSocvTCGKCken0Hr+wPPg/DbNxxKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZPyO+VL3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZPyO+VL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30420C2BD10;
	Sat,  6 Jul 2024 18:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720292062;
	bh=XtYLnPEToBA6VkC8SFnOKctaymluNZ+/MXPMPzweal4=;
	h=Date:To:From:Subject:From;
	b=ZPyO+VL3+JADMcsiKvBUXPnNad4gL4ieiIaaX/8YjXckEFiaiQba8oUxG6/pC7SMb
	 ZQlb49qaW8G9PlbI3eapXqlfMBaBmPuaxzk314WRwQmurEIIEI2wggfon5mwtc3WPo
	 itRCUUP5gBlsCJaMZs0TfacErKn+v5odQioPbFJM=
Date: Sat, 06 Jul 2024 11:54:21 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,willy@infradead.org,nphamcs@gmail.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,chengming.zhou@linux.dev,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-fix-zswap_never_enabled-for-config_zswap==n.patch removed from -mm tree
Message-Id: <20240706185422.30420C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: fix zswap_never_enabled() for CONFIG_ZSWAP==N
has been removed from the -mm tree.  Its filename was
     mm-zswap-fix-zswap_never_enabled-for-config_zswap==n.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: zswap: fix zswap_never_enabled() for CONFIG_ZSWAP==N
Date: Sun, 30 Jun 2024 11:22:31 +1200

If CONFIG_ZSWAP is set to N, it means zswap cannot be enabled. 
zswap_never_enabled() should return true.

The only effect of this issue is that with Barry's latest large folio
swapin patches for zram ("mm: support mTHP swap-in for zRAM-like
swapfile"), we will always fallback to order-0 swapin, even mistakenly
when !CONFIG_ZSWAP.

Basically this bug makes Barry's in progress patches not work at all.

The API was created to inform the mm core that zswap has never been
enabled, allowing the mm core to perform mTHP swap-in.  This is a
transitional solution until zswap supports mTHP.  If zswap has been
enabled, performing mTHP swap-in will result in corrupted data.  You
may find the answer in the mTHP swap-in series:

https://lore.kernel.org/linux-mm/CAJD7tkZ4FQr6HZpduOdvmqgg_-whuZYE-Bz5O2t6yzw6Yg+v1A@mail.gmail.com/

Link: https://lkml.kernel.org/r/20240629232231.42394-1-21cnbao@gmail.com
Fixes: 0300e17d67c3 ("mm: zswap: add zswap_never_enabled()")
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zswap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/zswap.h~mm-zswap-fix-zswap_never_enabled-for-config_zswap==n
+++ a/include/linux/zswap.h
@@ -68,7 +68,7 @@ static inline bool zswap_is_enabled(void
 
 static inline bool zswap_never_enabled(void)
 {
-	return false;
+	return true;
 }
 
 #endif
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are


