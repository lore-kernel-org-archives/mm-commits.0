Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D5813AF2
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957017; cv=none; b=nkp2J3hx14SjK2SEyFDNKrExW22rIxsFjS+ZT7d9+d+773vk1aAxwy1JojbA82PZ15Na2koEO8mSnz0gRjz/CiRR/vCGv85BQeLeCJ6k/2J/+prgsvRP5zZiQdiS8PFCPW5gDYrXAVC2ccFCxR1XQEy0ilCML991tuIoybWua2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957017; c=relaxed/simple;
	bh=pWlx/NmtapAuloSFbfeP5GyqeY2ZytAkwZ+MSTULu7U=;
	h=Date:To:From:Subject:Message-Id; b=gi9z7IvzeWsmHxb3htBgbJ2w+D85FpncI8ZEdF9EBYn0sQTvpHGg1msaXmrskUT3rsGsnrrtnlXBG63/mq5aiBiVSK3jP9IDsQK4h0DX45mLmgaCT8SHujNYoh8Dv3N/KQ06xrMfR9bclf+XwVZWIu4DGbMg0Mun53v5chaMYiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XtKmuQ7x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XtKmuQ7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3133BC113CC;
	Mon,  6 May 2024 00:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957017;
	bh=pWlx/NmtapAuloSFbfeP5GyqeY2ZytAkwZ+MSTULu7U=;
	h=Date:To:From:Subject:From;
	b=XtKmuQ7xHmiPkm3CK7CraOqFxdTQKR8SwCePdgsZH0TJfFls2NIJdznAe4X4siFl5
	 ohH76hOjCJ7EwIYmlDEXbRM6Z2ft0tjTPjskU+JfV+XpvBf9ldkPMNjNUG8qJlAxqF
	 9l434n4GlI+PhvHI3HioXRJ3YVzFybj/08ua1rCI=
Date: Sun, 05 May 2024 17:56:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ysato@users.sourceforge.jp,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richardycc@google.com,peterx@redhat.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jcmvbkbc@gmail.com,hughd@google.com,glaubitz@physik.fu-berlin.de,fengwei.yin@intel.com,dalias@libc.org,corbet@lwn.net,chris@zankel.net,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-admin-guide-cgroup-v1-memoryrst-dont-reference-page_mapcount.patch removed from -mm tree
Message-Id: <20240506005657.3133BC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation/admin-guide/cgroup-v1/memory.rst: don't reference page_mapcount()
has been removed from the -mm tree.  Its filename was
     documentation-admin-guide-cgroup-v1-memoryrst-dont-reference-page_mapcount.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: Documentation/admin-guide/cgroup-v1/memory.rst: don't reference page_mapcount()
Date: Tue, 9 Apr 2024 21:23:01 +0200

Let's stop talking about page_mapcount().

Link: https://lkml.kernel.org/r/20240409192301.907377-19-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/memory.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/cgroup-v1/memory.rst~documentation-admin-guide-cgroup-v1-memoryrst-dont-reference-page_mapcount
+++ a/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -802,8 +802,8 @@ a page or a swap can be moved only when
 |   | anonymous pages, file pages (and swaps) in the range mmapped by the task |
 |   | will be moved even if the task hasn't done page fault, i.e. they might   |
 |   | not be the task's "RSS", but other task's "RSS" that maps the same file. |
-|   | And mapcount of the page is ignored (the page can be moved even if       |
-|   | page_mapcount(page) > 1). You must enable Swap Extension (see 2.4) to    |
+|   | The mapcount of the page is ignored (the page can be moved independent   |
+|   | of the mapcount). You must enable Swap Extension (see 2.4) to            |
 |   | enable move of swap charges.                                             |
 +---+--------------------------------------------------------------------------+
 
_

Patches currently in -mm which might be from david@redhat.com are


