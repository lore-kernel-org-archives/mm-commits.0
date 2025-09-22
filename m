Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD21119A288;
	Mon, 22 Sep 2025 22:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758580676; cv=none; b=oIaj98t9z9M5AYLP9Piwpu9Z5fobS2pCoeB+Yx1Mr8K6fxx8XQJCMvWWL8AfHsuXJqEAa9Qyz/MOIGjXgpxqUhGsrbe8X5wu7ChDd8MU5NtLAhS27jcm9OnHIuWNHDOS5e8rta3fsVJPU/ucVpZBRwjriFA26ZFIQo+XmgWKB3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758580676; c=relaxed/simple;
	bh=R4eju/JW8BmOqw+IGO3wqLX9p1tngOBCcWl/O6J38OE=;
	h=Date:To:From:Subject:Message-Id; b=gxnwiSPsKQiG4D8w4bLYrQeSqrpERwcY2rXmqgLwsCWWDwe8wPRM5vJp1DwCfKKRSLyKvwLGx3MnCYRr/VcyZIOW+1GX8/Ea6E3YNsQv8ZB/K4zGVlUtFZn/AmWW72wMeWvCRRZcC/ajd5VtWwsT64aJurC5X5kxaDYC8r+vJOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NAhWY+oR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NAhWY+oR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC95C4CEF0;
	Mon, 22 Sep 2025 22:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758580674;
	bh=R4eju/JW8BmOqw+IGO3wqLX9p1tngOBCcWl/O6J38OE=;
	h=Date:To:From:Subject:From;
	b=NAhWY+oRZnn8NDkmCMW+2+FoM2nsMyAn75vl9ZzkJq4btbTX0P10wfUeHtTIkoFKR
	 9YIpdjUuWLKKGf9Fvb1tuouqeJYUmwglK9goRPPrig9nD23KklkYNwMKQsZpoMmiZn
	 zk0nmXillRlQGmHkJJqPpvK1Ekh0uunroXQuGU34=
Date: Mon, 22 Sep 2025 15:37:53 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akinobu.mita@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-do-not-ignore-callbacks-return-value-in-damon_sysfs_damon_call.patch added to mm-hotfixes-unstable branch
Message-Id: <20250922223754.4BC95C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: do not ignore callback's return value in damon_sysfs_damon_call()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-sysfs-do-not-ignore-callbacks-return-value-in-damon_sysfs_damon_call.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-do-not-ignore-callbacks-return-value-in-damon_sysfs_damon_call.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: mm/damon/sysfs: do not ignore callback's return value in damon_sysfs_damon_call()
Date: Sat, 20 Sep 2025 22:25:46 +0900

The callback return value is ignored in damon_sysfs_damon_call(), which
means that it is not possible to detect invalid user input when writing
commands such as 'commit' to
/sys/kernel/mm/damon/admin/kdamonds/<K>/state.  Fix it.

Link: https://lkml.kernel.org/r/20250920132546.5822-1-akinobu.mita@gmail.com
Fixes: f64539dcdb87 ("mm/damon/sysfs: use damon_call() for update_schemes_stats")
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.14+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-do-not-ignore-callbacks-return-value-in-damon_sysfs_damon_call
+++ a/mm/damon/sysfs.c
@@ -1592,12 +1592,14 @@ static int damon_sysfs_damon_call(int (*
 		struct damon_sysfs_kdamond *kdamond)
 {
 	struct damon_call_control call_control = {};
+	int err;
 
 	if (!kdamond->damon_ctx)
 		return -EINVAL;
 	call_control.fn = fn;
 	call_control.data = kdamond;
-	return damon_call(kdamond->damon_ctx, &call_control);
+	err = damon_call(kdamond->damon_ctx, &call_control);
+	return err ? err : call_control.return_code;
 }
 
 struct damon_sysfs_schemes_walk_data {
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

mm-damon-sysfs-do-not-ignore-callbacks-return-value-in-damon_sysfs_damon_call.patch

