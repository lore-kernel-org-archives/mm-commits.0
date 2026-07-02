Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9E42BF3F3
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 02:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782957827; cv=none; b=dhZgeDysXZyT1oxzkUOhSewBsb450ewR02TWekSA387jh0hGayaS6dccyj+ktDO6hicawesLjWXpsZXC8opLc+eBJP+JSBUjcWAcm5P9QGkYJIKcAxSvWDVfKc+meysJ50mdZtjD1sWJZCgYA/HS1woIC1rqzV54pSNx7OpiU9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782957827; c=relaxed/simple;
	bh=QUYankM6OQJZ2sn7ruxZAADEV/yuDhgG/lIZiLSYQOs=;
	h=Date:To:From:Subject:Message-Id; b=aORFZfu6iKa4fkdtQyVClVSj0RM0liAgQV5KEG5KIwujVdJed+JL1QfB9uMLLIfELteFxQ8W+kLIgZc3ighC/w6BNu5KW7rWpbJlCYixxrfodsPHyFqV18D8+L7v1hSbWyR5x1iAsIeNHTWdb1jkQNu5lN99edX5IMtpqooD9Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cZuSYPGW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cZuSYPGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5E51F00A3A;
	Thu,  2 Jul 2026 02:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782957826;
	bh=vSOYa2+KQ0ulPnOuaKBgecTLuG2rjaauvCbDhZAMjhQ=;
	h=Date:To:From:Subject;
	b=cZuSYPGWO4UVdolUWK4UoNKL33ESZwbAvGsQUhfolGjenXQYTe8oOIGYWmPfeGZmb
	 GHpg4qEm7pYqvpi0nB4Cfi5qye+yczmguLxti5jkPJEnuYIJa/mxTtRSKgX/Zhv82v
	 hngiAxjjxbs3XN3kNCaNuUQgB1eyhwFe3MJqnQQY=
Date: Wed, 01 Jul 2026 19:03:46 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ljs@kernel.org,david@kernel.org,brauner@kernel.org,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-a-second-pagecache-maintainer.patch removed from -mm tree
Message-Id: <20260702020346.6E5E51F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: a second pagecache maintainer
has been removed from the -mm tree.  Its filename was
     mm-a-second-pagecache-maintainer.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: a second pagecache maintainer
Date: Mon, 29 Jun 2026 15:59:28 +0200

As MM is slowly transitioning towards a more distributed maintainership
model, we agreed with Matthew that I will be a co-maintainer in case he is
not available.

Link: https://lore.kernel.org/20260629135927.2586391-2-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~mm-a-second-pagecache-maintainer
+++ a/MAINTAINERS
@@ -20406,7 +20406,7 @@ F:	kernel/padata.c
 
 PAGE CACHE
 M:	Matthew Wilcox (Oracle) <willy@infradead.org>
-R:	Jan Kara <jack@suse.cz>
+M:	Jan Kara <jack@suse.cz>
 L:	linux-fsdevel@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Supported
_

Patches currently in -mm which might be from jack@suse.cz are


