Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E5038C2C0
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298417; cv=none; b=UPHNHAfxw+giuXzxlkPp4ZyBOXXFY8w069K/K+1tdoytPzp42hEKW+yvYgK1R3KgYsTa6jeVWllqrxhpUGesdDajj0GZL3PiQ9kNXjqEgAOzDPN+x9JJTnZd4G9du7/iDHgsNu+dTvmRaOuHe6plqRuzgqZhJAWNRAWkhs9Hc9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298417; c=relaxed/simple;
	bh=ctgiYH1Ugse+kmIYYZZkOKJClgpSsUn/YeA9F7+oUSw=;
	h=Date:To:From:Subject:Message-Id; b=MqsG3i1tFi2tXZI4x7oz2wxG1rolbs+oBaZ5itXI9yPHba5HukVu1+WvRkYXkNhjL3d4i8ZnJjtodxOD7Zg0EDDpDH7INV4qYIanDlZMCKo8QjM2mBAF0orXKrvN29wbctCaz6SPFxVHCm1dIcNDn5DKvTsLiB8r3f9vJqaF43I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j9Jpp4H9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j9Jpp4H9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F23D1F000E9;
	Wed, 29 Jul 2026 04:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298415;
	bh=CJGufMdWQQiFqvajJJV8d3QRKdaeyVqYehFDCjvxcPk=;
	h=Date:To:From:Subject;
	b=j9Jpp4H9HThMlTQ5ASoyaALZ5NxfqQ0Euw1PoIT9e5NyNnq59grT3wEV9xyGHBH96
	 kQZdeemgoMmLhbccnFaFdS14/heHdvutCC8FOOdjamGE/xRMQMV8yzAyyCa66womqj
	 nIJwfViO7LcPPN5LIBxnlT7aowbw2y18ooJrZa+k=
Date: Tue, 28 Jul 2026 21:13:35 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,ljs@kernel.org,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch removed from -mm tree
Message-Id: <20260729041335.7F23D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: add missing newline to count_threshold format string
has been removed from the -mm tree.  Its filename was
     mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <ye.liu@linux.dev>
Subject: mm/page_owner: add missing newline to count_threshold format string
Date: Tue, 14 Jul 2026 09:51:04 +0800

The DEFINE_SIMPLE_ATTRIBUTE format string for page_owner_threshold_fops is
missing a trailing \n.  simple_attr_read() uses scnprintf() with the
format string, which does not append a newline, so reading
/sys/kernel/debug/page_owner_stacks/count_threshold produces output
without a terminating newline.  Add the missing \n to match the standard
debugfs attribute convention.

Link: https://lore.kernel.org/20260714015117.78351-6-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-page_owner-add-missing-newline-to-count_threshold-format-string
+++ a/mm/page_owner.c
@@ -974,7 +974,7 @@ static int page_owner_threshold_set(void
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
-			&page_owner_threshold_set, "%llu");
+			&page_owner_threshold_set, "%llu\n");
 
 
 static int __init pageowner_init(void)
_

Patches currently in -mm which might be from ye.liu@linux.dev are


