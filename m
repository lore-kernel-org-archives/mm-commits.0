Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6F32836AF;
	Thu, 10 Jul 2025 04:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752120561; cv=none; b=TdsRPswPvpKMB92k8lNRQNz2Wm9aulEJRpP3gOvCfKvFmA1H0giLnTkO1PqxeUccBOKjhDcVZUrB/vQU26H3RWj1CsQP12fZCPjNSJ0OalbckAayophdGRF+LNvsQLxQSJXzniTB79t4nTBGwMe4spTrZI3OVABHQQPn4eCPbto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752120561; c=relaxed/simple;
	bh=0VP3MPc3JlJGekmCmcoMGw7GW2MlDwNbEzY1oCMfRQs=;
	h=Date:To:From:Subject:Message-Id; b=in48oKdNJb2G8KoOQmv0N6fJbleGy6yfH2IYBvcuoWusw+Mwoag7rhb8gtPP1WM0habANTVdTwCYiSNGW7GW9wzXB9tHx6UgKqlY4NzRUFKRqhGPqiCTp2yB2xnOynBCwtuczbRsSMVYnpJ7XF8zJTjFctrv/HzKnj/Ow0nuKrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oeLyh1Ho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oeLyh1Ho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A139EC4CEE3;
	Thu, 10 Jul 2025 04:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752120561;
	bh=0VP3MPc3JlJGekmCmcoMGw7GW2MlDwNbEzY1oCMfRQs=;
	h=Date:To:From:Subject:From;
	b=oeLyh1HoSrc6JxfOfa5CUGGkwYvpjz2ZJnr7b/2MhNufHhYby0CC/b1eob++ypyh6
	 fcVfTQ+9kZ0ywt4JFyqNWaMIXYm9lO9skPTLjuJFVE9OcSjh1u77fDOeRu4VevScbw
	 x0I5tA1UprJcMsRlI//fORJ0FWXNZGPfyg/l9ReE=
Date: Wed, 09 Jul 2025 21:09:21 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,honggyu.kim@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] samples-damon-fix-damon-sample-mtier-for-start-failure.patch removed from -mm tree
Message-Id: <20250710040921.A139EC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon: fix damon sample mtier for start failure
has been removed from the -mm tree.  Its filename was
     samples-damon-fix-damon-sample-mtier-for-start-failure.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

samples-damon-change-enable-parameters-to-enabled.patch

