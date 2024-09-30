Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECAD113F43A;
	Mon, 30 Sep 2024 15:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727711699; cv=none; b=A8ORl5XarFYbQ2+8ejHT5m5tkoEY2CP976NVS7qPCeYUOcUvx7o6FbbU2uqh+X3EMSffTZ0EdXCwJXvy3bpJdzgGB7dy4Rmc829Bw5lEISwjEy7ZMq0yfebDJVdDaaXwWaV0QqY29VEf+C2TcWUjVJJSTFzYKaCk+2sdZ4Amvvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727711699; c=relaxed/simple;
	bh=XC9hjTVJHIV+dp43jaSoxZZ1QtVfhBf+eCq64TvF24U=;
	h=Date:To:From:Subject:Message-Id; b=kUdgeB1+qskjlK3Uu1HUe1x8Hvx2VfFzbiP8QIMbAAUg0EzGwBLwUGmHoiQQeZEA55xIugqVpFND4L7DQk2sc3gW/bwyGLILoMlmsA3o6zSqttUNRIW11c4PjH+7XXnZBborOPve+f7RAKBBGL7nvT+u34QyG6W7XyDCuhI2z+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F/Js1UnQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F/Js1UnQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CABC4CEC7;
	Mon, 30 Sep 2024 15:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727711697;
	bh=XC9hjTVJHIV+dp43jaSoxZZ1QtVfhBf+eCq64TvF24U=;
	h=Date:To:From:Subject:From;
	b=F/Js1UnQbk2sZTgZmxS8ibAwRlgG3AAV/5ptAwR8HUKdedz+iS4aomoZthHpm4/8d
	 OpTQ6IorLnlainFmIdRNLEdqQyYonZDFlW1DOCsvnXQI6maGdOcw0QRfqaeRBbnmqu
	 qA/b7EpdGAtPRmlIeYxlwI2EnOxU7jWCTr/JLCjA=
Date: Mon, 30 Sep 2024 08:54:56 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,hca@linux.ibm.com,gor@linux.ibm.com,agordeev@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-kcorec-allow-translation-of-physical-memory-addresses.patch added to mm-hotfixes-unstable branch
Message-Id: <20240930155457.68CABC4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/kcore.c: allow translation of physical memory addresses
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-proc-kcorec-allow-translation-of-physical-memory-addresses.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-kcorec-allow-translation-of-physical-memory-addresses.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: fs/proc/kcore.c: allow translation of physical memory addresses
Date: Mon, 30 Sep 2024 14:21:19 +0200

When /proc/kcore is read an attempt to read the first two pages results in
HW-specific page swap on s390 and another (so called prefix) pages are
accessed instead.  That leads to a wrong read.

Allow architecture-specific translation of memory addresses using
kc_xlate_dev_mem_ptr() and kc_unxlate_dev_mem_ptr() callbacks similarily
to /dev/mem xlate_dev_mem_ptr() and unxlate_dev_mem_ptr() callbacks.  That
way an architecture can deal with specific physical memory ranges.

Re-use the existing /dev/mem callback implementation on s390, which
handles the described prefix pages swapping correctly.

For other architectures the default callback is basically NOP.  It is
expected the condition (vaddr == __va(__pa(vaddr))) always holds true for
KCORE_RAM memory type.

Link: https://lkml.kernel.org/r/20240930122119.1651546-1-agordeev@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/io.h |    2 +
 fs/proc/kcore.c            |   36 +++++++++++++++++++++++++++++++++--
 2 files changed, 36 insertions(+), 2 deletions(-)

--- a/arch/s390/include/asm/io.h~fs-proc-kcorec-allow-translation-of-physical-memory-addresses
+++ a/arch/s390/include/asm/io.h
@@ -16,8 +16,10 @@
 #include <asm/pci_io.h>
 
 #define xlate_dev_mem_ptr xlate_dev_mem_ptr
+#define kc_xlate_dev_mem_ptr xlate_dev_mem_ptr
 void *xlate_dev_mem_ptr(phys_addr_t phys);
 #define unxlate_dev_mem_ptr unxlate_dev_mem_ptr
+#define kc_unxlate_dev_mem_ptr unxlate_dev_mem_ptr
 void unxlate_dev_mem_ptr(phys_addr_t phys, void *addr);
 
 #define IO_SPACE_LIMIT 0
--- a/fs/proc/kcore.c~fs-proc-kcorec-allow-translation-of-physical-memory-addresses
+++ a/fs/proc/kcore.c
@@ -50,6 +50,20 @@ static struct proc_dir_entry *proc_root_
 #define	kc_offset_to_vaddr(o) ((o) + PAGE_OFFSET)
 #endif
 
+#ifndef kc_xlate_dev_mem_ptr
+#define kc_xlate_dev_mem_ptr kc_xlate_dev_mem_ptr
+static inline void *kc_xlate_dev_mem_ptr(phys_addr_t phys)
+{
+	return __va(phys);
+}
+#endif
+#ifndef kc_unxlate_dev_mem_ptr
+#define kc_unxlate_dev_mem_ptr kc_unxlate_dev_mem_ptr
+static inline void kc_unxlate_dev_mem_ptr(phys_addr_t phys, void *virt)
+{
+}
+#endif
+
 static LIST_HEAD(kclist_head);
 static DECLARE_RWSEM(kclist_lock);
 static int kcore_need_update = 1;
@@ -471,6 +485,8 @@ static ssize_t read_kcore_iter(struct ki
 	while (buflen) {
 		struct page *page;
 		unsigned long pfn;
+		phys_addr_t phys;
+		void *__start;
 
 		/*
 		 * If this is the first iteration or the address is not within
@@ -537,7 +553,8 @@ static ssize_t read_kcore_iter(struct ki
 			}
 			break;
 		case KCORE_RAM:
-			pfn = __pa(start) >> PAGE_SHIFT;
+			phys = __pa(start);
+			pfn =  phys >> PAGE_SHIFT;
 			page = pfn_to_online_page(pfn);
 
 			/*
@@ -557,13 +574,28 @@ static ssize_t read_kcore_iter(struct ki
 			fallthrough;
 		case KCORE_VMEMMAP:
 		case KCORE_TEXT:
+			if (m->type == KCORE_RAM) {
+				__start = kc_xlate_dev_mem_ptr(phys);
+				if (!__start) {
+					ret = -ENOMEM;
+					if (iov_iter_zero(tsz, iter) != tsz)
+						ret = -EFAULT;
+					goto out;
+				}
+			} else {
+				__start = (void *)start;
+			}
+
 			/*
 			 * Sadly we must use a bounce buffer here to be able to
 			 * make use of copy_from_kernel_nofault(), as these
 			 * memory regions might not always be mapped on all
 			 * architectures.
 			 */
-			if (copy_from_kernel_nofault(buf, (void *)start, tsz)) {
+			ret = copy_from_kernel_nofault(buf, __start, tsz);
+			if (m->type == KCORE_RAM)
+				kc_unxlate_dev_mem_ptr(phys, __start);
+			if (ret) {
 				if (iov_iter_zero(tsz, iter) != tsz) {
 					ret = -EFAULT;
 					goto out;
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are

fs-proc-kcorec-allow-translation-of-physical-memory-addresses.patch

