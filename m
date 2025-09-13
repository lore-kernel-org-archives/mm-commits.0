Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9A123D7DB;
	Sat, 13 Sep 2025 20:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757794177; cv=none; b=gk2CWHEX6n2t2p/v7AbvPTsZiNLqfEopBuNALyX3rMSNzCbfMnb1J9oyLNBCJ9C1JO4sTxVR7R5CX1pjsfXUmLvHKEGLeGgjsAA7xEXLqJbA6KxIHH3bwj26FfzCSvzkqDEl5cNGTK3WPzW+GG0Ts7kht4ZpjUlFynmJlJGvwug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757794177; c=relaxed/simple;
	bh=F9caRdSskG/Wud2mKPACoqcU8uCCafA3LKGW+paQMo0=;
	h=Date:To:From:Subject:Message-Id; b=effcbaPp8exCnSgztUfmWyp7WZIrDPg+/Sujjy6S2tOpVZkCFMCMEEnhEGic54o34XV+DMCpyxNLzn+tHsEd5F5pyT3za/zbkbFN0HT7MGGSJqFFov893czmRZx5N2hLkBFOKGfqyjQH2AiTqUOw1hfEyWqWsOdvjsIWgvWKOME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q/BL0DqR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q/BL0DqR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC72C4CEF5;
	Sat, 13 Sep 2025 20:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757794177;
	bh=F9caRdSskG/Wud2mKPACoqcU8uCCafA3LKGW+paQMo0=;
	h=Date:To:From:Subject:From;
	b=Q/BL0DqRpcS+XfPEqVw0ccIbrSC9D+DQSSZIu6ruz8Uj7gIibQcaNWMQgeFGWvwyT
	 OmaoguF1KtMt8uponTqgTFF/22eXCcDENcKVeDHRzDJ3CRqqsvYotMpoioCgy2b9M3
	 VNdEys9lcT/M+tTjPSTtLSWAFyymE1mtVI+ZzHSU=
Date: Sat, 13 Sep 2025 13:09:36 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] samples-damon-prcl-avoid-starting-damon-before-initialization.patch removed from -mm tree
Message-Id: <20250913200937.2EC72C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon/prcl: avoid starting DAMON before initialization
has been removed from the -mm tree.  Its filename was
     samples-damon-prcl-avoid-starting-damon-before-initialization.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: samples/damon/prcl: avoid starting DAMON before initialization
Date: Mon, 8 Sep 2025 19:22:37 -0700

Commit 2780505ec2b4 ("samples/damon/prcl: fix boot time enable crash") is
somehow incompletely applying the origin patch [1].  It is missing the
part that avoids starting DAMON before module initialization.  Probably a
mistake during a merge has happened.  Fix it by applying the missed part
again.

Link: https://lkml.kernel.org/r/20250909022238.2989-3-sj@kernel.org
Link: https://lore.kernel.org/20250706193207.39810-3-sj@kernel.org [1]
Fixes: 2780505ec2b4 ("samples/damon/prcl: fix boot time enable crash")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/prcl.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/samples/damon/prcl.c~samples-damon-prcl-avoid-starting-damon-before-initialization
+++ a/samples/damon/prcl.c
@@ -137,6 +137,9 @@ static int damon_sample_prcl_enable_stor
 	if (enabled == is_enabled)
 		return 0;
 
+	if (!init_called)
+		return 0;
+
 	if (enabled) {
 		err = damon_sample_prcl_start();
 		if (err)
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

