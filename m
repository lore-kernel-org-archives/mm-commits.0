Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB506D304
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628241; cv=none; b=R/1BHs/S0lcgdleDHXLs8rKCCXpKkjK3bH1dLo+sXXXEm2SspWw2o/dTn5BtUoT9aAPZKBiAYaVzYhlJxWXZ9RueCNrwXtyjeW1l9kaCG5XhhYVVduRaq/m9IqI7ecprW3DVduqyUuhpgplW3lIxuI7Adm43If+tBYU5hDCk7l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628241; c=relaxed/simple;
	bh=X4GunKEO9kgoQ2w2flVuxuRljb5m9Jj/RC237+gVOW0=;
	h=Date:To:From:Subject:Message-Id; b=XI/HTHKUgKzZ3H15YrYQWK9xs1X2uIBYLfvWyJzvOMVFYaSYyHXQMdf7wAc3pUAsRLJ4wbtwJER4Q63ls6Xu1KaVFBeOjtYs7PW5cXHRHLt0dNpLTNjCPpQvKsepUTbxZ34R42mnu9QE1rj63IEGrRB6Uvgn9cBNczRfki7C8z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j24uv/Lu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j24uv/Lu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802B2C116B1;
	Sat, 29 Jun 2024 02:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628241;
	bh=X4GunKEO9kgoQ2w2flVuxuRljb5m9Jj/RC237+gVOW0=;
	h=Date:To:From:Subject:From;
	b=j24uv/LuNYS8u0/JOA/7DAknpIFliYt3e2OPNbT81XzC4RmvqsvV01jkv4F2EgNGe
	 12UJPe4dCRHMDZiibfrOBdFfWtRDX0jLouNcUnbOqMpSWa8RwdfLlCr9pIRAVnmsbI
	 UkszWMCmvfyNhJg5qcWz6ObS588sH+95Z9UxrPPo=
Date: Fri, 28 Jun 2024 19:30:41 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-fix-kmsan_copy_to_user-on-arches-with-overlapping-address-spaces.patch removed from -mm tree
Message-Id: <20240629023041.802B2C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: fix kmsan_copy_to_user() on arches with overlapping address spaces
has been removed from the -mm tree.  Its filename was
     kmsan-fix-kmsan_copy_to_user-on-arches-with-overlapping-address-spaces.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: kmsan: fix kmsan_copy_to_user() on arches with overlapping address spaces
Date: Fri, 21 Jun 2024 13:34:50 +0200

Comparing pointers with TASK_SIZE does not make sense when kernel and
userspace overlap.  Assume that we are handling user memory access in this
case.

Link: https://lkml.kernel.org/r/20240621113706.315500-7-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reported-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <kasan-dev@googlegroups.com>
Cc: Marco Elver <elver@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/hooks.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/kmsan/hooks.c~kmsan-fix-kmsan_copy_to_user-on-arches-with-overlapping-address-spaces
+++ a/mm/kmsan/hooks.c
@@ -267,7 +267,8 @@ void kmsan_copy_to_user(void __user *to,
 		return;
 
 	ua_flags = user_access_save();
-	if ((u64)to < TASK_SIZE) {
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE) ||
+	    (u64)to < TASK_SIZE) {
 		/* This is a user memory access, check it. */
 		kmsan_internal_check_memory((void *)from, to_copy - left, to,
 					    REASON_COPY_TO_USER);
_

Patches currently in -mm which might be from iii@linux.ibm.com are


