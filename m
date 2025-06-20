Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F31E7485
	for <mm-commits@vger.kernel.org>; Fri, 20 Jun 2025 00:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750380274; cv=none; b=M3Fqtbon4lSvdfYIy1syQio192blvVE3kfQxhOJy3e6BEL+QHdOdK33jF5Vc0l9h8cuTAhpq+X5VYpGHzZ5ubIEbQHyhGyEY/A6WCqiPOPfpchU1UJcOlvb8XnxoAcZIAdj95bWyIQVCCy4vZljOnKeB13oenzFXMHBFptnRQEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750380274; c=relaxed/simple;
	bh=XoPVsYlPjxZ89Xv2IFI29dYwdxHFn5u08VDR3BznzcI=;
	h=Date:To:From:Subject:Message-Id; b=sCs8glDDtbj6/ta4ZgjEEgH4Boayr504zrjHlMxBCmEvyVVX9Bf3wcRCiXevWvARJWjd1TV1kKTtmYbDTOJcsXh2C3TnDXx0vX2Nay/kHF8mwE6mMpyjDLzRo0p2Rce9b7l1GwE+uaqKuqal+QiSKHofTjbAOHYDcdZAjrofDNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VuQwuDup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VuQwuDup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0438DC4CEEA;
	Fri, 20 Jun 2025 00:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750380274;
	bh=XoPVsYlPjxZ89Xv2IFI29dYwdxHFn5u08VDR3BznzcI=;
	h=Date:To:From:Subject:From;
	b=VuQwuDupMP999GZR0qPC94BC3I8akA83Hr2PHIYkaO47PECmGh/F5FoncXwZDMmMH
	 BDiTLC7fzE7jfN6QqoDNa3vjNCxUf1Ce0R+Uv9GtFK5FOPlNtUO13jJUD7DA2HjyX1
	 m2NHlS593v4Vsbq6GjZNQsDnXCsjzlAHPSiXRG4s=
Date: Thu, 19 Jun 2025 17:44:33 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,catalin.marinas@arm.com,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-alloc_tag-fix-the-kmemleak-false-positive-issue-in-the-allocation-of-the-percpu-variable-tag-counters.patch added to mm-hotfixes-unstable branch
Message-Id: <20250620004434.0438DC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/alloc_tag: fix the kmemleak false positive issue in the allocation of the percpu variable tag->counters
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-alloc_tag-fix-the-kmemleak-false-positive-issue-in-the-allocation-of-the-percpu-variable-tag-counters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-alloc_tag-fix-the-kmemleak-false-positive-issue-in-the-allocation-of-the-percpu-variable-tag-counters.patch

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

Link: https://lkml.kernel.org/r/20250619183154.2122608-1-hao.ge@linux.dev
Fixes: 12ca42c23775 ("alloc_tag: allocate percpu counters for module tags dynamically")
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmemleak.h |    1 +
 lib/alloc_tag.c          |    8 +++++++-
 mm/kmemleak.c            |   14 ++++++++++++++
 3 files changed, 22 insertions(+), 1 deletion(-)

--- a/include/linux/kmemleak.h~mm-alloc_tag-fix-the-kmemleak-false-positive-issue-in-the-allocation-of-the-percpu-variable-tag-counters
+++ a/include/linux/kmemleak.h
@@ -28,6 +28,7 @@ extern void kmemleak_update_trace(const
 extern void kmemleak_not_leak(const void *ptr) __ref;
 extern void kmemleak_transient_leak(const void *ptr) __ref;
 extern void kmemleak_ignore(const void *ptr) __ref;
+extern void kmemleak_igonore_percpu(const void __percpu *ptr) __ref;
 extern void kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp) __ref;
 extern void kmemleak_no_scan(const void *ptr) __ref;
 extern void kmemleak_alloc_phys(phys_addr_t phys, size_t size,
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
+		kmemleak_igonore_percpu(tag->counters);
+	}
 	return 0;
 }
 
--- a/mm/kmemleak.c~mm-alloc_tag-fix-the-kmemleak-false-positive-issue-in-the-allocation-of-the-percpu-variable-tag-counters
+++ a/mm/kmemleak.c
@@ -1247,6 +1247,20 @@ void __ref kmemleak_transient_leak(const
 EXPORT_SYMBOL(kmemleak_transient_leak);
 
 /**
+ * kmemleak_ignore_phys - similar to kmemleak_ignore but taking a percpu
+ *			  address argument
+ * @ptr:	percpu address of the object
+ */
+void __ref kmemleak_igonore_percpu(const void __percpu *ptr)
+{
+	pr_debug("%s(0x%px)\n", __func__, ptr);
+
+	if (kmemleak_enabled && ptr && !IS_ERR_PCPU(ptr))
+		make_black_object((unsigned long)ptr, OBJECT_PERCPU);
+}
+EXPORT_SYMBOL_GPL(kmemleak_igonore_percpu);
+
+/**
  * kmemleak_ignore - ignore an allocated object
  * @ptr:	pointer to beginning of the object
  *
_

Patches currently in -mm which might be from gehao@kylinos.cn are

mm-alloc_tag-fix-the-kmemleak-false-positive-issue-in-the-allocation-of-the-percpu-variable-tag-counters.patch
mm-percpu-conditionally-define-_shared_alloc_tag-via-config_arch_module_needs_weak_per_cpu.patch

