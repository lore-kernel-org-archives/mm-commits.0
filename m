Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F849131E2D;
	Fri,  4 Jul 2025 01:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751591866; cv=none; b=bQQkbJwikriZPWdHKW18OnKCdIMcQN92kNJtskCagJIRlaV83ZYz4ImOI5OZKk4RqqrI83V9X4ooSTQc3z67ruoU/Z5MuT5KKU3mjYLBWlwy9gXRHwhsr3boLXoUnH392RFQD75+Yzxw8lFX1c3zKRsl8H8/5LtVcXK5mFtVQ3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751591866; c=relaxed/simple;
	bh=p+G4LfZ78+RSBbEGzyJsIvTVGQG7VnP8v8ertt3xUEc=;
	h=Date:To:From:Subject:Message-Id; b=LaP1ECvHF4ddGCVPyvUcNmpq23lNPR8oZqf0Y25v4uaFAum75rWe+g+0lIVq7xkrQK6bNBQLpZ0GK3nMBCoPYP5l1n3ytwGsEL7CEb3wrVmEDBHdm/w1I5O4ybzSfqNZdN2mVxMLTXML2so7FUxfavrGBa3gbygS20oiKEBOs3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0q/KlLO5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0q/KlLO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D689CC4CEE3;
	Fri,  4 Jul 2025 01:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751591865;
	bh=p+G4LfZ78+RSBbEGzyJsIvTVGQG7VnP8v8ertt3xUEc=;
	h=Date:To:From:Subject:From;
	b=0q/KlLO5C1D2LH27aFfrvYql7lG1aqqg2XsAk82wQQ4j7en9n/tqRgueEwzd9yCRJ
	 6FHXpK5wrEGGThEWnr8SZRsvXVW3lKYWWarpE16rHmSabilw1HYW7rvM77qMcC3Elz
	 Lyhf+UbJfPXLQU/PQvpyjfGSCUYKKq9uTpy9DyYI=
Date: Thu, 03 Jul 2025 18:17:45 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,honggyu.kim@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-fix-damon-sample-mtier-for-start-failure.patch added to mm-hotfixes-unstable branch
Message-Id: <20250704011745.D689CC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon: fix damon sample mtier for start failure
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     samples-damon-fix-damon-sample-mtier-for-start-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-fix-damon-sample-mtier-for-start-failure.patch

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
Subject: samples/damon: fix damon sample mtier for start failure
Date: Wed, 2 Jul 2025 09:02:03 +0900

The damon_sample_mtier_start() can fail so we must reset the "enable"
parameter to "false" again for proper rollback.

In such cases, setting Y to "enable" then N triggers the similar crash
with mtier because damon sample start failed but the "enable" stays as Y.

Link: https://lkml.kernel.org/r/20250702000205.1921-4-honggyu.kim@sk.com
Fixes: 82a08bde3cf7 ("samples/damon: implement a DAMON module for memory tiering")
Signed-off-by: Honggyu Kim <honggyu.kim@sk.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/mtier.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/samples/damon/mtier.c~samples-damon-fix-damon-sample-mtier-for-start-failure
+++ a/samples/damon/mtier.c
@@ -164,8 +164,12 @@ static int damon_sample_mtier_enable_sto
 	if (enable == enabled)
 		return 0;
 
-	if (enable)
-		return damon_sample_mtier_start();
+	if (enable) {
+		err = damon_sample_mtier_start();
+		if (err)
+			enable = false;
+		return err;
+	}
 	damon_sample_mtier_stop();
 	return 0;
 }
_

Patches currently in -mm which might be from honggyu.kim@sk.com are

samples-damon-fix-damon-sample-prcl-for-start-failure.patch
samples-damon-fix-damon-sample-wsse-for-start-failure.patch
samples-damon-fix-damon-sample-mtier-for-start-failure.patch
mm-damon-fix-divide-by-zero-in-damon_get_intervals_score.patch

