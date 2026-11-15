Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794768642;
	b=MCM9Abbh0vEYkgbIlV0YkLC1HSF8p5M846WL3UEEpdUWCbiwl0OP38EHxEud9RG3jub0
	 4ErKl+2LEHSFFUIW0+RVBPv5/3f65s/NWXaWYmUBb9ytjND9Da8WsjK/k+x1E8nnkxpdD
	 G/RTHea08+xVUlPiqKYxJ+qEiSAqhGlJNIudSxqVK3dw5U9n8iP8Y1dNwIPRmp9VaFndr
	 xy8JK73kGdqyH+PNvwLDiuOp0biOtgFH9K1K+ZPpKyyuxRKDJdquoyWcfAI8oYxIBdZYO
	 UJdwtk+LTH4hcSjufwXodxp1NhMEWPJZJPZrC7LtpjP97kmEXInZ8mZ5Y/zNhcF03ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794768642;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=EQH0+FV5XWU6Um47gRD/GcbuG1A02dmPqt/ikzcQsvU=;
	b=bUAiD7XnT4+xsN9iBugpI1RqTuGjnizMvZ6MytWg2gnA7hYW+sYRHqqV1uOD6WTy//Ey
	 CTkqr/WXS7/X+2JLiichUvseLUxvwswmnGs7bmJWwK3b4YbjcZNW2P8Chhn6lBmLkcN73
	 0Zr0UDHnZEVDb7ubHSDYQ0Y/dvRMt6drOUlLct6nwGmRhvk34b6UkGc2rKHQML5PD+NgC
	 dZkbZIm38YEwh8maDBmlLv9Dgu9M1g7Z/RK0aDo+aJQKOGD/mpQ93FHhiyAor1oe3aCgM
	 GyP2m6Ow5H08jZaabY6LANDnrMEVqZu++vGL4/paxs/g/wY9f5LCOf/mVRehxlycWzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pJXD12iW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D954606A31D
	for <mm-commits@vger.kernel.org>; Sun, 15 Nov 2026 18:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pJXD12iW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 202FD1F000C4;
	Sun, 15 Nov 2026 18:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794768642;
	bh=EQH0+FV5XWU6Um47gRD/GcbuG1A02dmPqt/ikzcQsvU=;
	h=Date:To:From:Subject;
	b=pJXD12iWKP0VQ09Jz8yiCwFRmoenq7LiWUfW4ALaAAOVvJhvqaIctvBcgi8NwJ9LU
	 WI9jHfp2nF/5PGThYJjuFnkWQFgaPeTN+PtCzt3Qq0XHc2tr4J8Zu8xnGhSM+JEWhb
	 hvmgQ1vUWUQ0FtFRhNivq5wNGR8KJJ/+UPkm09vs=
Date: Sun, 15 Nov 2026 10:50:41 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,
	sj@kernel.org,shakeel.butt@linux.dev,ryncsn@gmail.com,ridong.chen@linux.dev,
	qi.zheng@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,
	lianux.mm@gmail.com,lance.yang@linux.dev,kasong@tencent.com,
	hannes@cmpxchg.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,
	baohua@kernel.org,axelrasmussen@google.com,david@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-memory-management-mglru-multi-gen-lru-update.patch added to mm-hotfixes-unstable branch
Message-Id: <20261115185042.202FD1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: MAINTAINERS: MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU) update
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-memory-management-mglru-multi-gen-lru-update.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-memory-management-mglru-multi-gen-lru-update.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: MAINTAINERS: MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU) update
Date: Mon, 09 Nov 2026 19:31:53 +0100

Patch series "MAINTAINERS: MM updates (2)".

Some more MAINTAINERS updates with a focus on MGLRU and reclaim this time.


This patch (of 2):

MGLRU is currently the only MM component without a dedicated component
maintainer.  Fortunately, Kairui and Barry have been actively contributing
to MGLRU and have volunteered to take on more responsibility by officially
taking care of it.

Given that Kairui is already an established MM component maintainer in a
related MM component (SWAP), add him as an MGLRU maintainer right away.

For Barry, the idea is to transition him towards a component maintainer
role over the coming months, starting by moving him to the top of the
reviewer list.

Link: https://lore.kernel.org/20261109-maintainers_mglru-v1-0-c25e6de60bcc@kernel.org
Link: https://lore.kernel.org/20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Kairui Song <kasong@tencent.com>
Acked-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: SJ Park <sj@kernel.org>
Acked-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/MAINTAINERS~maintainers-memory-management-mglru-multi-gen-lru-update
+++ a/MAINTAINERS
@@ -17633,10 +17633,10 @@ K:	(?i:vmemmap)
 
 MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
 M:	Andrew Morton <akpm@linux-foundation.org>
-R:	Kairui Song <kasong@tencent.com>
+M:	Kairui Song <kasong@tencent.com>
+R:	Barry Song <baohua@kernel.org>
 R:	Qi Zheng <qi.zheng@linux.dev>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
-R:	Barry Song <baohua@kernel.org>
 R:	Axel Rasmussen <axelrasmussen@google.com>
 R:	Yuanchu Xie <yuanchu@google.com>
 R:	Wei Xu <weixugc@google.com>
_

Patches currently in -mm which might be from david@kernel.org are

mm-huge_memory-flush-dirty-file-pmds-before-removing-rmap.patch
maintainers-memory-management-mglru-multi-gen-lru-update.patch
maintainers-remove-myself-from-memory-management-reclaim.patch
mm-mprotect-dont-skip-uffd-marker-install-when-racing-with-pte-table-reclaim.patch
mm-khugepaged-free-unused-page-table-when-setting-a-huge-pmd-fails.patch

