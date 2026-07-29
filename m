Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DB23911BC
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298451; cv=none; b=CmZAs3c2QgaHcaUekL32pGZjZT3cNPOV5tc4yx4IMJ4hIxrpz5tqui3EDI/IGrQbCDBbFYBSgdoBvcbEkW10jJK3sNN3l+S69yknpeFI6j3VNX2q0b3NxjAZLyV2GN0qshQqDZsC3kr6OUZMWlV2SIgS2i5z6zxXxlP34pEkudI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298451; c=relaxed/simple;
	bh=EleT6OPIltgUxmvlqO6+r1vPfjGcHolXo1oD/50XH+4=;
	h=Date:To:From:Subject:Message-Id; b=mEYC1zysAYTPj5ftLTtcNBJ+3/FlwGaWJlFmJKiknmNBairc8DbcsRdwEhBV5lKMHeC3e3R8l3mZkMNj0xNmluNdfHZB+jd/dSiaqtdTLavGtq4USkAke9OBbCgj4qjqjxS8Agj1br/dWSqjeNvJElPV8q12r+wD7IJcs0emI10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X45fkcqM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X45fkcqM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240A71F00A3A;
	Wed, 29 Jul 2026 04:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298450;
	bh=6Ry0YlctMK8fG/rLjV2B6mFCODRUgt2TJhXZlUTU8FI=;
	h=Date:To:From:Subject;
	b=X45fkcqMpbQbWKy8F8CYXL80XTGuExHFZLmvFLIidPO8L8fayEU0UxTvhzRyEutCu
	 iVBFKbqrX8Z8sojRkyMZ+20ZmglE0w0wi2YcOchlY/RN2IPhbCe6YSt6WH/Y8ozNxj
	 rPmW2p30QxktkdrJnMndfZcB84ydcYeEwZ0K9GNY=
Date: Tue, 28 Jul 2026 21:14:09 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,agruenba@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fix-a-typo-in-the-wbc_init_bio-description.patch removed from -mm tree
Message-Id: <20260729041410.240A71F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: writeback.h: fix a typo in the wbc_init_bio() description
has been removed from the -mm tree.  Its filename was
     fix-a-typo-in-the-wbc_init_bio-description.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: writeback.h: fix a typo in the wbc_init_bio() description
Date: Mon, 15 Jun 2026 17:22:42 +0100

initializtion -> initialization (missing "a")

Link: https://lore.kernel.org/20260615162244.2170866-2-willy@infradead.org
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/writeback.h~fix-a-typo-in-the-wbc_init_bio-description
+++ a/include/linux/writeback.h
@@ -244,7 +244,7 @@ void wbc_attach_fdatawrite_inode(struct
 		struct inode *inode);
 
 /**
- * wbc_init_bio - writeback specific initializtion of bio
+ * wbc_init_bio - writeback specific initialization of bio
  * @wbc: writeback_control for the writeback in progress
  * @bio: bio to be initialized
  *
_

Patches currently in -mm which might be from agruenba@redhat.com are


