Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8D2142E81
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291613; cv=none; b=iq7jAkYgq9wnxXjtsTo4vr0qy1dLaNQ1fLnFtoe8nizkLAWTpfZPxb0lXIs8AiXiTiQiDBN2Qq2d7FbdsCY1TGsbvDpMlAd+zV5gd2skGLwxoSbqVMS4S4zba/DAjZ8TS3Opz4RquUwNR/8Q1wfE0WgJ9I07E830RaxTZeWrbTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291613; c=relaxed/simple;
	bh=BbS7yEAKQDFQN2yZMk8ecIMs6TgGN+jT9DPBRrHon5M=;
	h=Date:To:From:Subject:Message-Id; b=BogOyBN417eG6W6xhsLjHf288EtWME2FFLBRm6GGsHNXInmh75k4gi4JOdxcteFq0Y19B9IIewMbmAx1FFU2BHbxG6GPNQEikbU9g3uKOOY/F7tzqfrfKyvqwt2fqfTvUoPOav8Ldq5nk4schH/dXs5dUnnu+lNp6ECIPbB13oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EAIbKdeQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EAIbKdeQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DB6C32782;
	Tue, 25 Jun 2024 05:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291613;
	bh=BbS7yEAKQDFQN2yZMk8ecIMs6TgGN+jT9DPBRrHon5M=;
	h=Date:To:From:Subject:From;
	b=EAIbKdeQwJB+5XyCOtp/HbGYmiuwYxy/pH73rpP7y5zqyokh6VyNYfH2tzMNLuEFX
	 p2QFZvQWEgcsDVQBs0aIslHAE+R724wv1NwJQigMMbITh+GbKcW/M2WYyJ9KqFT7au
	 JkfZJhJP0ALLfFkdPmvkZt75G1IKYlCki8NknxE0=
Date: Mon, 24 Jun 2024 22:00:12 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,yosryahmed@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,v-songbaohua@oppo.com,surenb@google.com,ryan.roberts@arm.com,rafael@kernel.org,pavel@ucw.cz,len.brown@intel.com,khalid.aziz@oracle.com,kasong@tencent.com,hughd@google.com,hch@infradead.org,hannes@cmpxchg.org,david@redhat.com,davem@davemloft.net,chrisl@kernel.org,baolin.wang@linux.alibaba.com,andreas@gaisler.com,hanchuanhua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-make-should_try_to_free_swap-support-large-folio.patch removed from -mm tree
Message-Id: <20240625050013.00DB6C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: make should_try_to_free_swap() support large-folio
has been removed from the -mm tree.  Its filename was
     mm-swap-make-should_try_to_free_swap-support-large-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chuanhua Han <hanchuanhua@oppo.com>
Subject: mm: swap: make should_try_to_free_swap() support large-folio
Date: Wed, 29 May 2024 20:28:23 +1200

The function should_try_to_free_swap() operates under the assumption that
swap-in always occurs at the normal page granularity, i.e.,
folio_nr_pages() = 1.  However, in reality, for large folios,
add_to_swap_cache() will invoke folio_ref_add(folio, nr).  To accommodate
large folio swap-in, this patch eliminates this assumption.

Link: https://lkml.kernel.org/r/20240529082824.150954-6-21cnbao@gmail.com
Signed-off-by: Chuanhua Han <hanchuanhua@oppo.com>
Co-developed-by: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-swap-make-should_try_to_free_swap-support-large-folio
+++ a/mm/memory.c
@@ -3919,7 +3919,7 @@ static inline bool should_try_to_free_sw
 	 * reference only in case it's likely that we'll be the exlusive user.
 	 */
 	return (fault_flags & FAULT_FLAG_WRITE) && !folio_test_ksm(folio) &&
-		folio_ref_count(folio) == 2;
+		folio_ref_count(folio) == (1 + folio_nr_pages(folio));
 }
 
 static vm_fault_t pte_marker_clear(struct vm_fault *vmf)
_

Patches currently in -mm which might be from hanchuanhua@oppo.com are


