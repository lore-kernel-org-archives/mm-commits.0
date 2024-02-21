Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E12E12AAE2
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 23:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708559128; cv=none; b=KcEGTLQu3GFUTUvbICnDmqzVf1Qb1zDp82Vrv+1UqTzzs4yf2CpmzHtUUUVqlA3oMFHuUebu0zXljELJMls3gPWb+KYcHqaY6INOdiHXTinDHgeLQ0DwuKy3LSIC2GfcEcKeK+ZlRac0j3qXG0+AyDZ9g3RJx5OOZF1AtRxlP+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708559128; c=relaxed/simple;
	bh=O/gLjSb5S9P9MWv0yf9ikXs1Db5KaErK2jiIKbE75iI=;
	h=Date:To:From:Subject:Message-Id; b=qfg0EQYRO0QcYqJ9xV52ZzkeYFWle3eMSFPbSF6lTxDMDZk+diLWs85iDBO1OK3Su9oo+nGefOX9Pag6uCiXxBlspNaGMu82XhAfwWanzxn0h/Ku8aD39Lmndah3IXnZYRCRs+aJweFklTvnbSt0jigXDIyYO7Pl9s2Tdvavy9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KwCIwAnN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KwCIwAnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0220CC433C7;
	Wed, 21 Feb 2024 23:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708559128;
	bh=O/gLjSb5S9P9MWv0yf9ikXs1Db5KaErK2jiIKbE75iI=;
	h=Date:To:From:Subject:From;
	b=KwCIwAnNG2MRK0J9CHisKPtuaHy71Qr0QgUcrZVVkdyZxUdtSIb7uURPY3Mlf96ul
	 54L+dDqh2EW66zXyj5M7AA/EkHdsJzru1FaWBRUR1fV51vtNkdiJRvlrm4dtfz8Dce
	 HNSXJRy2Yvh3KrGNmLuskVM8ytSTRc53lLuTQzCw=
Date: Wed, 21 Feb 2024 15:45:27 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,p.raghav@samsung.com,oliver.sang@intel.com,da.gomez@samsung.com,mcgrof@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] test_xarray-add-tests-for-advanced-multi-index-use-fix.patch removed from -mm tree
Message-Id: <20240221234528.0220CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: test_xarray: fix soft lockup for advanced-api tests
has been removed from the -mm tree.  Its filename was
     test_xarray-add-tests-for-advanced-multi-index-use-fix.patch

This patch was dropped because it was folded into test_xarray-add-tests-for-advanced-multi-index-use.patch

------------------------------------------------------
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: test_xarray: fix soft lockup for advanced-api tests
Date: Fri, 16 Feb 2024 11:43:29 -0800

The new adanced API tests want to vet the xarray API is doing what it
promises by manually iterating over a set of possible indexes on its
own, and using a query operation which holds the RCU lock and then
releases it. So it is not using the helper loop options which xarray
provides on purpose. Any loop which iterates over 1 million entries
(which is possible with order 20, so emulating say a 4 GiB block size)
to just to rcu lock and unlock will eventually end up triggering a soft
lockup on systems which don't preempt, and have lock provin and RCU
prooving enabled.

xarray users already use XA_CHECK_SCHED for loops which may take a long
time, in our case we don't want to RCU unlock and lock as the caller
does that already, but rather just force a schedule every XA_CHECK_SCHED
iterations since the test is trying to not trust and rather test that
xarray is doing the right thing.


Link: https://lkml.kernel.org/r/20240216194329.840555-1-mcgrof@kernel.org
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lkml.kernel.org/r/202402071613.70f28243-lkp@intel.com
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_xarray.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/lib/test_xarray.c~test_xarray-add-tests-for-advanced-multi-index-use-fix
+++ a/lib/test_xarray.c
@@ -728,6 +728,7 @@ static noinline void *test_get_entry(str
 {
 	XA_STATE(xas, xa, index);
 	void *p;
+	static unsigned int i = 0;
 
 	rcu_read_lock();
 repeat:
@@ -737,6 +738,17 @@ repeat:
 		goto repeat;
 	rcu_read_unlock();
 
+	/*
+	 * This is not part of the page cache, this selftest is pretty
+	 * aggressive and does not want to trust the xarray API but rather
+	 * test it, and for order 20 (4 GiB block size) we can loop over
+	 * over a million entries which can cause a soft lockup. Page cache
+	 * APIs won't be stupid, proper page cache APIs loop over the proper
+	 * order so when using a larger order we skip shared entries.
+	 */
+	if (++i % XA_CHECK_SCHED == 0)
+		schedule();
+
 	return p;
 }
 
_

Patches currently in -mm which might be from mcgrof@kernel.org are

test_xarray-add-tests-for-advanced-multi-index-use.patch

