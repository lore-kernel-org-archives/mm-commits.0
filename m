Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B0C380
	for <mm-commits@vger.kernel.org>; Fri, 31 May 2024 22:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717194223; cv=none; b=VBjOgG+jyhxKLY5V/Vx2Wk1sUHaF00BHdFDFXNhrb3NjLGeMhom64NdX/hE2eXqP+C/06O4Im2K/KvL85MrxxiZPPsDaoYAkfLOQSDwik9KxPd7CJlbIXDFejX7XgFgf3HHWdSgVkd9mOUvkv5SeytycZl454VOmzrVArK8MJbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717194223; c=relaxed/simple;
	bh=jjtHTrEBN0gDgokfNhMBXpL7x2dRhI4ULO/ys6X7G/o=;
	h=Date:To:From:Subject:Message-Id; b=lOKgWLKjv1PWm8SOuVhcnJSu+SX9GgbaV6y4XChFh5TLEMgduR5sg8uv9QBCtg60aT+TQwxakbfD7aEUUg7st6QMnLL+OjqkYWfeuZq/nll6mYTTWOzvTqoZ/HL4h3tG0PY2cYk4aGvOH3oguFvdW9RQ+7HnWARoYCjh21KznuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ww8ICpo1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ww8ICpo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4856C116B1;
	Fri, 31 May 2024 22:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717194223;
	bh=jjtHTrEBN0gDgokfNhMBXpL7x2dRhI4ULO/ys6X7G/o=;
	h=Date:To:From:Subject:From;
	b=ww8ICpo1N/lJqUFT+DacOOGAp/lGT717aRiDpAWBpgc7QFWCBpjPNn+7ErBUlLuqq
	 Fsf5wQvmU49JgdEG36zk9BgNrLiGPj/Ryfts2bFGxdYczhXtD8OlyuemygR82PAFm6
	 hxUD1zhzkrZz21bmAwIEJRkt5teLazPtO3HgAgWw=
Date: Fri, 31 May 2024 15:23:42 -0700
To: mm-commits@vger.kernel.org,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-ts-add-missing-module_description-macros.patch added to mm-nonmm-unstable branch
Message-Id: <20240531222342.D4856C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/ts: add missing MODULE_DESCRIPTION() macros
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-ts-add-missing-module_description-macros.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-ts-add-missing-module_description-macros.patch

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
Subject: lib/ts: add missing MODULE_DESCRIPTION() macros
Date: Fri, 31 May 2024 08:14:56 -0700

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/ts_kmp.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/ts_bm.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/ts_fsm.o

Add the missing invocations of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240531-lib-ts-v1-1-03d7f3546c49@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ts_bm.c  |    1 +
 lib/ts_fsm.c |    1 +
 lib/ts_kmp.c |    1 +
 3 files changed, 3 insertions(+)

--- a/lib/ts_bm.c~lib-ts-add-missing-module_description-macros
+++ a/lib/ts_bm.c
@@ -216,6 +216,7 @@ static void __exit exit_bm(void)
 	textsearch_unregister(&bm_ops);
 }
 
+MODULE_DESCRIPTION("Boyer-Moore text search implementation");
 MODULE_LICENSE("GPL");
 
 module_init(init_bm);
--- a/lib/ts_fsm.c~lib-ts-add-missing-module_description-macros
+++ a/lib/ts_fsm.c
@@ -331,6 +331,7 @@ static void __exit exit_fsm(void)
 	textsearch_unregister(&fsm_ops);
 }
 
+MODULE_DESCRIPTION("naive finite state machine text search");
 MODULE_LICENSE("GPL");
 
 module_init(init_fsm);
--- a/lib/ts_kmp.c~lib-ts-add-missing-module_description-macros
+++ a/lib/ts_kmp.c
@@ -147,6 +147,7 @@ static void __exit exit_kmp(void)
 	textsearch_unregister(&kmp_ops);
 }
 
+MODULE_DESCRIPTION("Knuth-Morris-Pratt text search implementation");
 MODULE_LICENSE("GPL");
 
 module_init(init_kmp);
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

mm-hwpoison-add-module_description.patch
mm-dmapool-add-module_description.patch
mm-kfence-add-module_description.patch
mm-zsmalloc-add-module_description.patch
backtracetest-add-module_description.patch
dyndbg-add-missing-module_description-macro.patch
lib-ts-add-missing-module_description-macros.patch

