Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA0E165EED
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 08:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313714; cv=none; b=Gx5HkUTY/Xa/7sZ47i9OtSYLReBTWRXEcN0a4NDbD631/fuZ6HTY8mRNcSV8oPCVIbuJ0oVNHPcoMHrOU59Q2nvC0JCUPwT2HUau7umuxbjV/1K1MFyDCNGhydzv3aCqtTY6+q2aQqF77t0P1sFT0gQZ1ulHthwlkeWot47RaOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313714; c=relaxed/simple;
	bh=5NnQ3A1szIfXSwXH8zxMc56+ldtFLn13s7xqQPzEvIk=;
	h=Date:To:From:Subject:Message-Id; b=lvPcX6lgQnom8CRcJP00vmyoiV2435NjessKvRUjhm6cX/S8WxlzaoGz3TUb0XsAuKsmNTJSlqBfHcRIFmVPMznB69ufCMRE8q3SPxWmiXEKF8pTWedg4D9TCJ9TgxsciJ0i+fqyCtG/jMaslvWVgZByf1ZuvOAw+OAvoAKldLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ipx/RjaM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ipx/RjaM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22492C4CED0;
	Mon, 11 Nov 2024 08:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731313714;
	bh=5NnQ3A1szIfXSwXH8zxMc56+ldtFLn13s7xqQPzEvIk=;
	h=Date:To:From:Subject:From;
	b=ipx/RjaMCIT3LZrz77xqpJfa4PDiEomJfYEKDp+pNyjB269ufLACJTl9JDBopySE0
	 Xg5tgsKSoD9xl1EUDMW96BR38PeV4ykFPHH3DsUOU+0C8Cu+ebLcoOnaW4pt7uU/BZ
	 fqdxkSyhah61c1J/5A3rdPSxmwEYO/OHmDqvHkxY=
Date: Mon, 11 Nov 2024 00:28:33 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,kawasin@google.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-clear-idle-flag-in-mark_idle.patch removed from -mm tree
Message-Id: <20241111082834.22492C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: clear IDLE flag in mark_idle()
has been removed from the -mm tree.  Its filename was
     zram-clear-idle-flag-in-mark_idle.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: clear IDLE flag in mark_idle()
Date: Tue, 29 Oct 2024 00:36:15 +0900

If entry does not fulfill current mark_idle() parameters, e.g.  cutoff
time, then we should clear its ZRAM_IDLE from previous mark_idle()
invocations.

Consider the following case:
- mark_idle() cutoff time 8h
- mark_idle() cutoff time 4h
- writeback() idle - will writeback entries with cutoff time 8h,
  while it should only pick entries with cutoff time 4h

The bug was reported by Shin Kawamura.

Link: https://lkml.kernel.org/r/20241028153629.1479791-3-senozhatsky@chromium.org
Fixes: 755804d16965 ("zram: introduce an aged idle interface")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Shin Kawamura <kawasin@google.com>
Acked-by: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-clear-idle-flag-in-mark_idle
+++ a/drivers/block/zram/zram_drv.c
@@ -410,6 +410,8 @@ static void mark_idle(struct zram *zram,
 #endif
 		if (is_idle)
 			zram_set_flag(zram, index, ZRAM_IDLE);
+		else
+			zram_clear_flag(zram, index, ZRAM_IDLE);
 		zram_slot_unlock(zram, index);
 	}
 }
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


