Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0743BE64C
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 22:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788300882; cv=none; b=AXRAwGtqrhY25epUpU73h4Jxwbx6vq/s/oLt+nsJeN2NZFAOFCUwV9AOXlbrWhqXQVGP58c79n26SKvJbXY3Q2ZgY8kJfsLhRUdBmjiQsPKiPqZph3QgwRwLUS/p9jkCtCTukCGx1uNenVBJI74F6Q2AkM7HZsUT0L1L0mWrWVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788300882; c=relaxed/simple;
	bh=yjsgW6lqAS7xHtW5lGdMQv99+/TBAWu7CXOhKaoC4ts=;
	h=Date:To:From:Subject:Message-Id; b=nmhWkjEVcLzxPpP3WY7jlH+fsb5Gt6hjS4rqhwlfqYXG5/P2+u5zPLxtXVctwzT8ApM/HQWMiOHXZjDVyJKeF4/GRYrAxrzhqYff+N0PfVACbwELpdmNrPpRi5b8xnNzXmNUL0mGhTcJaNNnvn3HIWSIPcd8qYPRTZuvJatMV8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vPF6ZKc5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vPF6ZKc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F041F000E9;
	Tue,  1 Sep 2026 22:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788300880;
	bh=VaXopG/Rr7/DwCw1+NXnk73e3MExJUoWKmjpj8TYyMQ=;
	h=Date:To:From:Subject;
	b=vPF6ZKc5Fc6kGN/EtG9pzXLhINPH6Q+ut/T5TOONlQqGU9HQaIYpHk+C2AsIkkuTC
	 RpTNF8XtmXTPrFRAC+xNapWbCdjjQ5j1OGdZvYLE8RYNn8HseyuWynhcDhUJb+7tq+
	 VcQqAjgRm4Rx7CedwIXrOA+tPI2j9PUvzQbrqqos=
Date: Tue, 01 Sep 2026 15:14:40 -0700
To: mm-commits@vger.kernel.org,haoqinhuang7@gmail.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-remove-unreachable-kernel_read_file_from_path-return-check.patch added to mm-new branch
Message-Id: <20260901221440.C1F041F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: remove unreachable kernel_read_file_from_path() return check
has been added to the -mm mm-new branch.  Its filename is
     zram-remove-unreachable-kernel_read_file_from_path-return-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-remove-unreachable-kernel_read_file_from_path-return-check.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: remove unreachable kernel_read_file_from_path() return check
Date: Tue, 1 Sep 2026 14:13:05 +0900

Sashiko reported that:
kernel_read_file_from_path() returns negative error for zero-sized
files, so we cannot have "sz == 0" return, remove it and use a
generic error message instead.

Link: https://lore.kernel.org/20260901051335.2202390-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Haoqin Huang <haoqinhuang7@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-remove-unreachable-kernel_read_file_from_path-return-check
+++ a/drivers/block/zram/zram_drv.c
@@ -1722,11 +1722,6 @@ static int comp_params_store(struct zram
 			       dict_path, sz);
 			return sz;
 		}
-		if (sz == 0) {
-			pr_err("failed to load dictionary %s (empty file)\n",
-			       dict_path);
-			return -EINVAL;
-		}
 	}
 
 	zram->params[prio].dict_sz = sz;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-remove-unreachable-kernel_read_file_from_path-return-check.patch

