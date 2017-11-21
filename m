From: akpm@linux-foundation.org
Subject: + mmvmscan-mark-register_shrinker-as-__must_check.patch added to
 -mm tree
Date: Tue, 21 Nov 2017 13:40:41 -0800
Message-ID: <5a149d59.94OMoOVjN7qd+cgq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59782 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751229AbdKUVkm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Nov 2017 16:40:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, airlied@linux.ie, alexander.deucher@amd.com, david@fromorbit.com, jack@suse.com, pbonzini@redhat.com, shli@fb.com, snitzer@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,vmscan: mark register_shrinker() as __must_check
has been added to the -mm tree.  Its filename is
     mmvmscan-mark-register_shrinker-as-__must_check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmvmscan-mark-register_shrinker-as-__must_check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmvmscan-mark-register_shrinker-as-__must_check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: mm,vmscan: mark register_shrinker() as __must_check

There are users not checking for register_shrinker() failure.  Continuing
with ignoring failure can lead to later oops at unregister_shrinker().

Link: http://lkml.kernel.org/r/1511265757-15563-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shrinker.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/shrinker.h~mmvmscan-mark-register_shrinker-as-__must_check include/linux/shrinker.h
--- a/include/linux/shrinker.h~mmvmscan-mark-register_shrinker-as-__must_check
+++ a/include/linux/shrinker.h
@@ -75,6 +75,6 @@ struct shrinker {
 #define SHRINKER_NUMA_AWARE	(1 << 0)
 #define SHRINKER_MEMCG_AWARE	(1 << 1)
 
-extern int register_shrinker(struct shrinker *);
+extern __must_check int register_shrinker(struct shrinker *);
 extern void unregister_shrinker(struct shrinker *);
 #endif
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

dentry-fix-kmemcheck-splat-at-take_dentry_name_snapshot.patch
mmvmscan-mark-register_shrinker-as-__must_check.patch

