Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080451494C6
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 23:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716419615; cv=none; b=cEA/SWKrVF8D+SekE4l+k1ud8V9GLuxQr64EaUbz5nBT7oq3PQIGh1MwyfHQ4eU9MXN4Pn7YVzyCU4WT70fftCG9cKuW7s0d9XTJfQeq/62SHWvs9VLwy+/n2C1+x/jzFvHN3tquGqgM2H0MZfFaevVAkb98lHwK7ZrMvgy52NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716419615; c=relaxed/simple;
	bh=bhkhtJPMve5B7JDM7le2ADGFzY7tbKKYOlUOsSuSMgw=;
	h=Date:To:From:Subject:Message-Id; b=W87zJ6htBVWllovOiK6FSnP/CwPrv9ydYYbrivEayxrEsKHoZYm6j7SzoKteCuvs+ofpbmfUaDDTpuxUO50J46hEwc6i5r/7iT7Xp4lnYoYk36nX6XUA4BbXAkXCGSQngtBr36RvFx+shxxC7kneXpQOeNC5mAbl4AhR/3iT5BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lUYZfu61; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lUYZfu61"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A870C2BBFC;
	Wed, 22 May 2024 23:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716419614;
	bh=bhkhtJPMve5B7JDM7le2ADGFzY7tbKKYOlUOsSuSMgw=;
	h=Date:To:From:Subject:From;
	b=lUYZfu61KijxFx0W4WQmIAL64CqiBpdKcPMRpB1KJgmsfk8AFbzd5C8XoBnON5rH4
	 49QQpQu6YRZEYap8x0Ke67TDeE+peqEnonsCxI22yA5yiTU/qEQks5vpl6aP2WkWdK
	 bfP6ovFGnoF24EfecMc4LLvB672jZCntEWLTa5Mo=
Date: Wed, 22 May 2024 16:13:33 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,nao.horiguchi@gmail.com,minchan@kernel.org,linmiaohe@huawei.com,glider@google.com,elver@google.com,dvyukov@google.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-dmapool-add-module_description.patch added to mm-unstable branch
Message-Id: <20240522231334.7A870C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/dmapool: add MODULE_DESCRIPTION()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-dmapool-add-module_description.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-dmapool-add-module_description.patch

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
Subject: mm/dmapool: add MODULE_DESCRIPTION()
Date: Mon, 13 May 2024 12:37:39 -0700

Fix the 'make W=1' warning:

WARNING: modpost: missing MODULE_DESCRIPTION() in mm/dmapool_test.o

Link: https://lkml.kernel.org/r/20240513-mm-md-v1-2-8c20e7d26842@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/dmapool_test.c~mm-dmapool-add-module_description
+++ a/mm/dmapool_test.c
@@ -144,4 +144,5 @@ static void dmapool_exit(void)
 
 module_init(dmapool_checks);
 module_exit(dmapool_exit);
+MODULE_DESCRIPTION("dma_pool timing test");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

mm-hwpoison-add-module_description.patch
mm-dmapool-add-module_description.patch
mm-kfence-add-module_description.patch
mm-zsmalloc-add-module_description.patch
backtracetest-add-module_description.patch

