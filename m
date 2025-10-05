Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91013FC7
	for <mm-commits@vger.kernel.org>; Sun,  5 Oct 2025 23:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759707233; cv=none; b=GjUjhzYjB5H7OJUiyKliGnFPi/pFVokc6f97TFYlzCgMRKshRkRon7rJeKYPOfwd/Nc8+7UyntrC18GaABQHt8HvbTHJAELjwYElF0Cm5pIfm8xq9uUCpz56yVd4I9ClZ0EM5voKde0JRTDIw3LVCg3NY7woqWpF3KNG9dYjEYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759707233; c=relaxed/simple;
	bh=ozzwrjBaDTu2MF5XALoY0x1jvEni47bCgJb8rIV77yI=;
	h=Date:To:From:Subject:Message-Id; b=s3wFSyVeY2zoGtLPJKgjzr0EfzEDQae6h/aTTpVnu9zeOhIwD6L7Z5+6PXrz5QHpHKzkAWX1goJH80F8GLk7PdEF34940gNyDfC+QK9vyYnycy7AzLpjkONvTA9p6R4BQUcaJub5XfVo0OHjzdMWRJzIw/ZurTyKemt+qE6OuSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E2lx8CBN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E2lx8CBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5165BC4CEF4;
	Sun,  5 Oct 2025 23:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759707229;
	bh=ozzwrjBaDTu2MF5XALoY0x1jvEni47bCgJb8rIV77yI=;
	h=Date:To:From:Subject:From;
	b=E2lx8CBNB0UAC6IPuKSklY6ExjMr3seMp2Kp+dC6JTEyXXLyAeiFp+fDRGbSmcDLF
	 CmoXEoyn0SjB7JltyK2SfBYNCKJDreFKTmwACqi1u8QE+XMtdEG8u6o6L+tj/481AT
	 /nrttFZCgWWbdaz+M55uYTHmPOcI4xLroACfrbeI=
Date: Sun, 05 Oct 2025 16:33:48 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,weibu@redadmin.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] docs-admin-guide-mm-damon-correct-typo-directores.patch removed from -mm tree
Message-Id: <20251005233349.5165BC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs: admin-guide/mm/damon: correct typo "directores"
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-correct-typo-directores.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akiyoshi Kurita <weibu@redadmin.org>
Subject: docs: admin-guide/mm/damon: correct typo "directores"
Date: Sun, 28 Sep 2025 15:46:51 +0900

The word "directores" is a typo in usage.rst.  Correct it to "directories"
to improve documentation clarity.

Link: https://lkml.kernel.org/r/20250928064651.281325-1-weibu@redadmin.org
Signed-off-by: Akiyoshi Kurita <weibu@redadmin.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-correct-typo-directores
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -360,7 +360,7 @@ The directory for the :ref:`quotas <damo
 DAMON-based operation scheme.
 
 Under ``quotas`` directory, four files (``ms``, ``bytes``,
-``reset_interval_ms``, ``effective_bytes``) and two directores (``weights`` and
+``reset_interval_ms``, ``effective_bytes``) and two directories (``weights`` and
 ``goals``) exist.
 
 You can set the ``time quota`` in milliseconds, ``size quota`` in bytes, and
_

Patches currently in -mm which might be from weibu@redadmin.org are


