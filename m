Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3341E1EDA04
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119235; cv=none; b=CIkmnFbnj1Glhdsg3sse1LxIFmfqHtsRaj8aam1pcGslo+jKe1HDP+CWSE6R8a9KmEqrUT1SQQOkUeJjCGvoJcPg96fMrjnTVqV0DsIuZTMVL+SlgpAJCLn3Mzsagt1WNDssotLJNuOGUCwEzJ0iUfe0xC9GxTBU+kllDpi5Ows=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119235; c=relaxed/simple;
	bh=aUQYIwJIkiqQmv/59vsr7/E8/sb5xg8AcMdcsxlrY0c=;
	h=Date:To:From:Subject:Message-Id; b=C1b93Gz8OEvZlstL3DL5D2w6sQc+B0X52kfNOjJ7gYqvf/9Sd06Pn6P/wcVS/n3iJuaLlyNOaUL2IxUX6rCU4He4u2cs/X5ZYHNOHeZKNTPKaAz+eAoIB2FzEOKc6XeYufZqep3SDjKNtyZ8I0Rc2ZptinXX/X5ExYN+evqPt9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0EM1zXdV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0EM1zXdV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07395C4CEE4;
	Tue, 13 May 2025 06:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119235;
	bh=aUQYIwJIkiqQmv/59vsr7/E8/sb5xg8AcMdcsxlrY0c=;
	h=Date:To:From:Subject:From;
	b=0EM1zXdVNiOchEScxfYvzRfmPVAPt/mQseyXC9L8mabffP5S9Z4V7SmzB3kIvuN/H
	 hk2z7bLaXqA7cTi7bPrpamVObudDhTyIm/9nQM//n+QZGkzNSDrjnp7u3lSIOZEYzG
	 OPnkvNvLsW4jboBTHK4YD4Uy44f71PeMKJpE0pOo=
Date: Mon, 12 May 2025 23:53:54 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosry.ahmed@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,hezhongkun.hzk@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only.patch removed from -mm tree
Message-Id: <20250513065355.07395C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add max swappiness arg to lru_gen for anonymous memory only
has been removed from the -mm tree.  Its filename was
     mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhongkun He <hezhongkun.hzk@bytedance.com>
Subject: mm: add max swappiness arg to lru_gen for anonymous memory only
Date: Mon, 21 Apr 2025 17:13:30 +0800

The MGLRU already supports reclaiming only from anonymous memory via the
/sys/kernel/debug/lru_gen interface.  Now, memory.reclaim also supports
the swappiness=max parameter to enable reclaiming solely from anonymous
memory.  To unify the semantics of proactive reclaiming from anonymous
folios, the max parameter is introduced.

[hezhongkun.hzk@bytedance.com: use strcmp instead of strncmp, if swappiness is not set, use the default value]
  Link: https://lkml.kernel.org/r/20250507071057.3184240-1-hezhongkun.hzk@bytedance.com
[akpm@linux-foundation.org: tweak coding style]
Link: https://lkml.kernel.org/r/65181f7745d657d664d833c26d8a94cae40538b9.1745225696.git.hezhongkun.hzk@bytedance.com
Signed-off-by: Zhongkun He <hezhongkun.hzk@bytedance.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/multigen_lru.rst |    5 ++--
 mm/vmscan.c                                   |   19 ++++++++++++----
 2 files changed, 18 insertions(+), 6 deletions(-)

--- a/Documentation/admin-guide/mm/multigen_lru.rst~mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only
+++ a/Documentation/admin-guide/mm/multigen_lru.rst
@@ -151,8 +151,9 @@ generations less than or equal to ``min_
 ``min_gen_nr`` should be less than ``max_gen_nr-1``, since
 ``max_gen_nr`` and ``max_gen_nr-1`` are not fully aged (equivalent to
 the active list) and therefore cannot be evicted. ``swappiness``
-overrides the default value in ``/proc/sys/vm/swappiness``.
-``nr_to_reclaim`` limits the number of pages to evict.
+overrides the default value in ``/proc/sys/vm/swappiness`` and the valid
+range is [0-200, max], with max being exclusively used for the reclamation
+of anonymous memory. ``nr_to_reclaim`` limits the number of pages to evict.
 
 A typical use case is that a job scheduler runs this command before it
 tries to land a new job on a server. If it fails to materialize enough
--- a/mm/vmscan.c~mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only
+++ a/mm/vmscan.c
@@ -5588,24 +5588,35 @@ static ssize_t lru_gen_seq_write(struct
 	while ((cur = strsep(&next, ",;\n"))) {
 		int n;
 		int end;
-		char cmd;
+		char cmd, swap_string[5];
 		unsigned int memcg_id;
 		unsigned int nid;
 		unsigned long seq;
-		unsigned int swappiness = -1;
+		unsigned int swappiness;
 		unsigned long opt = -1;
 
 		cur = skip_spaces(cur);
 		if (!*cur)
 			continue;
 
-		n = sscanf(cur, "%c %u %u %lu %n %u %n %lu %n", &cmd, &memcg_id, &nid,
-			   &seq, &end, &swappiness, &end, &opt, &end);
+		n = sscanf(cur, "%c %u %u %lu %n %4s %n %lu %n", &cmd, &memcg_id, &nid,
+			   &seq, &end, swap_string, &end, &opt, &end);
 		if (n < 4 || cur[end]) {
 			err = -EINVAL;
 			break;
 		}
 
+		if (n == 4) {
+			swappiness = -1;
+		} else if (!strcmp("max", swap_string)) {
+			/* set by userspace for anonymous memory only */
+			swappiness = SWAPPINESS_ANON_ONLY;
+		} else {
+			err = kstrtouint(swap_string, 0, &swappiness);
+			if (err)
+				break;
+		}
+
 		err = run_cmd(cmd, memcg_id, nid, seq, &sc, swappiness, opt);
 		if (err)
 			break;
_

Patches currently in -mm which might be from hezhongkun.hzk@bytedance.com are

mm-cma-set-early_pfn-and-bitmap-as-a-union-in-cma_memrange.patch

