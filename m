Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B107E9
	for <mm-commits@vger.kernel.org>; Thu, 19 Jun 2025 00:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750291868; cv=none; b=GlU+BCR/NMPlTSLzf191rH/gQAuVxiicLklIV1d/+zjJjJ0/sg5g2cmpNKZRA+vKfq2qHKX+GNJjuTgZlb4Jv6SwUnYUakaaI21ahJmxHeUFSA0KM7RltWQm75IWkmsQw6GRs1fprv5xo9hzjNI6vcE0KqwZkOndDXLT1Hwgxds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750291868; c=relaxed/simple;
	bh=VLqMgCTvW43//XLFSzP933IXAIxc1ms6n7Qc8q8nVxA=;
	h=Date:To:From:Subject:Message-Id; b=gqSUorwBPdGhnhCdIVgEuKPd+N5oSonFekWHF1q87IKWcB6ni5nappYxkPazTCw9S02hajjXB/2oJb+wn+gVLCk0uqf8ykxg1BJ31Q6mBng8ItA55C2tdsg3a3cHBc3T890Fcd6earZARRjjOeGELfC05CVRXo5jrgP6gp7g8Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QTZM7rBX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QTZM7rBX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423DFC4CEE7;
	Thu, 19 Jun 2025 00:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750291868;
	bh=VLqMgCTvW43//XLFSzP933IXAIxc1ms6n7Qc8q8nVxA=;
	h=Date:To:From:Subject:From;
	b=QTZM7rBX4cW+7TJeSXnuRDnfRts/p310hDTU9ihr+c4zmSJEb4G9a79LhHtdqVw3c
	 ilr4xFB1Y2garllHxsoDW6D5x8Ci95Oqyd3pnUbTCklOa6TkjhZ6r+gscZs7L1Sf2D
	 pcVkNse9m7QMPp8tjEBq5SA+Q20KrHfGmR4XAcrs=
Date: Wed, 18 Jun 2025 17:11:07 -0700
To: mm-commits@vger.kernel.org,mhocko@suse.com,kent.overstreet@linux.dev,hezhongkun.hzk@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-rename-the-oldflags-and-parameter-in-memalloc_flags_.patch removed from -mm tree
Message-Id: <20250619001108.423DFC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: rename the oldflags and parameter in memalloc_flags_*()
has been removed from the -mm tree.  Its filename was
     mm-rename-the-oldflags-and-parameter-in-memalloc_flags_.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Zhongkun He <hezhongkun.hzk@bytedance.com>
Subject: mm: rename the oldflags and parameter in memalloc_flags_*()
Date: Wed, 18 Jun 2025 15:03:28 +0800

The variable name oldflags can indeed be misleading, because it does not
store the complete original value of flags.  Instead, it records which
flags from the given set are not currently set.  So rename it.

Link: https://lkml.kernel.org/r/20250618070328.2192849-1-hezhongkun.hzk@bytedance.com
Signed-off-by: Zhongkun He <hezhongkun.hzk@bytedance.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/mm.h |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/include/linux/sched/mm.h~mm-rename-the-oldflags-and-parameter-in-memalloc_flags_
+++ a/include/linux/sched/mm.h
@@ -322,21 +322,22 @@ static inline void might_alloc(gfp_t gfp
 }
 
 /**
- * memalloc_flags_save - Add a PF_* flag to current->flags, save old value
+ * memalloc_flags_save - Add a PF_* flag to current->flags, return saved flags mask
  *
  * This allows PF_* flags to be conveniently added, irrespective of current
  * value, and then the old version restored with memalloc_flags_restore().
  */
-static inline unsigned memalloc_flags_save(unsigned flags)
+static inline unsigned int memalloc_flags_save(unsigned int flags_mask)
 {
-	unsigned oldflags = ~current->flags & flags;
-	current->flags |= flags;
-	return oldflags;
+	unsigned int saved_flags_mask = ~current->flags & flags_mask;
+
+	current->flags |= flags_mask;
+	return saved_flags_mask;
 }
 
-static inline void memalloc_flags_restore(unsigned flags)
+static inline void memalloc_flags_restore(unsigned int flags_mask)
 {
-	current->flags &= ~flags;
+	current->flags &= ~flags_mask;
 }
 
 /**
_

Patches currently in -mm which might be from hezhongkun.hzk@bytedance.com are


