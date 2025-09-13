Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B7C23D7DB;
	Sat, 13 Sep 2025 20:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757794176; cv=none; b=Kph+tnjlQRmC9q27rdm7Oa2KLE3PRPdyQKM/pER06v9Wo+iloJBafPEbDYPrdICw4tHaQ02XEVAIsWevVNEOosKfHHvBgkjMHUe11LqppUVUPnhXwdrss8x0AA+7MuhSZScj6H93GihU0PhcvO3NkHrMYah16kBn2DXWvjoI4vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757794176; c=relaxed/simple;
	bh=El3379nhL1fJ+T7IN5nGZGX55cqNlukP57Krn/pIaq8=;
	h=Date:To:From:Subject:Message-Id; b=jqrJX83Y3LC/I6z5SgQIB6X9OcKWEBTBG4T2qRiX8gT+ot/TFY/vzlrCdqjejtX15s65ZsDSD5HJKfN+Q3xT7AyG5J4Lf3g+6ES+e8E2ii1vgFLnQQYFF+eL3KZHBMF6iwheWLXzV9KUjRp/fSPtxvHtb9PfdTCPRsJ8+Tho4Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TIyh4j+F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TIyh4j+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C75C4CEEB;
	Sat, 13 Sep 2025 20:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757794176;
	bh=El3379nhL1fJ+T7IN5nGZGX55cqNlukP57Krn/pIaq8=;
	h=Date:To:From:Subject:From;
	b=TIyh4j+Feyg2+e9VJvACN8Hxyy64cVPSfn0z9i5yr9wq322TXA+AhZNhvONAhp0Ge
	 FdU4yzKtBfcQuJxVlLtbgEeaphaKsCuPEkcuUltAA8h44/RYCsEAi0cj+0+6XGqaWS
	 Y5SKRJEZWUd3ytjCdAVR46shDXKP9Z257TGyJeUY=
Date: Sat, 13 Sep 2025 13:09:35 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] samples-damon-wsse-avoid-starting-damon-before-initialization.patch removed from -mm tree
Message-Id: <20250913200936.15C75C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon/wsse: avoid starting DAMON before initialization
has been removed from the -mm tree.  Its filename was
     samples-damon-wsse-avoid-starting-damon-before-initialization.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: samples/damon/wsse: avoid starting DAMON before initialization
Date: Mon, 8 Sep 2025 19:22:36 -0700

Patch series "samples/damon: fix boot time enable handling fixup merge
mistakes".

First three patches of the patch series "mm/damon: fix misc bugs in DAMON
modules" [1] were trying to fix boot time DAMON sample modules enabling
issues.  The issues are the modules can crash if those are enabled before
DAMON is enabled, like using boot time parameter options.  The three
patches were fixing the issues by avoiding starting DAMON before the
module initialization phase.

However, probably by a mistake during a merge, only half of the change is
merged, and the part for avoiding the starting of DAMON before the module
initialized is missed.  So the problem is not solved and thus the modules
can still crash if enabled before DAMON is initialized.  Fix those by
applying the unmerged parts again.

Note that the broken commits are merged into 6.17-rc1, but also backported
to relevant stable kernels.  So this series also needs to be merged into
the stable kernels.  Hence Cc-ing stable@.


This patch (of 3):

Commit 0ed1165c3727 ("samples/damon/wsse: fix boot time enable handling")
is somehow incompletely applying the origin patch [2].  It is missing the
part that avoids starting DAMON before module initialization.  Probably a
mistake during a merge has happened.  Fix it by applying the missed part
again.

Link: https://lkml.kernel.org/r/20250909022238.2989-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250909022238.2989-2-sj@kernel.org
Link: https://lkml.kernel.org/r/20250706193207.39810-1-sj@kernel.org [1]
Link: https://lore.kernel.org/20250706193207.39810-2-sj@kernel.org [2]
Fixes: 0ed1165c3727 ("samples/damon/wsse: fix boot time enable handling")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/wsse.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/samples/damon/wsse.c~samples-damon-wsse-avoid-starting-damon-before-initialization
+++ a/samples/damon/wsse.c
@@ -118,6 +118,9 @@ static int damon_sample_wsse_enable_stor
 		return 0;
 
 	if (enabled) {
+		if (!init_called)
+			return 0;
+
 		err = damon_sample_wsse_start();
 		if (err)
 			enabled = false;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-store-page_size-compression-failed-page-as-is.patch
mm-zswap-store-page_size-compression-failed-page-as-is-fix.patch
mm-zswap-store-page_size-compression-failed-page-as-is-v5.patch
mm-zswap-store-page_size-compression-failed-page-as-is-fix-2.patch
mm-damon-core-add-damon_ctx-addr_unit.patch
mm-damon-paddr-support-addr_unit-for-access-monitoring.patch
mm-damon-paddr-support-addr_unit-for-damos_pageout.patch
mm-damon-paddr-support-addr_unit-for-damos_lru_prio.patch
mm-damon-paddr-support-addr_unit-for-migrate_hotcold.patch
mm-damon-paddr-support-addr_unit-for-damos_stat.patch
mm-damon-sysfs-implement-addr_unit-file-under-context-dir.patch
docs-mm-damon-design-document-address-unit-parameter.patch
docs-admin-guide-mm-damon-usage-document-addr_unit-file.patch
docs-abi-damon-document-addr_unit-file.patch

