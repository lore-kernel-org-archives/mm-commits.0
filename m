Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832499;
	b=VD9laGJqZ4csFuCvEoEA8opcPQuXjQG771kTuDZhE225bjGJRLbklvoaXmZV3qdEaC4G
	 OaFy8SBPj6dvkjIICrjhL4ZAFKQyy2siWu68g60m502LvGHhAx5hxA28cEP6iffVQhqxM
	 q/HxGcftf/sgJwMzRbBdqu9Gl2nvILGGudMddnuN2RK8vdGa/CkJALpKxJyWLl1ictgoE
	 SPY/F40uw0bAcDScvfeCuB8SxcH7MB2HWBf9HQLyst9KPoi1lXBGEbmTPmxTlQr5NG/CF
	 4uEfey8V+jZsJcq1l5d3Qqv9Tz6iQmSPBg2VCb+rANGGzDo1Cs+pQOOw/1fr8Kb8boQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832499;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=fB52gu9hqJe/qOxkaMVobuZPogx0mWsVJGRZ8n3DXp8=;
	b=DIYXZ0DHbxGJ03x4ylZA1zMSanB2ixrNb4TE/aiD4zsKTVr7XgaFG2qjYwpU70mdqW7p
	 TcKFx14gewQ5vKs1xJOr+tu9YSR6RE4yxxgNCCfMKkxiqha2CpBYwDr8zXht3OJqHKarH
	 PNRyf/+XLJzh0NsyE3wnmbfUenQT49pOcwMW65UaqhgYWhUEnAgQ9CM3uHJeUBdFUy47Y
	 OibaVul68A+Q4gZAhuzckSy/cY5lfp96NYLsdh3yJbGmuCWwB7T1k6thMH+CMh4ZHfFCb
	 h/R8q8FU5/w+cQwjOCB76pARtVQxwyX+QnM//QenoTtBJ89UhrxnAVlxVc1ogBDd3bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fHZKXcU3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCDE606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fHZKXcU3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5831F1F01825;
	Sat, 24 Oct 2026 09:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832499;
	bh=fB52gu9hqJe/qOxkaMVobuZPogx0mWsVJGRZ8n3DXp8=;
	h=Date:To:From:Subject;
	b=fHZKXcU3uIhX8KAgNr04Mhj2/oU2P6WE0hx48hE3444tw1MBUFdD7ODxHDoZh2tB6
	 dl1o9/Ef5HKYVXdgYNXx0GsRZbzlXrfh5yo+AuY+nwjXx46i33AK0/mn03JF1RSID5
	 8LMsmkRPJb0ph9e6q5T4lD7tjmjJxAqwlqyGPZ9w=
Date: Sat, 24 Oct 2026 02:01:38 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,ricardo@marliere.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-mremap_test-validate-the-preamble-region-before-mapping-it.patch removed from -mm tree
Message-Id: <20261024090139.5831F1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: selftests/mm: mremap_test: Validate the preamble region before mapping it
has been removed from the -mm tree.  Its filename was
     selftests-mm-mremap_test-validate-the-preamble-region-before-mapping-it.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ricardo B. Marlière (SUSE) <ricardo@marliere.net>
Subject: selftests/mm: mremap_test: Validate the preamble region before mapping it
Date: Wed, 14 Oct 2026 15:46:46 -0300

remap_region() checks that the destination region is free before mapping
it, but not the preamble region placed right before it, so mapping the
preamble can intermittently fail with EEXIST:

  # Failed to map dest preamble region: File exists
  not ok 15 5MB mremap - Source 1MB-aligned, Dest 1MB-aligned with 40MB Preamble

This happens when the kernel's heap ASLR (arch_randomize_brk()) lands the
process heap inside that unchecked range.  Confirmed by correlating
brk(NULL) at startup with pass/fail across 60 runs: every failure had brk
land inside that range.

Fix it by including the preamble in the free-region check.

Link: https://lore.kernel.org/20261014-selftests-mm-mremap_preamble-v1-1-2e97f501cb56@marliere.net
Signed-off-by: Ricardo B. Marlière (SUSE) <ricardo@marliere.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
---

 tools/testing/selftests/mm/mremap_test.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/mremap_test.c~selftests-mm-mremap_test-validate-the-preamble-region-before-mapping-it
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -1006,8 +1006,10 @@ static long long remap_region(struct con
 	if (!((unsigned long long) addr & c.dest_alignment))
 		addr = (void *) ((unsigned long long) addr | c.dest_alignment);
 
-	/* Don't destroy existing mappings unless expected to overlap */
-	while (!is_remap_region_valid(addr, c.region_size) && !c.overlapping) {
+	/* Don't destroy existing mappings unless expected to overlap. */
+	while (!is_remap_region_valid(addr - c.dest_preamble_size,
+				      c.dest_preamble_size + c.region_size) &&
+	       !c.overlapping) {
 		/* Check for unsigned overflow */
 		tmp_addr = addr + c.dest_alignment;
 		if (tmp_addr < addr) {
_

Patches currently in -mm which might be from ricardo@marliere.net are


