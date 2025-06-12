Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D262DECCC
	for <mm-commits@vger.kernel.org>; Thu, 12 Jun 2025 23:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749771842; cv=none; b=effrmf+r9ceC4ifK4yGgKpLmGPc+Q4vvqWFRjSxOWi/Q9ceGSpIp4QO5Vo6bbLogYQe8oMUNNbfkgqA5DRgXM3XHXdnGu+MMxqXcPNn8vh5r8bd2oZU7sUeTeaju/rKWGj7PaG/5AMLfNrcGV+ZVHK2OiW5PPfvGfCl9l5TkhNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749771842; c=relaxed/simple;
	bh=y3bqAsQcKFz6YkZUH43hWjsymPqHlfto4cL90yTs97M=;
	h=Date:To:From:Subject:Message-Id; b=JCgIaUbnCOx4i76BRi3xF9UHS/ou3YRY70iMWQGV3EoH9phS1Q/1MmRWEMBWMi3tGi2588ISvptGI9MFJcp+Q/kpYEH2qRoT7mUmfvy2by0lB1UBmmbOrlNPaAU4SE0mNmJARbO1rOuCLvstPzopfPXUPY8ioiVYPMnlu0tQk30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bs9aSWuz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bs9aSWuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6003FC4CEEA;
	Thu, 12 Jun 2025 23:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749771842;
	bh=y3bqAsQcKFz6YkZUH43hWjsymPqHlfto4cL90yTs97M=;
	h=Date:To:From:Subject:From;
	b=Bs9aSWuzarSbpZBeDUhpBY4ycPhBvgdx3pl5iEIqE/wkDWl1ijtO1BHAqEenxONam
	 OpENWbvDiIwKNX5uzOHdS8U6BFSWWVDcsIG9EX2FqfyD3P46Y7e3GJssK5T2+aDqjn
	 pOJ3wOY57cMauo5CWneB1nIMyV3lxw4c1qBlES3c=
Date: Thu, 12 Jun 2025 16:44:01 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,prudo@redhat.com,piliu@redhat.com,mhocko@suse.cz,ltao@redhat.com,dyoung@redhat.com,ddutile@redhat.com,david@redhat.com,bhe@redhat.com,jbohac@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kdump-implement-reserve_crashkernel_cma.patch added to mm-nonmm-unstable branch
Message-Id: <20250612234402.6003FC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kdump: implement reserve_crashkernel_cma
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kdump-implement-reserve_crashkernel_cma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kdump-implement-reserve_crashkernel_cma.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

add-a-new-optional-cma-suffix-to-the-crashkernel=-command-line-option.patch
kdump-implement-reserve_crashkernel_cma.patch
kdump-documentation-describe-craskernel-cma-reservation.patch
kdump-wait-for-dma-to-finish-when-using-cma.patch
x86-implement-crashkernel-cma-reservation.patch

