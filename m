Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794555557;
	b=NfXoqfYwNEVxy3u0tJ5vmMPYGzXr+S1vq3oU0UZwEotn1P7RA4kTQ04iuFPVD0Tdc3KN
	 qPmfo6BsIKeL9HeQVOzB6sm+l9xA4cZZzfhVirLZM7DHxcFmai5AkhqJRFFdddbBmV4UY
	 bjHgqYfN0c0cc7vW6eaMrgQ+6Sdrq3F7ugiKhOdIiTNMdYlPyONEDE920e3dXmEX4L63G
	 KMXfgFns8tVDgCunK/X3ZWmoORw3Z4PpZhXExANY6xsUJtzq1mJuLQ61OONl3PXNNDjPp
	 I/QwlRylmeXfg2MgdH0idBlEBCIwac5hc9dzjzIY/MRzCYM2en7YQsPu125QHgetzHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794555557;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=3sU9LJy1cPPrQ36gs+Zyb2F7o0X7etMKSaG1jpzvCKA=;
	b=fKfiD7cTnv3pvz5dpez9BB2iQ9Wh3PhLVozhc4CYZUi2CD5ZfknGHxy5vEbY4yRnE3/o
	 zVqIBXPyCkNldUnT9MvDiS6J3XJxCXupVN1QdB2/2KUrzLJsKZCa4cp+0tqrPGQLtPWdk
	 EOIEIEzajrmJgDVXH8Iv+jc6QZRsyXoc6ejS3Q+dO2twy2krrVNSB7wj36zizD8dBQ8lP
	 H+TkDhe6WoxYYGe09j75SLxLFLniOHUQqxK58NrjVwFs9KyuxV1iU0YJz1zVMPGHTl1MK
	 /a0jq8wd9pn1EopOjG7wKoJ8Pl4eyeelpGw648ACZCCAR6Rp1p2iSM+ELaTkQUbWKwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=KRXzMkHB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA9E606A31C
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 07:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=KRXzMkHB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D221F000C4;
	Fri, 13 Nov 2026 07:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794555556;
	bh=3sU9LJy1cPPrQ36gs+Zyb2F7o0X7etMKSaG1jpzvCKA=;
	h=Date:To:From:Subject;
	b=KRXzMkHBQIpLiebP8wGgMp6+tZofRvfvpsaix2ytYs5uTeE6V3DaThc15plHQzeAT
	 elSGvDiIow7sKaVHXXXeSy7RCvj1Gf/hbPM+QwD1p34RhBGdnTqZXmizZ0K0I1anA4
	 47CutLjWxhKsQMJa4lfGFnHOOo2pSeYX5jsvafEA=
Date: Thu, 12 Nov 2026 23:39:15 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-api-define-damon_filter_type_active.patch added to mm-unstable branch
Message-Id: <20261113073916.73D221F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/api: define DAMON_FILTER_TYPE_ACTIVE
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-api-define-damon_filter_type_active.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-api-define-damon_filter_type_active.patch

This patch will later appear in the mm-unstable branch at
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
From: SJ Park <sj@kernel.org>
Subject: mm/damon/api: define DAMON_FILTER_TYPE_ACTIVE
Date: Thu, 12 Nov 2026 21:17:07 -0800

Patch series "mm/damon: add lru-active probe filter type".

The LRU-activeness of folios is useful information for understanding and
optimizing the system.  DAMOS ops filter therefore supports filtering
memory based on the information.  Using it, the information can be
extracted in the folio granularity.  It is precise but expensive.  DAMON
probe filter is the complementary way for getting the information in
region granularity with much cheaper cost.  DAMON filter does not
support LRU-activeness based filtering, though.  Add the support.

Define new DAMON filter type, DAMON_FILTER_TYPE_ACTIVE, on core API
(patch 1).  Add support for it on both vaddr and paddr operation set
(patch 2).  Extend DAMON filter sysfs ABI to let users configure DAMON
filters of the type using a new keyword, "active" (patch 3).  Finally,
update the DAMON design document to explain the new type (patch 4).

Test
====

Confirmed the functionality like below.

First, start masim [1] to generate a ~476 MiB hot memory region.

    $ ./masim.py run --config_file ./configs/stairs-500mb.cfg --repeat 10

Second, start DAMON to monitor data access and active memory ratio of
each region using DAMON user-space tool (damo) [2].

    $ sudo ./damo start --target_pid $(pidof masim) \
            --probe --probe_prep set_pgidle \
                --probe_filter allow pgidle_unset \
            --probe --probe_filter allow active \
            --probe_weight 1 0

Show the monitoring results.

    $ sudo ./damo report attrs
    heatmap: 00008[...]82222222222222222222222222222222222222222222222257777789999998888888874444445[...]8
    # min/max temperatures: -1,580,000,000, 100,002,000, column size: 62.841 MiB
    probes
    - prep: set_pgidle, filter: allow pgidle_unset (weight: 1)
    - allow active (weight: 0)
    intervals: sample 5 ms aggr 100 ms (max probe hits 20)
    #   size         address       age           probe_hits
    0   253.047 MiB  85.984 TiB    15.800 s      0 0
    1   4.000 KiB    127.984 TiB   15.400 s      0 20
    2   120.000 KiB  127.984 TiB   15.300 s      0 0
    3   1.450 GiB    127.407 TiB   11.300 s      0 0
    4   498.738 MiB  127.409 TiB   11.200 s      0 0
    5   500.273 MiB  127.409 TiB   11.100 s      0 0
    6   502.055 MiB  127.409 TiB   10.900 s      0 0
    7   461.926 MiB  127.411 TiB   6.500 s       0 0
    8   351.754 MiB  127.410 TiB   1.600 s       0 0
    9   497.930 MiB  127.411 TiB   0 ns          1 0
    10  8.000 KiB    127.984 TiB   0 ns          6 0
    11  476.340 MiB  127.410 TiB   1 s           20 0
    memory bw estimate: 0 B per second
    total size: 4.909 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

The second (idx 1) 4 KiB memory region is not accessed for 15 seconds
and the page for the region is on an active LRU list.  The last 476.340
MiB memory region is accessed for each sample for the last one second as
expected.  And nearly all pages of the region are not on an active LRU
list.


This patch (of 4):

Knowing which memory is on Active LRU lists is useful for understanding
and optimally operating systems.  Extend the DAMON core layer to be
ready for support of that.  For that, define a new damon_filter_type,
DAMON_FILTER_TYPE_ACTIVE.  It has no additional arguments and therefore
no additional change in the core layer is needed.  Testing if a given
memory is on an LRU list for the type of filter should be implemented in
the operation set layer.

Link: https://lore.kernel.org/20261113051711.89274-1-sj@kernel.org
Link: https://lore.kernel.org/20261113051711.89274-2-sj@kernel.org
Link: https://github.com/sjp38/masim [1]
Link: https://github.com/damonitor/damo [2]
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/damon.h~mm-damon-api-define-damon_filter_type_active
+++ a/include/linux/damon.h
@@ -780,6 +780,7 @@ struct damon_prep {
  * @DAMON_FILTER_TYPE_PGIDLE_UNSET:	Pgidle is unset.
  * @DAMON_FILTER_TYPE_PGIDLE_SET:	Pgidle is set.
  * @DAMON_FILTER_TYPE_HUGEPAGE_SIZE:	Page is part of a hugepage.
+ * @DAMON_FILTER_TYPE_ACTIVE:		LRU-active pages.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
@@ -787,6 +788,7 @@ enum damon_filter_type {
 	DAMON_FILTER_TYPE_PGIDLE_UNSET,
 	DAMON_FILTER_TYPE_PGIDLE_SET,
 	DAMON_FILTER_TYPE_HUGEPAGE_SIZE,
+	DAMON_FILTER_TYPE_ACTIVE,
 };
 
 /**
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-copy-only-installed-probe-in-damon_split_region_at.patch
mm-damon-core-add-damos_filter_type_age_ms.patch
mm-damon-sysfs-schemes-support-damos_filter_type_age_ms.patch
docs-mm-damon-design-update-for-age_ms-damos-core-filter-type.patch
docs-admin-guide-mm-damon-usage-update-for-age_ms-damos-core-filter.patch
mm-damon-api-define-damon_filter_type_active.patch
mm-damon-ops-common-implement-damon_filter_type_active-operation.patch
mm-damon-sysfs-support-lru-activeness-based-damon-filter-setup.patch
docs-mm-damon-design-update-for-damon_filter_type_active.patch

