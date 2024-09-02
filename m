Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1AA479C0
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725246513; cv=none; b=qXNGEZtwDZa+cWVgR3lCyGpjBQOQy0q12whnpfBtADryzqmdvwx1HBstX/Ivi72DQTKBCoP/ewXAdUQzfoT+AYbDzEqqCeE4w65LSfNpdW2KMR7KfrtrRJvIL+chgMe5Lkbl0oreCXArVHO0ALfFJKnuPAixVFX/GiEpC1SVrHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725246513; c=relaxed/simple;
	bh=oXBMSyuAHd8qpb7pllm9XKdEwOvBHIQ4MPxldnHs0J8=;
	h=Date:To:From:Subject:Message-Id; b=rwI2MlxvMu+MXKuHBZ7VPydB2xnJIlg3Vxim/Spol6KcfAU/Kv41CkVag/80SH1wBZvDtQJ15H13mNgKhj7bEfzfTOmBHf/NWIlMGBBBPRykoTY0zJIOZpIm/dC90Z77lbRMimW7eE7O32UMwq5R5EVKP8XeVIang8P56C45heg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QVOajdYH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QVOajdYH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FEEBC4CEC3;
	Mon,  2 Sep 2024 03:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725246512;
	bh=oXBMSyuAHd8qpb7pllm9XKdEwOvBHIQ4MPxldnHs0J8=;
	h=Date:To:From:Subject:From;
	b=QVOajdYHshMweUv/W4losyL7w5zAL7eqL80APFKeEf9xuXQaPtcbtxlL7Ga6YoSDe
	 82SxaBt8ZT1M92pm1j1FffCs58LWRn6kbBPqjymLjJp/brESwAmhmZT7IoS4T6Y08h
	 3qIwMRNURs4jw4CWUmg/FfvDSLxBh2FyO0Yw5mLI=
Date: Sun, 01 Sep 2024 20:08:31 -0700
To: mm-commits@vger.kernel.org,weiyongjun1@huawei.com,chenjun102@huawei.com,catalin.marinas@arm.com,ptikhomirov@virtuozzo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kmemleak-enable-tracking-for-percpu-pointers-v2.patch removed from -mm tree
Message-Id: <20240902030832.5FEEBC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmemleak-enable-tracking-for-percpu-pointers-v2
has been removed from the -mm tree.  Its filename was
     kmemleak-enable-tracking-for-percpu-pointers-v2.patch

This patch was dropped because it was folded into kmemleak-enable-tracking-for-percpu-pointers.patch

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
kmemleak-test-add-percpu-leak.patch

