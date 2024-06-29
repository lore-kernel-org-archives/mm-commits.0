Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC3A11712
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628238; cv=none; b=USpdNnh3cICgBjPwrCOg6CYVKeQE376pgqtHGT7cchoK9tARj+z7HWhlX7vZxfMBJSrDu2DX5JQFedtCbgnIV0/nondWgxO9PjE6IkaTh0nhO+rWp/KVW4saQnWTg75xCslGxIke1TumR5kmYu+3KOubs9m9wsgRzjrlJnf7hmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628238; c=relaxed/simple;
	bh=lnB/LQu6X1gbxMBawMGXzT4AEzhh9IrHZuxL7jt0NZ4=;
	h=Date:To:From:Subject:Message-Id; b=a37Q3VzYPfnV0JoUICbxiWfJ4V1f/lJYxPJVQValJqazGRkVO1Hk0tbfljJY/NWuG4teItxAVTyXRFz5BR/t+FRevMUF2frWp/sEuSQNhgbC5LuNKIujuHTYRQpEvjaAcVVAO17Pfr3pWB3QpQCQm3043kkWelbxTektt7ROKo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T3TgrCM3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T3TgrCM3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A103CC116B1;
	Sat, 29 Jun 2024 02:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628238;
	bh=lnB/LQu6X1gbxMBawMGXzT4AEzhh9IrHZuxL7jt0NZ4=;
	h=Date:To:From:Subject:From;
	b=T3TgrCM32vdHHtTPxpSt3GrpDYraNZTiTI2sK/hNfRhhqbpaZ1G7nU8qk1q2PV6+Q
	 N78iisn9YAMelUFsqNN8vWd30vtR3X96jcPWFSDuSHufP/YgVURscDqIx/MKkNHJy3
	 ahTE3XxpxYY6SoO9s0X3gXWKq/tqI438+PmveKKA=
Date: Fri, 28 Jun 2024 19:30:38 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-increase-the-maximum-store-size-to-4096.patch removed from -mm tree
Message-Id: <20240629023038.A103CC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: increase the maximum store size to 4096
has been removed from the -mm tree.  Its filename was
     kmsan-increase-the-maximum-store-size-to-4096.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: kmsan: increase the maximum store size to 4096
Date: Fri, 21 Jun 2024 13:34:48 +0200

The inline assembly block in s390's chsc() stores that much.

Link: https://lkml.kernel.org/r/20240621113706.315500-5-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
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

 mm/kmsan/instrumentation.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/kmsan/instrumentation.c~kmsan-increase-the-maximum-store-size-to-4096
+++ a/mm/kmsan/instrumentation.c
@@ -110,11 +110,10 @@ void __msan_instrument_asm_store(void *a
 
 	ua_flags = user_access_save();
 	/*
-	 * Most of the accesses are below 32 bytes. The two exceptions so far
-	 * are clwb() (64 bytes) and FPU state (512 bytes).
-	 * It's unlikely that the assembly will touch more than 512 bytes.
+	 * Most of the accesses are below 32 bytes. The exceptions so far are
+	 * clwb() (64 bytes), FPU state (512 bytes) and chsc() (4096 bytes).
 	 */
-	if (size > 512) {
+	if (size > 4096) {
 		WARN_ONCE(1, "assembly store size too big: %ld\n", size);
 		size = 8;
 	}
_

Patches currently in -mm which might be from iii@linux.ibm.com are


