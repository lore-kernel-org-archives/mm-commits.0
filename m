Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1601F4C62
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752977377; cv=none; b=qhhb/rykv15uKotEekwznpgXVX9+HbciXdcqoW6VbF3rwoCC5FhdnoOiQvnvonSO6jachROJ6PkBT+HYTMqJm7299U3EZ1W1cPzolu6ZndOJX3mop5I6jNkSG5Vr5ihW+bg/WIC55lePZqWXv7n6rlM9zxC698Jg8xY+f2bedcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752977377; c=relaxed/simple;
	bh=F6JalbMa33KzKjiirD0NykB7wPuCdAe6/hS5ukmgEqs=;
	h=Date:To:From:Subject:Message-Id; b=BBtM0yotd5knovnRL5BqHzqEpsA9UTZnDHjlx5Al85ySadwyYaQcXM1XN9u7N/QdyxWVRCJU5U2WlG5Cv0xAms/R6QOGsYxRWaIb5MvE1940o2KEgUD6JrHNbNVMzQrOtnU7Dksu0EZCHDnFK26+CeKdcqKPS8U8bE9La1CGL8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wAHxv2Fp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wAHxv2Fp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54C2C4CEE3;
	Sun, 20 Jul 2025 02:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752977376;
	bh=F6JalbMa33KzKjiirD0NykB7wPuCdAe6/hS5ukmgEqs=;
	h=Date:To:From:Subject:From;
	b=wAHxv2Fpq2yZDsuZB1NoJGWpQ27KDDpnl4rJwhHBSaZvAIvTPd2goMKE4KYpOoQKE
	 Kif5/4i+uSqQSOYgB2tIF8VfCfeoRxN878zKXFm02SZbUk8NbYQxF3HI4vea3wg0QN
	 lB77wM2TmMw1g7B0gTnD9EhAmhxm4OeP6VUxc5U0=
Date: Sat, 19 Jul 2025 19:09:36 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,guanwentao@uniontech.com,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-thermal-remove-duplicate-sprintf-call-in-workload_hint_test.patch removed from -mm tree
Message-Id: <20250720020936.D54C2C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/thermal: remove duplicate sprintf() call in workload_hint_test
has been removed from the -mm tree.  Its filename was
     selftests-thermal-remove-duplicate-sprintf-call-in-workload_hint_test.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: WangYuli <wangyuli@uniontech.com>
Subject: selftests/thermal: remove duplicate sprintf() call in workload_hint_test
Date: Thu, 10 Jul 2025 21:04:12 +0800

Remove redundant sprintf() call that was duplicating the same operation of
formatting delay_str with argv[1].

Link: https://lkml.kernel.org/r/6338CD0E839B770B+20250710130412.284531-1-wangyuli@uniontech.com
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Cc: Guan Wentao <guanwentao@uniontech.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/thermal/intel/workload_hint/workload_hint_test.c |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/testing/selftests/thermal/intel/workload_hint/workload_hint_test.c~selftests-thermal-remove-duplicate-sprintf-call-in-workload_hint_test
+++ a/tools/testing/selftests/thermal/intel/workload_hint/workload_hint_test.c
@@ -68,8 +68,6 @@ int main(int argc, char **argv)
 			exit(1);
 
 		sprintf(delay_str, "%s\n", argv[1]);
-
-		sprintf(delay_str, "%s\n", argv[1]);
 		fd = open(WORKLOAD_NOTIFICATION_DELAY_ATTRIBUTE, O_RDWR);
 		if (fd < 0) {
 			perror("Unable to open workload notification delay\n");
_

Patches currently in -mm which might be from wangyuli@uniontech.com are


