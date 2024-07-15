Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC7213D88E
	for <mm-commits@vger.kernel.org>; Mon, 15 Jul 2024 20:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721075457; cv=none; b=sok7neSHZYj9tKrEfjQmd5m2btqO5ljhCRKgeDextyWC18byn/s4wktGjKxG4basRjROAGesa6OfRLRrHX91NT4cULLg1pC5ICbP+V7ALivI66rB6/4jH9t9HpFanSGKgFGiq+RyT1PuUGMmYsIJ3tSDQ3rDf0IRGx2xpPMqB64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721075457; c=relaxed/simple;
	bh=fCQR1H5fLEhhOTmgHDR0wBJnSQsYpVEQjkroW8Fsa80=;
	h=Date:To:From:Subject:Message-Id; b=lpczEmhq9VnpCj7Q4k9tZneRXsL6NJuigFwgxfiaFrbF3o3Dwi3HmgGVcTMcSEh2kSa83ObZX8oBLP6mUkYw5/jVlOTRyRKOKJn22aMJLRpwacCXMtyHSQ200Av+pSpdGPeTKiavD3lHB6rGmaFgCy5hS6Dg5wfWGiUZz+Y8Z7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mrYSkwux; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mrYSkwux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E649C32782;
	Mon, 15 Jul 2024 20:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721075456;
	bh=fCQR1H5fLEhhOTmgHDR0wBJnSQsYpVEQjkroW8Fsa80=;
	h=Date:To:From:Subject:From;
	b=mrYSkwux+4P0ukuxtxrv92LUwuxTEZ5ghpimo9lX9TrPUwTh9gPGKdBweJegpUcvi
	 DwfPrLrKaWMR/K5RhoK3kqvm6uUt8Zbxcvtr8wHRM7e6+XZlrJAwzmFjouQknv/u78
	 741tOuUwkWQMUSBkROVXs7Q5qRgp1Fyw2SVuzfFg=
Date: Mon, 15 Jul 2024 13:30:55 -0700
To: mm-commits@vger.kernel.org,wuqiang.matt@bytedance.com,mhiramat@kernel.org,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_objpool-add-missing-module_description-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20240715203056.7E649C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: test_objpool: add missing MODULE_DESCRIPTION() macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-test_objpool-add-missing-module_description-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_objpool-add-missing-module_description-macro.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: lib: test_objpool: add missing MODULE_DESCRIPTION() macro
Date: Mon, 15 Jul 2024 07:18:56 -0700

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_objpool.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240715-md-lib-test_objpool-v2-1-5a2b9369c37e@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Reviewed-by: Matt Wu <wuqiang.matt@bytedance.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_objpool.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/test_objpool.c~lib-test_objpool-add-missing-module_description-macro
+++ a/lib/test_objpool.c
@@ -687,4 +687,5 @@ static void __exit ot_mod_exit(void)
 module_init(ot_mod_init);
 module_exit(ot_mod_exit);
 
-MODULE_LICENSE("GPL");
\ No newline at end of file
+MODULE_DESCRIPTION("Test module for lockless object pool");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

lib-test_objpool-add-missing-module_description-macro.patch

