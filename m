Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FCD5C7EE23
	for <mm-commits@archiver.kernel.org>; Tue, 30 May 2023 20:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbjE3Uat (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 May 2023 16:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbjE3Uas (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2023 16:30:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3042FC
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 13:30:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B5AC62A33
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 20:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91EAAC433D2;
        Tue, 30 May 2023 20:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685478645;
        bh=5sZhvoqs5pz8t7lx5NImXVfuu9Jss2ZbTPGqWXTAYmg=;
        h=Date:To:From:Subject:From;
        b=Ssl7DqwCirz/KPc/zMueyaXlGfQcO0kWxXc72Pg/OwkSueyLs4j6QNlmV6F0nS9G2
         nZwiVRKu/oh8818NPiubHHpthsr+qNgmAY0ezvtH3j6nK4/C9BCz7HBivrFUezMCpU
         M0qQNWSNww18tXgzZzKe7kSW3JGSPsKY7GBxb8xA=
Date:   Tue, 30 May 2023 13:30:44 -0700
To:     mm-commits@vger.kernel.org, wuchi.zero@gmail.com,
        tglx@linutronix.de,
        syzbot+7937ba6a50bdd00fffdf@syzkaller.appspotmail.com,
        swboyd@chromium.org, peterz@infradead.org,
        penguin-kernel@I-love.SAKURA.ne.jp, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + debugobjects-turn-off-debug_objects_enabled-from-debug_objects_oom.patch added to mm-nonmm-unstable branch
Message-Id: <20230530203045.91EAAC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: debugobjects: turn off debug_objects_enabled from debug_objects_oom()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     debugobjects-turn-off-debug_objects_enabled-from-debug_objects_oom.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/debugobjects-turn-off-debug_objects_enabled-from-debug_objects_oom.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: debugobjects: turn off debug_objects_enabled from debug_objects_oom()
Date: Mon, 29 May 2023 23:39:12 +0900

syzbot is reporting false positive ODEBUG message immediately after
ODEBUG was disabled due to OOM.

  [ 1062.309646][T22911] ODEBUG: Out of memory. ODEBUG disabled
  [ 1062.886755][ T5171] ------------[ cut here ]------------
  [ 1062.892770][ T5171] ODEBUG: assert_init not available (active state 0) object: ffffc900056afb20 object type: timer_list hint: process_timeout+0x0/0x40

This race happened because debug_objects_oom() emitted OOM message but did
not turn off debug_objects_enabled, and debug_print_object() did not check
debug_objects_enabled when calling WARN().

  CPU 0 [ T5171]                CPU 1 [T22911]
  --------------                --------------
  debug_object_assert_init() {
    if (!debug_objects_enabled)
      return;
    db = get_bucket((unsigned long) addr); // Finds a bucket, but...
                                debug_objects_oom() {
                                  pr_warn("Out of memory. ODEBUG disabled
");
                                  // all buckets get emptied here, and...
                                  hlist_move_list(&db->list, &freelist);
                                }
    lookup_object_or_alloc(addr, db, descr, false, true) {
      lookup_object(addr, b) {
        return NULL; // this bucket is already empty.
      }
      if (!descr->is_static_object || !descr->is_static_object(addr))
        return ERR_PTR(-ENOENT);
    }
    if (!obj) { // obj == ERR_PTR(-ENOENT) because non-static object.
       debug_objects_oom();
       return;
    }
    debug_print_object(&o, "assert_init") {
      // False positive due to not checking debug_objects_enabled.
      WARN(1, KERN_ERR "ODEBUG: %s %s (active state %u) "
           "object: %p object type: %s hint: %pS
", ...);
    }
  }

Link: https://lkml.kernel.org/r/1af29817-4698-c5ac-cf63-0dad289e740f@I-love.SAKURA.ne.jp
Reported-by: syzbot <syzbot+7937ba6a50bdd00fffdf@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=7937ba6a50bdd00fffdf
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: wuchi <wuchi.zero@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/debugobjects.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/lib/debugobjects.c~debugobjects-turn-off-debug_objects_enabled-from-debug_objects_oom
+++ a/lib/debugobjects.c
@@ -466,6 +466,7 @@ static void debug_objects_oom(void)
 	unsigned long flags;
 	int i;
 
+	debug_objects_enabled = 0;
 	pr_warn("Out of memory. ODEBUG disabled\n");
 
 	for (i = 0; i < ODEBUG_HASH_SIZE; i++, db++) {
@@ -502,10 +503,10 @@ static void debug_print_object(struct de
 		void *hint = descr->debug_hint ?
 			descr->debug_hint(obj->object) : NULL;
 		limit++;
-		WARN(1, KERN_ERR "ODEBUG: %s %s (active state %u) "
-				 "object: %p object type: %s hint: %pS\n",
-			msg, obj_states[obj->state], obj->astate,
-			obj->object, descr->name, hint);
+		WARN(debug_objects_enabled, KERN_ERR
+		     "ODEBUG: %s %s (active state %u) object: %p object type: %s hint: %pS\n",
+		     msg, obj_states[obj->state], obj->astate,
+		     obj->object, descr->name, hint);
 	}
 	debug_objects_warnings++;
 }
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

workingset-refactor-lru-refault-to-expose-refault-recency-check-fix.patch
mm-page_alloc-dont-wake-up-kswapd-from-rmqueue-unless-__gfp_kswapd_reclaim-is-specified.patch
debugobjects-turn-off-debug_objects_enabled-from-debug_objects_oom.patch

