Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD3F48643D
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791866052; cv=none; b=TqotVGnpqMvABFO1fMeuphCV0XUUHWyql/NprB7Zmnq4QSPO4C8c8zavhuulWGD8k49oy2Wvv4UeGSgjjoCGnaKJboYeq5cu2yna2BollgyRHGKUa+jdUFEAZhnln35OwlDbn7guCcYklwk34hEmUzz351FnkgujYhm3u8zz86I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791866052; c=relaxed/simple;
	bh=0eafWbwOpAI9RuvvNEvZSFgUenRHim7NMBGPnEF9g4I=;
	h=Date:To:From:Subject:Message-Id; b=XImJi+nbTwdWTDke5yAJ34Ggj2/3Ut8FlDJkrN/uRuuFmhMtGF73AzC3M40qjBYiEjRlv82M/LdQ+JoZV5Or4hKxK5DA+OFocS6h2v7d+K5mX5FIjxUoYM43JrVOBdJFwYZN0l6Cmq0n0XM8ZFPZh8V2OG1TnmCCDCFNUfwd0Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pkbSD1RY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pkbSD1RY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14EF21F00898;
	Tue, 13 Oct 2026 04:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791866050;
	bh=1MjUe/Eq17PhkRcP89mYRhWT3dngLTYytpBaz0khQjE=;
	h=Date:To:From:Subject;
	b=pkbSD1RYU8UPFWTLCYwhJR/8Nj3VEvDR65Se6ob1LtHstpi+pZ8XNhE4BEYPd6844
	 /Sa0iZw4L+MY3fOyylATBm/PcHBN7pU/XEbhAyzu3sQ75anYcnzuJdDuJByuYwGHCg
	 qsdApV4z8x0uNbTdt+9f5Vbqc7BkIajR5NNwMWvU=
Date: Mon, 12 Oct 2026 21:34:09 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,wangxuewen@kylinos.cn,sj@kernel.org,aethernet65535@gmail.com,adrianhuang0701@gmail.com,karthiproffesional@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-document-that-a-zero-sample_interval-is-accepted.patch removed from -mm tree
Message-Id: <20261013043410.14EF21F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: document that a zero sample_interval is accepted
has been removed from the -mm tree.  Its filename was
     mm-damon-document-that-a-zero-sample_interval-is-accepted.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Karthikeyan KS <karthiproffesional@gmail.com>
Subject: mm/damon: document that a zero sample_interval is accepted
Date: Mon, 21 Sep 2026 08:15:46 -0700

damon_set_attrs() accepts sample_interval == 0.  This was reported as a
bug in v1 of this patch (rejecting it in damon_set_attrs()).  A similar
patch was already declined for the same reason: a zero interval is
intentionally supported [1].

Document the behavior instead of changing it.

Link: https://lore.kernel.org/20260921151547.78472-5-sj@kernel.org
Link: https://lore.kernel.org/all/20260722094304.3132750-1-dayou5941@163.com/ [1]
Signed-off-by: Karthikeyan KS <karthiproffesional@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Adrian Huang <adrianhuang0701@gmail.com>
Cc: Liew Rui Yan <aethernet65535@gmail.com>
Cc: Xuewen Wang <wangxuewen@kylinos.cn>
Cc: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---

 include/linux/damon.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-document-that-a-zero-sample_interval-is-accepted
+++ a/include/linux/damon.h
@@ -836,7 +836,8 @@ struct damon_probe {
 /**
  * struct damon_attrs - Monitoring attributes for accuracy/overhead control.
  *
- * @sample_interval:		The time between access samplings.
+ * @sample_interval:		The time between access samplings.  Zero is
+ *				accepted.
  * @aggr_interval:		The time between monitor results aggregations.
  * @ops_update_interval:	The time between monitoring operations updates.
  * @intervals_goal:		Intervals auto-tuning goal.
_

Patches currently in -mm which might be from karthiproffesional@gmail.com are


