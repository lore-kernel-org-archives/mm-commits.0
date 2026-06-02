Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BDD3C13EE
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439218; cv=none; b=gg8cw5DfkGLns2mDHMBnc9zE1UAcjTZdWde9Zq5okafs3mWfqXS5imGRLWvyfxWIm5aRf66jcD+Q63Bdrass9xae2pQNfqzuP6NagcQRhKW6tcJ9hJq2IsCt81eZQANOckfybPZtV8nZREmp0sFJkhHPqMwzu5WPIYTP4Tjchj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439218; c=relaxed/simple;
	bh=tpm4UaPOGXSx4ziv1jRzjXNU0CTA9A5SBAL8k/t1DlU=;
	h=Date:To:From:Subject:Message-Id; b=n89UScsAO8LsVftfTJUWYMB7leg/f2r8R+E7kan2HDjGSCovucVWBXYTS0sJl7I14K3vHQzbf83/Tgybdu0oAEM+TIepv2iIdaVcD3J4zN7x8Lbcdgw9XfZlbaBM2CR+Wyp+fxDI3akufbzSOuglyzKGMnP8e9gWsMIpcXCy9f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1oF+I1+A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1oF+I1+A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0FA1F00893;
	Tue,  2 Jun 2026 22:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439217;
	bh=XG2+U7spZID/wTBCx+91FGLdHIZHyU3FoNNP+OFNXAs=;
	h=Date:To:From:Subject;
	b=1oF+I1+AcTUXoS87S+utwvv/DBWRpoQbzjr8gz2NzUziJ5PmcStAQH+a9fkeDnv59
	 +M4UJDKn8PExEPOfS7+RAd7S23yPHPhkooH+351JceFPHc1LSwoY3BH5EAD/mFRioV
	 J410glxg3fxf3K00AyDR2SAd2VRG7OcWtbf/PjGc=
Date: Tue, 02 Jun 2026 15:26:57 -0700
To: mm-commits@vger.kernel.org,richardycc@google.com,minchan@kernel.org,bgeffon@google.com,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-clear-trailing-bytes-of-compressed-writeback-pages.patch removed from -mm tree
Message-Id: <20260602222657.7E0FA1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: clear trailing bytes of compressed writeback pages
has been removed from the -mm tree.  Its filename was
     zram-clear-trailing-bytes-of-compressed-writeback-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: clear trailing bytes of compressed writeback pages
Date: Tue, 26 May 2026 11:27:17 +0900

Patch series "zram: writeback fixes", v2.

Brian (privately) reported a "leak" of writeback bitmap in certain cases,
so that backing device can store less pages; and a theoretical data leak
in the trailing bytes of compressed writeback pages.  Both issues are low
risk.


This patch (of 2):

When compressed writeback is available writtenback pages contain "garbage"
in PAGE_SIZE - obj_size trailing bytes.  That "garbage" is, basically,
whatever data that page held before we got it for writeback.  To get
advantage of it an attacker needs to be able to read from active backing
swap device, which is already catastrophic.  Still, just in case, zero out
those trailing bytes before writeback to a backing device so that we only
store swap-ed out data there.

Link: https://lore.kernel.org/20260526022754.2377730-1-senozhatsky@chromium.org
Link: https://lore.kernel.org/20260526022754.2377730-3-senozhatsky@chromium.org
Fixes: d38fab605c66 ("zram: introduce compressed data writeback")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Suggested-by: Brian Geffon <bgeffon@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-clear-trailing-bytes-of-compressed-writeback-pages
+++ a/drivers/block/zram/zram_drv.c
@@ -2134,6 +2134,8 @@ static int read_from_zspool_raw(struct z
 	zs_obj_read_end(zram->mem_pool, handle, size, src);
 	zcomp_stream_put(zstrm);
 
+	memzero_page(page, size, PAGE_SIZE - size);
+
 	return 0;
 }
 #endif
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


