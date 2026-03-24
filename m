Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F34F2459ED
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774386743; cv=none; b=LaLbsp06B7ig2KxRdrzq2SHnKVhPov8t4a5W5k9ZTaAQ2RYBLdS9ceW9ORk4vMo846PqZvWQ1mcx6ixsQimwtrfEjDsS1VS1k+M7z2AhkifAt7+VSq/MkRMxvPd1rg2Ckxr8N98skexDO7Hv13Bqm5aCKPhQt2rBWc5xuKYR0X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774386743; c=relaxed/simple;
	bh=wjZdu5oiwpmym+iGlCtNJd32qWnLSLMH7wA+Z1lzoi0=;
	h=Date:To:From:Subject:Message-Id; b=pFcL6OQEEUo/dphHOlGZ/SEpxfWLONI02dxISjalX/XTzIykUXjfwqst1JElnylWk2foi6JEmKx1NS35SRzhg3a4gMyaZP/YSxrAQQQgwdfgPlQyDELKIGFEBt2v7ePqx8UcsjRL0aSzbot92b+epdkDqMQUCkqLG3ox/GZ/090=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PRJFuNks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PRJFuNks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE00FC19424;
	Tue, 24 Mar 2026 21:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774386742;
	bh=wjZdu5oiwpmym+iGlCtNJd32qWnLSLMH7wA+Z1lzoi0=;
	h=Date:To:From:Subject:From;
	b=PRJFuNkskJuf0vak+wVmoY1QzTqxlbk7OIi8E4WCA9//efBzZSlFQz2Mh6eS9Uf/k
	 Dw/c61y0uRuVInxeas5nnt1onYO67ARs93r8MsTREnCOHpQXgq1VnLS02mp337fqfQ
	 v/4Kse+hAvua0hKyT2BW9h9l3FeuzJI8IRsPrJus=
Date: Tue, 24 Mar 2026 14:12:22 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,lkp@intel.com,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,ryncsn@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-use-the-swap-table-to-track-the-swap-count-fix.patch removed from -mm tree
Message-Id: <20260324211222.BE00FC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-swap-use-the-swap-table-to-track-the-swap-count-fix
has been removed from the -mm tree.  Its filename was
     mm-swap-use-the-swap-table-to-track-the-swap-count-fix.patch

This patch was dropped because it was folded into mm-swap-use-the-swap-table-to-track-the-swap-count.patch

------------------------------------------------------
From: Kairui Song <ryncsn@gmail.com>
Subject: mm-swap-use-the-swap-table-to-track-the-swap-count-fix
Date: Wed, 18 Feb 2026 20:22:54 +0800

fix build

Link: https://lkml.kernel.org/r/aZWuLZi-vYi3vAWe@KASONG-MC4
Signed-off-by: Kairui Song <ryncsn@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202602181835.58TEynxc-lkp@intel.com/
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-use-the-swap-table-to-track-the-swap-count-fix
+++ a/mm/swapfile.c
@@ -1624,7 +1624,7 @@ static int __swap_cluster_dup_entry(stru
 		}
 	} else if (count == SWP_TB_COUNT_MAX) {
 		VM_WARN_ON_ONCE(ci->extend_table[ci_off] >=
-				(BIT(BITS_PER_TYPE(ci->extend_table[0]))) - 1);
+                               type_max(typeof(ci->extend_table[0])));
 		++ci->extend_table[ci_off];
 	} else {
 		/* Never happens unless counting went wrong */
_

Patches currently in -mm which might be from ryncsn@gmail.com are

mm-swap-use-the-swap-table-to-track-the-swap-count.patch

