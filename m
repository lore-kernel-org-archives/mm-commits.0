Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0772581
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 01:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749001161; cv=none; b=OAjuBnonh7Du8oMoVINpqcUsv9dEKE33qaXjA3wxv8YP2X4Gh0yXHUXE6ilD7EHAIYSNQ6sVX8Z/ymZMLh/+/BRky6tnPTQO8lO/Qkg4S7QGkOasYWedzJA6pw0bckmhcUmzcLk5GZpCQH4t14Ctw8vunnLUf6rs2/cck/hD4XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749001161; c=relaxed/simple;
	bh=aKejXAVt36/frJZ3pFlT6YvKz4Pn0nlKGS80BDommbU=;
	h=Date:To:From:Subject:Message-Id; b=Oq1raRSYgqYkeEdAxfwRjQ7IaBDIOcLSrb1s0S8ZocUK4AaKqEmHXemhgICP+Nf0dQFz9Ew/vFq6KHMXFbfAVAi+pX29ZBWcAnnd16iv45WJ7zKGXxw0Za6BJtlT3qmZODs+JtpNQmdkgge6t3A2r978/xoQzPL3tF0e+gyVHrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VdZU04Se; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VdZU04Se"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD78C4CEED;
	Wed,  4 Jun 2025 01:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749001160;
	bh=aKejXAVt36/frJZ3pFlT6YvKz4Pn0nlKGS80BDommbU=;
	h=Date:To:From:Subject:From;
	b=VdZU04SemuMpdmu+A82PuAklEWsU+wsO4Ak8eNGtL7bhyYA+RE4iosWCcx+ymyfaG
	 9GwovWqb8eI4vIP+iWuA9izphxtZhliEGWJ/Wb55vee9YinmIhxN0jyLwYfNfrYtDV
	 8zM+OJN9Dq/5xQF/bo3Sq8tDKKBFrW01kGs/xhLg=
Date: Tue, 03 Jun 2025 18:39:19 -0700
To: mm-commits@vger.kernel.org,weihsinyeh168@gmail.com,arnd@arndb.de,julian@outer-limits.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + replace-__get_unaligned_cpu32-in-jhash-function.patch added to mm-nonmm-unstable branch
Message-Id: <20250604013920.8FD78C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: include/linux/jhash.h: replace __get_unaligned_cpu32 in jhash function
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     replace-__get_unaligned_cpu32-in-jhash-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/replace-__get_unaligned_cpu32-in-jhash-function.patch

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
From: Julian Vetter <julian@outer-limits.org>
Subject: include/linux/jhash.h: replace __get_unaligned_cpu32 in jhash function
Date: Tue, 3 Jun 2025 15:21:21 +0200

__get_unaligned_cpu32() is deprecated.  So, replace it with the more
generic get_unaligned() and just cast the input parameter.

Link: https://lkml.kernel.org/r/20250603132121.3674066-1-julian@outer-limits.org
Signed-off-by: Julian Vetter <julian@outer-limits.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Wei-Hsin Yeh <weihsinyeh168@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jhash.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/jhash.h~replace-__get_unaligned_cpu32-in-jhash-function
+++ a/include/linux/jhash.h
@@ -24,7 +24,7 @@
  * Jozsef
  */
 #include <linux/bitops.h>
-#include <linux/unaligned/packed_struct.h>
+#include <linux/unaligned.h>
 
 /* Best hash sizes are of power of two */
 #define jhash_size(n)   ((u32)1<<(n))
@@ -77,9 +77,9 @@ static inline u32 jhash(const void *key,
 
 	/* All but the last block: affect some 32 bits of (a,b,c) */
 	while (length > 12) {
-		a += __get_unaligned_cpu32(k);
-		b += __get_unaligned_cpu32(k + 4);
-		c += __get_unaligned_cpu32(k + 8);
+		a += get_unaligned((u32 *)k);
+		b += get_unaligned((u32 *)(k + 4));
+		c += get_unaligned((u32 *)(k + 8));
 		__jhash_mix(a, b, c);
 		length -= 12;
 		k += 12;
_

Patches currently in -mm which might be from julian@outer-limits.org are

replace-__get_unaligned_cpu32-in-jhash-function.patch

