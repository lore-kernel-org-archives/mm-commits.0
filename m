Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E5BFC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:06:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB2C3611C4
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346721AbhIIVHM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:07:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348295AbhIIVG7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:06:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D18836109F;
        Thu,  9 Sep 2021 21:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221549;
        bh=dAZMhlSfk8mHW7HS+KDQIz4YGEr0J6BpBqq6vjLsQC4=;
        h=Date:From:To:Subject:From;
        b=vvp9V4e6/VXflLlPtDTINOri+skYOUTdGJkLLZlWdeesaO8viyWHZbGQwFqniaynL
         qAf57wwHzNICZ9yzCGcKpqNlX9B2K0Vjir7mLd+8Qk/6bXLTcytjXYzAhdoVsxx84+
         IqNrFsijjcfl18nETPW4316ztmX1KIwQGuBXl+ZY=
Date:   Thu, 09 Sep 2021 14:05:48 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, benh@kernel.crashing.org, borntraeger@de.ibm.com,
        bp@alien8.de, catalin.marinas@arm.com, davem@davemloft.net,
        deller@gmx.de, ebiederm@xmission.com, feng.tang@intel.com,
        gor@linux.ibm.com, hca@linux.ibm.com, hch@infradead.org,
        hch@lst.de, hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        paulus@samba.org, tglx@linutronix.de, tsbogend@alpha.franken.de,
        viro@zeniv.linux.org.uk, will@kernel.org
Subject:  [merged] kexec-move-locking-into-do_kexec_load.patch
 removed from -mm tree
Message-ID: <20210909210548.uS7r1GDpn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: move locking into do_kexec_load
has been removed from the -mm tree.  Its filename was
     kexec-move-locking-into-do_kexec_load.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: kexec: move locking into do_kexec_load

Patch series "compat: remove compat_alloc_user_space", v5.

Going through compat_alloc_user_space() to convert indirect system call
arguments tends to add complexity compared to handling the native and
compat logic in the same code.


This patch (of 6):

The locking is the same between the native and compat version of
sys_kexec_load(), so it can be done in the common implementation to reduce
duplication.

Link: https://lkml.kernel.org/r/20210727144859.4150043-1-arnd@kernel.org
Link: https://lkml.kernel.org/r/20210727144859.4150043-2-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Co-developed-by: Eric Biederman <ebiederm@xmission.com>
Co-developed-by: Christoph Hellwig <hch@infradead.org>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |   44 ++++++++++++++++----------------------------
 1 file changed, 16 insertions(+), 28 deletions(-)

--- a/kernel/kexec.c~kexec-move-locking-into-do_kexec_load
+++ a/kernel/kexec.c
@@ -110,6 +110,17 @@ static int do_kexec_load(unsigned long e
 	unsigned long i;
 	int ret;
 
+	/*
+	 * Because we write directly to the reserved memory region when loading
+	 * crash kernels we need a mutex here to prevent multiple crash kernels
+	 * from attempting to load simultaneously, and to prevent a crash kernel
+	 * from loading over the top of a in use crash kernel.
+	 *
+	 * KISS: always take the mutex.
+	 */
+	if (!mutex_trylock(&kexec_mutex))
+		return -EBUSY;
+
 	if (flags & KEXEC_ON_CRASH) {
 		dest_image = &kexec_crash_image;
 		if (kexec_crash_image)
@@ -121,7 +132,8 @@ static int do_kexec_load(unsigned long e
 	if (nr_segments == 0) {
 		/* Uninstall image */
 		kimage_free(xchg(dest_image, NULL));
-		return 0;
+		ret = 0;
+		goto out_unlock;
 	}
 	if (flags & KEXEC_ON_CRASH) {
 		/*
@@ -134,7 +146,7 @@ static int do_kexec_load(unsigned long e
 
 	ret = kimage_alloc_init(&image, entry, nr_segments, segments, flags);
 	if (ret)
-		return ret;
+		goto out_unlock;
 
 	if (flags & KEXEC_PRESERVE_CONTEXT)
 		image->preserve_context = 1;
@@ -171,6 +183,8 @@ out:
 		arch_kexec_protect_crashkres();
 
 	kimage_free(image);
+out_unlock:
+	mutex_unlock(&kexec_mutex);
 	return ret;
 }
 
@@ -247,21 +261,8 @@ SYSCALL_DEFINE4(kexec_load, unsigned lon
 		((flags & KEXEC_ARCH_MASK) != KEXEC_ARCH_DEFAULT))
 		return -EINVAL;
 
-	/* Because we write directly to the reserved memory
-	 * region when loading crash kernels we need a mutex here to
-	 * prevent multiple crash  kernels from attempting to load
-	 * simultaneously, and to prevent a crash kernel from loading
-	 * over the top of a in use crash kernel.
-	 *
-	 * KISS: always take the mutex.
-	 */
-	if (!mutex_trylock(&kexec_mutex))
-		return -EBUSY;
-
 	result = do_kexec_load(entry, nr_segments, segments, flags);
 
-	mutex_unlock(&kexec_mutex);
-
 	return result;
 }
 
@@ -301,21 +302,8 @@ COMPAT_SYSCALL_DEFINE4(kexec_load, compa
 			return -EFAULT;
 	}
 
-	/* Because we write directly to the reserved memory
-	 * region when loading crash kernels we need a mutex here to
-	 * prevent multiple crash  kernels from attempting to load
-	 * simultaneously, and to prevent a crash kernel from loading
-	 * over the top of a in use crash kernel.
-	 *
-	 * KISS: always take the mutex.
-	 */
-	if (!mutex_trylock(&kexec_mutex))
-		return -EBUSY;
-
 	result = do_kexec_load(entry, nr_segments, ksegments, flags);
 
-	mutex_unlock(&kexec_mutex);
-
 	return result;
 }
 #endif
_

Patches currently in -mm which might be from arnd@arndb.de are


