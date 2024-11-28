Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46BBC13C;
	Thu, 28 Nov 2024 00:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732753368; cv=none; b=JbZD92xO2i4TpQC8oPg4vEAiGtw6et3rqHmAfbrojkK6VNMaq+bvnXXZ1l8xQd8WBitb5b4aWYbTqpBcP4lE7NmR6jLICaPvuD2mIlP5CbRtL2wQiaoajgphZ7aw7qOgcNq6VuY2qWmk76vSpd0+CvaE/GREZE7oLoV57wcVGzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732753368; c=relaxed/simple;
	bh=NAvzS1la58MsCAs+tIAji3uWK09yaPkkU4Fofom7ntE=;
	h=Date:To:From:Subject:Message-Id; b=sWbGu2gnuB0As6fVd5NexhrQZhDfFX+Wcv0qXyGY3jPi/os0z97qhoNApxzcmBcN2T4HzFK7dTnl6TklHedHm0C2bf6gT0SzPt00sRVzlvdj6boyQ4RKqMJxerfbQhzjvOXNXabd4IFbsQKfPs0DZmR4c6LIIaOoFOgG+4W73B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G1ZgMkns; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G1ZgMkns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AD8C4CECC;
	Thu, 28 Nov 2024 00:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732753368;
	bh=NAvzS1la58MsCAs+tIAji3uWK09yaPkkU4Fofom7ntE=;
	h=Date:To:From:Subject:From;
	b=G1ZgMknsAr7rPco9EBxdRbIB2rQovqWVlolZQTppgVw3+NGfNvhZTlR04CCtlcF9y
	 93kgJY/GEgN5Z0BpobbXzyJyhCD2f8Bl5pKLJrVkXwmOIcR4YHUyKeOEPzL8gFdzeb
	 c2pZzIpzLLz+DtPgUUEkPSyadg/MOef676bumFfQ=
Date: Wed, 27 Nov 2024 16:22:47 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,hca@linux.ibm.com,brauner@kernel.org,agordeev@linux.ibm.com,jolsa@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] fs-proc-kcorec-clear-ret-value-in-read_kcore_iter-after-successful-iov_iter_zero.patch removed from -mm tree
Message-Id: <20241128002248.08AD8C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/kcore.c: clear ret value in read_kcore_iter after successful iov_iter_zero
has been removed from the -mm tree.  Its filename was
     fs-proc-kcorec-clear-ret-value-in-read_kcore_iter-after-successful-iov_iter_zero.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiri Olsa <jolsa@kernel.org>
Subject: fs/proc/kcore.c: clear ret value in read_kcore_iter after successful iov_iter_zero
Date: Fri, 22 Nov 2024 00:11:18 +0100

If iov_iter_zero succeeds after failed copy_from_kernel_nofault, we need
to reset the ret value to zero otherwise it will be returned as final
return value of read_kcore_iter.

This fixes objdump -d dump over /proc/kcore for me.

Link: https://lkml.kernel.org/r/20241121231118.3212000-1-jolsa@kernel.org
Fixes: 3d5854d75e31 ("fs/proc/kcore.c: allow translation of physical memory addresses")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <hca@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/proc/kcore.c~fs-proc-kcorec-clear-ret-value-in-read_kcore_iter-after-successful-iov_iter_zero
+++ a/fs/proc/kcore.c
@@ -600,6 +600,7 @@ static ssize_t read_kcore_iter(struct ki
 					ret = -EFAULT;
 					goto out;
 				}
+				ret = 0;
 			/*
 			 * We know the bounce buffer is safe to copy from, so
 			 * use _copy_to_iter() directly.
_

Patches currently in -mm which might be from jolsa@kernel.org are


