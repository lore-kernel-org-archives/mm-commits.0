Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4068736195E
	for <mm-commits@vger.kernel.org>; Wed, 16 Sep 2026 00:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789520070; cv=none; b=gqHJZ1aG6D2jbYWThnfrrv/DWoG5Q70Ua/cCKE5N5YtwG72wiX3WCoX4tbAOiB3V3LPuCXkNUriDXBVbXrd6vGAegU7uKFAa/nPHLHwyFlyjz8ax34Hlcur1Po9votn156bfIMhxuRfGRU38JjrbHUNKViLltFSnfW58Gerjr38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789520070; c=relaxed/simple;
	bh=2WYOhpCIJwD3Gx8/KYBRWf2L63s2T1GCulpj/FYPOBc=;
	h=Date:To:From:Subject:Message-Id; b=lPLB257a2olYIFHCbamwp3+cU2aNNv3uQFLO0sNiAExXwCzU+/iIUuzfeA5maoVFnTEPVESngGqH93FHeblQ7Wz98Tb0ylHwZJnCg2pnxJAQoEHELAwHd0V7TIL5DUJ3NNg3q7sgcd35UaSKSJjaocGf5LVFB3dn+woFlcNcym8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uHXLyWA8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uHXLyWA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF0B1F000FF;
	Wed, 16 Sep 2026 00:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789520068;
	bh=ot+2MWZTvH1q9HcqBYkxZeBkSexc8cfQAbjrQP/EncY=;
	h=Date:To:From:Subject;
	b=uHXLyWA8SdROVmrnepe5ZWcIJK3FeY7TvYRF38mNuMOA0mxVQ+iKdKK3IeHB/2o1O
	 wA/rxxES+qR8Z329549X8n5l6ELaFe5DLd9cedm6JyRkzFQN0i1ZJlpXBzJ0ntVTcz
	 WOh/MbBHz3kjQiRSTVeOPRcmbewZ3t1QubCb6rg8=
Date: Tue, 15 Sep 2026 17:54:28 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,hanchuanhua802@gmail.com,david@kernel.org,baoquan.he@linux.dev,axelrasmussen@google.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-restore-accidentally-removed-seq-max_seq-check.patch added to mm-new branch
Message-Id: <20260916005428.AFF0B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: restore accidentally removed seq < max_seq check
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-restore-accidentally-removed-seq-max_seq-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-restore-accidentally-removed-seq-max_seq-check.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/mglru: restore accidentally removed seq < max_seq check
Date: Tue, 15 Sep 2026 18:15:56 +0800

Since commit 798c0330c2ca ("mm/mglru: rework aging feedback"), the
following sanity check was accidentally removed:

       if (seq < max_seq)
               return 0;

That means we can perform aging for any value less than or equal to
max_gen_nr.

This has been inconsistent with
Documentation/admin-guide/mm/multigen_lru.rst, which states:

 Users can write the following command to ``lru_gen`` to create a new
 generation ``max_gen_nr+1``:

     ``+ memcg_id node_id max_gen_nr [can_swap [force_scan]]``

The correct semantics are that writing a value smaller than max_gen_nr
should return 0, since the requested generation already exists.

Link: https://lore.kernel.org/20260915101556.50467-1-baohua@kernel.org
Fixes: 798c0330c2ca ("mm/mglru: rework aging feedback")
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chuanhua Han <hanchuanhua802@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
---

 mm/vmscan.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/vmscan.c~mm-mglru-restore-accidentally-removed-seq-max_seq-check
+++ a/mm/vmscan.c
@@ -5837,6 +5837,9 @@ static int run_aging(struct lruvec *lruv
 {
 	DEFINE_MAX_SEQ(lruvec);
 
+	if (seq < max_seq)
+		return 0;
+
 	if (seq > max_seq)
 		return -EINVAL;
 
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-mglru-make-retry-logic-explicit-in-isolate_folios.patch
mm-mglru-make-retry-logic-explicit-in-isolate_folios-fix.patch
mm-vmscan-avoid-pointless-large-folio-splits-without-swap.patch
mm-mglru-separate-folio-generation-update-from-lru-accounting.patch
mm-mglru-batch-update-lrugen-nr_pages-in-inc_min_seq.patch
mm-mglru-enhance-cold-hot-inversion-handling-in-inc_min_seq.patch
mm-mglru-exclude-folios-promoted-by-aging-from-protected-in-inc_min_seq.patch
mm-mglru-make-lru-folio-prefetch-helper-an-inline-function.patch
mm-mglru-move-folios-from-oldest-gen-to-second-oldest-gen-from-head-to-tail.patch
mm-mglru-batch-move-folios-to-the-second-oldest-gens-lru.patch
mm-mglru-restore-accidentally-removed-seq-max_seq-check.patch

