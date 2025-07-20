Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A115DC120
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752977346; cv=none; b=Krjt19vZEXzrA5bImrm5UEdpx37KapOQr91UsM+18QxhyfSZB2o2XV8/YSlHpvyKp4j2asGGOke6+IXOrBKUZTdFmTH29PKUHCJnCTby64COm7zY/OURvZWXVFinVkuRjxFB3ZnC2Rx82dSgQGE1JobNgD0DzOsYbnVOmhlsnFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752977346; c=relaxed/simple;
	bh=kuYpV0yaP7mOfxjldNLMTfr4zAkVh83SX8lmb7vSlbE=;
	h=Date:To:From:Subject:Message-Id; b=EWfwpB4l8sus8UwZ9MdqBBJeMKk3oqPzCfPvCoy18l9N98wyn4a9jnp8ajk0cl0+SoA9MyP3JVyQL9BPNCaAljYPrk2rz1FSw3Y3thAGS4Zkmx85YhJrfrLUVgBxSVzf5nspFddCaYC3UppPtmj0XeZET+aTe1+YPCiwKXObt3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RNlk99Xy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RNlk99Xy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157A7C4CEE3;
	Sun, 20 Jul 2025 02:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752977346;
	bh=kuYpV0yaP7mOfxjldNLMTfr4zAkVh83SX8lmb7vSlbE=;
	h=Date:To:From:Subject:From;
	b=RNlk99XyUOsQ44UZyAMHgWqc4EjoZ8tQRMNJ4NDs1xdm7cbpwTXwvGL4yW4l9O0+3
	 I19gU0RwoM6Lb4sLbCKcbyvvqXnaI8wst3rgqst9Rc0b2TlxbsJAgU2USpyWknYDNw
	 UZb6lkde4n8MoTqCEDukgMApJ/YoQ6vbpSPRF0pw=
Date: Sat, 19 Jul 2025 19:09:05 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,prudo@redhat.com,piliu@redhat.com,mhocko@suse.cz,ltao@redhat.com,dyoung@redhat.com,ddutile@redhat.com,david@redhat.com,bhe@redhat.com,jbohac@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kdump-implement-reserve_crashkernel_cma.patch removed from -mm tree
Message-Id: <20250720020906.157A7C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kdump: implement reserve_crashkernel_cma
has been removed from the -mm tree.  Its filename was
     kdump-implement-reserve_crashkernel_cma.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiri Bohac <jbohac@suse.cz>
Subject: kdump: implement reserve_crashkernel_cma
Date: Thu, 12 Jun 2025 12:16:39 +0200

reserve_crashkernel_cma() reserves CMA ranges for the crash kernel.  If
allocating the requested size fails, try to reserve in smaller blocks.

Store the reserved ranges in the crashk_cma_ranges array and the number of
ranges in crashk_cma_cnt.

Link: https://lkml.kernel.org/r/aEqpBwOy_ekm0gw9@dwarf.suse.cz
Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Donald Dutile <ddutile@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Philipp Rudo <prudo@redhat.com>
Cc: Pingfan Liu <piliu@redhat.com>
Cc: Tao Liu <ltao@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/crash_reserve.h |   12 +++++++
 kernel/crash_reserve.c        |   52 ++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

--- a/include/linux/crash_reserve.h~kdump-implement-reserve_crashkernel_cma
+++ a/include/linux/crash_reserve.h
@@ -13,12 +13,24 @@
  */
 extern struct resource crashk_res;
 extern struct resource crashk_low_res;
+extern struct range crashk_cma_ranges[];
+#if defined(CONFIG_CMA) && defined(CONFIG_ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION)
+#define CRASHKERNEL_CMA
+#define CRASHKERNEL_CMA_RANGES_MAX 4
+extern int crashk_cma_cnt;
+#else
+#define crashk_cma_cnt 0
+#define CRASHKERNEL_CMA_RANGES_MAX 0
+#endif
+
 
 int __init parse_crashkernel(char *cmdline, unsigned long long system_ram,
 		unsigned long long *crash_size, unsigned long long *crash_base,
 		unsigned long long *low_size, unsigned long long *cma_size,
 		bool *high);
 
+void __init reserve_crashkernel_cma(unsigned long long cma_size);
+
 #ifdef CONFIG_ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
 #ifndef DEFAULT_CRASH_KERNEL_LOW_SIZE
 #define DEFAULT_CRASH_KERNEL_LOW_SIZE	(128UL << 20)
--- a/kernel/crash_reserve.c~kdump-implement-reserve_crashkernel_cma
+++ a/kernel/crash_reserve.c
@@ -14,6 +14,8 @@
 #include <linux/cpuhotplug.h>
 #include <linux/memblock.h>
 #include <linux/kmemleak.h>
+#include <linux/cma.h>
+#include <linux/crash_reserve.h>
 
 #include <asm/page.h>
 #include <asm/sections.h>
@@ -469,6 +471,56 @@ retry:
 #endif
 }
 
+struct range crashk_cma_ranges[CRASHKERNEL_CMA_RANGES_MAX];
+#ifdef CRASHKERNEL_CMA
+int crashk_cma_cnt;
+void __init reserve_crashkernel_cma(unsigned long long cma_size)
+{
+	unsigned long long request_size = roundup(cma_size, PAGE_SIZE);
+	unsigned long long reserved_size = 0;
+
+	if (!cma_size)
+		return;
+
+	while (cma_size > reserved_size &&
+	       crashk_cma_cnt < CRASHKERNEL_CMA_RANGES_MAX) {
+
+		struct cma *res;
+
+		if (cma_declare_contiguous(0, request_size, 0, 0, 0, false,
+				       "crashkernel", &res)) {
+			/* reservation failed, try half-sized blocks */
+			if (request_size <= PAGE_SIZE)
+				break;
+
+			request_size = roundup(request_size / 2, PAGE_SIZE);
+			continue;
+		}
+
+		crashk_cma_ranges[crashk_cma_cnt].start = cma_get_base(res);
+		crashk_cma_ranges[crashk_cma_cnt].end =
+			crashk_cma_ranges[crashk_cma_cnt].start +
+			cma_get_size(res) - 1;
+		++crashk_cma_cnt;
+		reserved_size += request_size;
+	}
+
+	if (cma_size > reserved_size)
+		pr_warn("crashkernel CMA reservation failed: %lld MB requested, %lld MB reserved in %d ranges\n",
+			cma_size >> 20, reserved_size >> 20, crashk_cma_cnt);
+	else
+		pr_info("crashkernel CMA reserved: %lld MB in %d ranges\n",
+			reserved_size >> 20, crashk_cma_cnt);
+}
+
+#else /* CRASHKERNEL_CMA */
+void __init reserve_crashkernel_cma(unsigned long long cma_size)
+{
+	if (cma_size)
+		pr_warn("crashkernel CMA reservation not supported\n");
+}
+#endif
+
 #ifndef HAVE_ARCH_ADD_CRASH_RES_TO_IOMEM_EARLY
 static __init int insert_crashkernel_resources(void)
 {
_

Patches currently in -mm which might be from jbohac@suse.cz are


