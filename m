Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477CB4399C4
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 23:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788046975; cv=none; b=C+sXSUJYsivisPes/OgoOj1twPYoj7GLY0MghaL+1Z5NtLhSC8z3DVuy+bQg3SDMO6N3q8FIS9GMjhVN/2HxC+jRjSZTI/uKqbvtoc+QhxjmwDFEK0K8GO1SiL4j45zvUIA/YQXqxfsNczELKdYCtWxf17GQRDjY5/yXXYQzaY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788046975; c=relaxed/simple;
	bh=RKGXq2isizh/NLrZeIw6MBNdrtiObE57ULLoQeTbXcw=;
	h=Date:To:From:Subject:Message-Id; b=oYbmruFhFffVG3ew/jOkF7Kso02EDI9cwTv6uxz/PVF2Oh7+90p5/vNIN/GK139XARTdTSfE7u+oHR5QYufAIUj42FiCw53im5vAXMGxEYWWyeIXqkcbfgtSaaY6OOEIfi1PQuW/AI6MQwT24wS/Rg6b+qi7MUoUwFPAbCaMnfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fp/fhLDE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fp/fhLDE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B141F000E9;
	Sat, 29 Aug 2026 23:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788046974;
	bh=qvjl08f+/tWEdHifLSW8DUE9oN8Jdfqo91T5JSc1HrU=;
	h=Date:To:From:Subject;
	b=Fp/fhLDE7+FEEvJ7smBlGq3B/NL72U1zecAZB04IL2oPRTaH6ntkMuX4cvJlPwhYO
	 OszGMU5qxzq+muy7xCBspkoNMR+cYkBI4JaWdxgWLjkuNnwZXZXpx2iSrhLr0tZymw
	 GSxEso4lFnPnuBUhKNNIbqT3fpQGUJbYWL74Wpy8=
Date: Sat, 29 Aug 2026 16:42:53 -0700
To: mm-commits@vger.kernel.org,hpa@zytor.com,david.laight.linux@gmail.com,zhanxusheng@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + minmaxh-update-the-stale-x-versus-ux-comment.patch added to mm-nonmm-unstable branch
Message-Id: <20260829234253.F2B141F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: minmax.h: update the stale 'x' versus 'ux' comment
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     minmaxh-update-the-stale-x-versus-ux-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/minmaxh-update-the-stale-x-versus-ux-comment.patch

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
From: Zhan Xusheng <zhanxusheng@xiaomi.com>
Subject: minmax.h: update the stale 'x' versus 'ux' comment
Date: Mon, 17 Aug 2026 20:16:13 +0800

Commit b280bb27a9f7 ("minmax.h: reduce the #define expansion of min(),
max() and clamp()") made __sign_use(), __is_nonneg() and __types_ok() take
only 'ux', and commit a5743f32baec ("minmax.h: use BUILD_BUG_ON_MSG() for
the lo < hi test in clamp()") did the same for the clamp() limit test. 
The comment describing the old split was added one patch earlier and was
never updated.

'ux' now carries the value check too, since __is_nonneg() tests it rather
than the original expression, and nothing here looks at the value of 'x'
any more: it is expanded only to initialise 'ux' and in the error message,
as the first of those changes intended.

Link: https://lore.kernel.org/20260817121613.3846511-1-zhanxusheng@xiaomi.com
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/minmax.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/minmax.h~minmaxh-update-the-stale-x-versus-ux-comment
+++ a/include/linux/minmax.h
@@ -38,9 +38,9 @@
  * Note that 'x' is the original expression, and 'ux' is the unique variable
  * that contains the value.
  *
- * We use 'ux' for pure type checking, and 'x' for when we need to look at the
- * value (but without evaluating it for side effects!
- * Careful to only ever evaluate it with sizeof() or __builtin_constant_p() etc).
+ * We use 'ux' for both the type and the value checks, so 'x' itself is only
+ * expanded twice: once to initialise 'ux', and once quoted in the error
+ * message.
  *
  * Pointers end up being checked by the normal C type rules at the actual
  * comparison, and these expressions only need to be careful to not cause
_

Patches currently in -mm which might be from zhanxusheng@xiaomi.com are

minmaxh-update-the-stale-x-versus-ux-comment.patch

