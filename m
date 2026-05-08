Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2E037F726
	for <mm-commits@vger.kernel.org>; Fri,  8 May 2026 20:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778270983; cv=none; b=Lz8hc7fiahRIFx+iJQ4UYtb38I6IzRbJb4u7c6aI0jPPhP01sndt3bCY+u2mvU34R9INYXzgZ1r0cvb5rLLatha3kc59W9sKt+moSlfzHGMiN5MaUL0BMBdwZxawADl0FR25nQqxaUvZGZ+4xRK02KEJUKDNpyB1OCR8QKTWkBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778270983; c=relaxed/simple;
	bh=4tZHAykClrk43K0CpqHLgtkIkPc2w/A/pqXiRPL5pKc=;
	h=Date:To:From:Subject:Message-Id; b=pYfTGgyrvmBUAHx0gjkAWI20e2k6vyiCkOqBHNIld4KF3pGBCVL6oXVIB4G+R416CX9mLIMsX30QcoqbWR1gg7/8NHZV/x7bPsUv+ynRtojd9m0jcTPS9wB+9BbjEKL4GS0xDt/6njlyFCUTuHIdTx62uNMGmQ7nAI1plqxCjA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bFaO8hG8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bFaO8hG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC04C2BCB0;
	Fri,  8 May 2026 20:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778270983;
	bh=4tZHAykClrk43K0CpqHLgtkIkPc2w/A/pqXiRPL5pKc=;
	h=Date:To:From:Subject:From;
	b=bFaO8hG84p7yRaTVt2sZ/WhYVUjWR7curOpvb5wBwoj+MDUk+WcvI1vG26YuHB9S+
	 nEmIGV1nLOHVU4uF9CcrIbUKApzTs0Lvrg6P/hub4+uYfsPog9Y7UMA+bY9xoWMkf+
	 paGV08n82Q9w49Hsm4lwPYG7U59LQ62ouEMSBZ0Y=
Date: Fri, 08 May 2026 13:09:42 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,pimyn@google.com,gthelen@google.com,elver@google.com,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kfence-fix-kasan-hw-tags-bypass-via-runtime-sample_interval-change.patch added to mm-nonmm-unstable branch
Message-Id: <20260508200943.4EC04C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kfence: fix KASAN HW tags bypass via runtime sample_interval change
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kfence-fix-kasan-hw-tags-bypass-via-runtime-sample_interval-change.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kfence-fix-kasan-hw-tags-bypass-via-runtime-sample_interval-change.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: kfence: fix KASAN HW tags bypass via runtime sample_interval change
Date: Thu, 7 May 2026 11:52:37 +0200

If a user writes a non-zero value to the sample_interval module parameter
at runtime, the missing KASAN HW tags check in the late init path allows
KFENCE to be enabled alongside KASAN HW tags, bypassing the boot
restriction.

This patch adds the missing check to param_set_sample_interval() to reject
the parameter change if KASAN HW tags are enabled.

Link: https://lore.kernel.org/20260507095237.741017-1-glider@google.com
Fixes: 09833d99db36 ("mm/kfence: disable KFENCE upon KASAN HW tags enablement")
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Pimyn Girgis <pimyn@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/kfence/core.c~kfence-fix-kasan-hw-tags-bypass-via-runtime-sample_interval-change
+++ a/mm/kfence/core.c
@@ -77,6 +77,11 @@ static int param_set_sample_interval(con
 		WRITE_ONCE(kfence_enabled, false);
 	}
 
+	if (num && kasan_hw_tags_enabled()) {
+		pr_info("disabled as KASAN HW tags are enabled\n");
+		return -EINVAL;
+	}
+
 	*((unsigned long *)kp->arg) = num;
 
 	if (num && !READ_ONCE(kfence_enabled) && system_state != SYSTEM_BOOTING)
_

Patches currently in -mm which might be from glider@google.com are

kfence-fix-kasan-hw-tags-bypass-via-runtime-sample_interval-change.patch

