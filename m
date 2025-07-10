Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C332853F6
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126293; cv=none; b=YnPM+4H/yPFCkSxVI24VAQR28Lijuv/FsMj5VhPPPdewNxRuiKRDk+0SAvnBuI3hLiwDwmkp+suSvl6De2qf+RoN4SVcqquURGhjb8qmV+0zc1Rk4lcPcBuukOvACyVel263iRUPJS1M20p7R8vJ5q3mYN00VJ7fr/rMiOTRcQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126293; c=relaxed/simple;
	bh=0P2mpLxJBmMmoobuehBrq0/WTmiyW6eQZoViUGReeHw=;
	h=Date:To:From:Subject:Message-Id; b=uIIQa67bl2SxTVYIKnI+KoqyeXbfTpg7DJ8gkhAXOklLr4EOzsEeLl6YA1OmmeXii3wriCo2y5ZYtCQYmDArhVYCLmHG8WPkBC+4LPBa3PcibzqiS7vLyZfA7Fc4Tk4D0j2ohXaZnwRzcdfnkSjul8JDDBBQ8xgPR0sYYi47pmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c3Q7Ylzt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c3Q7Ylzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1A5C4CEF4;
	Thu, 10 Jul 2025 05:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126293;
	bh=0P2mpLxJBmMmoobuehBrq0/WTmiyW6eQZoViUGReeHw=;
	h=Date:To:From:Subject:From;
	b=c3Q7YlztQTno6UVIsxLpUA+tjlsSo3qGXEqMpymQV2W9I0gmymvffXNbPUMh/4Xbe
	 xvU28b9Ya9ilbgNw+bF9fGMFnAAI3wjY3Nt1OjIzlxZVGW+yfYGbBzdSdtWYXe1Pdl
	 /gXfRbmCO2X+YNKfm/gSYmq/EuN3QxuSLMmhjMU4=
Date: Wed, 09 Jul 2025 22:44:52 -0700
To: mm-commits@vger.kernel.org,xiubli@redhat.com,Slava.Dubeyko@ibm.com,ira.weiny@intel.com,idryomov@gmail.com,hch@lst.de,dan.carpenter@linaro.org,axboe@kernel.dk,amarkuze@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-zero_user.patch removed from -mm tree
Message-Id: <20250710054453.5B1A5C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove zero_user()
has been removed from the -mm tree.  Its filename was
     mm-remove-zero_user.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove zero_user()
Date: Thu, 12 Jun 2025 15:34:41 +0100

All users have now been converted to either memzero_page() or
folio_zero_range().

Link: https://lkml.kernel.org/r/20250612143443.2848197-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Xiubo Li <xiubli@redhat.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/include/linux/highmem.h~mm-remove-zero_user
+++ a/include/linux/highmem.h
@@ -292,12 +292,6 @@ static inline void zero_user_segment(str
 	zero_user_segments(page, start, end, 0, 0);
 }
 
-static inline void zero_user(struct page *page,
-	unsigned start, unsigned size)
-{
-	zero_user_segments(page, start, start + size, 0, 0);
-}
-
 #ifndef __HAVE_ARCH_COPY_USER_HIGHPAGE
 
 static inline void copy_user_highpage(struct page *to, struct page *from,
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-pass-the-inode-to-squashfs_readahead_fragment.patch
squashfs-use-folios-in-squashfs_bio_read_cached.patch

