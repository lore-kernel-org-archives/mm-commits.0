Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0F2188583
	for <mm-commits@vger.kernel.org>; Mon,  4 Nov 2024 05:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730696401; cv=none; b=UI2EFIz4NRE+5vBXo5tpGldQ/mz/fAs4s0kKqgro/uoc4hOrQVJNXi3I5tSJzaKG2pwAxEg5WI48Kv+3kO0Tj4UWsGRtlvsCOpVAzOvGjgJpY7Cv1Xs949uvIxHco5QjlsXqTzrxrOQhtjBuKJbo7/cKXYZTwweTFLF++rN1UtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730696401; c=relaxed/simple;
	bh=39xshRk0LtGW2b4vUAQZzQM/hF77V94XEOaBLpu4psg=;
	h=Date:To:From:Subject:Message-Id; b=gorlFZr2ixOQ0JX6PuzyErrScTig4tyIg9DT/0gYjpHJPKuRxNM4ZKRga57NM9H0nw2JRH3bYtSxU+tmTjK0tDn78+2/2B7N/QijHHVJDPaoFQA37QvsN6RoZKrafD8JWkquswAbTcAvoz2z1LGxrP/hAkaNxd8C2IPuIzUJ48Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cxH1+r1C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cxH1+r1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA13C4CECE;
	Mon,  4 Nov 2024 05:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730696401;
	bh=39xshRk0LtGW2b4vUAQZzQM/hF77V94XEOaBLpu4psg=;
	h=Date:To:From:Subject:From;
	b=cxH1+r1C3doqyHTJz1LJ8JfmOMIPqITx7aPYm2JxGq6lTFYz4FQyt8vyDvERXBiL0
	 T2YYdGxSPHvQ0CPwJuFiUIfK8w661gkPtny9EMlTmO0pvPPdjnyGIJUMQl8y18mfON
	 4QTXGYB7+/RBAv9HsvWzEB7dr10vkRSaOU7w/6/g=
Date: Sun, 03 Nov 2024 21:00:00 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,songmuchun@bytedance.com,shakeel.butt@linux.dev,sfr@canb.auug.org.au,roman.gushchin@linux.dev,mhocko@suse.com,hughd@google.com,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] memcg-workingset-remove-folio_memcg_rcu-usage-fix.patch removed from -mm tree
Message-Id: <20241104050001.2DA13C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg-workingset-remove-folio_memcg_rcu-usage-fix
has been removed from the -mm tree.  Its filename was
     memcg-workingset-remove-folio_memcg_rcu-usage-fix.patch

This patch was dropped because it was folded into memcg-workingset-remove-folio_memcg_rcu-usage.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-workingset-remove-folio_memcg_rcu-usage-fix
Date: Sun Oct 27 05:59:41 PM PDT 2024

fix build: provide folio_memcg_charged stub for CONFIG_MEMCG=n

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/linux/memcontrol.h~memcg-workingset-remove-folio_memcg_rcu-usage-fix
+++ a/include/linux/memcontrol.h
@@ -1055,6 +1055,11 @@ static inline struct mem_cgroup *folio_m
 	return NULL;
 }
 
+static inline bool folio_memcg_charged(struct folio *folio)
+{
+	return false;
+}
+
 static inline struct mem_cgroup *folio_memcg_check(struct folio *folio)
 {
 	return NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-keep-track-of-free-highatomic-fix.patch
mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling-fix.patch
mm-fix-__wp_page_copy_user-fallback-path-for-remote-mm-fix.patch
mm-memoryc-remove-stray-newline-at-top-of-file.patch
memcg-workingset-remove-folio_memcg_rcu-usage.patch
bootmem-stop-using-page-index-fix.patch
vma-detect-infinite-loop-in-vma-tree-fix.patch
maple_tree-add-a-test-checking-storing-null-fix.patch
fs-proc-kcorec-fix-coccinelle-reported-error-instances-fix.patch

