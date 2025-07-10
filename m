Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4B92836AF;
	Thu, 10 Jul 2025 04:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752120560; cv=none; b=hnyrAputJ7qgcqu8pmu2yQd8k1NA8aQlRTY/qxiwLoWwrdwG7rp0+W4tqfBW5PEelI1lAfyT6uN1npy6elXjqQBUpEn5G6m5enRgvVs5z3xY+417U2WGekfyBlB2DKDWARW+RuFMhRtbqQS1H786HbzRWWpzpr1UtB5iRMDJIGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752120560; c=relaxed/simple;
	bh=RvzEVMuwTY7CkGJP34MGfEf11YdaOIlPHK0pvhhBIRk=;
	h=Date:To:From:Subject:Message-Id; b=biK6BGiymKZD6zEKAWQY705JoTGKb7qeP9rdb1thikhIXaspYEx5xZc3P5MR0N6CS+/f409qGqWESBayt+rAnW+kFC/eiyayAxBNXI7xQqudDKTCnhw+SuS71UWrHEl7nABh8fgKekushJoaiOlfLas0VxnhwY8D8n9+3eUp8LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fkFzA+ru; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fkFzA+ru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FAF3C4CEED;
	Thu, 10 Jul 2025 04:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752120560;
	bh=RvzEVMuwTY7CkGJP34MGfEf11YdaOIlPHK0pvhhBIRk=;
	h=Date:To:From:Subject:From;
	b=fkFzA+ru9MZHsbNrdn8EZUvye5fn65QY5U1zx6ex61ALtqRJDt4sBKUNgT0ghRyX3
	 cQkpPAH9946eZcd9eoo+TAF9AsxFcnRi82jstr2iSgUS7x1y7CZTpuAftY6ttp8C78
	 VHTqyxsiUZqGETwXTspNkkRSu9eNMSvWWHYAvSUo=
Date: Wed, 09 Jul 2025 21:09:19 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,honggyu.kim@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] samples-damon-fix-damon-sample-wsse-for-start-failure.patch removed from -mm tree
Message-Id: <20250710040920.7FAF3C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon: fix damon sample wsse for start failure
has been removed from the -mm tree.  Its filename was
     samples-damon-fix-damon-sample-wsse-for-start-failure.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

samples-damon-change-enable-parameters-to-enabled.patch

