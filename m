Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06DA1C84CB;
	Tue, 25 Aug 2026 01:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622322; cv=none; b=XrazGDB+Xdhshiw4cB7IbgOxlrtvaU5vWEY3aLVfirR64q8cmGaDgqNoADHspbKAGGlbF9jgxEbSiIlOoJbsnnfdiKTy0robBZRna+tRfMJnyO4nph4yYtYfSpcemPyfUWa6KkEUCHW5NQipVrbYHHVE1YsviZGrCS40ELap4dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622322; c=relaxed/simple;
	bh=U4Fk9Hjn+76WcVhcs2OXntv5IK7yw3GLi9nzxOy9U2c=;
	h=Date:To:From:Subject:Message-Id; b=rh8uEKrJnTymXcP9x2BxuStPG+ILFjvCDtmaFrqQ91FSnNViQVB7tZr29Lq6k/nGdiu0XTbMi4aVcZx8nncEhx+tMH2oWryyBlO45etDBAHUmpafFhJTUt8nBlxOlwT2Scghc9DOVQ+Uo5GefK1xMlPMmIv0y8HEor+zaNXBZHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2HTn27iH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2HTn27iH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E4F1F00A3A;
	Tue, 25 Aug 2026 01:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622320;
	bh=Ah5i46KIUoWYCNAdTM/Du2zqUuNV74L3ObdP2oFa5C8=;
	h=Date:To:From:Subject;
	b=2HTn27iHEYrlJ365HCqHRA8LxghzrpfrmYyJe9FeS7yJ9HX6SpLDECV+Kjg8bS3Gp
	 jl/0ebN7dFd8uSTNB1AwKdHpGgB3LjQ0Xj5jABlplj2TgwbM7Q+ViZG6Ed3RvtduWt
	 qrGpBd9OseImJVkI6I6zOAKIo1lidYCEzUCNxAX8=
Date: Mon, 24 Aug 2026 18:45:20 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,minchan@kernel.org,haoqinhuang7@gmail.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-validate-deflate-params.patch removed from -mm tree
Message-Id: <20260825014520.C4E4F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: validate deflate params
has been removed from the -mm tree.  Its filename was
     zram-validate-deflate-params.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: validate deflate params
Date: Wed, 29 Jul 2026 13:57:36 +0900

We must validate user-supplied deflate winbits before we pass it to
zlib_deflate_workspacesize(), which triggers BUG_ON() if winbits value is
outside of valid ranges.

Link: https://lore.kernel.org/20260729045745.775973-3-senozhatsky@chromium.org
Fixes: dc75a0d93bd5 ("zram: support deflate-specific params")
Link: https://sashiko.dev/#/patchset/20260728092935.31139-1-haoqinhuang7@gmail.com
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Haoqin Huang <haoqinhuang7@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/backend_deflate.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/block/zram/backend_deflate.c~zram-validate-deflate-params
+++ a/drivers/block/zram/backend_deflate.c
@@ -24,8 +24,16 @@ static int deflate_setup_params(struct z
 {
 	if (params->level == ZCOMP_PARAM_NOT_SET)
 		params->level = Z_DEFAULT_COMPRESSION;
-	if (params->deflate.winbits == ZCOMP_PARAM_NOT_SET)
+	if (params->deflate.winbits == ZCOMP_PARAM_NOT_SET) {
 		params->deflate.winbits = DEFLATE_DEF_WINBITS;
+	} else {
+		s32 wb = params->deflate.winbits;
+
+		if ((wb < -15 || wb > -9) && (wb < 9 || wb > 15)) {
+			pr_err("invalid deflate winbits: %d\n", wb);
+			return -EINVAL;
+		}
+	}
 
 	return 0;
 }
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


