Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD44143C4B
	for <mm-commits@vger.kernel.org>; Thu,  4 Jul 2024 23:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720136857; cv=none; b=qy5aGjR9aCq5+CrcVfNB2PQ309ejoZSgVabYX3ImlS6o0kEY+nkcPYvaxiTmy/9Mk7kwjhWpd0trZhC9D8/LOJGoOQD3N25LyWveQchuClPsU1LcjExiGyPShWCWgU9B3QMLk+RdKQrhXwj+JI6uc2Wi8dfQ+eLyTBa+HWX47hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720136857; c=relaxed/simple;
	bh=S4TCOKEHE51I4UJSYaSqd1HOTh+WuJ7KLBA4WtrcMKc=;
	h=Date:To:From:Subject:Message-Id; b=qtj6Q4FmkwYKLcjGomz+YOLR3dr7cQbhZ9GxWwvpZiuvUT99K5Jmp4AOzZG3EHtSFgHqHeYREJ2fnISSwQ4z+C8K/dGZQRWJG3auszXb7GsIwklt8K47Z4ubGeV2qYoO3Ygn1ZRiKbfhxdPulOVQ/V7+ddeu0GRaHm5E6lWFgTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GwlRgmOO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GwlRgmOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3582C3277B;
	Thu,  4 Jul 2024 23:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720136856;
	bh=S4TCOKEHE51I4UJSYaSqd1HOTh+WuJ7KLBA4WtrcMKc=;
	h=Date:To:From:Subject:From;
	b=GwlRgmOOBuDN9wPIl29TjO6WieWek4uggrjJaaUvKAgB2EtX+ecx13lB7/sN6nyQQ
	 jYP3GS4ndmjJe6RuNCKDVkOLmz0PTD/mjtS3djqJD0pt0bobIaAmz5Zrf1QaB8S1Wk
	 ma+A7eKbzAylHiffzZc+Uaz3uBxC4K5x5z3FOoEw=
Date: Thu, 04 Jul 2024 16:47:36 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,jiaqiyan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] docs-mm-add-enable_soft_offline-sysctl-fix.patch removed from -mm tree
Message-Id: <20240704234736.D3582C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs-mm-add-enable_soft_offline-sysctl-fix
has been removed from the -mm tree.  Its filename was
     docs-mm-add-enable_soft_offline-sysctl-fix.patch

This patch was dropped because it was folded into docs-mm-add-enable_soft_offline-sysctl.patch

------------------------------------------------------
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: docs-mm-add-enable_soft_offline-sysctl-fix
Date: Mon, 1 Jul 2024 21:15:05 -0700

fix kerneldoc warnings

Link: https://lkml.kernel.org/r/CACw3F52=GxTCDw-PqFh3-GDM-fo3GbhGdu0hedxYXOTT4TQSTg@mail.gmail.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |    3 +++
 1 file changed, 3 insertions(+)

--- a/Documentation/admin-guide/sysctl/vm.rst~docs-mm-add-enable_soft_offline-sysctl-fix
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -274,12 +274,15 @@ Correctable memory errors are very commo
 solution for memory pages having (excessive) corrected memory errors.
 
 For different types of page, soft-offline has different behaviors / costs.
+
 - For a raw error page, soft-offline migrates the in-use page's content to
   a new raw page.
+
 - For a page that is part of a transparent hugepage, soft-offline splits the
   transparent hugepage into raw pages, then migrates only the raw error page.
   As a result, user is transparently backed by 1 less hugepage, impacting
   memory access performance.
+
 - For a page that is part of a HugeTLB hugepage, soft-offline first migrates
   the entire HugeTLB hugepage, during which a free hugepage will be consumed
   as migration target.  Then the original hugepage is dissolved into raw
_

Patches currently in -mm which might be from jiaqiyan@google.com are

mm-memory-failure-refactor-log-format-in-soft-offline-code.patch
mm-memory-failure-userspace-controls-soft-offlining-pages.patch
selftest-mm-test-enable_soft_offline-behaviors.patch
docs-mm-add-enable_soft_offline-sysctl.patch
docs-mm-add-enable_soft_offline-sysctl-fix-fix.patch

