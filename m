Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7595114386D
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854746; cv=none; b=iq7RRH1W41IuQdyH+OdyHmG2LXf2eMnEBaxrdOYIcpsyOo8FAo6bCwom85OUL/nwiSR9fIxlta6sLhLtSZe3ERlI3CSBkNx5VCjvHL1ZEKQ578T5EBDc4zZb2tq1IR2sBEY6Rb4LkHH7g2m3FfBh4dUV88x5O7DWmoPaKTBFENs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854746; c=relaxed/simple;
	bh=zrr7SgOuY5g+CvluRCShG9DrXpQe1w+t4JxogFi17TM=;
	h=Date:To:From:Subject:Message-Id; b=S3a7ZxvBDY2BiaXWvSf/s3wQvsWbORb9v2kznLi+6CVdD+TopyRI9Fu5EunFydpuomB714G0IXm3ZNOEPDYUYnEpDKmelQ9CQGeaiprrlwpa83ygTWE7YkSIjcK+ukGICg3JmK3jlpTu8x5BmOjU0UFdaV4c1LqK3cLcqkbYPhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fchCUmfg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fchCUmfg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5C5C4CECF;
	Wed,  6 Nov 2024 00:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854746;
	bh=zrr7SgOuY5g+CvluRCShG9DrXpQe1w+t4JxogFi17TM=;
	h=Date:To:From:Subject:From;
	b=fchCUmfg4Sidm8rd3VJxRodZzYOirmLX14TC8OMM/H35fx8KOyGrpuGOILZRMxDe3
	 N5Xw8n//n3BMYYGweertdANlG8HftkrKCr9khUmOvUJXZH9J8bOmyIK9QvXWZ4NsHS
	 5/3r2w9zXrg9gEHkxq5O5OTAGQrwn3mphFoZJ04c=
Date: Tue, 05 Nov 2024 16:59:05 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,wajdi.k.feghali@intel.com,usamaarif642@gmail.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,nphamcs@gmail.com,nanhai.zou@intel.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,21cnbao@gmail.com,kanchana.p.sridhar@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-define-obj_cgroup_get-if-config_memcg-is-not-defined.patch removed from -mm tree
Message-Id: <20241106005906.4C5C5C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: define obj_cgroup_get() if CONFIG_MEMCG is not defined
has been removed from the -mm tree.  Its filename was
     mm-define-obj_cgroup_get-if-config_memcg-is-not-defined.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Subject: mm: define obj_cgroup_get() if CONFIG_MEMCG is not defined
Date: Mon, 30 Sep 2024 22:32:16 -0700

This resolves an issue with obj_cgroup_get() not being defined if
CONFIG_MEMCG is not defined.

Before this patch, we would see build errors if obj_cgroup_get() is called
from code that is agnostic of CONFIG_MEMCG.

The zswap_store() changes for large folios in subsequent commits will
require the use of obj_cgroup_get() in zswap code that falls into this
category.

Link: https://lkml.kernel.org/r/20241001053222.6944-2-kanchana.p.sridhar@intel.com
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Wajdi Feghali <wajdi.k.feghali@intel.com>
Cc: "Zou, Nanhai" <nanhai.zou@intel.com>
Cc: Barry Song <21cnbao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/memcontrol.h~mm-define-obj_cgroup_get-if-config_memcg-is-not-defined
+++ a/include/linux/memcontrol.h
@@ -1282,6 +1282,10 @@ struct mem_cgroup *mem_cgroup_from_css(s
 	return NULL;
 }
 
+static inline void obj_cgroup_get(struct obj_cgroup *objcg)
+{
+}
+
 static inline void obj_cgroup_put(struct obj_cgroup *objcg)
 {
 }
_

Patches currently in -mm which might be from kanchana.p.sridhar@intel.com are


