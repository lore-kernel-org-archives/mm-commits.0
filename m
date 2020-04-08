From: akpm@linux-foundation.org
Subject: [merged]
 bitops-always-inline-sign-extension-helpers.patch removed from -mm tree
Date: Tue, 07 Apr 2020 19:00:40 -0700
Message-ID: <20200408020040.l4scNkKTL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726464AbgDHCAl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:00:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chris-wilson.co.uk, jpoimboe@redhat.com, mm-commits@vger.kernel.org, peterz@infradead.org, rdunlap@infradead.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: bitops: always inline sign extension helpers
has been removed from the -mm tree.  Its filename was
     bitops-always-inline-sign-extension-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: bitops: always inline sign extension helpers

With CONFIG_CC_OPTIMIZE_FOR_SIZE, objtool reports:

  drivers/gpu/drm/i915/gem/i915_gem_execbuffer.o: warning: objtool: i915_gem_execbuffer2_ioctl()+0x5b7: call to gen8_canonical_addr() with UACCESS enabled

This means i915_gem_execbuffer2_ioctl() is calling gen8_canonical_addr()
from the user_access_begin/end critical region (i.e, with SMAP disabled).

While it's probably harmless in this case, in general we like to avoid
extra function calls in SMAP-disabled regions because it can open up
inadvertent security holes.

Fix the warning by changing the sign extension helpers to __always_inline.
This convinces GCC to inline gen8_canonical_addr().

The sign extension functions are trivial anyway, so it makes sense to
always inline them.  With my test optimize-for-size-based config, this
actually shrinks the text size of i915_gem_execbuffer.o by 45 bytes -- and
no change for vmlinux.

Link: http://lkml.kernel.org/r/740179324b2b18b750b16295c48357f00b5fa9ed.1582982020.git.jpoimboe@redhat.com
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitops.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/bitops.h~bitops-always-inline-sign-extension-helpers
+++ a/include/linux/bitops.h
@@ -162,7 +162,7 @@ static inline __u8 ror8(__u8 word, unsig
  *
  * This is safe to use for 16- and 8-bit types as well.
  */
-static inline __s32 sign_extend32(__u32 value, int index)
+static __always_inline __s32 sign_extend32(__u32 value, int index)
 {
 	__u8 shift = 31 - index;
 	return (__s32)(value << shift) >> shift;
@@ -173,7 +173,7 @@ static inline __s32 sign_extend32(__u32
  * @value: value to sign extend
  * @index: 0 based bit index (0<=index<64) to sign bit
  */
-static inline __s64 sign_extend64(__u64 value, int index)
+static __always_inline __s64 sign_extend64(__u64 value, int index)
 {
 	__u8 shift = 63 - index;
 	return (__s64)(value << shift) >> shift;
_

Patches currently in -mm which might be from jpoimboe@redhat.com are
