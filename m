Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E2A2D8370
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967396; cv=none; b=RaSdw5EFNnnoOu6b3HT03dQKxXxPLw3HtzyIM1stbrRH7HirQryeRYabN4NYTbNS8048x359oMoDraENCwKUYLcCEAeG6R2cxzIu64Rs9sbdQA+TFGRyRBH/31PiF76jKLTMkFoNvDLUD1El80d8fzl/TaHVBzJbOAuOIg9WY24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967396; c=relaxed/simple;
	bh=bO3mLUYO282TYPzWe1Nn/RyCh9dEwDY27ZYJChjOJU4=;
	h=Date:To:From:Subject:Message-Id; b=HKrXWCUBm/hdLlogj7fkHzVo4g3ecf7TyuwR4j5laQ4OHjNd/m/F82wpFyAdf7Ep5a04tsq+au85isPF5VcqueFXzSm9EU3hDBbVuhlDG56JMVo9f8/SCUpXgRW4Skyaw0P+iVvRkGl5ES987d3eOXPxfWv4PUTU6VwLK12aNIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LK9ajKa9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LK9ajKa9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F5AC16AAE;
	Wed, 21 Jan 2026 03:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967395;
	bh=bO3mLUYO282TYPzWe1Nn/RyCh9dEwDY27ZYJChjOJU4=;
	h=Date:To:From:Subject:From;
	b=LK9ajKa9v9BKAsWy5EvvdsxPpVkdhPwYstTGUA2HwdjV0QFPRprOPFKPQOITDLJ3+
	 QeT7Au7lARcAc5CJP+rl/YCAKH1EahsmBFE4H8E/yftPcqcFdE7W5zVnh4NfEvl9en
	 gqbzEMaUmLkAa1EelcEny9+Usx8Bo4sZQvk36DKA=
Date: Tue, 20 Jan 2026 19:49:54 -0800
To: mm-commits@vger.kernel.org,lirongqing@baidu.com,lance.yang@linux.dev,jm@machine-hall.org,tglozar@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-kconfigdebug-fix-bootparam_hung_task_panic-comment.patch removed from -mm tree
Message-Id: <20260121034955.61F5AC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/Kconfig.debug: fix BOOTPARAM_HUNG_TASK_PANIC comment
has been removed from the -mm tree.  Its filename was
     lib-kconfigdebug-fix-bootparam_hung_task_panic-comment.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tomas Glozar <tglozar@redhat.com>
Subject: lib/Kconfig.debug: fix BOOTPARAM_HUNG_TASK_PANIC comment
Date: Tue, 6 Jan 2026 15:01:40 +0100

The comment for CONFIG_BOOTPARAM_HUNG_TASK_PANIC says:

   Say N if unsure.

but since commit 9544f9e6947f ("hung_task: panic when there are more than
N hung tasks at the same time"), N is not a valid value for the option,
leading to a warning at build time:

   .config:11736:warning: symbol value 'n' invalid for BOOTPARAM_HUNG_TASK_PANIC

as well as an error when given to menuconfig.

Fix the comment to say '0' instead of 'N'.

Link: https://lkml.kernel.org/r/20260106140140.136446-1-tglozar@redhat.com
Fixes: 9544f9e6947f ("hung_task: panic when there are more than N hung tasks at the same time")
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Reported-by: Johnny Mnemonic <jm@machine-hall.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/Kconfig.debug~lib-kconfigdebug-fix-bootparam_hung_task_panic-comment
+++ a/lib/Kconfig.debug
@@ -1274,7 +1274,7 @@ config BOOTPARAM_HUNG_TASK_PANIC
 	  high-availability systems that have uptime guarantees and
 	  where a hung tasks must be resolved ASAP.
 
-	  Say N if unsure.
+	  Say 0 if unsure.
 
 config DETECT_HUNG_TASK_BLOCKER
 	bool "Dump Hung Tasks Blocker"
_

Patches currently in -mm which might be from tglozar@redhat.com are


