Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F852F3657
	for <mm-commits@vger.kernel.org>; Wed, 25 Jun 2025 22:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750892157; cv=none; b=Ztiis6oCSvPit/+eN+H4Qg2tTNPPPpRot7rjkvO49zouMgQuRmcQOl/lUotb9iJYrhko0BVzvrvHHAdbuDN6zlZwsEi5ElbTCnwcsRZH1C2ymfIVa5QQZYC7/gOliapeuJBEwBkdZCYBFHktGzov1fDUsqdg0ORhRj31CspujdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750892157; c=relaxed/simple;
	bh=TzlKNnRpIlTds0dRuUocGZlJdVWtkMhMzi3D5+W31LY=;
	h=Date:To:From:Subject:Message-Id; b=MeYUukyHECTd73KAgt3N4QGgjjYmeRBDfLzmAyCFdQVyrtRw79hD/ZgxSAm03R8xRKyA6lk08Idi36ihAOEsO4SbrCs53twqLZwARygxoYrMt9kruia9kbru9asmPhjW+rfmdJz/h3de0BFlwVkSV86TjgVp2tHnTtOwYurMhgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z8FerYHZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z8FerYHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2FBC4CEEA;
	Wed, 25 Jun 2025 22:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750892156;
	bh=TzlKNnRpIlTds0dRuUocGZlJdVWtkMhMzi3D5+W31LY=;
	h=Date:To:From:Subject:From;
	b=z8FerYHZIR8JSk6HsYP064t20UmBuNYt9sCj90eyUcA0XSI4O+yJX/3vM6x2RQWJd
	 nRyfoUJhqAzq/tJI+8xUybj+4gv9ufFlDgVTOeQWxsCqHNkyBm1epy/WUb3iTD/woE
	 NE4pWPW+JdJnyerlafe/MZT1Rh74aLfpyFxjOKj0=
Date: Wed, 25 Jun 2025 15:55:56 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,catalin.marinas@arm.com,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-alloc_tag-fix-the-kmemleak-false-positive-issue-in-the-allocation-of-the-percpu-variable-tag-counters.patch removed from -mm tree
Message-Id: <20250625225556.BB2FBC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/alloc_tag: fix the kmemleak false positive issue in the allocation of the percpu variable tag->counters
has been removed from the -mm tree.  Its filename was
     mm-alloc_tag-fix-the-kmemleak-false-positive-issue-in-the-allocation-of-the-percpu-variable-tag-counters.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hao Ge <gehao@kylinos.cn>
Subject: mm/alloc_tag: fix the kmemleak false positive issue in the allocation of the percpu variable tag->counters
Date: Fri, 20 Jun 2025 02:31:54 +0800

When loading a module, as long as the module has memory allocation
operations, kmemleak produces a false positive report that resembles the
following:

unreferenced object (percpu) 0x7dfd232a1650 (size 16):
  comm "modprobe", pid 1301, jiffies 4294940249
  hex dump (first 16 bytes on cpu 2):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 0):
    kmemleak_alloc_percpu+0xb4/0xd0
    pcpu_alloc_noprof+0x700/0x1098
    load_module+0xd4/0x348
    codetag_module_init+0x20c/0x450
    codetag_load_module+0x70/0xb8
    load_module+0xef8/0x1608
    init_module_from_file+0xec/0x158
    idempotent_init_module+0x354/0x608
    __arm64_sys_finit_module+0xbc/0x150
    invoke_syscall+0xd4/0x258
    el0_svc_common.constprop.0+0xb4/0x240
    do_el0_svc+0x48/0x68
    el0_svc+0x40/0xf8
    el0t_64_sync_handler+0x10c/0x138
    el0t_64_sync+0x1ac/0x1b0

This is because the module can only indirectly reference
alloc_tag_counters through the alloc_tag section, which misleads kmemleak.

However, we don't have a kmemleak ignore interface for percpu allocations
yet.  So let's create one and invoke it for tag->counters.

[gehao@kylinos.cn: fix build error when CONFIG_DEBUG_KMEMLEAK=n, s/igonore/ignore/]
  Link: https://lkml.kernel.org/r/20250620093102.2416767-1-hao.ge@linux.dev
Link: https://lkml.kernel.org/r/20250619183154.2122608-1-hao.ge@linux.dev
Fixes: 12ca42c23775 ("alloc_tag: allocate percpu counters for module tags dynamically")
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>	[lib/alloc_tag.c]
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmemleak.h |    4 ++++
 lib/alloc_tag.c          |    8 +++++++-
 mm/kmemleak.c            |   14 ++++++++++++++
 3 files changed, 25 insertions(+), 1 deletion(-)

--- a/include/linux/kmemleak.h~mm-alloc_tag-fix-the-kmemleak-false-positive-issue-in-the-allocation-of-the-percpu-variable-tag-counters
+++ a/include/linux/kmemleak.h
@@ -28,6 +28,7 @@ extern void kmemleak_update_trace(const
 extern void kmemleak_not_leak(const void *ptr) __ref;
 extern void kmemleak_transient_leak(const void *ptr) __ref;
 extern void kmemleak_ignore(const void *ptr) __ref;
+extern void kmemleak_ignore_percpu(const void __percpu *ptr) __ref;
 extern void kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp) __ref;
 extern void kmemleak_no_scan(const void *ptr) __ref;
 extern void kmemleak_alloc_phys(phys_addr_t phys, size_t size,
@@ -97,6 +98,9 @@ static inline void kmemleak_not_leak(con
 static inline void kmemleak_transient_leak(const void *ptr)
 {
 }
+static inline void kmemleak_ignore_percpu(const void __percpu *ptr)
+{
+}
 static inline void kmemleak_ignore(const void *ptr)
 {
 }
--- a/lib/alloc_tag.c~mm-alloc_tag-fix-the-kmemleak-false-positive-issue-in-the-allocation-of-the-percpu-variable-tag-counters
+++ a/lib/alloc_tag.c
@@ -10,6 +10,7 @@
 #include <linux/seq_buf.h>
 #include <linux/seq_file.h>
 #include <linux/vmalloc.h>
+#include <linux/kmemleak.h>
 
 #define ALLOCINFO_FILE_NAME		"allocinfo"
 #define MODULE_ALLOC_TAG_VMAP_SIZE	(100000UL * sizeof(struct alloc_tag))
@@ -632,8 +633,13 @@ static int load_module(struct module *mo
 			       mod->name);
 			return -ENOMEM;
 		}
-	}
 
+		/*
+		 * Avoid a kmemleak false positive. The pointer to the counters is stored
+		 * in the alloc_tag section of the module and cannot be directly accessed.
+		 */
+		kmemleak_ignore_percpu(tag->counters);
+	}
 	return 0;
 }
 
--- a/mm/kmemleak.c~mm-alloc_tag-fix-the-kmemleak-false-positive-issue-in-the-allocation-of-the-percpu-variable-tag-counters
+++ a/mm/kmemleak.c
@@ -1247,6 +1247,20 @@ void __ref kmemleak_transient_leak(const
 EXPORT_SYMBOL(kmemleak_transient_leak);
 
 /**
+ * kmemleak_ignore_percpu - similar to kmemleak_ignore but taking a percpu
+ *			    address argument
+ * @ptr:	percpu address of the object
+ */
+void __ref kmemleak_ignore_percpu(const void __percpu *ptr)
+{
+	pr_debug("%s(0x%px)\n", __func__, ptr);
+
+	if (kmemleak_enabled && ptr && !IS_ERR_PCPU(ptr))
+		make_black_object((unsigned long)ptr, OBJECT_PERCPU);
+}
+EXPORT_SYMBOL_GPL(kmemleak_ignore_percpu);
+
+/**
  * kmemleak_ignore - ignore an allocated object
  * @ptr:	pointer to beginning of the object
  *
_

Patches currently in -mm which might be from gehao@kylinos.cn are

mm-percpu-conditionally-define-_shared_alloc_tag-via-config_arch_module_needs_weak_per_cpu.patch

