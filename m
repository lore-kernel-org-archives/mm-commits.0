Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794555561;
	b=p9nfUYREACCWRRSuk5rJd/05AsFqZsamtr2bQ2E/7wdP9I8oxV6BiHylkE+ny6F8X8rE
	 KL8qte5eyq2JDyxWG+6NsvI9UY6dR7fivHIj7wg6PRq8DcucSq/69fvFXt8+h9mPqr9Z+
	 0uCTQ2r4TfwnK2mJILhEhGYQypFpI3ya4QlV8OwjZlzxMVbtYcdjHFRuD2VSnlabTGGfJ
	 pZeN7Y2KWDOHCkMbhoNGJXFpCmOgU0DB8ZCBFMC5OIC/jtV3Lcqw9xCaZC1lHhrEfc0MO
	 e9WApO7KItFKC/2i0RXu3DFhD31Y+Dg8mgsFLu9Xx/+FvUiMgyYb6Bd6k+rFKllNFbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794555561;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=SVaVssamWAcEaTHOcF07ybMuZeNfTd31w25PlQgIv2A=;
	b=44J0DW9I9inqtowT78yI3gcZKGIjzc6BiKJpqEmqE+nN0ChYHaZ5ShUOftATaAZRb4T7
	 Q7ygAs2W6y4DQCj6i/Z0M7Qz7FTv+/jidNlx7X9D1vIxJH7iknACzUYQqo1o9YoBM+yjb
	 UjvVxgXbPY7B4GwMdfGgcbQhA/8rxutNykD4N23hlKjCwcE00Eaffl4x8cqV8KdGiq8BJ
	 iEXeoJZKNNHDhkg/OYfeNfDTDZ0O+nZgY4/v8tRRBKEbS//S/lyjaeCfN3cHQuBG/vTIz
	 NKn4j6pnEaJMjMvkr99p+Tt+ZqWiUuSlBgAdk860a0eOWQ8ObEv1BxFHcozmF4Ln/yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1jceM0cN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B03A606A321
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 07:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1jceM0cN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAFC01F000C4;
	Fri, 13 Nov 2026 07:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794555561;
	bh=SVaVssamWAcEaTHOcF07ybMuZeNfTd31w25PlQgIv2A=;
	h=Date:To:From:Subject;
	b=1jceM0cNFmC7J4G8LqbmsSzy8mXRdccCgDJ55hEvyJJjqOMVeFraX+TXoe3ua4dnk
	 T3f20Ts3p84sdHx2gTRaoYR4JIuDnQKzyEB3AjYgFSxGnCj93LEqeY2YqTrD+voMwC
	 nbWkZE202OcC+m0PY2UDw9m2wE2FXLW6N+Vs6qrI=
Date: Thu, 12 Nov 2026 23:39:20 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-support-lru-activeness-based-damon-filter-setup.patch added to mm-unstable branch
Message-Id: <20261113073920.DAFC01F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/sysfs: support LRU-activeness based DAMON filter setup
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-support-lru-activeness-based-damon-filter-setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-support-lru-activeness-based-damon-filter-setup.patch

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
Subject: mm/damon/sysfs: support LRU-activeness based DAMON filter setup
Date: Thu, 12 Nov 2026 21:17:09 -0800

Support DAMON sysfs interface based setup of DAMON_FILTER_TYPE_ACTIVE
type DAMON filters.  For that, wire the type with a new user keyword,
"active".  Users can set up the new type of filter using the existing
DAMON filter setup interface with the new keyword.

Link: https://lore.kernel.org/20261113051711.89274-4-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-support-lru-activeness-based-damon-filter-setup
+++ a/mm/damon/sysfs.c
@@ -1011,6 +1011,10 @@ damon_sysfs_filter_type_names[] = {
 		.type = DAMON_FILTER_TYPE_HUGEPAGE_SIZE,
 		.name = "hugepage_size",
 	},
+	{
+		.type = DAMON_FILTER_TYPE_ACTIVE,
+		.name = "active",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
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

