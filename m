Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E6BC432BE
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 20:25:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70B7860FC0
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 20:25:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbhG0UZQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Jul 2021 16:25:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:46894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230409AbhG0UZQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 27 Jul 2021 16:25:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A715660F9C;
        Tue, 27 Jul 2021 20:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627417516;
        bh=KJIYoqDtTYHdZvuxiYywrvLuEeDLG1b0k1G5MMbJdQI=;
        h=Date:From:To:Subject:From;
        b=wBY/ZrjaTiRvf7Lky/2ejNY416xYNAg6rAecU2OpJ9l7yCEsLy8BcZd2hKFCN7DZ4
         Fwz8RDnsfsuC/z5z7Ao2lirL7cnd0CKEC4AlcLXSvLBLQLJzL54YHUfAB1o7igwYL9
         OMKqFeOArvml+e5DsHqpb6g+FpsaHjEzWJx6DPYY=
Date:   Tue, 27 Jul 2021 13:25:15 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org,
        viro@zeniv.linux.org.uk, tsbogend@alpha.franken.de,
        tglx@linutronix.de, paulus@samba.org, mpe@ellerman.id.au,
        mingo@redhat.com, James.Bottomley@HansenPartnership.com,
        hpa@zytor.com, hch@lst.de, hch@infradead.org, hca@linux.ibm.com,
        gor@linux.ibm.com, feng.tang@intel.com, ebiederm@xmission.com,
        deller@gmx.de, davem@davemloft.net, catalin.marinas@arm.com,
        bp@alien8.de, borntraeger@de.ibm.com, benh@kernel.crashing.org,
        arnd@arndb.de
Subject:  + kexec-avoid-compat_alloc_user_space.patch added to -mm
 tree
Message-ID: <20210727202515.QSYMO%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: avoid compat_alloc_user_space
has been added to the -mm tree.  Its filename is
     kexec-avoid-compat_alloc_user_space.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kexec-avoid-compat_alloc_user_space.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kexec-avoid-compat_alloc_user_space.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: kexec: avoid compat_alloc_user_space

kimage_alloc_init() expects a __user pointer, so compat_sys_kexec_load()
uses compat_alloc_user_space() to convert the layout and put it back onto
the user space caller stack.

Moving the user space access into the syscall handler directly actually
makes the code simpler, as the conversion for compat mode can now be done
on kernel memory.

Link: https://lkml.kernel.org/r/20210727144859.4150043-3-arnd@kernel.org
Link: https://lore.kernel.org/lkml/YPbtsU4GX6PL7%2F42@infradead.org/
Link: https://lore.kernel.org/lkml/m1y2cbzmnw.fsf@fess.ebiederm.org/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Co-developed-by: Eric Biederman <ebiederm@xmission.com>
Co-developed-by: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |   61 +++++++++++++++++++----------------------------
 1 file changed, 25 insertions(+), 36 deletions(-)

--- a/kernel/kexec.c~kexec-avoid-compat_alloc_user_space
+++ a/kernel/kexec.c
@@ -19,26 +19,9 @@
 
 #include "kexec_internal.h"
 
-static int copy_user_segment_list(struct kimage *image,
-				  unsigned long nr_segments,
-				  struct kexec_segment __user *segments)
-{
-	int ret;
-	size_t segment_bytes;
-
-	/* Read in the segments */
-	image->nr_segments = nr_segments;
-	segment_bytes = nr_segments * sizeof(*segments);
-	ret = copy_from_user(image->segment, segments, segment_bytes);
-	if (ret)
-		ret = -EFAULT;
-
-	return ret;
-}
-
 static int kimage_alloc_init(struct kimage **rimage, unsigned long entry,
 			     unsigned long nr_segments,
-			     struct kexec_segment __user *segments,
+			     struct kexec_segment *segments,
 			     unsigned long flags)
 {
 	int ret;
@@ -58,10 +41,8 @@ static int kimage_alloc_init(struct kima
 		return -ENOMEM;
 
 	image->start = entry;
-
-	ret = copy_user_segment_list(image, nr_segments, segments);
-	if (ret)
-		goto out_free_image;
+	image->nr_segments = nr_segments;
+	memcpy(image->segment, segments, nr_segments * sizeof(*segments));
 
 	if (kexec_on_panic) {
 		/* Enable special crash kernel control page alloc policy. */
@@ -104,7 +85,7 @@ out_free_image:
 }
 
 static int do_kexec_load(unsigned long entry, unsigned long nr_segments,
-		struct kexec_segment __user *segments, unsigned long flags)
+		struct kexec_segment *segments, unsigned long flags)
 {
 	struct kimage **dest_image, *image;
 	unsigned long i;
@@ -250,7 +231,8 @@ static inline int kexec_load_check(unsig
 SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
 		struct kexec_segment __user *, segments, unsigned long, flags)
 {
-	int result;
+	struct kexec_segment *ksegments;
+	unsigned long result;
 
 	result = kexec_load_check(nr_segments, flags);
 	if (result)
@@ -261,7 +243,12 @@ SYSCALL_DEFINE4(kexec_load, unsigned lon
 		((flags & KEXEC_ARCH_MASK) != KEXEC_ARCH_DEFAULT))
 		return -EINVAL;
 
-	result = do_kexec_load(entry, nr_segments, segments, flags);
+	ksegments = memdup_user(segments, nr_segments * sizeof(ksegments[0]));
+	if (IS_ERR(ksegments))
+		return PTR_ERR(ksegments);
+
+	result = do_kexec_load(entry, nr_segments, ksegments, flags);
+	kfree(ksegments);
 
 	return result;
 }
@@ -273,7 +260,7 @@ COMPAT_SYSCALL_DEFINE4(kexec_load, compa
 		       compat_ulong_t, flags)
 {
 	struct compat_kexec_segment in;
-	struct kexec_segment out, __user *ksegments;
+	struct kexec_segment *ksegments;
 	unsigned long i, result;
 
 	result = kexec_load_check(nr_segments, flags);
@@ -286,24 +273,26 @@ COMPAT_SYSCALL_DEFINE4(kexec_load, compa
 	if ((flags & KEXEC_ARCH_MASK) == KEXEC_ARCH_DEFAULT)
 		return -EINVAL;
 
-	ksegments = compat_alloc_user_space(nr_segments * sizeof(out));
+	ksegments = kmalloc_array(nr_segments, sizeof(ksegments[0]),
+			GFP_KERNEL);
+	if (!ksegments)
+		return -ENOMEM;
+
 	for (i = 0; i < nr_segments; i++) {
 		result = copy_from_user(&in, &segments[i], sizeof(in));
 		if (result)
-			return -EFAULT;
+			goto fail;
 
-		out.buf   = compat_ptr(in.buf);
-		out.bufsz = in.bufsz;
-		out.mem   = in.mem;
-		out.memsz = in.memsz;
-
-		result = copy_to_user(&ksegments[i], &out, sizeof(out));
-		if (result)
-			return -EFAULT;
+		ksegments[i].buf   = compat_ptr(in.buf);
+		ksegments[i].bufsz = in.bufsz;
+		ksegments[i].mem   = in.mem;
+		ksegments[i].memsz = in.memsz;
 	}
 
 	result = do_kexec_load(entry, nr_segments, ksegments, flags);
 
+fail:
+	kfree(ksegments);
 	return result;
 }
 #endif
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-move-locking-into-do_kexec_load.patch
kexec-avoid-compat_alloc_user_space.patch
mm-simplify-compat_sys_move_pages.patch
mm-simplify-compat-numa-syscalls.patch
compat-remove-some-compat-entry-points.patch
arch-remove-compat_alloc_user_space.patch

