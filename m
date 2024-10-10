Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77E91CEABC
	for <mm-commits@vger.kernel.org>; Thu, 10 Oct 2024 20:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728593936; cv=none; b=FtYy1uLpd1sxy6NteFeVQYg/pltyFzluBVrJCk6yzU4igMuCfv7/aGDaw3FmcM2BE9Xnlder+sAFopz58RStVjSulmxvrCVxg6hhbxhB4p29J7n50OZLu1d8V4yqqfY1dXsC4DY39TGl439XDYjFsNCOOADWTDEJL9gvw2EIWgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728593936; c=relaxed/simple;
	bh=8mkCCQyPsQZbK/K6Rd+KiAhQrMc3tgJ/a/A0ohTndrg=;
	h=Date:To:From:Subject:Message-Id; b=rzX3e52UCng3CC7vuFDYRl/5WDhupNZsScp2furUR1ITxdy1yA06rAKd1NB6Xdsx9cAJHLcs2Dqss41h+Q7UKrY2rieY4fqZb1J6W6FJ5HPP+7oHjj0TYMQsLbLVzawxEnE92RDnAjiRxTKeYv1q8OVoZizcliPaGrcS6eYklTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oZKhpxAZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oZKhpxAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40106C4CEC5;
	Thu, 10 Oct 2024 20:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728593936;
	bh=8mkCCQyPsQZbK/K6Rd+KiAhQrMc3tgJ/a/A0ohTndrg=;
	h=Date:To:From:Subject:From;
	b=oZKhpxAZGJmBkXPCKqvfF5n6ssJ8JfG/LupPBCiTN9MQ6bjSNiYPbymuXZ6roHvi8
	 nOaxG/FHeRyRb/ajYcMXKX5qf9oSZicolbFsIiTgPC/JpcwgwQfcMykJWrdwyoKjPN
	 kWdvkvNyh/e8jytB+Lgf3rWzv3E/jjRRkh7j1AhU=
Date: Thu, 10 Oct 2024 13:58:55 -0700
To: mm-commits@vger.kernel.org,elver@google.com,andreyknvl@gmail.com,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-kasan-kmsan-copy_from-to_kernel_nofault-v3.patch removed from -mm tree
Message-Id: <20241010205856.40106C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-kasan-kmsan-copy_from-to_kernel_nofault-v3
has been removed from the -mm tree.  Its filename was
     mm-kasan-kmsan-copy_from-to_kernel_nofault-v3.patch

This patch was dropped because it was folded into mm-kasan-kmsan-copy_from-to_kernel_nofault.patch

------------------------------------------------------
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Subject: mm-kasan-kmsan-copy_from-to_kernel_nofault-v3
Date: Tue, 8 Oct 2024 15:15:26 +0500

v2:
- squashed previous submitted in -mm tree 2 patches based on Linus tree
v3:
- moved checks to *_nofault_loop macros per Marco's comments
- edited the commit message

Link: https://lore.kernel.org/linux-mm/CANpmjNMAVFzqnCZhEity9cjiqQ9CVN1X7qeeeAp_6yKjwKo8iw@mail.gmail.com/
Link: https://lkml.kernel.org/r/20241008101526.2591147-1-snovitoll@gmail.com
Suggested-by: Marco Elver <elver@google.com>
Reported-by: syzbot+61123a5daeb9f7454599@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=61123a5daeb9f7454599
Reported-by: Andrey Konovalov <andreyknvl@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=210505
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/maccess.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/maccess.c~mm-kasan-kmsan-copy_from-to_kernel_nofault-v3
+++ a/mm/maccess.c
@@ -13,9 +13,14 @@ bool __weak copy_from_kernel_nofault_all
 	return true;
 }
 
+/*
+ * The below only uses kmsan_check_memory() to ensure uninitialized kernel
+ * memory isn't leaked.
+ */
 #define copy_from_kernel_nofault_loop(dst, src, len, type, err_label)	\
 	while (len >= sizeof(type)) {					\
 		__get_kernel_nofault(dst, src, type, err_label);	\
+		kmsan_check_memory(src, sizeof(type));			\
 		dst += sizeof(type);					\
 		src += sizeof(type);					\
 		len -= sizeof(type);					\
@@ -31,8 +36,6 @@ long copy_from_kernel_nofault(void *dst,
 	if (!copy_from_kernel_nofault_allowed(src, size))
 		return -ERANGE;
 
-	/* Make sure uninitialized kernel memory isn't copied. */
-	kmsan_check_memory(src, size);
 	pagefault_disable();
 	if (!(align & 7))
 		copy_from_kernel_nofault_loop(dst, src, size, u64, Efault);
@@ -52,6 +55,7 @@ EXPORT_SYMBOL_GPL(copy_from_kernel_nofau
 #define copy_to_kernel_nofault_loop(dst, src, len, type, err_label)	\
 	while (len >= sizeof(type)) {					\
 		__put_kernel_nofault(dst, src, type, err_label);	\
+		instrument_write(dst, sizeof(type));			\
 		dst += sizeof(type);					\
 		src += sizeof(type);					\
 		len -= sizeof(type);					\
@@ -64,7 +68,6 @@ long copy_to_kernel_nofault(void *dst, c
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS))
 		align = (unsigned long)dst | (unsigned long)src;
 
-	instrument_write(dst, size);
 	pagefault_disable();
 	if (!(align & 7))
 		copy_to_kernel_nofault_loop(dst, src, size, u64, Efault);
_

Patches currently in -mm which might be from snovitoll@gmail.com are

mm-kasan-kmsan-copy_from-to_kernel_nofault.patch

