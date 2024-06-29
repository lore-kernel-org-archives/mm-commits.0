Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4525C11712
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628240; cv=none; b=hmktjk+Rs8gedAOGy5JJqpmSb5qkEm9zwdoed14zIZ515qhYz/al7BlaRNBpKWLgP0VF8f3L/xkBHEsakqwiGi7Pxj6dGoliNw1MwXHXxyFvufFJq/lHcNX9q1rq6A7+KGaAR7kTBjIdvAKe33ArSZsoamoJxlEIyMHtyzG/aDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628240; c=relaxed/simple;
	bh=+sd+vevKIgeuNRfWFCuQ+6ZqxQoHg+oDxjz7RSRCbps=;
	h=Date:To:From:Subject:Message-Id; b=K0t8A0O81XGVeyrww4Z+J88gptsCpREC0Ad/3GadxaJja7b9Hkox6Z5zdJCKSwG/9A+1BmAVCB9dr1MmlowMh1XINN4rAfqplfkqCUXzK3MBm9WIZ2oxXNysWC7h9DOwjg/wG6+YIpk3JV1TqUTyecRj5qe0sg/bsY9471Y+Gjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H8qDK6kS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H8qDK6kS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A10BC116B1;
	Sat, 29 Jun 2024 02:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628240;
	bh=+sd+vevKIgeuNRfWFCuQ+6ZqxQoHg+oDxjz7RSRCbps=;
	h=Date:To:From:Subject:From;
	b=H8qDK6kSHKUmIwJ4dvsFmnoU6ZIcBiIEc/UNkk5PtFpyolAf/HsltT+5GFDmzV0Fw
	 mHWhI8W52F4PUM8FaW8BttTQpEphpJtHSdcpR1dGpT8/FTAf9YIpkNI+U/Gd5pLCqf
	 fhl6Nh2Z45NztC2tfn02T5qjpGuo83/gePukXcKY=
Date: Fri, 28 Jun 2024 19:30:39 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-fix-is_bad_asm_addr-on-arches-with-overlapping-address-spaces.patch removed from -mm tree
Message-Id: <20240629023040.1A10BC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: fix is_bad_asm_addr() on arches with overlapping address spaces
has been removed from the -mm tree.  Its filename was
     kmsan-fix-is_bad_asm_addr-on-arches-with-overlapping-address-spaces.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: kmsan: fix is_bad_asm_addr() on arches with overlapping address spaces
Date: Fri, 21 Jun 2024 13:34:49 +0200

Comparing pointers with TASK_SIZE does not make sense when kernel and
userspace overlap.  Skip the comparison when this is the case.

Link: https://lkml.kernel.org/r/20240621113706.315500-6-iii@linux.ibm.com
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

 mm/kmsan/instrumentation.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/kmsan/instrumentation.c~kmsan-fix-is_bad_asm_addr-on-arches-with-overlapping-address-spaces
+++ a/mm/kmsan/instrumentation.c
@@ -20,7 +20,8 @@
 
 static inline bool is_bad_asm_addr(void *addr, uintptr_t size, bool is_store)
 {
-	if ((u64)addr < TASK_SIZE)
+	if (IS_ENABLED(CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE) &&
+	    (u64)addr < TASK_SIZE)
 		return true;
 	if (!kmsan_get_metadata(addr, KMSAN_META_SHADOW))
 		return true;
_

Patches currently in -mm which might be from iii@linux.ibm.com are


