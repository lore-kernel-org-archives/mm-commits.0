Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B07614A627
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854745; cv=none; b=V2i5vRA5Tv4+c9p0/swpX8a1hr3FI+y38hCSDa1FcO1/ZDQlB7buGhet7PytPv3zYAIa1EmXGKIITNVWDIrya9JBwU8mvBxRyF6VKkAC0Bh0usvFBuYfI/dQ+jtyNvDW56lxEtmyxSG0NgDg/2XGNZnFfyKtCmJSnwdaIk0SZQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854745; c=relaxed/simple;
	bh=NlZBh2nPFWZt73Nf5nU+pERSENBS1HaIza4/nWX8pTg=;
	h=Date:To:From:Subject:Message-Id; b=UMQx7RX/Q+bXwex/sTLgKmmr431RjnM4qJ5u3rVLGyi3RWHqCCOsVs563JSvg8JFObZMvrBdLSv5vpIFShUO+EJiL1B7GaqhHf7vsYchWqCSQ2Eyi97aRgT3iX2zU/78bJ0G1B3eO789+gWyqH5gLatx2lpPYu+jCX/9C2cDKWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SrDV+JJq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SrDV+JJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157E4C4CECF;
	Wed,  6 Nov 2024 00:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854745;
	bh=NlZBh2nPFWZt73Nf5nU+pERSENBS1HaIza4/nWX8pTg=;
	h=Date:To:From:Subject:From;
	b=SrDV+JJq3a1l85JHLu4y1NrIVH+jsaPH0eMyMDEv+c1e3dqYRyvgPJO6LQttEt/KP
	 HukTnjHaqJLx/xuXUTHY/8QyrkFTQWpH+RBmgTR+2Zard/k/fqROq1sSqSsaPLOrRx
	 +gMWt6RO2aUVbF3vvkdLxNP27ABQpC3OK+otV2F0=
Date: Tue, 05 Nov 2024 16:59:04 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,sj@kernel.org,dev.jain@arm.com,bajing@cmss.chinamobile.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-access_memory_even-remove-unused-variables.patch removed from -mm tree
Message-Id: <20241106005905.157E4C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/access_memory_even: remove unused variables
has been removed from the -mm tree.  Its filename was
     selftests-damon-access_memory_even-remove-unused-variables.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ba Jing <bajing@cmss.chinamobile.com>
Subject: selftests/damon/access_memory_even: remove unused variables
Date: Tue, 24 Sep 2024 10:14:26 +0800

By reading the code, I found these variables are never referenced in the
code.  Just remove them.

Link: https://lkml.kernel.org/r/20240924021426.1980-1-bajing@cmss.chinamobile.com
Signed-off-by: Ba Jing <bajing@cmss.chinamobile.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/access_memory_even.c |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/testing/selftests/damon/access_memory_even.c~selftests-damon-access_memory_even-remove-unused-variables
+++ a/tools/testing/selftests/damon/access_memory_even.c
@@ -14,10 +14,8 @@
 int main(int argc, char *argv[])
 {
 	char **regions;
-	clock_t start_clock;
 	int nr_regions;
 	int sz_region;
-	int access_time_ms;
 	int i;
 
 	if (argc != 3) {
_

Patches currently in -mm which might be from bajing@cmss.chinamobile.com are


