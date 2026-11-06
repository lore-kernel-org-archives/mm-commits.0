Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793934523;
	b=G0OltSaM9MCYBtS8GZRfEOwCsXqZkY2bBL4U83UuBQjWmwTjty9qH/3IlNOJibp4iYLN
	 QgIEYpgyOEI0svt7scqyFd3v+JMouFO0MjMESsvT6MpnZSHazZPZfwLGK6f2IxO30rK6p
	 Yu6RbPjT9D4Bn2Hu2AR5X+MTy8916H9mV2Z9ARKFq0YpkyRPva+nneE86bJvNohoSM7TG
	 E97FpMAFPQU2lQPxzRbGW/qxZoc3JgmZMjmmroLSfylGK2KPwXPbBDjr22EkbSPI5t6/l
	 0Qx3Vi19+hlYcbMHo+/KA9zWIFpWpV5dgX4l+8wh+++2o2y6TJPAAWYeg/PrXursCQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793934523;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=M6PcInuQoCxwKHdBcQGbtKz+/AJ7o5s2Eks9H2rvtk4=;
	b=PoE4g2Evdg5/DsO2MlyCoG94WigP9jSBL2KbHl2hwWBg22xh6oT+vc6hJwvwo/KhRjwW
	 kbL7iX6qMzdN14xpDB4laSQvn6taYnA+Dyywspg4Sazqedqnwh/M0eBxtAQdmSHdLIuVT
	 Q4nKEISxbe5mvQCWrceqehg7HQu9AlIPVgMXKX69L5bQCtz/GvpMSx1OMvFAuMd9FIeEP
	 qfCYznidDxypSdAiuRlT5Cgp0NzVZzLXpGugLojPrpEQ0oJa3HP4dtmOCt3p9ssSa5Tti
	 x4eeE+Lpf4XuQxxoNmYT96Ga2+OKRw+QvH68jg8jzjIAXFGjqwRl/7T2SyTs1uOVQOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UbflArEs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DED606A31B
	for <mm-commits@vger.kernel.org>; Fri,  6 Nov 2026 03:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UbflArEs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655821F0089F;
	Fri,  6 Nov 2026 03:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793934522;
	bh=M6PcInuQoCxwKHdBcQGbtKz+/AJ7o5s2Eks9H2rvtk4=;
	h=Date:To:From:Subject;
	b=UbflArEsflCjb3UH1H2ZMwpHZFJ0oN8XiGJqZzOvLuZiWzI4Ix0keOxdYGhgA3aU4
	 Dg+q6MDagEoskoT8P8Lpsn9G2KeOVxXIvesB2biinkThF8kgLabrnxCPQwvFDrJmGp
	 vG792VcJ3TpKnq26Rshkdk01/wzHar9TWkr5K7/8=
Date: Thu, 05 Nov 2026 19:08:42 -0800
To: mm-commits@vger.kernel.org,jm5905938@gmail.com,sj@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-support-damos_filter_type_age_ms.patch added to mm-new branch
Message-Id: <20261106030842.655821F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/sysfs-schemes: support DAMOS_FILTER_TYPE_AGE_MS
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-schemes-support-damos_filter_type_age_ms.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-support-damos_filter_type_age_ms.patch

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
Subject: mm/damon/sysfs-schemes: support DAMOS_FILTER_TYPE_AGE_MS
Date: Thu, 05 Nov 2026 18:05:56 -0800

Support use of DAMOS_FILTER_TYPE_AGE_MS via DAMON sysfs ABI.  Add a user
keyword "age_ms" for configuring a filter of the type using the existing
filter configuration interface.  Reuse existing 'min' and 'max' sysfs
files in the filter configuration directory for storing the age range in
milliseconds.

Link: https://lore.kernel.org/20261106020559.98352-3-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
---

 mm/damon/sysfs-schemes.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-support-damos_filter_type_age_ms
+++ a/mm/damon/sysfs-schemes.c
@@ -593,6 +593,10 @@ damos_sysfs_filter_type_names[] = {
 		.type = DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
 		.name = "probe_hits_wsum",
 	},
+	{
+		.type = DAMOS_FILTER_TYPE_AGE_MS,
+		.name = "age_ms",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
@@ -2875,6 +2879,7 @@ static int damon_sysfs_add_scheme_filter
 			filter->sz_range.max = sysfs_filter->range_max;
 			break;
 		case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
+		case DAMOS_FILTER_TYPE_AGE_MS:
 			filter->range_min = sysfs_filter->range_min;
 			filter->range_max = sysfs_filter->range_max;
 			break;
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-sysfs_memcg_path_leak-define-ksft_skip.patch
mm-damon-core-copy-only-installed-probe-in-damon_split_region_at.patch
mm-damon-core-add-damos_filter_type_age_ms.patch
mm-damon-sysfs-schemes-support-damos_filter_type_age_ms.patch
docs-mm-damon-design-update-for-age_ms-damos-core-filter-type.patch
docs-admin-guide-mm-damon-usage-update-for-age_ms-damos-core-filter.patch

