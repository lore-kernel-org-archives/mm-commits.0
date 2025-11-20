Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190CA34D3AA
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675078; cv=none; b=JDMda9FhOWCBPSKTNGoYTg/r9tnZ69xg/ZT0hgAFYuBs6VRVBNFdSVj47bO3ewcQ7ADKdzxUoayevcukrIlK4zW8WWZLF2e1Vn3OUUKMbZw9vMufCCvhsR+3swwKmxzU9bRU4tGKSx2Z8i0aKrnWD/25gbjPA+hGNTUT55ICttU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675078; c=relaxed/simple;
	bh=+HvLsrSRBNfFcrr3JQ8RynhWi83AnzDytMN1+BM/h8M=;
	h=Date:To:From:Subject:Message-Id; b=mk9gVfxhwUV3PPZK56SuzzZjQd1lGIkXQDAi5YbR1P65cp6NkXJSkK1LmxEjgXYcSxI4XB9by8DGn9WXb3tDtpApf8uRyMiAWcLzA5fUdUv8dyeFFUY75FceAy6CjldOHSq1nUkFy30KO+UWJxn6c2hr7Un8+EwnSS5i2WAQTVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zPZWboCy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zPZWboCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89FDC4CEF1;
	Thu, 20 Nov 2025 21:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675077;
	bh=+HvLsrSRBNfFcrr3JQ8RynhWi83AnzDytMN1+BM/h8M=;
	h=Date:To:From:Subject:From;
	b=zPZWboCyGJxyecq1iy+cyX4wwNrPCBTxZM+3TJQDKzSo2Mag3Mr4WCCg87CvPfcPl
	 HE+x0tYCReMGQH37DcacaoutfgjPDMHVkE3B/ToVFeV2cJTp7o+sJ7vejwmuSpUJ53
	 HihJywDk88EUYrVTdqSaEiJssp1PwelCwMuonE9M=
Date: Thu, 20 Nov 2025 13:44:37 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,sj@kernel.org,kent.overstreet@linux.dev,zengchi@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] alloc_tag-use-%pe-format-specifier.patch removed from -mm tree
Message-Id: <20251120214437.A89FDC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/alloc_tag: use %pe format specifier
has been removed from the -mm tree.  Its filename was
     alloc_tag-use-%pe-format-specifier.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zeng Chi <zengchi@kylinos.cn>
Subject: lib/alloc_tag: use %pe format specifier
Date: Wed, 5 Nov 2025 10:39:25 +0800

The %pe format specifier is designed to print error pointers.  It prints a
symbolic error name (eg.  -EINVAL) and it makes the code simpler by
omitting PTR_ERR();

This patch fixes this cocci report:
lib/alloc_tag.c:776:63-70: WARNING: Consider using %pe to print PTR_ERR()

Link: https://lkml.kernel.org/r/20251105023925.1447482-1-zeng_chi911@163.com
Signed-off-by: Zeng Chi <zengchi@kylinos.cn>
Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/alloc_tag.c~alloc_tag-use-%pe-format-specifier
+++ a/lib/alloc_tag.c
@@ -845,7 +845,7 @@ static int __init alloc_tag_init(void)
 
 	alloc_tag_cttype = codetag_register_type(&desc);
 	if (IS_ERR(alloc_tag_cttype)) {
-		pr_err("Allocation tags registration failed, errno = %ld\n", PTR_ERR(alloc_tag_cttype));
+		pr_err("Allocation tags registration failed, errno = %pe\n", alloc_tag_cttype);
 		free_mod_tags_mem();
 		shutdown_mem_profiling(true);
 		return PTR_ERR(alloc_tag_cttype);
_

Patches currently in -mm which might be from zengchi@kylinos.cn are


