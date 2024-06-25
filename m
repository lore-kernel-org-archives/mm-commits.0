Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E6C1849
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719288986; cv=none; b=gGZQnVari/aGisBtBLZSRQxay8EFty+6/WiVgbq/TiClzsQl5wfpRRw8RAHL7noS6ye5IR4jcoDfxcmw/dQPWsBzTnFrB8/2bQdeG4j6vGn9MSPzJTJK9oIK3EoolmnUsQ/gwGdmFEWpzRQ5zhwaWneRlKaedP4gSSxFTvgUAMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719288986; c=relaxed/simple;
	bh=jaU1dFMCHeLtPFeIkJ3O3z2Ivlachs5G8oeBqzdqHD8=;
	h=Date:To:From:Subject:Message-Id; b=YzQz9frvD+aIx6XjnKXoxNcxjy7j1rpQhLMuSNEwS8BgzzpIksGxLXLXtsJjV7wv6dV5kjpqYKuT88nG7k2Lij9R4P9VnW/AynsVxY9utGlZkwj6uHGeMSd79d9lcQGBrFH6Ieol13UvWJ//M6SGq9XbDgzCfgSyKkvzqhK6Ms4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YnRDuGvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YnRDuGvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4818C32782;
	Tue, 25 Jun 2024 04:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719288985;
	bh=jaU1dFMCHeLtPFeIkJ3O3z2Ivlachs5G8oeBqzdqHD8=;
	h=Date:To:From:Subject:From;
	b=YnRDuGvrQcuQtckfhMp4ZQCggpnK99sxFheiNlH7YQ8itINTOAoNe4l6haF5zX0au
	 Wngk6+Y1tBPFxKu5XF/Eiznv+2PmiA/tuuwVcm6BizA61wr9uVDvGzncdBQKpKGAb7
	 6Y82i6xalAHw5M812LRcCDsGdP3Ht9ZCyGqOld88=
Date: Mon, 24 Jun 2024 21:16:25 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] writeback-factor-out-balance_wb_limits-to-remove-repeated-code-v3-fix.patch removed from -mm tree
Message-Id: <20240625041625.C4818C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: writeback-factor-out-balance_wb_limits-to-remove-repeated-code-v3-fix
has been removed from the -mm tree.  Its filename was
     writeback-factor-out-balance_wb_limits-to-remove-repeated-code-v3-fix.patch

This patch was dropped because it was folded into writeback-factor-out-balance_wb_limits-to-remove-repeated-code.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: writeback-factor-out-balance_wb_limits-to-remove-repeated-code-v3-fix
Date: Tue Jun 11 02:50:38 PM PDT 2024

s/fileds/fields/ in comment

Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page-writeback.c~writeback-factor-out-balance_wb_limits-to-remove-repeated-code-v3-fix
+++ a/mm/page-writeback.c
@@ -1806,8 +1806,8 @@ static inline void wb_dirty_exceeded(str
 }
 
 /*
- * The limits fileds dirty_exceeded and pos_ratio won't be updated if wb is
- * in freerun state. Please don't use these invalid fileds in freerun case.
+ * The limits fields dirty_exceeded and pos_ratio won't be updated if wb is
+ * in freerun state. Please don't use these invalid fields in freerun case.
  */
 static void balance_wb_limits(struct dirty_throttle_control *dtc,
 			      bool strictlimit)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

writeback-factor-out-balance_wb_limits-to-remove-repeated-code.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-fix.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-4.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix.patch

