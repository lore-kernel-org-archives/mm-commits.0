Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598151482E3
	for <mm-commits@vger.kernel.org>; Fri,  6 Dec 2024 02:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733450673; cv=none; b=MGiboWIJF3gnx+zu7Ubr1dtGOkhj+rNkQs3+tE1hXrjsvTocl/DKrERwSSgbmbGV1H/nqBcYz9Xb63aj/InIvCHnD9n6+zivYtsBk4XO4c94b25vM83NfjCVG8n8X2Yazev7kutqLMzCfHzHNPdhdO0fC6mM/K58YGPlAfz9n3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733450673; c=relaxed/simple;
	bh=z2mhBDhyQgkeA40HpTp7Q52FGzpIeMafEym20F6eqMM=;
	h=Date:To:From:Subject:Message-Id; b=koJTVZXYtRAyCXP+nJfEDrr3+S0/xV37j2UlghQF3kEYRT+Nn6IBdL6bfnHQz/M0PNXnj+HYJgM1DTsjy13hvAiYaxyglW0mVPFtTH5sFYWHGmsB1+ri3pOVbGw/1XKxTEyAaXcJ/NPvNXwNveo53Ph8wLelihZbeUlDlOJZYXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qwv8thlt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qwv8thlt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0CEDC4CED1;
	Fri,  6 Dec 2024 02:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733450672;
	bh=z2mhBDhyQgkeA40HpTp7Q52FGzpIeMafEym20F6eqMM=;
	h=Date:To:From:Subject:From;
	b=qwv8thltj71iTKqj4waoiuNdQxQx0oHBBIgVzM5mKlXgg1svFJUH0n5JmyPwRLBlI
	 1lX+rxLiRXAtPbXP8GdgT5nxVmKzfUcaKwXbIejcX+xv7ech5sKCjFe8eSUB8bAmpl
	 iiyAeLEFxPKJ0sGHXLUwMLPTjezevvHfsrRyHKxg=
Date: Thu, 05 Dec 2024 18:04:32 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rdunlap@infradead.org,pedro.falcato@gmail.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,keescook@chromium.org,jorgelo@chromium.org,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mseal-move-can_do_mseal-to-msealc.patch added to mm-unstable branch
Message-Id: <20241206020432.C0CEDC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mseal: move can_do_mseal() to mseal.c
has been added to the -mm mm-unstable branch.  Its filename is
     mseal-move-can_do_mseal-to-msealc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mseal-move-can_do_mseal-to-msealc.patch

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
From: Jeff Xu <jeffxu@chromium.org>
Subject: mseal: move can_do_mseal() to mseal.c
Date: Fri, 6 Dec 2024 01:39:34 +0000

No code logic change.

can_do_mseal() is called exclusively by mseal.c, and mseal.c is compiled
only when CONFIG_64BIT flag is set in makefile.  Therefore, it is
unnecessary to have 32 bit stub function in the header file.

Link: https://lkml.kernel.org/r/20241206013934.2782793-1-jeffxu@google.com
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
Cc: Jorge Lucangeli Obes <jorgelo@chromium.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   16 ----------------
 mm/mseal.c    |    8 ++++++++
 2 files changed, 8 insertions(+), 16 deletions(-)

--- a/mm/internal.h~mseal-move-can_do_mseal-to-msealc
+++ a/mm/internal.h
@@ -1457,22 +1457,6 @@ void __meminit __init_single_page(struct
 unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
 			  int priority);
 
-#ifdef CONFIG_64BIT
-static inline int can_do_mseal(unsigned long flags)
-{
-	if (flags)
-		return -EINVAL;
-
-	return 0;
-}
-
-#else
-static inline int can_do_mseal(unsigned long flags)
-{
-	return -EPERM;
-}
-#endif
-
 #ifdef CONFIG_SHRINKER_DEBUG
 static inline __printf(2, 0) int shrinker_debugfs_name_alloc(
 			struct shrinker *shrinker, const char *fmt, va_list ap)
--- a/mm/mseal.c~mseal-move-can_do_mseal-to-msealc
+++ a/mm/mseal.c
@@ -158,6 +158,14 @@ static int apply_mm_seal(unsigned long s
 	return 0;
 }
 
+static inline int can_do_mseal(unsigned long flags)
+{
+	if (flags)
+		return -EINVAL;
+
+	return 0;
+}
+
 /*
  * mseal(2) seals the VM's meta data from
  * selected syscalls.
_

Patches currently in -mm which might be from jeffxu@chromium.org are

selftest-mm-remove-seal_elf.patch
mseal-move-can_do_mseal-to-msealc.patch

