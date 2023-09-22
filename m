Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98686CD4846
	for <mm-commits@archiver.kernel.org>; Fri, 22 Sep 2023 17:42:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbjIVRm7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Sep 2023 13:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232971AbjIVRm4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Sep 2023 13:42:56 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26B799
        for <mm-commits@vger.kernel.org>; Fri, 22 Sep 2023 10:42:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2696AC433C7;
        Fri, 22 Sep 2023 17:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695404568;
        bh=RHHwXy8Nf1YQW2EJu/3Kl5jc+qsl/YORwZqNNzdcSeU=;
        h=Date:To:From:Subject:From;
        b=RkMF1YNc1AyC2cvwFYkHHUs5HOLBxj+pliA3qAJrc0xeNdSsj4niYJNYv62C7akwP
         eix9JhaabDic8S55at05Sq9M2uqFVfd6KGT0HAyri1UB+un6CpijJu68OmA/E9DPhj
         htwx156dsbFY/RVnvqtj6NOKh1m1gXyTeBhqUs98=
Date:   Fri, 22 Sep 2023 10:42:47 -0700
To:     mm-commits@vger.kernel.org, vgoyal@redhat.com,
        sourabhjain@linux.ibm.com, konrad.wilk@oracle.com,
        ebiederm@xmission.com, dyoung@redhat.com,
        boris.ostrovsky@oracle.com, bhe@redhat.com,
        eric.devolder@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kexec-change-locking-mechanism-to-a-mutex.patch removed from -mm tree
Message-Id: <20230922174248.2696AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kexec: change locking mechanism to a mutex
has been removed from the -mm tree.  Its filename was
     kexec-change-locking-mechanism-to-a-mutex.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Eric DeVolder <eric.devolder@oracle.com>
Subject: kexec: change locking mechanism to a mutex
Date: Thu, 21 Sep 2023 17:59:38 -0400

Scaled up testing has revealed that the kexec_trylock() implementation
leads to failures within the crash hotplug infrastructure due to the
inability to acquire the lock, specifically the message:

 crash hp: kexec_trylock() failed, elfcorehdr may be inaccurate

When hotplug events occur, the crash hotplug infrastructure first attempts
to obtain the lock via the kexec_trylock().  However, the implementation
either acquires the lock, or fails and returns; there is no waiting on the
lock.  Here is the comment/explanation from
kernel/kexec_internal.h:kexec_trylock():

 * Whatever is used to serialize accesses to the kexec_crash_image needs to be
 * NMI safe, as __crash_kexec() can happen during nmi_panic(), so here we use a
 * "simple" atomic variable that is acquired with a cmpxchg().

While this in theory can happen for either CPU or memory hoptlug, this
problem is most prone to occur for memory hotplug.

When memory is hot plugged, the memory is converted into smaller 128MiB
memblocks (typically).  As each memblock is processed, a kernel thread and
a udev event thread are created.  The udev thread tries for the lock via
the reading of the sysfs node /sys/devices/system/memory/crash_hotplug
node, and the kernel worker thread tries for the lock upon entering the
crash hotplug infrastructure.

These threads then compete for the kexec lock.

For example, a 1GiB DIMM is converted into 8 memblocks, each spawning two
threads for a total of 16 threads that create a small "swarm" all trying
to acquire the lock.  The larger the DIMM, the more the memblocks and the
larger the swarm.

At the root of the problem is the atomic lock behind kexec_trylock(); it
works well for low lock traffic; ie loading/unloading a capture kernel,
things that happen basically once.  But with the introduction of crash
hotplug, the traffic through the lock increases significantly, and more
importantly in bursts occurring at roughly the same time.  Thus there is a
need to wait on the lock.

A possible workaround is to simply retry the lock, say up to N times. 
There is, of course, the problem of determining a value of N that works
for all implementations, and for all the other call sites of
kexec_trylock().  Not ideal.

The design decision to use the atomic lock is described in the comment
from kexec_internal.h, cited above.  However, examining the code of
__crash_kexec():

        if (kexec_trylock()) {
                if (kexec_crash_image) {
                        ...
                }
                kexec_unlock();
        }

reveals that the use of kexec_trylock() here is actually a "best effort"
due to the atomic lock.  This atomic lock, prior to crash hotplug, would
almost always be assured (another kexec syscall could hold the lock and
prevent this, but that is about it).

So at the point where the capture kernel would be invoked, if the lock is
not obtained, then kdump doesn't occur.

It is possible to instead use a mutex with proper waiting, and utilize
mutex_trylock() as the "best effort" in __crash_kexec().  The use of a
mutex then avoids all the lock acquisition problems that were revealed by
the crash hotplug activity.

Convert the atomic lock to a mutex.

Link: https://lkml.kernel.org/r/20230921215938.2192-1-eric.devolder@oracle.com
Signed-off-by: Eric DeVolder <eric.devolder@oracle.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c     |   10 ++--------
 kernel/kexec.c          |    3 +--
 kernel/kexec_core.c     |   13 +++++--------
 kernel/kexec_file.c     |    3 +--
 kernel/kexec_internal.h |   12 +++---------
 5 files changed, 12 insertions(+), 29 deletions(-)

--- a/kernel/crash_core.c~kexec-change-locking-mechanism-to-a-mutex
+++ a/kernel/crash_core.c
@@ -749,10 +749,7 @@ int crash_check_update_elfcorehdr(void)
 	int rc = 0;
 
 	/* Obtain lock while reading crash information */
-	if (!kexec_trylock()) {
-		pr_info("kexec_trylock() failed, elfcorehdr may be inaccurate\n");
-		return 0;
-	}
+	kexec_lock();
 	if (kexec_crash_image) {
 		if (kexec_crash_image->file_mode)
 			rc = 1;
@@ -784,10 +781,7 @@ static void crash_handle_hotplug_event(u
 	struct kimage *image;
 
 	/* Obtain lock while changing crash information */
-	if (!kexec_trylock()) {
-		pr_info("kexec_trylock() failed, elfcorehdr may be inaccurate\n");
-		return;
-	}
+	kexec_lock();
 
 	/* Check kdump is not loaded */
 	if (!kexec_crash_image)
--- a/kernel/kexec.c~kexec-change-locking-mechanism-to-a-mutex
+++ a/kernel/kexec.c
@@ -96,8 +96,7 @@ static int do_kexec_load(unsigned long e
 	 * crash kernels we need a serialization here to prevent multiple crash
 	 * kernels from attempting to load simultaneously.
 	 */
-	if (!kexec_trylock())
-		return -EBUSY;
+	kexec_lock();
 
 	if (flags & KEXEC_ON_CRASH) {
 		dest_image = &kexec_crash_image;
--- a/kernel/kexec_core.c~kexec-change-locking-mechanism-to-a-mutex
+++ a/kernel/kexec_core.c
@@ -47,7 +47,7 @@
 #include <crypto/hash.h>
 #include "kexec_internal.h"
 
-atomic_t __kexec_lock = ATOMIC_INIT(0);
+DEFINE_MUTEX(__kexec_lock);
 
 /* Flag to indicate we are going to kexec a new kernel */
 bool kexec_in_progress = false;
@@ -1057,7 +1057,7 @@ void __noclone __crash_kexec(struct pt_r
 	 * of memory the xchg(&kexec_crash_image) would be
 	 * sufficient.  But since I reuse the memory...
 	 */
-	if (kexec_trylock()) {
+	if (mutex_trylock(&__kexec_lock)) {
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
 
@@ -1103,8 +1103,7 @@ ssize_t crash_get_memory_size(void)
 {
 	ssize_t size = 0;
 
-	if (!kexec_trylock())
-		return -EBUSY;
+	kexec_lock();
 
 	size += crash_resource_size(&crashk_res);
 	size += crash_resource_size(&crashk_low_res);
@@ -1146,8 +1145,7 @@ int crash_shrink_memory(unsigned long ne
 	int ret = 0;
 	unsigned long old_size, low_size;
 
-	if (!kexec_trylock())
-		return -EBUSY;
+	kexec_lock();
 
 	if (kexec_crash_image) {
 		ret = -ENOENT;
@@ -1229,8 +1227,7 @@ int kernel_kexec(void)
 {
 	int error = 0;
 
-	if (!kexec_trylock())
-		return -EBUSY;
+	kexec_lock();
 	if (!kexec_image) {
 		error = -EINVAL;
 		goto Unlock;
--- a/kernel/kexec_file.c~kexec-change-locking-mechanism-to-a-mutex
+++ a/kernel/kexec_file.c
@@ -341,8 +341,7 @@ SYSCALL_DEFINE5(kexec_file_load, int, ke
 
 	image = NULL;
 
-	if (!kexec_trylock())
-		return -EBUSY;
+	kexec_lock();
 
 	if (image_type == KEXEC_TYPE_CRASH) {
 		dest_image = &kexec_crash_image;
--- a/kernel/kexec_internal.h~kexec-change-locking-mechanism-to-a-mutex
+++ a/kernel/kexec_internal.h
@@ -18,15 +18,9 @@ int kimage_is_destination_range(struct k
  * NMI safe, as __crash_kexec() can happen during nmi_panic(), so here we use a
  * "simple" atomic variable that is acquired with a cmpxchg().
  */
-extern atomic_t __kexec_lock;
-static inline bool kexec_trylock(void)
-{
-	return atomic_cmpxchg_acquire(&__kexec_lock, 0, 1) == 0;
-}
-static inline void kexec_unlock(void)
-{
-	atomic_set_release(&__kexec_lock, 0);
-}
+extern struct mutex __kexec_lock;
+#define kexec_lock() mutex_lock(&__kexec_lock)
+#define kexec_unlock() mutex_unlock(&__kexec_lock)
 
 #ifdef CONFIG_KEXEC_FILE
 #include <linux/purgatory.h>
_

Patches currently in -mm which might be from eric.devolder@oracle.com are


