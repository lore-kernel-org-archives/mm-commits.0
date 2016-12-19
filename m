From: akpm@linux-foundation.org
Subject: + mm-throttle-show_mem-from-warn_alloc-fix.patch added to -mm
 tree
Date: Mon, 19 Dec 2016 15:21:33 -0800
Message-ID: <58586b7d.OaXJOXtKBi7rAEvo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48622 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932585AbcLSXUj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2016 18:20:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-throttle-show_mem-from-warn_alloc-fix
has been added to the -mm tree.  Its filename is
     mm-throttle-show_mem-from-warn_alloc-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-throttle-show_mem-from-warn_alloc-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-throttle-show_mem-from-warn_alloc-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-throttle-show_mem-from-warn_alloc-fix

reduce scope of the ratelimit_states

Cc: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN mm/page_alloc.c~mm-throttle-show_mem-from-warn_alloc-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-throttle-show_mem-from-warn_alloc-fix
+++ a/mm/page_alloc.c
@@ -3018,15 +3018,10 @@ static inline bool should_suppress_show_
 	return ret;
 }
 
-static DEFINE_RATELIMIT_STATE(nopage_rs,
-		DEFAULT_RATELIMIT_INTERVAL,
-		DEFAULT_RATELIMIT_BURST);
-
-static DEFINE_RATELIMIT_STATE(show_mem_rs, HZ, 1);
-
 static void warn_alloc_show_mem(gfp_t gfp_mask)
 {
 	unsigned int filter = SHOW_MEM_FILTER_NODES;
+	static DEFINE_RATELIMIT_STATE(show_mem_rs, HZ, 1);
 
 	if (should_suppress_show_mem() || !__ratelimit(&show_mem_rs))
 		return;
@@ -3050,6 +3045,8 @@ void warn_alloc(gfp_t gfp_mask, const ch
 {
 	struct va_format vaf;
 	va_list args;
+	static DEFINE_RATELIMIT_STATE(nopage_rs, DEFAULT_RATELIMIT_INTERVAL,
+				      DEFAULT_RATELIMIT_BURST);
 
 	if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs) ||
 	    debug_guardpage_minorder() > 0)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
kernel-watchdog-prevent-false-hardlockup-on-overloaded-system-fix.patch
mm.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
linux-next-git-rejects.patch
reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

