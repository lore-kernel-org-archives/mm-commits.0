From: akpm@linux-foundation.org
Subject: + revert-kobject-dont-block-for-each-kobject_uevent.patch added to -mm tree
Date: Thu, 16 Apr 2009 14:09:02 -0700
Message-ID: <200904162109.n3GL92aM018616@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752888AbZDPVMS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Apr 2009 17:12:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, arjan@linux.intel.com, gregkh@suse.de, penguin-kernel@i-love.sakura.ne.jp


The patch titled
     revert "kobject: don't block for each kobject_uevent"
has been added to the -mm tree.  Its filename is
     revert-kobject-dont-block-for-each-kobject_uevent.patch

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
Subject: revert "kobject: don't block for each kobject_uevent"
From: Hugh Dickins <hugh@veritas.com>

Revert f520360d93cdc37de5d972dac4bf3bdef6a7f6a7 "kobject: don't block for
each kobject_uevent".

Tetsuo Handa, running a kernel with CONFIG_DEBUG_PAGEALLOC=y and
CONFIG_UEVENT_HELPER_PATH=/sbin/hotplug, has been hitting RCU detected CPU
stalls: it's been spinning in the loop where do_execve() counts up the
args (but why wasn't fixup_exception working?  dunno).

The recent change, switching kobject_uevent_env() from UMH_WAIT_EXEC to
UMH_NO_WAIT, is broken: the exec uses args on the local stack here, and an
env which is kfreed as soon as call_usermodehelper() returns.  It very
much needs to wait for the exec to be done.

Or keep the UMH_NO_WAIT, and complicate the code to allocate and free
these resources correctly?  No, as GregKH pointed out when making the
commit, CONFIG_UEVENT_HELPER_PATH="" is a much better optimization -
though some distros are still saying /sbin/hotplug in their .config, yet
with no such binary in their initrd or their root.

Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kobject_uevent.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/kobject_uevent.c~revert-kobject-dont-block-for-each-kobject_uevent lib/kobject_uevent.c
--- a/lib/kobject_uevent.c~revert-kobject-dont-block-for-each-kobject_uevent
+++ a/lib/kobject_uevent.c
@@ -258,7 +258,7 @@ int kobject_uevent_env(struct kobject *k
 			goto exit;
 
 		retval = call_usermodehelper(argv[0], argv,
-					     env->envp, UMH_NO_WAIT);
+					     env->envp, UMH_WAIT_EXEC);
 	}
 
 exit:
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
clocksource-pass-clocksource-to-read-callback.patch
revert-kobject-dont-block-for-each-kobject_uevent.patch
mm-pass-correct-mm-when-growing-stack.patch
mm-disable-preemption-in-apply_to_pte_range.patch
getrusage-fill-ru_maxrss-value.patch
prio_tree-debugging-patch.patch

