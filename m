Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092AF15E81
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628289; cv=none; b=ZTTEjUato4qaKhtdOtIOrpfAv6p2xdwaQWIPAYnoH3azMja7/nhJghUIxh5MRu7on8piexoz5aCg6ppHg/Fj6e+YWnFWaLIYvuKt2yPKfD7CpVUVwuCrdZUODfTGCjiztFtxOSsKy6XcoVPw85zhImtKFo1DlXQNH77L2lSjqw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628289; c=relaxed/simple;
	bh=+a8X/L0df587iqreeRZtCtux5RcFpm15dm+YO1ksJjI=;
	h=Date:To:From:Subject:Message-Id; b=VCe8zgPucTs/zy8dp+oFZgl4slIr61WZ+dCsHAA8E49ujPETZ9elmaqjWXM1EqMoZakub2dSDDT+M00LYCd16TSR1X11EOdPqc0n2ZkTytyyDzOabZX3E1rIcZqVs60vVLemDtGIy3hEnE+8i4Se/+TOgXaaJtroKCC+vPpCjbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gf86wLYU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gf86wLYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4974C116B1;
	Sat, 29 Jun 2024 02:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628288;
	bh=+a8X/L0df587iqreeRZtCtux5RcFpm15dm+YO1ksJjI=;
	h=Date:To:From:Subject:From;
	b=gf86wLYUZKxv1c0FdZm82PyVkushBZ6evYHQ5Y9gw0MOFEnw5ZI+HmRzlNv1lLHz8
	 UIm/jPeffFnnBRbeNGEleRAxw9pnd60Uqu/xCMaNtdi9P3zKNk9mAsE+8UNS/uH37+
	 vkCjp6lAA94wltOhWMtCU3Q9olvWdlKHWcmYEjTo=
Date: Fri, 28 Jun 2024 19:31:28 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,glider@google.com,elver@google.com,dvyukov@google.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-do-not-pass-null-pointers-as-0.patch removed from -mm tree
Message-Id: <20240629023128.D4974C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: do not pass NULL pointers as 0
has been removed from the -mm tree.  Its filename was
     kmsan-do-not-pass-null-pointers-as-0.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: kmsan: do not pass NULL pointers as 0
Date: Thu, 27 Jun 2024 16:57:47 +0200

sparse complains about passing NULL pointers as 0.  Fix all instances.

Link: https://lkml.kernel.org/r/20240627145754.27333-3-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202406272033.KejtfLkw-lkp@intel.com/
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/hooks.c           |   15 ++++++++-------
 mm/kmsan/instrumentation.c |    4 ++--
 2 files changed, 10 insertions(+), 9 deletions(-)

--- a/mm/kmsan/hooks.c~kmsan-do-not-pass-null-pointers-as-0
+++ a/mm/kmsan/hooks.c
@@ -303,7 +303,8 @@ void kmsan_handle_urb(const struct urb *
 	if (is_out)
 		kmsan_internal_check_memory(urb->transfer_buffer,
 					    urb->transfer_buffer_length,
-					    /*user_addr*/ 0, REASON_SUBMIT_URB);
+					    /*user_addr*/ NULL,
+					    REASON_SUBMIT_URB);
 	else
 		kmsan_internal_unpoison_memory(urb->transfer_buffer,
 					       urb->transfer_buffer_length,
@@ -316,14 +317,14 @@ static void kmsan_handle_dma_page(const
 {
 	switch (dir) {
 	case DMA_BIDIRECTIONAL:
-		kmsan_internal_check_memory((void *)addr, size, /*user_addr*/ 0,
-					    REASON_ANY);
+		kmsan_internal_check_memory((void *)addr, size,
+					    /*user_addr*/ NULL, REASON_ANY);
 		kmsan_internal_unpoison_memory((void *)addr, size,
 					       /*checked*/ false);
 		break;
 	case DMA_TO_DEVICE:
-		kmsan_internal_check_memory((void *)addr, size, /*user_addr*/ 0,
-					    REASON_ANY);
+		kmsan_internal_check_memory((void *)addr, size,
+					    /*user_addr*/ NULL, REASON_ANY);
 		break;
 	case DMA_FROM_DEVICE:
 		kmsan_internal_unpoison_memory((void *)addr, size,
@@ -418,8 +419,8 @@ void kmsan_check_memory(const void *addr
 {
 	if (!kmsan_enabled)
 		return;
-	return kmsan_internal_check_memory((void *)addr, size, /*user_addr*/ 0,
-					   REASON_ANY);
+	return kmsan_internal_check_memory((void *)addr, size,
+					   /*user_addr*/ NULL, REASON_ANY);
 }
 EXPORT_SYMBOL(kmsan_check_memory);
 
--- a/mm/kmsan/instrumentation.c~kmsan-do-not-pass-null-pointers-as-0
+++ a/mm/kmsan/instrumentation.c
@@ -315,8 +315,8 @@ void __msan_warning(u32 origin)
 	if (!kmsan_enabled || kmsan_in_runtime())
 		return;
 	kmsan_enter_runtime();
-	kmsan_report(origin, /*address*/ 0, /*size*/ 0,
-		     /*off_first*/ 0, /*off_last*/ 0, /*user_addr*/ 0,
+	kmsan_report(origin, /*address*/ NULL, /*size*/ 0,
+		     /*off_first*/ 0, /*off_last*/ 0, /*user_addr*/ NULL,
 		     REASON_ANY);
 	kmsan_leave_runtime();
 }
_

Patches currently in -mm which might be from iii@linux.ibm.com are


