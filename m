Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B126EB5C
	for <mm-commits@vger.kernel.org>; Wed, 31 Jul 2024 21:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722459957; cv=none; b=UtQEJPzyRowQgO1C3KtaJxXDCP8UxHSxixy2yG8NgRJu3YrF/EjAtV9TKMCzXQf+dhStjShZGunG/GSnqE5/C+nAylSxXrwOhrTumsiLIdyTgFN7NpMv8QsHtiaVChp2ZvFjdefr8+njDNDa/ZNlxJ9gBbFRTL2AJmPQGRuMF4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722459957; c=relaxed/simple;
	bh=XHuIZgHXL0kVUIUFVH3uAs/fza5MNXZMSdWqA6T6Sqw=;
	h=Date:To:From:Subject:Message-Id; b=CwklIZyoPa1QDIXe03hx8Xb/cXO8L/dFs87TtEdtan/6UH6pw5DuQFoJ77OPuzc7Fmtw0EbihGQ+xU/vlkU7aTxWTd9ri8pnakvntQcKSTMEfjJtF+6SG/RmqU8VgpRRWhLghQajFool12Lmplt5Y/nQPfdrI9vW1hRJaXaIuN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CHrJ4PbH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CHrJ4PbH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD19C116B1;
	Wed, 31 Jul 2024 21:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722459956;
	bh=XHuIZgHXL0kVUIUFVH3uAs/fza5MNXZMSdWqA6T6Sqw=;
	h=Date:To:From:Subject:From;
	b=CHrJ4PbHGxfClTQ9YHLURowALMclu2CUv3kiviQ3N+BaJfdBm/La71rs0kYIBJ1Yg
	 TyFQ7G9aTjZrPmGT9/P2FbkTPPQ/ceQTU0X/w+PiSLYTKC7idVwWjUdEadZtruDut/
	 za4T5OSR1JaiB8fQNubKsD6tZs7pIYRPE8m8iH/s=
Date: Wed, 31 Jul 2024 14:05:56 -0700
To: mm-commits@vger.kernel.org,weiyongjun1@huawei.com,chenjun102@huawei.com,catalin.marinas@arm.com,ptikhomirov@virtuozzo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kmemleak-enable-tracking-for-percpu-pointers-v2.patch added to mm-unstable branch
Message-Id: <20240731210556.8BD19C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kmemleak-enable-tracking-for-percpu-pointers-v2
has been added to the -mm mm-unstable branch.  Its filename is
     kmemleak-enable-tracking-for-percpu-pointers-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmemleak-enable-tracking-for-percpu-pointers-v2.patch

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
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Subject: kmemleak-enable-tracking-for-percpu-pointers-v2
Date: Wed, 31 Jul 2024 10:54:09 +0800

rename confusing scan_pointer to pointer_update_refs and move it just
after update_refs

Link: https://lkml.kernel.org/r/20240731025526.157529-2-ptikhomirov@virtuozzo.com
Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Cc: Chen Jun <chenjun102@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

--- a/mm/kmemleak.c~kmemleak-enable-tracking-for-percpu-pointers-v2
+++ a/mm/kmemleak.c
@@ -1362,28 +1362,7 @@ static void update_refs(struct kmemleak_
 	}
 }
 
-/*
- * Memory scanning is a long process and it needs to be interruptible. This
- * function checks whether such interrupt condition occurred.
- */
-static int scan_should_stop(void)
-{
-	if (!kmemleak_enabled)
-		return 1;
-
-	/*
-	 * This function may be called from either process or kthread context,
-	 * hence the need to check for both stop conditions.
-	 */
-	if (current->mm)
-		return signal_pending(current);
-	else
-		return kthread_should_stop();
-
-	return 0;
-}
-
-static void scan_pointer(struct kmemleak_object *scanned,
+static void pointer_update_refs(struct kmemleak_object *scanned,
 			 unsigned long pointer, unsigned int objflags)
 {
 	struct kmemleak_object *object;
@@ -1442,6 +1421,27 @@ static void scan_pointer(struct kmemleak
 }
 
 /*
+ * Memory scanning is a long process and it needs to be interruptible. This
+ * function checks whether such interrupt condition occurred.
+ */
+static int scan_should_stop(void)
+{
+	if (!kmemleak_enabled)
+		return 1;
+
+	/*
+	 * This function may be called from either process or kthread context,
+	 * hence the need to check for both stop conditions.
+	 */
+	if (current->mm)
+		return signal_pending(current);
+	else
+		return kthread_should_stop();
+
+	return 0;
+}
+
+/*
  * Scan a memory block (exclusive range) for valid pointers and add those
  * found to the gray list.
  */
@@ -1464,8 +1464,8 @@ static void scan_block(void *_start, voi
 		pointer = *(unsigned long *)kasan_reset_tag((void *)ptr);
 		kasan_enable_current();
 
-		scan_pointer(scanned, pointer, 0);
-		scan_pointer(scanned, pointer, OBJECT_PERCPU);
+		pointer_update_refs(scanned, pointer, 0);
+		pointer_update_refs(scanned, pointer, OBJECT_PERCPU);
 	}
 	raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
 }
_

Patches currently in -mm which might be from ptikhomirov@virtuozzo.com are

kmemleak-enable-tracking-for-percpu-pointers.patch
kmemleak-enable-tracking-for-percpu-pointers-v2.patch
kmemleak-test-add-percpu-leak.patch

