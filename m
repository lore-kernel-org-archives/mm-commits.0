Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4F623D3FE
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837178; cv=none; b=EuD3wEcBSBDW1zKphQJwmKl9St6zf6GZSRO9j1WJMwgAeuUPkq16Kw5mEQ/0HJjeMc8gg58KhLJxPH1iC19OWswb0eFrWKcATaY1hDm9NIk5+/+1l0s27s6sXtaDVsAC12QccSlXutfkjJWarOwf0wUPSrFMvFmQVzDmz4Rke/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837178; c=relaxed/simple;
	bh=WGWR5Y0jJDqdFKqO+XVo4T/UwbMQfEHDyQwY0Vb/hZU=;
	h=Date:To:From:Subject:Message-Id; b=HrV8G314bUOpIsyCq5HEyJwzclkpzMbGdtEtdjsx1vM3Qglm9HdomES1IgX+uZubje8UA+K8POS7Lk+BDuVoGTRmdUkBBUiFckokqQPrNAdz/bzzRfvAC1mLIadz58c2O7xOSPKJQnPY5EMU7a3rv63J4CVgyjJUXIq2sx447Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uxAdSfnc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uxAdSfnc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34BBC4CEDD;
	Tue, 14 Jan 2025 06:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837177;
	bh=WGWR5Y0jJDqdFKqO+XVo4T/UwbMQfEHDyQwY0Vb/hZU=;
	h=Date:To:From:Subject:From;
	b=uxAdSfncW6BP8002OhHp4wN9aekbGIZ+1zutmR9HvwQ8I9iWu/bNIv5a4LB25dO6h
	 KFLy8F60pBxauSN1LPwJxvK+W5JPzJjBgKOjEnWqijvnbEqB5IIvoxxoLzLKXgu3kO
	 8yjbkMwSokjR3g23fX1huUd+cNbhXfhibTZbVAFM=
Date: Mon, 13 Jan 2025 22:46:17 -0800
To: mm-commits@vger.kernel.org,si.yanteng@linux.dev,shuah@kernel.org,rmoar@google.com,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,alexs@kernel.org,2023002089@link.tyut.edu.cn,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-config-remove-configs-for-damon-debugfs-interface-selftests.patch removed from -mm tree
Message-Id: <20250114064617.C34BBC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/config: remove configs for DAMON debugfs interface selftests
has been removed from the -mm tree.  Its filename was
     selftests-damon-config-remove-configs-for-damon-debugfs-interface-selftests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/config: remove configs for DAMON debugfs interface selftests
Date: Mon, 6 Jan 2025 11:19:37 -0800

It's time to remove DAMON debugfs interface, which has deprecated long
before in February 2023.  Read the cover letter of this patch series for
more details.

Remove configs for selftests of it from DAMON selftests config file, to
prevent unnecessary noises from the tests.

[1] https://lore.kernel.org/20230209192009.7885-1-sj@kernel.org

Link: https://lkml.kernel.org/r/20250106191941.107070-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Rae Moar <rmoar@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yanteng Si <si.yanteng@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/config |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/damon/config~selftests-damon-config-remove-configs-for-damon-debugfs-interface-selftests
+++ a/tools/testing/selftests/damon/config
@@ -1,6 +1,5 @@
 CONFIG_DAMON=y
 CONFIG_DAMON_SYSFS=y
-CONFIG_DAMON_DBGFS=y
 CONFIG_DAMON_PADDR=y
 CONFIG_DAMON_VADDR=y
 CONFIG_DAMON_RECLAIM=y
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

