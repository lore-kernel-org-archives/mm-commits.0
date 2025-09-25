Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083461B21BD;
	Thu, 25 Sep 2025 23:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758841872; cv=none; b=bUR3Z4Rq2fGfWNzVGGjbPZ/plmiAif92HNlJh/g8VBlJ9qAY3fowHyZ7/KWkVJDkOQNCCIYQUz6aErE43azGX1+WCeF9d1Hc9s+snD4CaFOinmyLrk9gPdcFvKtz7UAahuAndSgEaotpoSJMgW1pPPGpoYp1rgvUQmkJxG7eSa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758841872; c=relaxed/simple;
	bh=1TNCOGMjqP5zEQTeoVGZzW0z8bRd6kZXSZJyjGhIS9Y=;
	h=Date:To:From:Subject:Message-Id; b=AgJjxdMP8mIfJGL2XQN9CKQ4ofcLkYDEAVxums43d1l1+Y2Icrt8GZJOykdyBPLCzdMeZfgwg7Q4Ju2AT/JspHXrGUARjwmmrwYW0sfMO0dIcfx47Cut7+hW1cTKglgBLNjiyT2GuKtb/F/NPedA9YsY53xil8pGbwyOL7SPBzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zi5meFwa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zi5meFwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84658C4CEF0;
	Thu, 25 Sep 2025 23:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758841871;
	bh=1TNCOGMjqP5zEQTeoVGZzW0z8bRd6kZXSZJyjGhIS9Y=;
	h=Date:To:From:Subject:From;
	b=zi5meFwaRskp/UyD08RnNR5XRjBYWUAPsrkVcAKx87Hbc4S93W6Vb46nqGMyhEywC
	 TILeCYm0h8W66QGsKa+e4BDU7PYkMSkPwyECO+U5QYJjNFOqWdPSJr1oGIlyypCNWo
	 cmC8yUJXlX6nKMDhTwni5fN503GvTfeEqKbgs29E=
Date: Thu, 25 Sep 2025 16:11:10 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akinobu.mita@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-sysfs-do-not-ignore-callbacks-return-value-in-damon_sysfs_damon_call.patch removed from -mm tree
Message-Id: <20250925231111.84658C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: do not ignore callback's return value in damon_sysfs_damon_call()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-do-not-ignore-callbacks-return-value-in-damon_sysfs_damon_call.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


