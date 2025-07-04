Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3050E80C02;
	Fri,  4 Jul 2025 01:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751591864; cv=none; b=rXlUuXJHwjcLv+i3qTvON+iyXVFQwc5EV3lXgP8Z3ZJ6umhQpOsx4xTIYUPzA39nhx0ewq5XL2wlTb2dQX2iGhvUZC1/9f5C0gpcD/CXUHFGBM5EKlWf6XJ2XgF3zbGfXIUwy8xNieSy9wXt9vdD2hyGWzdW671i7PWZF2DN70I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751591864; c=relaxed/simple;
	bh=CRmMAqmA9q3qA7eCMygugqMdYTUtt5J4DIwc1/52h/4=;
	h=Date:To:From:Subject:Message-Id; b=k+PLnGbqLlKxPflxL3hkIbS/cf9OC3ic3Z7hWByC3cwY39auGpARPhwmC75UoXjZygxWcSWMrp4DQTvdP5t/I8FjZWUZ83LvlGIC8xrzc3itdlWhWDZ6u0OHTyVP2Gi1+L2bQACXExvwpOPOsGdR7uALiwlbA6I+mpQt+WJix30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b+D/WYUo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b+D/WYUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB0CC4CEE3;
	Fri,  4 Jul 2025 01:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751591864;
	bh=CRmMAqmA9q3qA7eCMygugqMdYTUtt5J4DIwc1/52h/4=;
	h=Date:To:From:Subject:From;
	b=b+D/WYUo9pZDquspHFxtmVy5TEexnlhtIT7rxVCJv8YlFuSDDoTS5jTP04/w59OW/
	 xc/ZNrhYRdWCFmR5QpM9yJFr3BCMTovBOe2wDL3dUWdrhWDd/p7L6a7zvPKjO7jphG
	 NvRbCwuTFFG9RPQNWMbyy2fUoKJznHRc0dUYnyTI=
Date: Thu, 03 Jul 2025 18:17:43 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,honggyu.kim@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-fix-damon-sample-wsse-for-start-failure.patch added to mm-hotfixes-unstable branch
Message-Id: <20250704011743.ECB0CC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon: fix damon sample wsse for start failure
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     samples-damon-fix-damon-sample-wsse-for-start-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-fix-damon-sample-wsse-for-start-failure.patch

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
From: Honggyu Kim <honggyu.kim@sk.com>
Subject: samples/damon: fix damon sample wsse for start failure
Date: Wed, 2 Jul 2025 09:02:02 +0900

The damon_sample_wsse_start() can fail so we must reset the "enable"
parameter to "false" again for proper rollback.

In such cases, setting Y to "enable" then N triggers the similar crash
with wsse because damon sample start failed but the "enable" stays as Y.

Link: https://lkml.kernel.org/r/20250702000205.1921-3-honggyu.kim@sk.com
Fixes: b757c6cfc696 ("samples/damon/wsse: start and stop DAMON as the user requests")
Signed-off-by: Honggyu Kim <honggyu.kim@sk.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/wsse.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/samples/damon/wsse.c~samples-damon-fix-damon-sample-wsse-for-start-failure
+++ a/samples/damon/wsse.c
@@ -102,8 +102,12 @@ static int damon_sample_wsse_enable_stor
 	if (enable == enabled)
 		return 0;
 
-	if (enable)
-		return damon_sample_wsse_start();
+	if (enable) {
+		err = damon_sample_wsse_start();
+		if (err)
+			enable = false;
+		return err;
+	}
 	damon_sample_wsse_stop();
 	return 0;
 }
_

Patches currently in -mm which might be from honggyu.kim@sk.com are

samples-damon-fix-damon-sample-prcl-for-start-failure.patch
samples-damon-fix-damon-sample-wsse-for-start-failure.patch
samples-damon-fix-damon-sample-mtier-for-start-failure.patch
mm-damon-fix-divide-by-zero-in-damon_get_intervals_score.patch

