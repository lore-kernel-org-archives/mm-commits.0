Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9B52940F
	for <mm-commits@vger.kernel.org>; Tue,  8 Oct 2024 18:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728411198; cv=none; b=PwRYZF1FwZ3AVaTnywwZPoWEg310dPHBZXQb0HBcaCsimadC4brMd1E+YYAAQzE1wl52PRvWivrxOOtboYrWVj/f4tu0ylpwMlHGgquNtHPhrNLbCWs9RabGs9M2Tnns3BYDHOiza3th1TmElC+erLfaeJSACD6bsAIpBqDzJbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728411198; c=relaxed/simple;
	bh=6fgNBKsZ2YTZ0IP9kJkrBZjqGqPElrCBYDyrjOPshrc=;
	h=Date:To:From:Subject:Message-Id; b=a/v8li8eyXJXtv9SW90SGOhUKdELuh35WSI+U7xLg76vTZMbUYsRw6IAFDCpRrFsinxnjnV4VtkNqRstPZvYfB4z/mIwYLeKO7+xdKB4DkoW8WumqzhyHGrOJoNRgFO9UgHqhSW3mfgaTbmxgvmGizbQYazYHRH9purOpAnKVVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yCDsSn9T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yCDsSn9T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F800C4CEC7;
	Tue,  8 Oct 2024 18:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728411197;
	bh=6fgNBKsZ2YTZ0IP9kJkrBZjqGqPElrCBYDyrjOPshrc=;
	h=Date:To:From:Subject:From;
	b=yCDsSn9TuOO34rcdTbwFe4IauxhIG0SxDzEGAGUfrUDaBnBuOKsOLuhhB0uu9VHV0
	 RJYv6qmJxL/wP1MLXwnpxxHPBURMk2pVIFGpcw1fTFQEo8sVYb+CAzrxDanipwfQqY
	 gM2YxosF937A74mwbF+pN6Z41vayPi0JPmDx8ORY=
Date: Tue, 08 Oct 2024 11:13:16 -0700
To: mm-commits@vger.kernel.org,elver@google.com,andreyknvl@gmail.com,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kasan-kmsan-copy_from-to_kernel_nofault-v3.patch added to mm-unstable branch
Message-Id: <20241008181317.6F800C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-kasan-kmsan-copy_from-to_kernel_nofault-v3
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kasan-kmsan-copy_from-to_kernel_nofault-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kasan-kmsan-copy_from-to_kernel_nofault-v3.patch

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
mm-kasan-kmsan-copy_from-to_kernel_nofault-v3.patch

