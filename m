Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96583B8D75
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439038; cv=none; b=LCDHm+FovA6f1x1Du2N17FwgY47rHoEXRXYwXNXuBjv87N4mhUsjHm65TmU7HiSLD+okKctgbHiKuMzAeSFFIUpY/yOoWQ0H+EkbR6wMHuKh7Ow5pxpM/kP9Idops/WE41oU1xAkPJhVNGqs0i7sQjy3Eo2gIMUzQGhiSYFNV3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439038; c=relaxed/simple;
	bh=gzyqeHIUVwhDdwDbLd3eLJj20TgffAfINyYdj/GKJRY=;
	h=Date:To:From:Subject:Message-Id; b=GsIf3Mm9jNDlfrh1nXu86Gf0c8lRBpzQPvR/qF4BVwcpyCEsZ/ANCR69CQ8YEndrKqTGEHMQ4fJVwHdhCTVpw4Yw68M2qJQrhX5QfunhgVrAQ1BqjxpuaLkJa2BJGG551+Md32B/tR5y3bNkNkB97gH9sBRirKXC4p+DhJFndV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BYtaRpdU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BYtaRpdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E05B1F00898;
	Tue,  2 Jun 2026 22:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439037;
	bh=6r0O/PzZCf0djG8Hex4F7nhwVC0FGP1S0MIUDkSvjMY=;
	h=Date:To:From:Subject;
	b=BYtaRpdUg8ld58aYWaLNQojiHQbV3/iRSINwurTDkUGOdV5Dvv0Pun6PjSxrpLGWl
	 HpKiqJCdrNiQRwHPnmySGSc8fsk54nOAQae0G/GOPU6EMphiJdM00Wb7fQQ5sYbysP
	 yc2wZ0i5/dZI7+3u5tp1T42T9UGn3JDnGx6isNzE=
Date: Tue, 02 Jun 2026 15:23:57 -0700
To: mm-commits@vger.kernel.org,error27@gmail.com,akpm@linux-foundation.org,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_meminit-use-for-bools.patch removed from -mm tree
Message-Id: <20260602222357.8E05B1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_meminit: use && for bools
has been removed from the -mm tree.  Its filename was
     lib-test_meminit-use-for-bools.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: lib/test_meminit: use && for bools
Date: Mon, 4 May 2026 12:06:37 +0200

As pointed out by Dan Carpenter, test_kmemcache() was using a bitwise AND
on two bools instead of a boolean AND.  Fix this for the sake of code
cleanliness.

Link: https://lore.kernel.org/20260504100637.1535762-1-glider@google.com
Fixes: 5015a300a522 ("lib: introduce test_meminit module")
Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/kernel-janitors/afOcIan1ap9kD26M@stanley.mountain/
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_meminit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_meminit.c~lib-test_meminit-use-for-bools
+++ a/lib/test_meminit.c
@@ -387,7 +387,7 @@ static int __init test_kmemcache(int *to
 			ctor = flags & 1;
 			rcu = flags & 2;
 			zero = flags & 4;
-			if (ctor & zero)
+			if (ctor && zero)
 				continue;
 			num_tests += do_kmem_cache_size(size, ctor, rcu, zero,
 							&failures);
_

Patches currently in -mm which might be from glider@google.com are


