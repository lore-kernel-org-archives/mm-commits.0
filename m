From: akpm@linux-foundation.org
Subject: +
 slub-improve-bit-diffusion-for-freelist-ptr-obfuscation.patch added to -mm
 tree
Date: Thu, 05 Mar 2020 19:27:14 -0800
Message-ID: <20200306032714.qBjTiILkH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbgCFD1Q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Mar 2020 22:27:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, iamjoonsoo.kim@lge.com, keescook@chromium.org, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, silvio.cesare@gmail.com, stable@vger.kernel.org


The patch titled
     Subject: slub: improve bit diffusion for freelist ptr obfuscation
has been added to the -mm tree.  Its filename is
     slub-improve-bit-diffusion-for-freelist-ptr-obfuscation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-improve-bit-diffusion-for-freelist-ptr-obfuscation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-improve-bit-diffusion-for-freelist-ptr-obfuscation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: slub: improve bit diffusion for freelist ptr obfuscation

Under CONFIG_SLAB_FREELIST_HARDENED=y, the obfuscation was relatively weak
in that the ptr and ptr address were usually so close that the first XOR
would result in an almost entirely 0-byte value[1], leaving most of the
"secret" number ultimately being stored after the third XOR.  A single
blind memory content exposure of the freelist was generally sufficient to
learn the secret.

Add a swab() call to mix bits a little more.  This is a cheap way (1
cycle) to make attacks need more than a single exposure to learn the
secret (or to know _where_ the exposure is in memory).

kmalloc-32 freelist walk, before:

ptr              ptr_addr            stored value      secret
ffff90c22e019020@ffff90c22e019000 is 86528eb656b3b5bd (86528eb656b3b59d)
ffff90c22e019040@ffff90c22e019020 is 86528eb656b3b5fd (86528eb656b3b59d)
ffff90c22e019060@ffff90c22e019040 is 86528eb656b3b5bd (86528eb656b3b59d)
ffff90c22e019080@ffff90c22e019060 is 86528eb656b3b57d (86528eb656b3b59d)
ffff90c22e0190a0@ffff90c22e019080 is 86528eb656b3b5bd (86528eb656b3b59d)
...

after:

ptr              ptr_addr            stored value      secret
ffff9eed6e019020@ffff9eed6e019000 is 793d1135d52cda42 (86528eb656b3b59d)
ffff9eed6e019040@ffff9eed6e019020 is 593d1135d52cda22 (86528eb656b3b59d)
ffff9eed6e019060@ffff9eed6e019040 is 393d1135d52cda02 (86528eb656b3b59d)
ffff9eed6e019080@ffff9eed6e019060 is 193d1135d52cdae2 (86528eb656b3b59d)
ffff9eed6e0190a0@ffff9eed6e019080 is f93d1135d52cdac2 (86528eb656b3b59d)

[1] https://blog.infosectcbr.com.au/2020/03/weaknesses-in-linux-kernel-heap.html

Link: http://lkml.kernel.org/r/202003051623.AF4F8CB@keescook
Fixes: 2482ddec670f ("mm: add SLUB free list pointer obfuscation")
Reported-by: Silvio Cesare <silvio.cesare@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c~slub-improve-bit-diffusion-for-freelist-ptr-obfuscation
+++ a/mm/slub.c
@@ -259,7 +259,7 @@ static inline void *freelist_ptr(const s
 	 * freepointer to be restored incorrectly.
 	 */
 	return (void *)((unsigned long)ptr ^ s->random ^
-			(unsigned long)kasan_reset_tag((void *)ptr_addr));
+			swab((unsigned long)kasan_reset_tag((void *)ptr_addr)));
 #else
 	return ptr;
 #endif
_

Patches currently in -mm which might be from keescook@chromium.org are

slub-improve-bit-diffusion-for-freelist-ptr-obfuscation.patch
slub-relocate-freelist-pointer-to-middle-of-object.patch
shmem-distribute-switch-variables-for-initialization.patch
lib-test_stackinitc-xfail-switch-variable-init-tests.patch
ubsan-add-trap-instrumentation-option.patch
ubsan-split-bounds-checker-from-other-options.patch
lkdtm-bugs-add-arithmetic-overflow-and-array-bounds-checks.patch
ubsan-check-panic_on_warn.patch
kasan-unset-panic_on_warn-before-calling-panic.patch
ubsan-include-bug-type-in-report-header.patch
