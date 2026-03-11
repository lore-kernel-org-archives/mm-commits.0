Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEEB3E3DA6;
	Wed, 11 Mar 2026 18:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773252951; cv=none; b=jAtOrJYFJc8ejUxW9tnxaUsrYyQVeUlCiAKg2pYXzh5gPJv7zwIhTmf+ITrYlKvsp5m1bIAMBPGe6Q8nnII1arQtw5fzIUurAZihu6HNRp6Ku2F/AaXt2w6kgzesjpLSacl4XJGxWW/QtUXi59GxjPe7IAqFI/pQ4qpzBuy2q4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773252951; c=relaxed/simple;
	bh=mhXBbC0jZZ3C2IzhNqn79wYdoC0r5cHoon09Ub+qHbI=;
	h=Date:To:From:Subject:Message-Id; b=gkmMHvLO9F1yqh205vSbRzdEKR6+BhcHltwmrSZCeCVSEDYxUL7sqAkj+yP8S673+NDb6B8gsXK5TaQB1MdQcZqrZFMffXgcU6xzB3BW522/2Xjul9QXJLjzLEZvnpDdqQBdK8gnEdEpvtuTbxKRiU3TnJuOxpBenVEvQdECmNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pBBVOS28; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pBBVOS28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C3AC4CEF7;
	Wed, 11 Mar 2026 18:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773252951;
	bh=mhXBbC0jZZ3C2IzhNqn79wYdoC0r5cHoon09Ub+qHbI=;
	h=Date:To:From:Subject:From;
	b=pBBVOS2880bWGRHRl9JqIO4AiEmohXGzFvIX3XCafh2bPYu3Gy3nVe1B6Kwq9eojf
	 ykyqI3+DUXVfwbVaiHzmWrK6G9RSzoC2cXw/KQx9y3LInNf2ZHdNtSbykhrIMAHNcD
	 kPIqdGK4PP7czNtm6nHFDiU4GghCzaLcrBziSA80=
Date: Wed, 11 Mar 2026 11:15:50 -0700
To: mm-commits@vger.kernel.org,zkabelac@redhat.com,urezki@gmail.com,stable@vger.kernel.org,sj@kernel.org,mhocko@suse.com,hch@lst.de,anshuman.khandual@arm.com,mpatocka@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-allow-__gfp_retry_mayfail-in-vmalloc.patch removed from -mm tree
Message-Id: <20260311181551.25C3AC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: allow __GFP_RETRY_MAYFAIL in vmalloc
has been removed from the -mm tree.  Its filename was
     mm-allow-__gfp_retry_mayfail-in-vmalloc.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Date: Thu, 12 Feb 2026 17:33:30 +0100 (CET)

The commit 07003531e03c8 ("mm/vmalloc: warn on invalid vmalloc gfp flags")
breaks the device mapper VDO target.  The VDO target calls vmalloc with
__GFP_RETRY_MAYFAIL and this flag is not in the mask of allowed flags.

There is no reason why vmalloc couldn't support __GFP_RETRY_MAYFAIL, so
let's add this flag to GFP_VMALLOC_SUPPORTED.

Link: https://lkml.kernel.org/r/ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com
Fixes: 07003531e03c ("mm/vmalloc: warn on invalid vmalloc gfp flags")
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>	[6.19]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmalloc.c~mm-allow-__gfp_retry_mayfail-in-vmalloc
+++ a/mm/vmalloc.c
@@ -3941,6 +3941,7 @@ fail:
  */
 #define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
 				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
+				__GFP_RETRY_MAYFAIL |\
 				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
 				GFP_USER | __GFP_NOLOCKDEP)
 
_

Patches currently in -mm which might be from mpatocka@redhat.com are


