Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513BC3515DA
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338659; cv=none; b=KdZihKU36FfPbJhVtOXY4YoNqM6cBA9ApKTU1A/Femq2bWskye1HwELXYlnwvRpWA3hqywlOVKPpf4CZe9BMnE3H2SbKQpWJbhNdMekJmvtItKEhrdpn8jNw6JXzOW/84x8BGVWmHYaekePnm4oIsBHzx4YqrA7hRci7l/LACUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338659; c=relaxed/simple;
	bh=IUgOw8rmoPwvR8wW8CkFqNGfSCbM4q39+SppNf2HHOA=;
	h=Date:To:From:Subject:Message-Id; b=idpTv9sicLea7MqdjA3yRMEH+XIdAwlgKIuneeGUKZ6sdQd9y40fnPEOP3b0CdEmMws/8Pyy6dROstdLzFJYRvYOUwFi2myQi945sL9mPaFtuzpRTsxeQ/n2Uk/k258rgPcom9gIUdlcl6CzVU0/NPO6rAcd2huLLsxE2+Hy4mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZcRBxHVy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZcRBxHVy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3211F0089C;
	Wed,  7 Oct 2026 02:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338658;
	bh=qJ3txw3fGGC0Yw+hXyjMpTf6szi4nlodfz5jQuisjQY=;
	h=Date:To:From:Subject;
	b=ZcRBxHVyUt+4TsHd9iRObKDE/akkv8Ajub6QF7xYWJ66vChW6HX90sl1blev1qQYl
	 jw/n0DhpJT6OIVPXkPGIs3g3pbERWvZBGb2SbSsGqCqx0lmydiz6BpW/MC1D8k5Rjv
	 6RuYQsW5E7qtvtblHcynPHX29zUjsvAIFA2VRpzs=
Date: Tue, 06 Oct 2026 19:04:17 -0700
To: mm-commits@vger.kernel.org,hpa@zytor.com,david.laight.linux@gmail.com,zhanxusheng@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] minmaxh-update-the-stale-x-versus-ux-comment.patch removed from -mm tree
Message-Id: <20261007020417.DD3211F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: minmax.h: update the stale 'x' versus 'ux' comment
has been removed from the -mm tree.  Its filename was
     minmaxh-update-the-stale-x-versus-ux-comment.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
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


