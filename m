Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CE83002A3
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025875; cv=none; b=PqU7aasL6VfTwQNFtq9RyEJ5XnHm+j3ZotV8EtQHlhLvZI1Sfw+5g4qyNH1NZxW/IaYjX96rCE9Gr+ktnfYJNMZDjj7uu5sy/93ovGbRJ6KkBAXZZT68EIBq59ByS7yXvNA+1t0pDDwbtBnlaybq2NNcAfkSgW5sqofam9wuVGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025875; c=relaxed/simple;
	bh=ysM7HocnPe2S96qloMqSQigH7RXNi6nlXfSsn5IrZzc=;
	h=Date:To:From:Subject:Message-Id; b=Tp9Q+Tu3qAeJ99OX+9/ph3EOG0g7w1Qv19Ojq1nvTbDB2Esp6s0gRAUYw8ZRJwttqlUPd9a3FO86THIxikLLsiQTcS7dmp1JSArX4xQPgaopu88ggLryNduRmWO35SbBuG7CkH/LThRodmsAk3L/gMzN4W1c7fJvhsk27tEaMII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BcSYFPNQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BcSYFPNQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41040C4CEF1;
	Mon, 24 Nov 2025 23:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025875;
	bh=ysM7HocnPe2S96qloMqSQigH7RXNi6nlXfSsn5IrZzc=;
	h=Date:To:From:Subject:From;
	b=BcSYFPNQ6GsaiIp5ZTUbEAk51engQu/g6Lv/HeZCa4snSLM5pGIv3XoPnHUlBdOTZ
	 l33Wb+yKbj07haxWc/qXpq5k3xCSCdvZ6lhJgtF7BLQQxseieiVVeFUYI7d/Eo/SKH
	 zHQ1TpP7kZ5ytbMw8SjMNwVWuyesnwzWTlWGoe34=
Date: Mon, 24 Nov 2025 15:11:14 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,akpm@linux-foundation.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-add-__read_mostly-to-sysctl_hugetlb_shm_group.patch removed from -mm tree
Message-Id: <20251124231115.41040C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: add __read_mostly to sysctl_hugetlb_shm_group
has been removed from the -mm tree.  Its filename was
     hugetlb-add-__read_mostly-to-sysctl_hugetlb_shm_group.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: hugetlb: add __read_mostly to sysctl_hugetlb_shm_group
Date: Fri, 21 Nov 2025 14:48:59 -0500

sysctl bits are mostly-read values.

Link: https://lkml.kernel.org/r/20251121194859.265259-2-gourry@gourry.net
Signed-off-by: Gregory Price <gourry@gourry.net>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/hugetlb.h~hugetlb-add-__read_mostly-to-sysctl_hugetlb_shm_group
+++ a/include/linux/hugetlb.h
@@ -171,7 +171,7 @@ bool hugetlbfs_pagecache_present(struct
 
 struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio);
 
-extern int sysctl_hugetlb_shm_group;
+extern int sysctl_hugetlb_shm_group __read_mostly;
 extern struct list_head huge_boot_pages[MAX_NUMNODES];
 
 void hugetlb_bootmem_alloc(void);
_

Patches currently in -mm which might be from gourry@gourry.net are


