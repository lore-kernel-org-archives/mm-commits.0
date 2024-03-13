Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EA560DD8
	for <mm-commits@vger.kernel.org>; Wed, 13 Mar 2024 19:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710357186; cv=none; b=GoB0MvEGyfeJQqZs/f7BK59AVcK5SZtj56G9i8AV2bG3KpnhY/efSAdm4tTssiAzGTYAbLkxWBUvOwRhVDo/TDnDua/T/ko5S1bord4/sPsdeXT0n8OtfQdKSDwoLPYmvWdD9egf+FOkoetQGzkjUaCs8KxotpcZ1kg3SoeC06A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710357186; c=relaxed/simple;
	bh=LzB9jVyGbdEPUt0pxdyKfh+c+pCzWEjHVKF0LJLOIZY=;
	h=Date:To:From:Subject:Message-Id; b=I+9r0s6YeGBhFKfgt/OcpW1bkE5ntbvz7cu10zzaD079GW0j6wqtSHH95Dgy7D3bIUuicHGb0WkzYK98QlUaSdeZYrn6dJhioTa3X5lDxYJrEJzh3bFt++yYHIMw44FdRmA10VKQNX8WMfgK7fc+SJ59vuHGatE2DZAO+VZiYuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=opOfB5l8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="opOfB5l8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D680C43142;
	Wed, 13 Mar 2024 19:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710357185;
	bh=LzB9jVyGbdEPUt0pxdyKfh+c+pCzWEjHVKF0LJLOIZY=;
	h=Date:To:From:Subject:From;
	b=opOfB5l8prPtHTGy4LM8vV/brfR8szXMOLn+G4akppll6QjGzyRn/lxvHyXyIIDJs
	 5UsyiUgbR82ES+K0iW7hkqsHsqG5QLlqbTj3abEAYqzLsaJDSkTPmxzkZiCeJoLAdS
	 oWo+DGzmFPtRMTEJiVnAsXp6swN8AAbR7NwEuovA=
Date: Wed, 13 Mar 2024 12:13:04 -0700
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,nphamcs@gmail.com,herbert@gondor.apana.org.au,hannes@cmpxchg.org,ddstreet@ieee.org,davem@davemloft.net,chrisl@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] crypto-introduce-acomp_is_async-to-expose-if-comp-drivers-might-sleep.patch removed from -mm tree
Message-Id: <20240313191305.5D680C43142@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crypto: introduce: acomp_is_async to expose if comp drivers might sleep
has been removed from the -mm tree.  Its filename was
     crypto-introduce-acomp_is_async-to-expose-if-comp-drivers-might-sleep.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: crypto: introduce: acomp_is_async to expose if comp drivers might sleep
Date: Thu, 22 Feb 2024 21:11:34 +1300

acomp's users might want to know if acomp is really async to optimize
themselves.  One typical user which can benefit from exposed async stat is
zswap.

In zswap, zsmalloc is the most commonly used allocator for (and perhaps
the only one).  For zsmalloc, we cannot sleep while we map the compressed
memory, so we copy it to a temporary buffer.  By knowing the alg won't
sleep can help zswap to avoid the need for a buffer.  This shows
noticeable improvement in load/store latency of zswap.

Link: https://lkml.kernel.org/r/20240222081135.173040-2-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/crypto/acompress.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/crypto/acompress.h~crypto-introduce-acomp_is_async-to-expose-if-comp-drivers-might-sleep
+++ a/include/crypto/acompress.h
@@ -160,6 +160,12 @@ static inline void acomp_request_set_tfm
 	req->base.tfm = crypto_acomp_tfm(tfm);
 }
 
+static inline bool acomp_is_async(struct crypto_acomp *tfm)
+{
+	return crypto_comp_alg_common(tfm)->base.cra_flags &
+	       CRYPTO_ALG_ASYNC;
+}
+
 static inline struct crypto_acomp *crypto_acomp_reqtfm(struct acomp_req *req)
 {
 	return __crypto_acomp_tfm(req->base.tfm);
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are


