Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99125C15B
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739457; cv=none; b=TM3FWxHXPZ14XjCXM+sKjBin8uK473xSE5ZLFQDYPTdswffzsSLw7AlQbnPZgG08BI7z2n46aqyrbUm3V2nK/Ze7wlzYHYVBxVCHNP9/3OR8Llqz0GXKxqcfO75G5efZtGWqvAarFHhjviJEW2wWAexBUu8OlMcf//pJp3lfVPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739457; c=relaxed/simple;
	bh=5eWTD8QKTeLQ4L+FM9bhrQU9h6HOPPLviGiLXO/UfCQ=;
	h=Date:To:From:Subject:Message-Id; b=GvpnP8fx8cWRg/Bl7VDaWeDDv69JrPCiN+LaMGNJs+tDXG0hSXjwKmMNOtqJsTdrTl8k3MNPS2TkyRV+/6Ee2Zz+yJmuX6xXBGqLXkfjPhBgNuwVjklPZUlCw+CVPrIZIcWYBTdTi8W/81hkaVGu/HRslKLjCJ5dB/uJ+0KMI6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NKBZj+wF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NKBZj+wF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E287C43390;
	Sat, 24 Feb 2024 01:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739457;
	bh=5eWTD8QKTeLQ4L+FM9bhrQU9h6HOPPLviGiLXO/UfCQ=;
	h=Date:To:From:Subject:From;
	b=NKBZj+wFecS/JNYNOss3FbaJoR5YD0mPxBLQO83DvgFs0kVkfHltruR+M5Tjh8eqo
	 xqAoQHOxLdcf1o1jio8LAltGrddZQAHrkfCU4Ww0tnWBTqMk25Nhsq7A2d2nfoUv/7
	 syA3GVHb5VdTOlpcGcT3zipneZZfwxDhMiwXFEbU=
Date: Fri, 23 Feb 2024 17:50:56 -0800
To: mm-commits@vger.kernel.org,jack@suse.cz,hch@lst.de,dhowells@redhat.com,dchinner@redhat.com,brauner@kernel.org,bfoster@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] writeback-remove-a-duplicate-prototype-for-tag_pages_for_writeback.patch removed from -mm tree
Message-Id: <20240224015057.6E287C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: writeback: remove a duplicate prototype for tag_pages_for_writeback
has been removed from the -mm tree.  Its filename was
     writeback-remove-a-duplicate-prototype-for-tag_pages_for_writeback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: writeback: remove a duplicate prototype for tag_pages_for_writeback
Date: Thu, 15 Feb 2024 07:36:37 +0100

[hch@lst.de: split from a larger patch]
Link: https://lkml.kernel.org/r/20240215063649.2164017-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Dave Chinner <dchinner@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/writeback.h~writeback-remove-a-duplicate-prototype-for-tag_pages_for_writeback
+++ a/include/linux/writeback.h
@@ -363,8 +363,6 @@ bool wb_over_bg_thresh(struct bdi_writeb
 typedef int (*writepage_t)(struct folio *folio, struct writeback_control *wbc,
 				void *data);
 
-void tag_pages_for_writeback(struct address_space *mapping,
-			     pgoff_t start, pgoff_t end);
 int write_cache_pages(struct address_space *mapping,
 		      struct writeback_control *wbc, writepage_t writepage,
 		      void *data);
_

Patches currently in -mm which might be from willy@infradead.org are


