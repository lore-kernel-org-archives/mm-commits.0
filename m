Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7567524F
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 02:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235369; cv=none; b=sE0tCdLThwdk29KYCWCRsoGyZk7SCU06gTpV7k+DWkxGh/2vIX2Ijx8+L3NdqhnFSdAusyou6Lm8EDO3x5VCbcuzcNfsxYNBfi5XxDbJiHtDNMiaukCw9Yl+JidYoxa0pDXfqjWTGoRDIdP2Axp3ldPlmcDFtdefITSbIu7zddk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235369; c=relaxed/simple;
	bh=DWRSLBJApJyyDWiQxHWNwPutg27/z054zi8aLiS9gBU=;
	h=Date:To:From:Subject:Message-Id; b=ga6dr5IWXShX484cnvu0kjaEAvCYDRhCu7Ucd2dfbMezOm1PVfpN3VpCoEP35LuSl23ib+bdZryYw6ODg4m1gVpxo5iBrt1z/JBRhaC7Yq9jOVtolMWJOKVhD4Ge130BXhdw1IMFiP/9dIbZyqR7RC7iQakiOi61+t53mjbT1sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rtnpmlg5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rtnpmlg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25EF7C433F1;
	Fri, 26 Jan 2024 02:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235369;
	bh=DWRSLBJApJyyDWiQxHWNwPutg27/z054zi8aLiS9gBU=;
	h=Date:To:From:Subject:From;
	b=rtnpmlg58LKoixcUny7xSuVhA30DBx5fPcsnzV+H55OtK3vSskf9xI6jqsSR2Hezv
	 zi9rfjhnDSopyiqSc22YeRanlG8nBzEoeNdGAhwizmbnJJpTqy/NiJDohfp2VfjZQu
	 lDo6aOkK38fgunDapGNGIh/eht025ceqmkLPu8Cs=
Date: Thu, 25 Jan 2024 18:16:06 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,chrisl@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-lru_gen-try-to-prefetch-next-page-when-canning-lru.patch removed from -mm tree
Message-Id: <20240126021609.25EF7C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, lru_gen: try to prefetch next page when scanning LRU
has been removed from the -mm tree.  Its filename was
     mm-lru_gen-try-to-prefetch-next-page-when-canning-lru.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, lru_gen: try to prefetch next page when scanning LRU
Date: Fri, 12 Jan 2024 02:33:21 +0800

Prefetch for inactive/active LRU have been long exiting, apply the same
optimization for MGLRU.

Ramdisk based swap test in a 4G memcg on a EPYC 7K62 with:

  memcached -u nobody -m 16384 -s /tmp/memcached.socket \
    -a 0766 -t 16 -B binary &

  memtier_benchmark -S /tmp/memcached.socket \
    -P memcache_binary -n allkeys \
    --key-minimum=1 --key-maximum=16000000 -d 1024 \
    --ratio=1:0 --key-pattern=P:P -c 2 -t 16 --pipeline 8 -x 6

Average result of 18 test runs:

Before:           44017.78 Ops/sec
After patch 1-3:  44890.50 Ops/sec (+1.8%)

Ramdisk fio test in a 4G memcg on a EPYC 7K62 with:

  fio -name=mglru --numjobs=16 --directory=/mnt --size=960m \
    --buffered=1 --ioengine=io_uring --iodepth=128 \
    --iodepth_batch_submit=32 --iodepth_batch_complete=32 \
    --rw=randread --random_distribution=zipf:0.5 --norandommap \
    --time_based --ramp_time=1m --runtime=5m --group_reporting

Before this patch:
bw (  MiB/s): min= 7644, max= 9293, per=100.00%, avg=8777.77, stdev=16.59, samples=9568
iops        : min=1956954, max=2379053, avg=2247108.51, stdev=4247.22, samples=9568

After this patch (+7.5%):
bw (  MiB/s): min= 8462, max= 9902, per=100.00%, avg=9444.77, stdev=16.43, samples=9568
iops        : min=2166433, max=2535135, avg=2417858.23, stdev=4205.15, samples=9568

Prefetch is highly related to timing and architecture so it may only help in
certain cases, some extra test showed at least no regression here for
the series:

Ramdisk memtier test above in a 8G memcg on an Intel i7-9700:

  memtier_benchmark -S /tmp/memcached.socket \
    -P memcache_binary -n allkeys --key-minimum=1 \
    --key-maximum=36000000 --key-pattern=P:P -c 1 -t 12 \
    --ratio 1:0 --pipeline 8 -d 1024 -x 4

Average result of 12 test runs:

Before:           61241.96 Ops/sec
After patch 1-3:  61268.53 Ops/sec (+0.0%)

Link: https://lkml.kernel.org/r/20240111183321.19984-4-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/mm/vmscan.c~mm-lru_gen-try-to-prefetch-next-page-when-canning-lru
+++ a/mm/vmscan.c
@@ -3773,10 +3773,12 @@ static bool inc_min_seq(struct lruvec *l
 			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
 
-			if (unlikely(list_is_first(&folio->lru, head)))
+			if (unlikely(list_is_first(&folio->lru, head))) {
 				prev = NULL;
-			else
+			} else {
 				prev = lru_to_folio(&folio->lru);
+				prefetchw(&prev->flags);
+			}
 
 			new_gen = folio_inc_gen(lruvec, folio, false, &batch);
 			lru_gen_try_inc_bulk(lrugen, folio, bulk_gen, new_gen, type, zone, &batch);
@@ -4452,10 +4454,12 @@ static int scan_folios(struct lruvec *lr
 			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
 
 			scanned += delta;
-			if (unlikely(list_is_first(&folio->lru, head)))
+			if (unlikely(list_is_first(&folio->lru, head))) {
 				prev = NULL;
-			else
+			} else {
 				prev = lru_to_folio(&folio->lru);
+				prefetchw(&prev->flags);
+			}
 
 			if (sort_folio(lruvec, folio, sc, tier, bulk_gen, &batch))
 				sorted += delta;
_

Patches currently in -mm which might be from kasong@tencent.com are


