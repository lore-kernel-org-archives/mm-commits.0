Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF391494C6
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 23:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716419613; cv=none; b=gl9JMKPNKCZVzi9s6zGVAuqZ02H/EY2ul1slpVi4GwcBjEUX+CsV+rL8doCQSUkcu4od5yfsps6SWEPRfujsl7GYTtvgQHxF/K5YYEnUP7bahWhsL4Omf7EkrtwOCsitBEky6dDeK3861FUqQpOKUfufwpR4hQaSSqJfvIjPovI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716419613; c=relaxed/simple;
	bh=1g/Z9P7Zm4immgffOFY23SDcRAy98jeFVB3ungBtwZM=;
	h=Date:To:From:Subject:Message-Id; b=ne3sPmgbq04uRDmptpKfKpR/QcfCebjMj7lifXhbxED76Syiv/L2DYV+RONCFsWP6PKzfi3ElyW8dbr6XownDJfuby45JJP7xAr0BuYXk0787yLtVPfKofTurkzdqOx6a3vQMSnNuxNfmIXRJK4xJ2SCifDiNUjJepP4w1hOgOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xvdK+UaN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xvdK+UaN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B36C32782;
	Wed, 22 May 2024 23:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716419613;
	bh=1g/Z9P7Zm4immgffOFY23SDcRAy98jeFVB3ungBtwZM=;
	h=Date:To:From:Subject:From;
	b=xvdK+UaNw3pL3jJYYV43Tx1gS5YQaH5Bp+mCHQkdkXIMJ8wo+l8SWa4zW9trhkk9x
	 Sc6HvgHOdSWvUtP3re/BSMdvORMBofXXk0ip4xg2hxup4Yj3LTtYQ9IrPU/j1kjzLW
	 fUfewo1NGsVvM5qPC8xfdwRnWFtN6cfq8YIvl7WY=
Date: Wed, 22 May 2024 16:13:32 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,nao.horiguchi@gmail.com,minchan@kernel.org,linmiaohe@huawei.com,glider@google.com,elver@google.com,dvyukov@google.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-add-module_description.patch added to mm-unstable branch
Message-Id: <20240522231333.11B36C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hwpoison: add MODULE_DESCRIPTION()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-add-module_description.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-add-module_description.patch

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
Subject: mm/hwpoison: add MODULE_DESCRIPTION()
Date: Mon, 13 May 2024 12:37:38 -0700

Patch series "mm: add missing MODULE_DESCRIPTION() macros".

This fixes the instances of "WARNING: modpost: missing
MODULE_DESCRIPTION()" that I'm seeing in mm/.


This patch (of 4):

Fix the 'make W=1' warning:
WARNING: modpost: missing MODULE_DESCRIPTION() in mm/hwpoison-inject.o

Link: https://lkml.kernel.org/r/20240513-mm-md-v1-0-8c20e7d26842@quicinc.com
Link: https://lkml.kernel.org/r/20240513-mm-md-v1-1-8c20e7d26842@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hwpoison-inject.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hwpoison-inject.c~mm-hwpoison-add-module_description
+++ a/mm/hwpoison-inject.c
@@ -110,4 +110,5 @@ static int __init pfn_inject_init(void)
 
 module_init(pfn_inject_init);
 module_exit(pfn_inject_exit);
+MODULE_DESCRIPTION("HWPoison pages injector");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

mm-hwpoison-add-module_description.patch
mm-dmapool-add-module_description.patch
mm-kfence-add-module_description.patch
mm-zsmalloc-add-module_description.patch
backtracetest-add-module_description.patch

