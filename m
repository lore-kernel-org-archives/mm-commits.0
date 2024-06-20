Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944D94685
	for <mm-commits@vger.kernel.org>; Thu, 20 Jun 2024 00:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718845109; cv=none; b=K3gOvEjpWhDtsmXvdo67mFIVZj/tOx5YVn8pn/fnf6oQolx0UwtEs1Z1mVs++7vwXYlvo+4OxtCDxaVNXjlJMQMw6yqJMBEmmSTofEy0MszzMDtNVsguIddGQAkiD3A9HEmg5Y6tqKgHQwFD694krMbJKetrT7072JseHR15InI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718845109; c=relaxed/simple;
	bh=T7/gOSN7KrfuH99gevkCt+xBzl+wHWvIc4UriV7wYwg=;
	h=Date:To:From:Subject:Message-Id; b=fYPKq0QD39iUdwLjXsK2Vs9AzrbmWFrnNte3M9zqxZA39w8+tW/HdPSAGrH6zU7tm2xif2iTNBlKEb8HuXYzsN2F67vUSdYwAXXvEIVGY44chT0rCIzka1ZAYZG+mjOCy0+oadKoScRy8bNS+MlKRabyerGS82DvND78I7gV3+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ENf0YHCr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ENf0YHCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615A6C2BBFC;
	Thu, 20 Jun 2024 00:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718845109;
	bh=T7/gOSN7KrfuH99gevkCt+xBzl+wHWvIc4UriV7wYwg=;
	h=Date:To:From:Subject:From;
	b=ENf0YHCrmPOucQHJEq4pI+2G8BKm6SN+HfZmKpndVxZ5vb9Ar748JkcgPK0qwT414
	 8k0U7j52LJ0AMMYQHvhRzopHgJe9AlAWStVSB1yGS/5PB8jV0xPNdIVDT0dVWC9Frm
	 QiFc4eTGio/Soc7lPR1ebvcScjPYErwfghjSKVYE=
Date: Wed, 19 Jun 2024 17:58:28 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-expose-kmsan_get_metadata.patch added to mm-unstable branch
Message-Id: <20240620005829.615A6C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kmsan: expose kmsan_get_metadata()
has been added to the -mm mm-unstable branch.  Its filename is
     kmsan-expose-kmsan_get_metadata.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-expose-kmsan_get_metadata.patch

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
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: kmsan: expose kmsan_get_metadata()
Date: Wed, 19 Jun 2024 17:43:44 +0200

Each s390 CPU has lowcore pages associated with it.  Each CPU sees its own
lowcore at virtual address 0 through a hardware mechanism called
prefixing.  Additionally, all lowcores are mapped to non-0 virtual
addresses stored in the lowcore_ptr[] array.

When lowcore is accessed through virtual address 0, one needs to resolve
metadata for lowcore_ptr[raw_smp_processor_id()].

Expose kmsan_get_metadata() to make it possible to do this from the arch
code.

Link: https://lkml.kernel.org/r/20240619154530.163232-10-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <kasan-dev@googlegroups.com>
Cc: Marco Elver <elver@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmsan.h      |    9 +++++++++
 mm/kmsan/instrumentation.c |    1 +
 mm/kmsan/kmsan.h           |    1 -
 3 files changed, 10 insertions(+), 1 deletion(-)

--- a/include/linux/kmsan.h~kmsan-expose-kmsan_get_metadata
+++ a/include/linux/kmsan.h
@@ -230,6 +230,15 @@ void kmsan_handle_urb(const struct urb *
  */
 void kmsan_unpoison_entry_regs(const struct pt_regs *regs);
 
+/**
+ * kmsan_get_metadata() - Return a pointer to KMSAN shadow or origins.
+ * @addr:      kernel address.
+ * @is_origin: whether to return origins or shadow.
+ *
+ * Return NULL if metadata cannot be found.
+ */
+void *kmsan_get_metadata(void *addr, bool is_origin);
+
 #else
 
 static inline void kmsan_init_shadow(void)
--- a/mm/kmsan/instrumentation.c~kmsan-expose-kmsan_get_metadata
+++ a/mm/kmsan/instrumentation.c
@@ -14,6 +14,7 @@
 
 #include "kmsan.h"
 #include <linux/gfp.h>
+#include <linux/kmsan.h>
 #include <linux/kmsan_string.h>
 #include <linux/mm.h>
 #include <linux/uaccess.h>
--- a/mm/kmsan/kmsan.h~kmsan-expose-kmsan_get_metadata
+++ a/mm/kmsan/kmsan.h
@@ -66,7 +66,6 @@ struct shadow_origin_ptr {
 
 struct shadow_origin_ptr kmsan_get_shadow_origin_ptr(void *addr, u64 size,
 						     bool store);
-void *kmsan_get_metadata(void *addr, bool is_origin);
 void __init kmsan_init_alloc_meta_for_range(void *start, void *end);
 
 enum kmsan_bug_reason {
_

Patches currently in -mm which might be from iii@linux.ibm.com are

ftrace-unpoison-ftrace_regs-in-ftrace_ops_list_func.patch
kmsan-make-the-tests-compatible-with-kmsanpanic=1.patch
kmsan-disable-kmsan-when-deferred_struct_page_init-is-enabled.patch
kmsan-increase-the-maximum-store-size-to-4096.patch
kmsan-fix-is_bad_asm_addr-on-arches-with-overlapping-address-spaces.patch
kmsan-fix-kmsan_copy_to_user-on-arches-with-overlapping-address-spaces.patch
kmsan-remove-a-useless-assignment-from-kmsan_vmap_pages_range_noflush.patch
kmsan-remove-an-x86-specific-include-from-kmsanh.patch
kmsan-expose-kmsan_get_metadata.patch
kmsan-export-panic_on_kmsan.patch
kmsan-allow-disabling-kmsan-checks-for-the-current-task.patch
kmsan-introduce-memset_no_sanitize_memory.patch
kmsan-support-slab_poison.patch
kmsan-use-align_down-in-kmsan_get_metadata.patch
kmsan-do-not-round-up-pg_data_t-size.patch
mm-slub-let-kmsan-access-metadata.patch
mm-slub-disable-kmsan-when-checking-the-padding-bytes.patch
mm-kfence-disable-kmsan-when-checking-the-canary.patch
lib-zlib-unpoison-dfltcc-output-buffers.patch
kmsan-accept-ranges-starting-with-0-on-s390.patch
s390-boot-turn-off-kmsan.patch
s390-use-a-larger-stack-for-kmsan.patch
s390-boot-add-the-kmsan-runtime-stub.patch
s390-checksum-add-a-kmsan-check.patch
s390-cpacf-unpoison-the-results-of-cpacf_trng.patch
s390-cpumf-unpoison-stcctm-output-buffer.patch
s390-diag-unpoison-diag224-output-buffer.patch
s390-ftrace-unpoison-ftrace_regs-in-kprobe_ftrace_handler.patch
s390-irqflags-do-not-instrument-arch_local_irq_-with-kmsan.patch
s390-mm-define-kmsan-metadata-for-vmalloc-and-modules.patch
s390-string-add-kmsan-support.patch
s390-traps-unpoison-the-kernel_stack_overflows-pt_regs.patch
s390-uaccess-add-kmsan-support-to-put_user-and-get_user.patch
s390-uaccess-add-the-missing-linux-instrumentedh-include.patch
s390-unwind-disable-kmsan-checks.patch
s390-kmsan-implement-the-architecture-specific-functions.patch
kmsan-enable-on-s390.patch

