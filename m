From: akpm@linux-foundation.org
Subject: +
 include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max-fix.patch
 added to -mm tree
Date: Fri, 20 Jun 2014 14:55:12 -0700
Message-ID: <53a4adc0.+wAaKkinTYTFMS9z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965046AbaFTVzN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 17:55:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@intel.com, mina86@mina86.com


The patch titled
     Subject: Re: include/linux/kernel.h:744:28: note: in expansion of macro 'min'
has been added to the -mm tree.  Its filename is
     include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Nazarewicz <mina86@mina86.com>
Subject: Re: include/linux/kernel.h:744:28: note: in expansion of macro 'min'

On Fri, Jun 20 2014, Fengguang Wu <fengguang.wu@intel.com> wrote:
>>> include/linux/kernel.h:744:28: note: in expansion of macro 'min'
>     #define clamp(val, lo, hi) min(max(val, lo), hi)
>                                ^
>>> drivers/net/ethernet/intel/i40e/i40e_debugfs.c:1901:11: note: in expans=
ion of macro 'clamp'
>       bytes =3D clamp(bytes, (u16)1024, (u16)I40E_MAX_AQ_BUF_SIZE);
>               ^

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/kernel.h~include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max-fix include/linux/kernel.h
--- a/include/linux/kernel.h~include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max-fix
+++ a/include/linux/kernel.h
@@ -719,8 +719,8 @@ static inline void ftrace_dump(enum ftra
 	(void) (&_max1 == &_max2);		\
 	_max1 > _max2 ? _max1 : _max2; })
 
-#define min3(x, y, z) min(min(x, y), z)
-#define max3(x, y, z) max(max(x, y), z)
+#define min3(x, y, z) min((typeof(x))min(x, y), z)
+#define max3(x, y, z) max((typeof(x))max(x, y), z)
 
 /**
  * min_not_zero - return the minimum that is _not_ zero, unless both are zero
@@ -741,7 +741,7 @@ static inline void ftrace_dump(enum ftra
  * This macro does strict typechecking of min/max to make sure they are of the
  * same type as val.  See the unnecessary pointer comparisons.
  */
-#define clamp(val, lo, hi) min(max(val, lo), hi)
+#define clamp(val, lo, hi) min((typeof(val))max(val, lo), hi)
 
 /*
  * ..and if you can't take the strict
_

Patches currently in -mm which might be from mina86@mina86.com are

dma-cma-fix-possible-memory-leak.patch
mm-page_alloc-simplify-drain_zone_pages-by-using-min.patch
dma-cma-separate-core-cma-management-codes-from-dma-apis.patch
dma-cma-support-alignment-constraint-on-cma-region.patch
dma-cma-support-arbitrary-bitmap-granularity.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
cma-generalize-cma-reserved-area-management-functionality.patch
ppc-kvm-cma-use-general-cma-reserved-area-management-framework.patch
mm-cma-clean-up-cma-allocation-error-path.patch
mm-cma-change-cma_declare_contiguous-to-obey-coding-convention.patch
mm-cma-clean-up-log-message.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

