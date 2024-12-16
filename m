Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0CE101DE
	for <mm-commits@vger.kernel.org>; Mon, 16 Dec 2024 05:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734326438; cv=none; b=tU33CMsbnkkxJlN/rqRh+hf4K4brZVi+tRdSqXDUqE2ezyJA8ZZw4hlGQ8fwmSRD4F2lYsvCEfW26MHrUnW/AFIWfcicxyUJ0NsSjRi/pw8g7l8N5Ovc5bsTF4jG6uj2ePld99TEHQDJIBAV9+m1xzslNpYtxd+4I7wIW8ptLBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734326438; c=relaxed/simple;
	bh=MgLZ1zZOCgTyglfR8yxI5OE0a33JOCjW0K03RT28NoU=;
	h=Date:To:From:Subject:Message-Id; b=fiy3wnwi22JbYSLVtp2guysTpnRXuNhgnhHAGFeirGnrAPNehodSEA5BQis0vutysUiyXqEOUAuTriKBI6VqcALk1MWEU4xiJfBwqShLghWVX6qou0BYZvOP49ATSHnmFgcBOW71wFOGR0hmNTpv/YoBsIhmhnDDMVqpiB4Jom8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E/3ffLH1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E/3ffLH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728C9C4CED0;
	Mon, 16 Dec 2024 05:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734326437;
	bh=MgLZ1zZOCgTyglfR8yxI5OE0a33JOCjW0K03RT28NoU=;
	h=Date:To:From:Subject:From;
	b=E/3ffLH1wbHL/g7jO9a+2QWg8G4C6/lfdFtwdor6A82UUYlohzmW1d4vHVX7OI2u9
	 Zp8eRCZalqsIKp5YSZ4pVqS3WKy11I1SiEVvQesCzEakY+F5CbKauTsbTWS73UhGS+
	 7ImdQbS9QXA/frUtY9HXdb4tVrMDgeDR3F62FL0s=
Date: Sun, 15 Dec 2024 21:20:36 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,caiqingfu@ruijie.com.cn,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zram-panic-when-use-ext4-over-zram-fix.patch removed from -mm tree
Message-Id: <20241216052037.728C9C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram-panic-when-use-ext4-over-zram-fix
has been removed from the -mm tree.  Its filename was
     zram-panic-when-use-ext4-over-zram-fix.patch

This patch was dropped because it was folded into zram-panic-when-use-ext4-over-zram.patch

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram-panic-when-use-ext4-over-zram-fix
Date: Tue, 10 Dec 2024 18:38:35 +0900

simplify zram_write_page() -ENOMEM return

Link: https://lkml.kernel.org/r/20241210093835.GN16709@google.com
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: caiqingfu <caiqingfu@ruijie.com.cn>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-panic-when-use-ext4-over-zram-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -1668,7 +1668,7 @@ compress_again:
 
 	if (last_comp_len && (last_comp_len != comp_len)) {
 		zs_free(zram->mem_pool, handle);
-		handle = (unsigned long)ERR_PTR(-ENOMEM);
+		handle = -ENOMEM;
 	}
 	/*
 	 * handle allocation has 2 paths:
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-panic-when-use-ext4-over-zram.patch

