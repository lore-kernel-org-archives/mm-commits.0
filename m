Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D154596E
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291533; cv=none; b=s4G/MFBQvgOpoo72KidMPYO1QE/kEuhSHEMwFtGKO0hH+OtYLXB+fkB96v1+iXhgql9suZt0hJ4t7Q/Qx3AZ4DqhzT6yZYhq+cZWXqJ8hcJWwyliqSQAXuB85pZaptCT7K0raPLp1ki2tUAZK3fW4MhBRkFIBP1vRhVSlXQwcJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291533; c=relaxed/simple;
	bh=xaSsVTE26XhREsQcl6ND3YvRl35uaYV22e8xr+BewEs=;
	h=Date:To:From:Subject:Message-Id; b=lcgeWZHBj68qioFutY9cI7U7hkU4AGqZFNeUqx7aD/reQmc3TxMXtLP5Khq4e+x26C0Ewh/LzVHx35BniOKNlEyroIsTkiGym3u8g1ndKxak+UgXZdfSkNTZKwzJPnhZ+F75R6LWO+TCddCBM9OBnegZOsPG1BYj7X+012A4+ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FzBt3+UI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FzBt3+UI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28E7C32782;
	Tue, 25 Jun 2024 04:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291533;
	bh=xaSsVTE26XhREsQcl6ND3YvRl35uaYV22e8xr+BewEs=;
	h=Date:To:From:Subject:From;
	b=FzBt3+UIJHU7Jk/+1pyav7YzjjF4Gz+MOZzimoOXBKbxkv1z78YLyUGCXzFjdiiwb
	 shVjpSfep+Nc2EJhrubyF/ZcMHpQwbopYaxADit7AvFLgYlTaCrxyNoKv2y0MDALTw
	 MLOUeWO9CiOvQqMkmMTHHFZTlmglgSy7P0ltBdKg=
Date: Mon, 24 Jun 2024 21:58:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,willy@infradead.org,shy828301@gmail.com,lu.zhongjun@zte.com.cn,david@redhat.com,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-mark-racy-access-onhuge_anon_orders_always.patch removed from -mm tree
Message-Id: <20240625045852.F28E7C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: mark racy access onhuge_anon_orders_always
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-mark-racy-access-onhuge_anon_orders_always.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: mm/huge_memory: mark racy access onhuge_anon_orders_always
Date: Wed, 15 May 2024 10:47:54 +0800 (CST)

huge_anon_orders_always is accessed lockless, it is better to use the
READ_ONCE() wrapper.  This is not fixing any visible bug, hopefully this
can cease some KCSAN complains in the future.  Also do that for
huge_anon_orders_madvise.

Link: https://lkml.kernel.org/r/20240515104754889HqrahFPePOIE1UlANHVAh@zte.com.cn
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lu Zhongjun <lu.zhongjun@zte.com.cn>
Reviewed-by: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-mark-racy-access-onhuge_anon_orders_always
+++ a/include/linux/huge_mm.h
@@ -134,8 +134,8 @@ static inline bool hugepage_flags_enable
 	 * So we don't need to look at huge_anon_orders_inherit.
 	 */
 	return hugepage_global_enabled() ||
-	       huge_anon_orders_always ||
-	       huge_anon_orders_madvise;
+	       READ_ONCE(huge_anon_orders_always) ||
+	       READ_ONCE(huge_anon_orders_madvise);
 }
 
 static inline int highest_order(unsigned long orders)
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are


