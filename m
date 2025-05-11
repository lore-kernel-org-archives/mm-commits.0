Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7FF2F2E
	for <mm-commits@vger.kernel.org>; Sun, 11 May 2025 03:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746934375; cv=none; b=d3NQCrAiNOHN5qUefStarO1heIKt+U6EoZEXkOmNqfU8KMXsSj+mM7lFGoX3A/BQzMMZlC0a/PLUx7XZVq/cmvoDKwck2zxt5PwWVfWXWtDvcBmIqsTyKRJU4u0GMtedtuoHP1ORK0D+RWcPfJ2+p5m1nG0opEWGAhTov33UQQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746934375; c=relaxed/simple;
	bh=uQSnxo8hLy+Khut8KiEFTH7kvpeubuH/UQ8mmYsq0HE=;
	h=Date:To:From:Subject:Message-Id; b=YjKmds/KhceD0+3pQLo+dSCWWEX+5alMFNLreorpmjGSJGJk/V+D+w0n3G0tTYpUtQHNmO8JLv/EN8dVNirkezU+PdFn8L05UoRpyLjkNMrfrppcJaOUNZMATgk0sNtboSg650tlXS7VgukaxfwzVayj83uO60vA69jXB7Gb340=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rmy1ew1x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rmy1ew1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2879C4CEE4;
	Sun, 11 May 2025 03:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746934374;
	bh=uQSnxo8hLy+Khut8KiEFTH7kvpeubuH/UQ8mmYsq0HE=;
	h=Date:To:From:Subject:From;
	b=rmy1ew1xuLHFyNuso4J36N1DSnG64JT4B3sNTcaFIgo/U6qgRFwdItfpAzmXLRd/4
	 eN1RXhcJv6qg4GdjrCht5hUqyyhxOt3UbjU9V8O9PZcypEfX9WmQCLWj2sp1NFbJaq
	 RQUUdHj7OtU48iXzM+i2skvyCys7JOn3dhUXRJss=
Date: Sat, 10 May 2025 20:32:53 -0700
To: mm-commits@vger.kernel.org,richardycc@google.com,minchan@kernel.org,dan.carpenter@linaro.org,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zram-modernize-writeback-interface-v3.patch removed from -mm tree
Message-Id: <20250511033253.F2879C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: modernize writeback interface
has been removed from the -mm tree.  Its filename was
     zram-modernize-writeback-interface-v3.patch

This patch was dropped because it was folded into zram-modernize-writeback-interface.patch

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: modernize writeback interface
Date: Fri, 4 Apr 2025 10:52:50 +0900

simplify parse_page_index() range checks, per Brian

Link: https://lkml.kernel.org/r/20250404015327.2427684-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Brian Geffon <bgeffon@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-modernize-writeback-interface-v3
+++ a/drivers/block/zram/zram_drv.c
@@ -853,9 +853,9 @@ static int parse_page_index(char *val, u
 	ret = kstrtoul(val, 10, lo);
 	if (ret)
 		return ret;
-	*hi = *lo + 1;
-	if (*lo >= nr_pages || *hi > nr_pages)
+	if (*lo >= nr_pages)
 		return -ERANGE;
+	*hi = *lo + 1;
 	return 0;
 }
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-dont-underflow-size-calculation-in-zs_obj_write.patch
zram-modernize-writeback-interface.patch
zram-modernize-writeback-interface-v4.patch
zsmalloc-cleanup-headers-includes.patch
documentation-zram-update-idle-pages-tracking-documentation.patch

