Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162FD1A6835
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744853; cv=none; b=JArZNMjOypz0Oohk+L+oXBChSr3jtEZiCqyveJrse0lKY3sRul97vVbynE5IlTpwvsr3bFrgmBWCtYLoJMPAcpVjwi7wM5pglzdKEW1GQdPixwXNE+qxkttP5nrG0fADsIT7l7RZd4ZnU74d6JODLSykehyAk0s8NlWGfkxlx1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744853; c=relaxed/simple;
	bh=akQiIsvNswRqgyMDi9zhe1hpnbrJMFTZTXw5aVfhwOY=;
	h=Date:To:From:Subject:Message-Id; b=BtsGFdeoo3NeM+gHnYekQHGVUTejPVA7aoPukjTxLwBeeOKsmaaaTzy1G0okfjK+PcPkAtbxAhyFOZ/JtfS5Zk8vPvsT+4pSxl1tBL8Y8l29qcPn2l15KnNKxSqxIgGYkb5IlTmj3Nv1rmSKyQRD2vR3CoYiuzWbYNN/wtIaFKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PzIEDnV1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PzIEDnV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E177EC4CEF7;
	Sun, 29 Mar 2026 00:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744853;
	bh=akQiIsvNswRqgyMDi9zhe1hpnbrJMFTZTXw5aVfhwOY=;
	h=Date:To:From:Subject:From;
	b=PzIEDnV1lpdG5aH5aR5NEK26xC8jSuiLvvmtqeZWlEw3CuCuGyGiVcL6HSv7YURGD
	 NqYap4Z3wgNrt+MqV2Y7SjtWOG1GihY+TjgvOtQOOXrhoG/C39GiEfbSeyPWRb4Tay
	 bdDLXEIcwx33Np2hDrwOReMhAy/NqbHk6o917Nys=
Date: Sat, 28 Mar 2026 17:40:52 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,gaoxu2@honor.com,bgeffon@google.com,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-do-not-permit-params-change-after-init.patch removed from -mm tree
Message-Id: <20260329004052.E177EC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: do not permit params change after init
has been removed from the -mm tree.  Its filename was
     zram-do-not-permit-params-change-after-init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: do not permit params change after init
Date: Wed, 11 Mar 2026 17:42:44 +0900

Patch series "zram: recompression cleanups and tweaks", v2.

This series is a somewhat random mix of fixups, recompression cleanups and
improvements partly based on internal conversations.  A few patches in the
series remove unexpected or confusing behaviour, e.g.  auto correction of
bad priority= param for recompression, which should have always been just
an error.  Then it also removes "chain recompression" which has a tricky,
unexpected and confusing behaviour at times.  We also unify and harden the
handling of algo/priority params.  There is also an addition of missing
device lock in algorithm_params_store() which previously permitted
modification of algo params while the device is active.


This patch (of 6):

First, algorithm_params_store(), like any sysfs handler, should grab
device lock.

Second, like any write() sysfs handler, it should grab device lock in
exclusive mode.

Third, it should not permit change of algos' parameters after device init,
as this doesn't make sense - we cannot compress with one C/D dict and then
just change C/D dict to a different one, for example.

Another thing to notice is that algorithm_params_store() accesses device's
->comp_algs for algo priority lookup, which should be protected by device
lock in exclusive mode in general.

Link: https://lkml.kernel.org/r/20260311084312.1766036-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20260311084312.1766036-2-senozhatsky@chromium.org
Fixes: 4eac932103a5 ("zram: introduce algorithm_params device attribute")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Brian Geffon <bgeffon@google.com>
Cc: gao xu <gaoxu2@honor.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-do-not-permit-params-change-after-init
+++ a/drivers/block/zram/zram_drv.c
@@ -1734,6 +1734,10 @@ static ssize_t algorithm_params_store(st
 		}
 	}
 
+	guard(rwsem_write)(&zram->dev_lock);
+	if (init_done(zram))
+		return -EBUSY;
+
 	/* Lookup priority by algorithm name */
 	if (algo) {
 		s32 p;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


