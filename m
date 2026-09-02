Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810C7296BBC
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 02:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788317996; cv=none; b=Pjs3YS7WQvY4tfuOgTg7azuKLTscAAwl/kqyZWNsqK9WOBNta7A2CqYz87/IxCJIz/GTSktzsIkgVxCTpfnu/uLbZRqFUzwQ75olx4JeB7+f41fHdIHVNO+LBC7xnSc1hga2wr+/so4LoOeGLgvdJPDe1IM+sBFcG/gdAEv7+EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788317996; c=relaxed/simple;
	bh=kLAzHFlDwtc+K8bQHaIKG2gAPSYEuVcsxnd/NrZoR2k=;
	h=Date:To:From:Subject:Message-Id; b=eQ8ER4UI3r/6rnkHJCIK1nKxt7j0J1/Jp5g9FK1NE7zRStcm9fR2Y8tnbm93ORVgpkYLLjTETtQDhSklKn3Tk2lhxZYVp9YIckQ1e6A44plOMwRLz+UClmaHsTZd0VLy0sXLLxOrlZ9hGL0AOKk+4S4qyQqgnGdtucYoFFj5RNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=trgbJmlv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="trgbJmlv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120361F000E9;
	Wed,  2 Sep 2026 02:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788317994;
	bh=C4qszz4tGSu3hyo+/A93LZnXYeMAwIk1cCDJrgCuTHM=;
	h=Date:To:From:Subject;
	b=trgbJmlvg40UqxYof2pwKC7bND96qU76zqZhkigyoacjFEMDJfq51aC27UtvEcHHE
	 uOCq0QUuEvTFFp524MDUieAeCXaE++9u5sQt3rPGQ36+4oc1FrT+lSxuiZfXLP6ty4
	 Q9BGbfKM/gBpdRwSzKR3SbuwyaSiLaEL4gPGwg24=
Date: Tue, 01 Sep 2026 19:59:53 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,xueyuan.chen21@gmail.com,weixugc@google.com,stevensd@chromium.org,shakeel.butt@linux.dev,ridong.chen@linux.dev,mhocko@kernel.org,ljs@kernel.org,lianux.mm@gmail.com,kunwu.chan@gmail.com,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-separate-folio-generation-update-from-lru-accounting.patch added to mm-new branch
Message-Id: <20260902025954.120361F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: separate folio generation update from LRU accounting
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-separate-folio-generation-update-from-lru-accounting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-separate-folio-generation-update-from-lru-accounting.patch

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
Subject: mm/mglru: separate folio generation update from LRU accounting
Date: Wed, 2 Sep 2026 07:24:15 +0800

Patch series "mm/mglru: speed up inc_min_seq() and fix cold/hot
inversions", v3.


This is an aging speedup series split out from the MGLRU swappiness series
[1], with the inc_min_seq changes separated to make them easier to review.

Currently, inc_min_seq() has two primary issues that affect both
performance and folio hotness assessment:

1. It processes each folio one by one, while many operations can be
   batched or skipped.  For example, a batch of folios can be moved
   together from the oldest generation to the second-oldest generation,
   and the associated counting can also be done in batches.

2. It may cause potential cold/hot inversion by placing promoted
   folios (which have been scanned and found to have young PTEs) behind
   non-promoted folios.  A similar inversion can also occur among
   non-promoted folios, as tail folios from the oldest generation are
   placed before head folios when moving them to the second-oldest
   generation.

This series tries to batch operations as much as possible and fix the
potential cold/hot inversion by keeping promoted folios ahead of
non-promoted folios, while also preserving the order of non-promoted
folios when moving them from the oldest generation to the second-oldest
generation.

Minor issue: inc_min_seq() also counts protected folios improperly, as
promoted folios should be skipped, as in sort_folio().

We need a stable workload with a stable number of folios to measure aging
and evaluate the speedup in inc_min_seq().  So I asked ChatGPT to generate
the microbenchmark below.  It ages an LRU vec containing 512 MB of memory
100 times:

 #define _GNU_SOURCE

 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <stdint.h>
 #include <unistd.h>
 #include <fcntl.h>
 #include <errno.h>
 #include <time.h>
 #include <sys/mman.h>

 #define SIZE		(512UL * 1024 * 1024)
 #define LRU_GEN		"/sys/kernel/debug/lru_gen"
 #define TARGET_CGROUP	"/system.slice/agetest.scope"
 #define START_GEN	3
 #define END_GEN	103

 static long long nsec_diff(const struct timespec *start,
 			   const struct timespec *end)
 {
 	return (end->tv_sec - start->tv_sec) * 1000000000LL +
 	       (end->tv_nsec - start->tv_nsec);
 }

 static int find_memcg_id(void)
 {
 	FILE *fp;
 	char line[4096];
 	int memcg_id;

 	fp = fopen(LRU_GEN, "r");
 	if (!fp) {
 		perror("fopen lru_gen");
 		return -1;
 	}

 	while (fgets(line, sizeof(line), fp)) {
 		char *p;

 		if (strncmp(line, "memcg ", 6))
 			continue;

 		p = line + 6;

 		if (sscanf(p, "%d", &memcg_id) != 1)
 			continue;

 		/*
 		 * The memcg path follows the numeric ID.
 		 */
 		p = strchr(p, ' ');
 		if (!p)
 			continue;

 		if (strstr(p, TARGET_CGROUP)) {
 			fclose(fp);
 			return memcg_id;
 		}
 	}

 	fclose(fp);

 	fprintf(stderr, "Cannot find %s\n", TARGET_CGROUP);
 	return -1;
 }

 int main(void)
 {
 	void *addr;
 	int memcg_id;
 	int fd;
 	long long total_ns = 0;

 	/*
 	 * mmap 512 MB and touch every page.
 	 */
 	addr = mmap(NULL, SIZE, PROT_READ | PROT_WRITE,
 		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	if (addr == MAP_FAILED) {
 		perror("mmap");
 		return 1;
 	}

 	memset(addr, 0x55, SIZE);

 	printf("mmap: %p, size: %lu MB\n",
 	       addr, SIZE / 1024 / 1024);

 	/*
 	 * Find the memcg ID automatically.
 	 */
 	memcg_id = find_memcg_id();
 	if (memcg_id < 0)
 		return 1;

 	printf("memcg: %d (%s)\n", memcg_id, TARGET_CGROUP);
 	printf("aging generation %d -> %d\n",
 	       START_GEN, END_GEN);

 	fd = open(LRU_GEN, O_WRONLY);
 	if (fd < 0) {
 		perror("open lru_gen");
 		return 1;
 	}

 	for (int gen = START_GEN; gen <= END_GEN; gen++) {
 		char buf[128];
 		int len;
 		struct timespec start, end;
 		long long ns;

 		len = snprintf(buf, sizeof(buf),
 			       "+ %d 0 %d\n", memcg_id, gen);

 		clock_gettime(CLOCK_MONOTONIC, &start);

 		if (write(fd, buf, len) != len) {
 			perror("write lru_gen");
 			close(fd);
 			return 1;
 		}

 		clock_gettime(CLOCK_MONOTONIC, &end);

 		ns = nsec_diff(&start, &end);
 		total_ns += ns;

 		printf("gen %3d: %8.3f ms\n",
 		       gen, ns / 1000000.0);
 		fflush(stdout);
 	}

 	close(fd);

 	printf("\nTotal:   %.3f ms\n",
 	       total_ns / 1000000.0);
 	printf("Average: %.3f ms\n",
 	       total_ns / (double)(END_GEN - START_GEN + 1) /
 	       1000000.0);

 	while (1)
 		sleep(1);

 	return 0;
 }

Run the above microbenchmark with:
systemd-run --scope --unit=agetest -p MemoryMax=1024M ./agetest

I’m seeing a significant speedup in inc_min_seq() on my x86 PC:

W/o patch:

Running scope as unit: agetest.scope
mmap: 0x72c1b5a00000, size: 512 MB
memcg: 12673 (/system.slice/agetest.scope)
aging generation 3 -> 103
gen   3:    7.433 ms
gen   4:    0.949 ms
gen   5:    2.535 ms
gen   6:    5.043 ms
gen   7:    5.041 ms
gen   8:    5.027 ms
...
gen 100:    5.035 ms
gen 101:    5.011 ms
gen 102:    5.029 ms
gen 103:    5.056 ms

Total:   503.946 ms
Average: 4.990 ms

W/ patch:

Running scope as unit: agetest.scope
mmap: 0x775ec5200000, size: 512 MB
memcg: 12717 (/system.slice/agetest.scope)
aging generation 3 -> 103
gen   3:    7.558 ms
gen   4:    0.916 ms
gen   5:    2.277 ms
gen   6:    2.328 ms
…
gen 100:    2.303 ms
gen 101:    2.297 ms
gen 102:    2.305 ms
gen 103:    2.312 ms

Total:   236.635 ms
Average: 2.343 ms

The average aging time drops from 4.990 ms to 2.343 ms!

Thanks, Xueyuan, for testing this on ARM[2].  It actually shows an even
larger improvement.

Xueyuan tested this series on his arm64 machine (24 cores, 4K base pages)
and reproduced the improvement:

THP=never (PTE):
  baseline: 7.644 ms
  patched:  2.964 ms (-61.2%)

THP=always (PMD):
  baseline: 0.0373 ms
  patched:  0.0292 ms (-21.8%)


This patch (of 7):


folio_inc_gen() currently updates both the folio's generation and the LRU
size accounting.  This makes it difficult to batch the LRU size updates
when moving multiple folios.

Extract the generation update into __folio_inc_gen(), which only updates
the folio's generation and reports whether the generation was actually
increased.  Keep folio_inc_gen() as the wrapper that performs the LRU size
accounting when needed.

This separates the per-folio generation update from LRU accounting and
allows the latter to be batched by subsequent changes.

Link: https://lore.kernel.org/20260901232421.40157-1-baohua@kernel.org
Link: https://lore.kernel.org/20260901232421.40157-2-baohua@kernel.org
Link: https://lore.kernel.org/linux-mm/20260812121658.69965-1-baohua@kernel.org/ [1]
Link: https://lore.kernel.org/linux-mm/20260827035416.3012015-1-xueyuan.chen21@gmail.com/ [2]
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Ridong Chen <ridong.chen@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

--- a/mm/vmscan.c~mm-mglru-separate-folio-generation-update-from-lru-accounting
+++ a/mm/vmscan.c
@@ -3300,21 +3300,21 @@ static int folio_update_gen(struct folio
 	return ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
 }
 
-/* protect pages accessed multiple times through file descriptors */
-static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
+static int __folio_inc_gen(struct folio *folio, int old_gen, bool *increased)
 {
-	int type = folio_is_file_lru(folio);
-	struct lru_gen_folio *lrugen = &lruvec->lrugen;
-	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
 	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
+	int new_gen;
 
 	VM_WARN_ON_ONCE_FOLIO(!(old_flags & LRU_GEN_MASK), folio);
 
 	do {
 		new_gen = ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
 		/* folio_update_gen() has promoted this page? */
-		if (new_gen >= 0 && new_gen != old_gen)
+		if (new_gen >= 0 && new_gen != old_gen) {
+			if (increased)
+				*increased = false;
 			return new_gen;
+		}
 
 		new_gen = (old_gen + 1) % MAX_NR_GENS;
 
@@ -3322,8 +3322,22 @@ static int folio_inc_gen(struct lruvec *
 		new_flags |= (new_gen + 1UL) << LRU_GEN_PGOFF;
 	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
 
-	lru_gen_update_size(lruvec, folio, old_gen, new_gen);
+	if (increased)
+		*increased = true;
+	return new_gen;
+}
+
+/* protect pages accessed multiple times through file descriptors */
+static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
+{
+	int type = folio_is_file_lru(folio);
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
+	bool gen_increased;
 
+	new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
+	if (gen_increased)
+		lru_gen_update_size(lruvec, folio, old_gen, new_gen);
 	return new_gen;
 }
 
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-mglru-make-retry-logic-explicit-in-isolate_folios.patch
mm-vmscan-avoid-pointless-large-folio-splits-without-swap.patch
mm-mglru-separate-folio-generation-update-from-lru-accounting.patch
mm-mglru-batch-update-lrugen-nr_pages-in-inc_min_seq.patch
mm-mglru-enhance-cold-hot-inversion-handling-in-inc_min_seq.patch
mm-mglru-exclude-folios-promoted-by-aging-from-protected-in-inc_min_seq.patch
mm-mglru-make-lru-folio-prefetch-helper-an-inline-function.patch
mm-mglru-move-folios-from-oldest-gen-to-second-oldest-gen-from-head-to-tail.patch
mm-mglru-batch-move-folios-to-the-second-oldest-gens-lru.patch

