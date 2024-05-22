Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6395D1494C6
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 23:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716419616; cv=none; b=vAp+TICaOAz1RSYrR+mIPt3oPz9FevKcGuYX83a0XbycekObugB6Z6LL5jJaRWrIz3XBVdv5itIlOXyEjxuSkVkQxlHDizHF8PdHKWf1SNgaW1Fo+B78RTtSXG/fmlbtglJyLHxhlIFGTsZPo4npKQiGsOn43ACM6VJYbpc0pec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716419616; c=relaxed/simple;
	bh=8q9BUa48clcX360URzp5whyCqj/xDamnzK0qJp29g68=;
	h=Date:To:From:Subject:Message-Id; b=m2ly1XdC9VV6vziujEKPEdyPdFKk6BR1qn7s1u3XYtnDA25H1o/NnyijgRlwOPuu9SBHsqIZF/CEsZCdh9vm4vq5DfjZrL9s2VYx2GyndD93/5wr9VLc/Ipa94nN6+A+wAEOHraGql2/5Ocgt4s7qjOqDi1LhcyXLZBAALRSe24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mKAG86Di; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mKAG86Di"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8EFC2BBFC;
	Wed, 22 May 2024 23:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716419616;
	bh=8q9BUa48clcX360URzp5whyCqj/xDamnzK0qJp29g68=;
	h=Date:To:From:Subject:From;
	b=mKAG86DizEOHy/AiJbP2uqzgIkBr30Vmi7j6LZvOwyGDyGJM8AMLuPulhECqIY6ii
	 m0gxOMdWmKk+AfLZSni++JLsVzBpjO9vwWX0lMB4jmZm1+7EsU+4py6auJNzuOJZ8s
	 zEeOexSdy6S3/141kup4+8lFfquLqCvPqePmr4k0=
Date: Wed, 22 May 2024 16:13:35 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,nao.horiguchi@gmail.com,minchan@kernel.org,linmiaohe@huawei.com,glider@google.com,elver@google.com,dvyukov@google.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kfence-add-module_description.patch added to mm-unstable branch
Message-Id: <20240522231335.DE8EFC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kfence: add MODULE_DESCRIPTION()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kfence-add-module_description.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kfence-add-module_description.patch

This patch will later appear in the mm-unstable branch at
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
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: mm/kfence: add MODULE_DESCRIPTION()
Date: Mon, 13 May 2024 12:37:40 -0700

Fix the 'make W=1' warning:

WARNING: modpost: missing MODULE_DESCRIPTION() in mm/kfence/kfence_test.o

Link: https://lkml.kernel.org/r/20240513-mm-md-v1-3-8c20e7d26842@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/kfence_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kfence/kfence_test.c~mm-kfence-add-module_description
+++ a/mm/kfence/kfence_test.c
@@ -852,3 +852,4 @@ kunit_test_suites(&kfence_test_suite);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>");
+MODULE_DESCRIPTION("kfence unit test suite");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

mm-hwpoison-add-module_description.patch
mm-dmapool-add-module_description.patch
mm-kfence-add-module_description.patch
mm-zsmalloc-add-module_description.patch
backtracetest-add-module_description.patch

