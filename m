Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A4C28F5
	for <mm-commits@vger.kernel.org>; Sat,  7 Dec 2024 05:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733550278; cv=none; b=qquPeDfCzzn2lHk4kPONjd7Zsh/7Qxo5v5LwypR3rX5DD3IXpLJ9aM2HhymtzuBVhmB2+r7v1I6nNU8WRkjjr+KKqbtzzH4zT95i9akX919/MHfqbqbl1gxttt5W/Vy7AC0q0KNXTg+JNuC8nSU3dUZhOUjBJodwYCMps6Rlcr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733550278; c=relaxed/simple;
	bh=cTBA9xs+SrPLRHOp/JuBKfRi/CsJZjPMS8V+nZ7PH8I=;
	h=Date:To:From:Subject:Message-Id; b=mY+gGc+i1aYyrjL0Z0dhMcAcGS0B+pPZc7gOwgeJQugO3rgrHZsowgUcPIfy+9fzeJ39uXMuyJOFnrJiIwfSNakbqlYZuNbDXyTZY0EafRx5E8oVWhhOOVVUbu++gNPYXONNwqqtG6Zafio4ycAwGdkm/SklAbvcZZStdBw+GS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gjqejcra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gjqejcra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11887C4CECD;
	Sat,  7 Dec 2024 05:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733550278;
	bh=cTBA9xs+SrPLRHOp/JuBKfRi/CsJZjPMS8V+nZ7PH8I=;
	h=Date:To:From:Subject:From;
	b=GjqejcraIPbIUWZHAz3GWHUTXJgXD1QvZW6CxYtivaSDhkPAKtrZoDqjkjl15ZXmZ
	 IQV6isih+zjkZSb8u3cPqXOM0CyDFaPED2Vqp9FNTbRS9WBtSu1EeKCpT+X+Ay9fO6
	 LIaZBKNxqjFVfeevY4K2iqyO6Fces8RtuPM2oLZQ=
Date: Fri, 06 Dec 2024 21:44:37 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rdunlap@infradead.org,pedro.falcato@gmail.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,keescook@chromium.org,jorgelo@chromium.org,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mseal-remove-can_do_mseal.patch added to mm-unstable branch
Message-Id: <20241207054438.11887C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mseal: remove can_do_mseal()
has been added to the -mm mm-unstable branch.  Its filename is
     mseal-remove-can_do_mseal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mseal-remove-can_do_mseal.patch

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
Subject: mseal: remove can_do_mseal()
Date: Fri, 6 Dec 2024 19:48:39 +0000

No code logic change.

can_do_mseal() is called exclusively by mseal.c, and mseal.c is compiled
only when CONFIG_64BIT flag is set in makefile.  Therefore, it is
unnecessary to have 32 bit stub function in the header file, remove this
function and merge the logic into do_mseal().

Link: https://lkml.kernel.org/r/20241206013934.2782793-1-jeffxu@google.com
Link: https://lkml.kernel.org/r/20241206194839.3030596-2-jeffxu@google.com
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jorge Lucangeli Obes <jorgelo@chromium.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   16 ----------------
 mm/mseal.c    |    6 +++---
 2 files changed, 3 insertions(+), 19 deletions(-)

--- a/mm/internal.h~mseal-remove-can_do_mseal
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
--- a/mm/mseal.c~mseal-remove-can_do_mseal
+++ a/mm/mseal.c
@@ -217,9 +217,9 @@ int do_mseal(unsigned long start, size_t
 	unsigned long end;
 	struct mm_struct *mm = current->mm;
 
-	ret = can_do_mseal(flags);
-	if (ret)
-		return ret;
+	/* Verify flags not set. */
+	if (flags)
+		return -EINVAL;
 
 	start = untagged_addr(start);
 	if (!PAGE_ALIGNED(start))
_

Patches currently in -mm which might be from jeffxu@chromium.org are

selftest-mm-remove-seal_elf.patch
mseal-remove-can_do_mseal.patch

