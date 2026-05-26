Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E3878F29
	for <mm-commits@vger.kernel.org>; Tue, 26 May 2026 20:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779825711; cv=none; b=IL2+YUVtPYYCAgu3AT5NtGE2dnQ1N5NyBLn37RQ5dKmejhriZ/axAgplJgKLLqkDz252KRtjIFcVbwrwO2KEkHKAF2kObGjm9qMhVIG6SsStT2BepW+XnKhNw5GfdfBd1POoXqHlsKvbBprl06LeLTAKaf0zX9UI+U0HG5EP3a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779825711; c=relaxed/simple;
	bh=Gt0bR8hPXKupA8ERkCN0KNamDBrV1Q9rPD2pgeg1NRg=;
	h=Date:To:From:Subject:Message-Id; b=QSr/2vBzlpfa5O+GJBLUZBOkAcpkYpGNarHZ57FWd4EQOFUaxomxbMWrFMX7/uQj3snSw1ThWEVBVO/mK4GGKbiAnKuoGSn1qJS3DXWT6AeMrPuC6t1i4Owew9W6wPXAD3z3KWgcIVrt8OaWXk4pUOLLLvTzCk2iQcVlELlz2bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Olrmn83x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Olrmn83x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB431F00A3A;
	Tue, 26 May 2026 20:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779825709;
	bh=wvPfHvxwpxcIbGycX9bGAECPJFypKLZwo7OFM8rOSbk=;
	h=Date:To:From:Subject;
	b=Olrmn83x+sF4eQLAYXv6hOCJjgv5xEtSFb47cKQot2mlXq+RuHwPUi9nmIXWZLrwT
	 5iVVten3jyh2px/02+JrJ355fKlS1lnVRL44DPbCYRHSIrphttRPIlSpMZff7nOyHd
	 OMpvD0Sh2nMSWyX6ITCA8ndImWcKKK16k41r50WI=
Date: Tue, 26 May 2026 13:01:48 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] zram-clear-trailing-bytes-of-compressed-writeback-pages.patch removed from -mm tree
Message-Id: <20260526200149.2EB431F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: clear trailing bytes of compressed writeback pages
has been removed from the -mm tree.  Its filename was
     zram-clear-trailing-bytes-of-compressed-writeback-pages.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: clear trailing bytes of compressed writeback pages
Date: Mon, 25 May 2026 13:46:02 +0900

When compressed writeback is available writtenback pages contain garbage
PAGE_SIZE - obj_size trailing bytes.  Zero out those trailing bytes before
writeback to a backing device.

Link: https://lore.kernel.org/20260525044639.1888561-3-senozhatsky@chromium.org
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


