Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A54143C4B
	for <mm-commits@vger.kernel.org>; Thu,  4 Jul 2024 23:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720136858; cv=none; b=mH+XPmTBWM/wJEcM+n8G2d20EWKdi3Ql77ryeBQj1SWCFkzoZYGU/WXhnjgZtcdoeGUE82FwXYMeb8a4cVMra8auKYI//Cayg2i4j0ccRkt8j4/cmg1worbkp/oPGBzzaI+qopNwIXa5ZdpPtKFZKWgRGs3JdL6liVI8rwjFv7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720136858; c=relaxed/simple;
	bh=bKv7vnpFLecdV+0dsxCsUDeiNRb2x2dyhOAIoK4QIhs=;
	h=Date:To:From:Subject:Message-Id; b=HDU4Zq6mId4kCo3ytqgbIZQDUGYuf7i9TxPfZRqGtODITywjkPDwnFOb00ZUL3Mbwdsu5+lzhyw0OG7gElsqyh1drVstRqPyhYc4PL/qczlzWlenNQTgMRxOZq7rfLKZH6iS8Lzyzg8Myc/krKO6XwgROn+8nLInZ9NDMSJjylc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WRk5E262; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WRk5E262"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0221C3277B;
	Thu,  4 Jul 2024 23:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720136858;
	bh=bKv7vnpFLecdV+0dsxCsUDeiNRb2x2dyhOAIoK4QIhs=;
	h=Date:To:From:Subject:From;
	b=WRk5E2623rqTwV6Y/H/8To4ot8QB3g6HXkxJmBJAdxr7Qo5xrTvQKypj8DNd7Scbv
	 dgNA07e6J+ADPRxdIWP2R/zkjD5EexjDAkwdUDpw1EXkg13Xfdmjp20lR+rLMHPjAp
	 LfzOvMkG2QYb5qkzm9tSx8Xl2oYLvvnSjXwvjSb8=
Date: Thu, 04 Jul 2024 16:47:37 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,jiaqiyan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] docs-mm-add-enable_soft_offline-sysctl-fix-fix.patch removed from -mm tree
Message-Id: <20240704234737.F0221C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs-mm-add-enable_soft_offline-sysctl-fix-fix
has been removed from the -mm tree.  Its filename was
     docs-mm-add-enable_soft_offline-sysctl-fix-fix.patch

This patch was dropped because it was folded into docs-mm-add-enable_soft_offline-sysctl.patch

------------------------------------------------------
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: docs-mm-add-enable_soft_offline-sysctl-fix-fix
Date: Mon, 1 Jul 2024 23:37:55 -0700

there are more blank lines needed

Link: https://lkml.kernel.org/r/CACw3F52_obAB742XeDRNun4BHBYtrxtbvp5NkUincXdaob0j1g@mail.gmail.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |    3 +++
 1 file changed, 3 insertions(+)

--- a/Documentation/admin-guide/sysctl/vm.rst~docs-mm-add-enable_soft_offline-sysctl-fix-fix
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -299,8 +299,11 @@ the request to soft offline the pages.
 
 It is worth mentioning that after setting enable_soft_offline to 0, the
 following requests to soft offline pages will not be performed:
+
 - Request to soft offline pages from RAS Correctable Errors Collector.
+
 - On ARM, the request to soft offline pages from GHES driver.
+
 - On PARISC, the request to soft offline pages from Page Deallocation Table.
 
 extfrag_threshold
_

Patches currently in -mm which might be from jiaqiyan@google.com are

mm-memory-failure-refactor-log-format-in-soft-offline-code.patch
mm-memory-failure-userspace-controls-soft-offlining-pages.patch
selftest-mm-test-enable_soft_offline-behaviors.patch
docs-mm-add-enable_soft_offline-sysctl.patch

