Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1A015C158
	for <mm-commits@vger.kernel.org>; Thu, 12 Jun 2025 05:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749706988; cv=none; b=ee/JYmmJNNyBsna5IRcTJ7KJVzriLgnzFkRoMBFl4IvOOHbHwoDhEvLZjrippQhxkAz7gkX2YMoyj8BCXa0PBXaabHfXOyTCL0xuPxlS75BiZ9ZmSGQlprOgP14RMgJnG8ZhGDb631SNQvrbK0p8ggLt578VCsfV2nRaJMGwVss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749706988; c=relaxed/simple;
	bh=wWB8mu7eUtijdbYOhNvw+uz6NrUBlR5kpshfCEwxZzg=;
	h=Date:To:From:Subject:Message-Id; b=pLXPhnDYzGrxGs0K9n50MiLLLX4YL/JrdKJMFmNrZ0EPCRgH/InoA7oT6rxCXFCCMyhcFj9tirLKohhIOTwxxMrb2QeRqJGWMSgf/m2fzwIuPQF4RuCPjmhW1d+qzOAAMor2Oavq/ApqocS2HRBZkL2S6AQJHOa4ar9FKE6n4yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b2S1aziG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b2S1aziG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43061C4CEF0;
	Thu, 12 Jun 2025 05:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749706988;
	bh=wWB8mu7eUtijdbYOhNvw+uz6NrUBlR5kpshfCEwxZzg=;
	h=Date:To:From:Subject:From;
	b=b2S1aziGrhGIwA7xtKvvWCs4Ghcoc6JqOHokiTV4fHfdd0uepM7YrcfRfjOMyxwoy
	 l3IgG5xI/+pbdm72BrDjlzcTycvb6CS+l992L+X+iBxxZ4fFjLx2VQYitkRAFnCLK1
	 sOcTsgiBCNk24bGmQT60bNnSzw/H8Q5jiKx4ljGk=
Date: Wed, 11 Jun 2025 22:43:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-myself-as-a-thp-reviewer.patch removed from -mm tree
Message-Id: <20250612054308.43061C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add Barry as a THP reviewer
has been removed from the -mm tree.  Its filename was
     maintainers-add-myself-as-a-thp-reviewer.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <baohua@kernel.org>
Subject: MAINTAINERS: add Barry as a THP reviewer
Date: Mon, 9 Jun 2025 12:24:42 +1200

I have been actively contributing to mTHP and reviewing related patches
for an extended period, and I would like to continue supporting patch
reviews.

Link: https://lkml.kernel.org/r/20250609002442.1856-1-21cnbao@gmail.com
Signed-off-by: Barry Song <baohua@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Dev Jain <dev.jain@arm.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-myself-as-a-thp-reviewer
+++ a/MAINTAINERS
@@ -15919,6 +15919,7 @@ R:	Liam R. Howlett <Liam.Howlett@oracle.
 R:	Nico Pache <npache@redhat.com>
 R:	Ryan Roberts <ryan.roberts@arm.com>
 R:	Dev Jain <dev.jain@arm.com>
+R:	Barry Song <baohua@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
_

Patches currently in -mm which might be from baohua@kernel.org are


