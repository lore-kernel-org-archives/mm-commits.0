Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793934520;
	b=McK0p8lwaheQghou5gT4hlgEjKMf1GftWHBGf1gfYdqy+eCvIzU/4YPxAFd/4cHT7NKO
	 amd5eFW7RNlpb/l/Mpm/b+F8SZWxKKqKFVFZ+5NEakN5E3cFOQyg06ArUy9w84Rc0pQdj
	 j8XCNQUfaKooRBECLz6hTGDOrqB1J1T8M9+IIIa8Hy73m8oNCzRdZJ4E2U1PBo0EKfkyu
	 AXfwPqJw37IEl3km9f9cb35F+teoOWHM4VIaeKR6ZrycmuJ9heiw5nux58Fd1uA2sD+pD
	 XFMu35T6Jfy/sOvSsrsGGh7Hm+qZah1hmCJIm+PtHONfq9zv6AT7v7ox2lVLsuWYyUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793934520;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=JLZLsEz676x4B5v/AnUMDVj6QURRftA3G34iVJvrWrE=;
	b=gBQKuOtEc+0uV+Rz/qSXK0tWXiMAGCMyegGzMBXVedafzLyoCAxnf9QGDr+0Xn9rjBPY
	 I+QBTKpl+HRHvqixLdGCojRVf+/Vo424JbXPXIfMpbnw9N/an3eE+tJho6ciwPwYUyftc
	 96rxg2k6Ux/CQO5BNB89lYEq+cUPz5YatPLQenULLTEZSg8iOTgSELhesHKL8k1fKXr6B
	 LJXTB0dVgwW1a16cHc6xsaZXM2H83Yn+iUEbdvfYbPHMHIpjSJQkBq/oSWAB4rlf8fJEt
	 2IIoQDoko1fKguXqgf0MYiccUrV1ouD0lHljdLIV7yM9oJQttooAofffR/x2QamcGmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tzxrzhd5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD1F606A31B
	for <mm-commits@vger.kernel.org>; Fri,  6 Nov 2026 03:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tzxrzhd5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0381E1F0089F;
	Fri,  6 Nov 2026 03:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793934520;
	bh=JLZLsEz676x4B5v/AnUMDVj6QURRftA3G34iVJvrWrE=;
	h=Date:To:From:Subject;
	b=tzxrzhd5WHmEPO+nwq699GRcmvy51Jw6LKWSoKO3/P9Mz3hbAW7ekuVS04tW3z4vC
	 8ClUvdSoUe/vdCBIqeinZfJ85asnxytCLW94Vinc3J1eqyT22dnh4wkK3dfcRKgv3j
	 at4n2TheD8fJZZCrTYjvCg/uIg28RynmTWrHyiGI=
Date: Thu, 05 Nov 2026 19:08:39 -0800
To: mm-commits@vger.kernel.org,jm5905938@gmail.com,sj@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-add-damos_filter_type_age_ms.patch added to mm-new branch
Message-Id: <20261106030840.0381E1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/core: add DAMOS_FILTER_TYPE_AGE_MS
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-add-damos_filter_type_age_ms.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-add-damos_filter_type_age_ms.patch

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
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: add DAMOS_FILTER_TYPE_AGE_MS
Date: Thu, 05 Nov 2026 18:05:55 -0800

Patch series "mm/damon: introduce age_ms damos core filter type".

DAMOS access pattern supports selecting regions to apply a given
operation to, based on their age (access frequency stability).  The age
is specified in the aggregation intervals unit.  The aggregation
interval can be changed by users or intervals auto-tuning features.  If
the intention is to specify the age in a deterministic way (e.g., 2
minutes), it should be updated for each aggregation interval update.
Doing so is cumbersome and challenging, particularly in the interval
auto-tuning case.

One straightforward solution is extending the DAMOS access pattern for
specific deterministic time based age specification.  However, DAMOS
core filter is a better option.  It is playing a similar role in a more
flexible way.  It can be used for both accepting and rejecting regions
based on if they matched or unmatched to a given criteria.  Multiple
filters can also be combined for more flexible and detailed rules.

Extend DAMOS core filter to support milliseconds unit based age
criteria.

Implement a new DAMOS core filter type, DAMOS_FILTER_TYPE_AGE_MS, in
core layer and expose to DAMON API, via patch 1.  Add the support of the
feature on DAMON sysfs ABI with patch 2.  Update the design and usage
documents to explain the new features with patches 3 and 4,
respectively.

Reviewer notes (no need to be in git history).

Test
====

Confirmed the age_ms filter is working using masim [1] and DAMON
user-space tool [2]'s DAMOS filter-based snapshot feature, like below.

Start masim.

    $ ./masim.py run --config_file ./configs/stairs-500mb.cfg \
            --quiet --repeat 10 &

Start DAMON for access monitoring.

    $ sudo ./damo start --probe \
            --probe_prep set_pgidle --probe_filter allow pgidle_unset

Monitoring results without an age_ms filter shows regions of any age.

    $ sudo ./damo report attrs --style idle-time-percentiles
    # total recency percentiles
    <percentile> <idle time>
      0     0 ns  |                    |
      1     0 ns  |                    |
     25   100 ms  |                    |
     50  3.300 s  |****************    |
     75      4 s  |******************* |
     99  4.100 s  |********************|
    100  4.100 s  |********************|
    memory bw estimate: 66.628 GiB per second
    total size: 7.797 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

With an age_ms DAMOS filter applied for snapshotting, shows regions of
given age range.

For [0, 2s range]

    $ sudo ./damo report attrs --style idle-time-percentiles \
            --snapshot_damos_filter allow age_ms 0 2s
    # total recency percentiles
    <percentile> <idle time>
      0     0 ns  |                    |
      1     0 ns  |                    |
     25     0 ns  |                    |
     50     0 ns  |                    |
     75   100 ms  |*                   |
     99   200 ms  |**                  |
    100  1.600 s  |********************|
    memory bw estimate: 100.311 GiB per second  df-passed: 0 B per second
    total size: 7.797 GiB  df-passed 0 B
    scheme stats
    tried 0 times (0 B)
    applied 0 times (0 B)
    0 B passed filters
    quota exceeded 0 times
    0 B
    tried 0 snapshots (max 0)
    record DAMON intervals: sample 5 ms, aggr 100 ms


This patch (of 4):

There is no way to specify DAMOS target regions with a deterministic
time based age range.  Extend DAMOS core filter to specify target
regions with age in milliseconds.  Introduce new damos_filter_type,
DAMOS_FILTER_TYPE_AGE_MS in DAMON API, and implement support of the type
in the core layer.

Convert the age in aggregation intervals to milliseconds and use it when
the filter is evaluated.  Reuse damos_filter->range_{min,max} to save
the age range.

Link: https://lore.kernel.org/20261106020559.98352-1-sj@kernel.org
Link: https://lore.kernel.org/20261106020559.98352-2-sj@kernel.org
Link: https://github.com/sjp38/masim [1]
Link: https://github.com/damonitor/damo [2]
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
---

 include/linux/damon.h |   16 ++++++++++------
 mm/damon/core.c       |   10 +++++++++-
 2 files changed, 19 insertions(+), 7 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-add-damos_filter_type_age_ms
+++ a/include/linux/damon.h
@@ -394,13 +394,16 @@ struct damos_stat {
  * @DAMOS_FILTER_TYPE_ADDR:	Address range.
  * @DAMOS_FILTER_TYPE_TARGET:	Data Access Monitoring target.
  * @DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:	probe_hits weighted sum range.
+ * @DAMOS_FILTER_TYPE_AGE_MS:	Region age range in milliseconds.
  *
- * All types except &DAMOS_FILTER_TYPE_ADDR, &DAMOS_FILTER_TYPE_TARGET and
- * &DAMOS_FILTER_TYPE_PROBE_HITS_WSUM are handled by the underlying &struct
- * damon_operations as a part of scheme action trying, and therefore accounted
- * as 'tried'.  In contrast, &DAMOS_FILTER_TYPE_ADDR, &DAMOS_FILTER_TYPE_TARGET
- * and &DAMOS_FILTER_TYPE_PROBE_HITS_WSUM filters are handled by the core layer
- * before trying of the action, and therefore not accounted as 'tried'.
+ * All types except &DAMOS_FILTER_TYPE_ADDR, &DAMOS_FILTER_TYPE_TARGET,
+ * &DAMOS_FILTER_TYPE_PROBE_HITS_WSUM and &DAMOS_FILTER_TYPE_AGE_MS are handled
+ * by the underlying &struct damon_operations as a part of scheme action
+ * trying, and therefore accounted as 'tried'.  In contrast,
+ * &DAMOS_FILTER_TYPE_ADDR, &DAMOS_FILTER_TYPE_TARGET,
+ * &DAMOS_FILTER_TYPE_PROBE_HITS_WSUM and &DAMOS_FILTER_TYPE_AGE_MS filters are
+ * handled by the core layer before trying of the action, and therefore not
+ * accounted as 'tried'.
  *
  * Support for the operations-handled filters depends on the running
  * &struct damon_operations.
@@ -415,6 +418,7 @@ enum damos_filter_type {
 	DAMOS_FILTER_TYPE_ADDR,
 	DAMOS_FILTER_TYPE_TARGET,
 	DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
+	DAMOS_FILTER_TYPE_AGE_MS,
 };
 
 /**
--- a/mm/damon/core.c~mm-damon-core-add-damos_filter_type_age_ms
+++ a/mm/damon/core.c
@@ -659,6 +659,7 @@ bool damos_filter_for_ops(enum damos_fil
 	case DAMOS_FILTER_TYPE_ADDR:
 	case DAMOS_FILTER_TYPE_TARGET:
 	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
+	case DAMOS_FILTER_TYPE_AGE_MS:
 		return false;
 	default:
 		break;
@@ -1336,6 +1337,7 @@ static int damos_commit_filter_arg(
 		dst->sz_range = src->sz_range;
 		break;
 	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
+	case DAMOS_FILTER_TYPE_AGE_MS:
 		if (src->range_max < src->range_min)
 			return -EINVAL;
 		dst->range_min = src->range_min;
@@ -2552,7 +2554,7 @@ static bool damos_filter_match(struct da
 	bool matched = false;
 	struct damon_target *ti;
 	int target_idx = 0;
-	unsigned long start, end, wsum;
+	unsigned long start, end, wsum, age_ms;
 
 	*err = 0;
 	switch (filter->type) {
@@ -2594,6 +2596,12 @@ static bool damos_filter_match(struct da
 		matched = filter->range_min <= wsum &&
 			wsum <= filter->range_max;
 		break;
+	case DAMOS_FILTER_TYPE_AGE_MS:
+		age_ms = div_u64((u64)r->age * ctx->attrs.aggr_interval,
+				USEC_PER_MSEC);
+		matched = filter->range_min <= age_ms &&
+			age_ms <= filter->range_max;
+		break;
 	default:
 		return false;
 	}
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-sysfs_memcg_path_leak-define-ksft_skip.patch
mm-damon-core-copy-only-installed-probe-in-damon_split_region_at.patch
mm-damon-core-add-damos_filter_type_age_ms.patch
mm-damon-sysfs-schemes-support-damos_filter_type_age_ms.patch
docs-mm-damon-design-update-for-age_ms-damos-core-filter-type.patch
docs-admin-guide-mm-damon-usage-update-for-age_ms-damos-core-filter.patch

