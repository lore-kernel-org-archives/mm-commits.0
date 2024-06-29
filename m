Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF12911CA1
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628253; cv=none; b=aDqHnHCgWXZ5FfJJzF5zm9nuDgPP8PHkbmx+Rxwlo3mj6nwy1rVBY282PnCf0lDo5qj6wQcG/MAxl2ZapM0MWlxoogRnRWT526gaVHM4vHgA6PDwcABe5WYAG4Kp8NO1E7xTSFLVmBrNXYI4ilzTiY3tW0WZaYNtR0pGUh6gAvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628253; c=relaxed/simple;
	bh=ctgga4pflsuCI7bpjI2jK0NveqTBmYCMwsNic+8fZdY=;
	h=Date:To:From:Subject:Message-Id; b=nDDF+6RlWQNrqdPd5Xrz9GzqaEgaONRTLTmzJIAy/Y9+2weorpC7Dyz8CW/ORu7pj9L30kSTENk3Y9QUVxwS6sO8nfJwI44jzTwxCmCUXWzzgJu7hJ4Eid13tyfzJAEZv46fbxa54k90cGpglNWAzrcVKFEe5ZZp7ZVvfBKHtcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fsUmeexc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fsUmeexc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6BB9C116B1;
	Sat, 29 Jun 2024 02:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628252;
	bh=ctgga4pflsuCI7bpjI2jK0NveqTBmYCMwsNic+8fZdY=;
	h=Date:To:From:Subject:From;
	b=fsUmeexcfp+j5vJPcJ9kGK3eGz0aL/IQ5yg9mgbPkkSYwGX30Ii3ipS9iFPD7vehg
	 FHDBVW80u5xkD9qAKagLXw52F5042VSoiCdY0D0cRPcTWaPc8OVT2QvKMm21CyM4yO
	 qk1SjkV9XF1lJm0bqfYzjqRbBUSAKafC8VV/cVtE=
Date: Fri, 28 Jun 2024 19:30:52 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-use-align_down-in-kmsan_get_metadata.patch removed from -mm tree
Message-Id: <20240629023052.C6BB9C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: use ALIGN_DOWN() in kmsan_get_metadata()
has been removed from the -mm tree.  Its filename was
     kmsan-use-align_down-in-kmsan_get_metadata.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: kmsan: use ALIGN_DOWN() in kmsan_get_metadata()
Date: Fri, 21 Jun 2024 13:34:58 +0200

Improve the readability by replacing the custom aligning logic with
ALIGN_DOWN().  Unlike other places where a similar sequence is used, there
is no size parameter that needs to be adjusted, so the standard macro
fits.

Link: https://lkml.kernel.org/r/20240621113706.315500-15-iii@linux.ibm.com
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

 mm/kmsan/shadow.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/kmsan/shadow.c~kmsan-use-align_down-in-kmsan_get_metadata
+++ a/mm/kmsan/shadow.c
@@ -123,14 +123,12 @@ return_dummy:
  */
 void *kmsan_get_metadata(void *address, bool is_origin)
 {
-	u64 addr = (u64)address, pad, off;
+	u64 addr = (u64)address, off;
 	struct page *page;
 	void *ret;
 
-	if (is_origin && !IS_ALIGNED(addr, KMSAN_ORIGIN_SIZE)) {
-		pad = addr % KMSAN_ORIGIN_SIZE;
-		addr -= pad;
-	}
+	if (is_origin)
+		addr = ALIGN_DOWN(addr, KMSAN_ORIGIN_SIZE);
 	address = (void *)addr;
 	if (kmsan_internal_is_vmalloc_addr(address) ||
 	    kmsan_internal_is_module_addr(address))
_

Patches currently in -mm which might be from iii@linux.ibm.com are


