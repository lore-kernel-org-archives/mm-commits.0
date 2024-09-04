Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976F978274
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423546; cv=none; b=CNvS6aySB0oMKgmaYZ2BnZuzHauJ27yY9Slk0HL+J0FZSdxtfCKGUQF0da6gqIaDHbPCBxHDAH4PR8cVovfxT8/TFSqt0QXXiJPqyAFDR0YBkwoPc63CwBdiV/36WYT/IMq7qUl0zAUIDHFz9C7UE2v/g+CtVuvmMKP1F0ZTld4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423546; c=relaxed/simple;
	bh=hmoq89F+iMMajmFFeqxZjn62x3IuDWWTg/rSg7zoZec=;
	h=Date:To:From:Subject:Message-Id; b=UnfgvUepj79w9oT6oCjSJ05Cyd+evvIb64tDHD2ntd6R74ufOhxqhBZBeXNxWX1tJWpuPMtzyzFPF7Ppr1jip7XKySf/41Q0RYvXHKOAqhi2uyiC3tA6dbsFyDswaNN9pJRlrYtjEXS/wGZSLMkTUOAjR9aGsruU214bhucYLPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TxPOSNjN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TxPOSNjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B63EC4CEC2;
	Wed,  4 Sep 2024 04:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423546;
	bh=hmoq89F+iMMajmFFeqxZjn62x3IuDWWTg/rSg7zoZec=;
	h=Date:To:From:Subject:From;
	b=TxPOSNjNSQoLTJZ+BOYG+kC8W20kiy6b187FBlHZ1deqOYkcbsSUD30ZJKqef3f3P
	 tGEB6VuBm0bSs7wApgH6PegYb5vUDmEVgiuOBSTD2ahclXNDzqRSdLx0+6tG0Rmv4q
	 SJPsgzcRaNAW7fNinOHxi6Yh2DT/6UmmtJ3dEMig=
Date: Tue, 03 Sep 2024 21:19:05 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,me@yhndnzj.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-cgroup-v2-clarify-that-zswapwriteback-is-ignored-if-zswap-is-disabled.patch removed from -mm tree
Message-Id: <20240904041906.6B63EC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation/cgroup-v2: clarify that zswap.writeback is ignored if zswap is disabled
has been removed from the -mm tree.  Its filename was
     documentation-cgroup-v2-clarify-that-zswapwriteback-is-ignored-if-zswap-is-disabled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Yuan <me@yhndnzj.com>
Subject: Documentation/cgroup-v2: clarify that zswap.writeback is ignored if zswap is disabled
Date: Fri, 23 Aug 2024 16:27:11 +0000

As discussed in [1], zswap-related settings natually lose their effect
when zswap is disabled, specifically zswap.writeback here.  Be explicit
about this behavior.

[1] https://lore.kernel.org/linux-kernel/CAKEwX=Mhbwhh-=xxCU-RjMXS_n=RpV3Gtznb2m_3JgL+jzz++g@mail.gmail.com/

[akpm@linux-foundation.org: fix/simplify text]
Link: https://lkml.kernel.org/r/20240823162506.12117-3-me@yhndnzj.com
Signed-off-by: Mike Yuan <me@yhndnzj.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/admin-guide/cgroup-v2.rst~documentation-cgroup-v2-clarify-that-zswapwriteback-is-ignored-if-zswap-is-disabled
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1755,6 +1755,8 @@ The following nested keys are defined.
 
 	Note that this is subtly different from setting memory.swap.max to
 	0, as it still allows for pages to be written to the zswap pool.
+	This setting has no effect if zswap is disabled, and swapping
+	is allowed unless memory.swap.max is set to 0.
 
   memory.pressure
 	A read-only nested-keyed file.
_

Patches currently in -mm which might be from me@yhndnzj.com are


