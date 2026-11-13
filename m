Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794555563;
	b=q77KvLYQg/iz7A768Tupgh1Qt00AHz2K9jSylKmiYP/P4sbCzAd6egmUwpAcMBO9tLPE
	 Dth8rUDAJ59BiMyBv0+4UHLyzuwM5KaAgFNbwctqBZ07MzOUfJmxdyqyXfP3OczBo/JQb
	 niCBe+UBnndpWcUifINMEHmyNcJAMpcnGsEP001AUS/n9xy0Pb1ByM8pq4t9sAijdUCMF
	 uD8is7NXQafhd4p4SwdH8tQnbTrIC1kztM65P6l125b546BpZXxq9aJbWu9hB/UiS4yCh
	 gJG9qD9T9VUvRZmkgD7WFKEBZHR5ha6TiTXv5xjdkkLxd95s2UhN6V8zZUmQS5h+JGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794555563;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=21GQl/oECkQ3KfFkKrQWydu4Z9CK8I56yupQNHW7ZwI=;
	b=jd1DDWAhdGEP1fI9WgQRBHNn37/hdqgDusgDrglLeXhc9fq9PTYpNQsvXJrgw5GrfqsU
	 zj92doBjuxCmVJAvKIHsYt0F+RISz0jfyIHZaqyCf6fOGEcnDGQwmKiOzhynwmm1G+Qes
	 gGCX1FNyiKQdMPA9jhZnOWfITSDOR5tymfeAl9NVNnKDgTInFsp8bfc6RvCqO/sX7ODnS
	 kfmpS/RS1M4TBsLFxEJBKoG3HsDfMZICHFkmBSQkQlF/y/6GxWztXMNpy5JiVPluY8UMH
	 pAlCG9SFSaRnGcF+yW4kIObiCacM+/ZwGUCaBz0253wcRGaZxrNxQxcgNCyY3EhoT9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vo0MCiCX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE60606A31C
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 07:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vo0MCiCX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18FC31F000C4;
	Fri, 13 Nov 2026 07:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794555563;
	bh=21GQl/oECkQ3KfFkKrQWydu4Z9CK8I56yupQNHW7ZwI=;
	h=Date:To:From:Subject;
	b=vo0MCiCXgmRc9lJbtyCFMnBWu91pxgA09oqI/DGkDTvAykjoVd727M+226I49QWYJ
	 ZfsUmqZL3HSs6p8ZDOIiAMQkLgQzD6sKrS0Qm4Up+hbaxW0IZcuAs2FLZ2VL+qXg7b
	 OodKnUIJ3bArl8ATucaX4C0OfUM2c06V2a+isdjs=
Date: Thu, 12 Nov 2026 23:39:22 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,
	rdunlap@infradead.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-update-for-damon_filter_type_active.patch added to mm-unstable branch
Message-Id: <20261113073923.18FC31F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/mm/damon/design: update for DAMON_FILTER_TYPE_ACTIVE
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-update-for-damon_filter_type_active.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-update-for-damon_filter_type_active.patch

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
Subject: Docs/mm/damon/design: update for DAMON_FILTER_TYPE_ACTIVE
Date: Thu, 12 Nov 2026 21:17:10 -0800

Update DAMON design document for the newly added LRU-activeness DAMON
filter type.

Link: https://lore.kernel.org/20261113051711.89274-5-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
---

 Documentation/mm/damon/design.rst |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-update-for-damon_filter_type_active
+++ a/Documentation/mm/damon/design.rst
@@ -302,6 +302,7 @@ filter types.  Currently below filter ty
 - ``pgidle_set``: Matches if the page for the memory is marked as access-idle.
 - ``hugepage_size``: Matches if the page for the memory is a part of a hugepage
   of a given size range.
+- ``active``: Same to that for DAMOS filters.
 
 If such probes are registered, DAMON executes the probes for each region's
 sampling memory when it does the access :ref:`sampling
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

