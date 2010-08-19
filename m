From: akpm@linux-foundation.org
Subject: + proc-export-uncached-bit-properly-in-proc-kpageflags.patch added to -mm tree
Date: Thu, 19 Aug 2010 16:24:24 -0700
Message-ID: <201008192324.o7JNOOOV014567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080Ab0HSXY1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Aug 2010 19:24:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tiwai@suse.de, fengguang.wu@intel.com


The patch titled
     proc: export uncached bit properly in /proc/kpageflags
has been added to the -mm tree.  Its filename is
     proc-export-uncached-bit-properly-in-proc-kpageflags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: export uncached bit properly in /proc/kpageflags
From: Takashi Iwai <tiwai@suse.de>

Fix the left-over old ifdef for PG_uncached in /proc/kpageflags.  Now it's
used by x86, too.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/page.c~proc-export-uncached-bit-properly-in-proc-kpageflags fs/proc/page.c
--- a/fs/proc/page.c~proc-export-uncached-bit-properly-in-proc-kpageflags
+++ a/fs/proc/page.c
@@ -146,7 +146,7 @@ u64 stable_page_flags(struct page *page)
 	u |= kpf_copy_bit(k, KPF_HWPOISON,	PG_hwpoison);
 #endif
 
-#ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
+#ifdef CONFIG_ARCH_USES_PG_UNCACHED
 	u |= kpf_copy_bit(k, KPF_UNCACHED,	PG_uncached);
 #endif
 
_

Patches currently in -mm which might be from tiwai@suse.de are

origin.patch
linux-next.patch
hp_accel-add-quirks-for-hp-probook-532x-and-hp-mini-5102.patch
proc-export-uncached-bit-properly-in-proc-kpageflags.patch

