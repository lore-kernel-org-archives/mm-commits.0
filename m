Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794555559;
	b=ZpKWoHTS1E3ie/hv4Kkms5jbVh8w5G+LKOhnkbiojRDME6gY98JAEf7YqEOF8Sh0oU55
	 9OpQabTtDf3vdHLBSqk4dIrFiqx5ufBsFdcclfHLfcq5V1T+zd6uQldJy709UIVaMWZ/T
	 6qLQ9wsLRrwLG2cG6c4oFLz03igggqYSpvK9AvFRHO15G57WXnSL/B5KWn4Rn88TVciGb
	 EXhvVKnSRJjOkju2Is+qL/vxmImZp0sG095IlehgXLYNugMD3PLJ4Nwbty4KFM7cgkgUb
	 ZlBHUYRUgsPwNAta2DBoWr/5b5Fj3MbQgZg8pDmxZw7zrjUYrIvxdcU5imoZ6qpBb5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794555559;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=7dnDP5QdWh9PX7iIWl532yazQ4e3CW+xEeFz8xx3UuM=;
	b=t731fCftj9HdtQcq6ie3CmUxWTf/cgl0umXjfJVNtI/j5zIWDo1vm/RWEaIVXsaQNEc1
	 G5M06EC14XKZI4M24E7SVIrBjH165O5ogC+hvIEfG01MS4NdKQ/+LD2/ISUM+QzRd3V1u
	 xQ03+bCiM0ZmdZH8x9P7e0XKa1RjSq8kRC00yPqdQyrBIdqO0dH49amfqZMFpToMiqRuY
	 eqqWSaLCFiLUEDjYdismMI8fFrKCVfnXIwxd9aAdUjn8HSWGVp65gJlNroLB+vWR35Crp
	 0bIScDL8J1p+gA6qAuJxBy95oN8za8OWtGI8afenilcHD1YnlbjG+QFHJcGDIKhZIyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=M8vHgcAq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF070606A32A
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 07:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=M8vHgcAq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B1E1F000C4;
	Fri, 13 Nov 2026 07:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794555558;
	bh=7dnDP5QdWh9PX7iIWl532yazQ4e3CW+xEeFz8xx3UuM=;
	h=Date:To:From:Subject;
	b=M8vHgcAqidHBSHRSKNqZMUiH2sYv1zss4sK8XlPPR/fnMJCxMiGE02XhItOqxJXt+
	 aOYZcUKbNxHdGv4xXgZGh867FTPhREgod+t3/rjfixIJ0tdXHhdQGUoiLwCyTOfjM2
	 K0ZubmP/Olo9JGgoj6CX2RFYENopcx4FPs/FWBag=
Date: Thu, 12 Nov 2026 23:39:18 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-ops-common-implement-damon_filter_type_active-operation.patch added to mm-unstable branch
Message-Id: <20261113073918.A9B1E1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/ops-common: implement DAMON_FILTER_TYPE_ACTIVE operation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-ops-common-implement-damon_filter_type_active-operation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-ops-common-implement-damon_filter_type_active-operation.patch

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
Subject: mm/damon/ops-common: implement DAMON_FILTER_TYPE_ACTIVE operation
Date: Thu, 12 Nov 2026 21:17:08 -0800

Implement DAMON_FILTER_TYPE_ACTIVE operation.  Use folio_test_active()
to show if the folio of the given memory is on an active LRU list.  The
implementation is made on ops-common, so both vaddr and paddr gain the
support of the filter type.

Link: https://lore.kernel.org/20261113051711.89274-3-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/damon/ops-common.c~mm-damon-ops-common-implement-damon_filter_type_active-operation
+++ a/mm/damon/ops-common.c
@@ -574,6 +574,13 @@ bool damon_ops_filter_match(struct damon
 		matched = filter->range_min <= folio_sz &&
 			folio_sz <= filter->range_max;
 		break;
+	case DAMON_FILTER_TYPE_ACTIVE:
+		if (!folio) {
+			matched = false;
+			break;
+		}
+		matched = folio_test_active(folio);
+		break;
 	default:
 		break;
 	}
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

