From: akpm@linux-foundation.org
Subject: +
 mm-expand-config_slab_freelist_hardened-to-include-slab.patch added to -mm
 tree
Date: Thu, 25 Jun 2020 16:01:26 -0700
Message-ID: <20200625230126.K0hZZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728280AbgFYXB3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Jun 2020 19:01:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vjitta@codeaurora.org, vinmenon@codeaurora.org, vbabka@suse.cz, rientjes@google.com, penberg@kernel.org, mjg59@google.com, jannh@google.com, iamjoonsoo.kim@lge.com, guro@fb.com, cl@linux.com, alex.popov@linux.com, keescook@chromium.org


The patch titled
     Subject: mm/slab: expand CONFIG_SLAB_FREELIST_HARDENED to include SLAB
has been added to the -mm tree.  Its filename is
     mm-expand-config_slab_freelist_hardened-to-include-slab.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-expand-config_slab_freelist_hardened-to-include-slab.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-expand-config_slab_freelist_hardened-to-include-slab.patch

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
Subject: mm/slab: expand CONFIG_SLAB_FREELIST_HARDENED to include SLAB

Patch series "mm: Expand CONFIG_SLAB_FREELIST_HARDENED to include SLAB"

In reviewing Vlastimil Babka's latest slub debug series, I realized[1]
that several checks under CONFIG_SLAB_FREELIST_HARDENED weren't being
applied to SLAB.  Fix this by expanding the Kconfig coverage, and adding a
simple double-free test for SLAB.


This patch (of 2):

Include SLAB caches when performing kmem_cache pointer verification.  A
defense against such corruption[1] should be applied to all the
allocators.  With this added, the "SLAB_FREE_CROSS" and "SLAB_FREE_PAGE"
LKDTM tests now pass on SLAB:

  lkdtm: Performing direct entry SLAB_FREE_CROSS
  lkdtm: Attempting cross-cache slab free ...
  ------------[ cut here ]------------
  cache_from_obj: Wrong slab cache. lkdtm-heap-b but object is from lkdtm-heap-a
  WARNING: CPU: 2 PID: 2195 at mm/slab.h:530 kmem_cache_free+0x8d/0x1d0
  ...
  lkdtm: Performing direct entry SLAB_FREE_PAGE
  lkdtm: Attempting non-Slab slab free ...
  ------------[ cut here ]------------
  virt_to_cache: Object is not a Slab page!
  WARNING: CPU: 1 PID: 2202 at mm/slab.h:489 kmem_cache_free+0x196/0x1d0

Additionally clean up neighboring Kconfig entries for clarity,
readability, and redundant option removal.

[1] https://github.com/ThomasKing2014/slides/raw/master/Building%20universal%20Android%20rooting%20with%20a%20type%20confusion%20vulnerability.pdf

Link: http://lkml.kernel.org/r/20200625215548.389774-1-keescook@chromium.org
Link: http://lkml.kernel.org/r/20200625215548.389774-2-keescook@chromium.org
Fixes: 598a0717a816 ("mm/slab: validate cache membership under freelist hardening")
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Alexander Popov <alex.popov@linux.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Garrett <mjg59@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/init/Kconfig~mm-expand-config_slab_freelist_hardened-to-include-slab
+++ a/init/Kconfig
@@ -1885,9 +1885,8 @@ config SLAB_MERGE_DEFAULT
 	  command line.
 
 config SLAB_FREELIST_RANDOM
-	default n
+	bool "Randomize slab freelist"
 	depends on SLAB || SLUB
-	bool "SLAB freelist randomization"
 	help
 	  Randomizes the freelist order used on creating new pages. This
 	  security feature reduces the predictability of the kernel slab
@@ -1895,12 +1894,14 @@ config SLAB_FREELIST_RANDOM
 
 config SLAB_FREELIST_HARDENED
 	bool "Harden slab freelist metadata"
-	depends on SLUB
+	depends on SLAB || SLUB
 	help
 	  Many kernel heap attacks try to target slab cache metadata and
 	  other infrastructure. This options makes minor performance
 	  sacrifices to harden the kernel slab allocator against common
-	  freelist exploit methods.
+	  freelist exploit methods. Some slab implementations have more
+	  sanity-checking than others. This option is most effective with
+	  CONFIG_SLUB.
 
 config SHUFFLE_PAGE_ALLOCATOR
 	bool "Page allocator randomization"
_

Patches currently in -mm which might be from keescook@chromium.org are

mm-expand-config_slab_freelist_hardened-to-include-slab.patch
slab-add-naive-detection-of-double-free.patch
exec-change-uselib2-is_sreg-failure-to-eacces.patch
exec-move-s_isreg-check-earlier.patch
exec-move-path_noexec-check-earlier.patch
