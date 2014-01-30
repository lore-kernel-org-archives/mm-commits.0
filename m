From: akpm@linux-foundation.org
Subject: + fanotify-remove-useless-bypass_perm-check.patch added to -mm
 tree
Date: Thu, 30 Jan 2014 14:01:30 -0800
Message-ID: <52eacbba.EM5tfBr+sUjIo/3h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43004 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbaA3WBb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Jan 2014 17:01:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, eparis@redhat.com, jack@suse.cz

Subject: + fanotify-remove-useless-bypass_perm-check.patch added to -mm tree
To: jack@suse.cz,eparis@redhat.com
From: akpm@linux-foundation.org
Date: Thu, 30 Jan 2014 14:01:30 -0800


The patch titled
     Subject: fanotify: remove useless bypass_perm check
has been added to the -mm tree.  Its filename is
     fanotify-remove-useless-bypass_perm-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fanotify-remove-useless-bypass_perm-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fanotify-remove-useless-bypass_perm-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fanotify: remove useless bypass_perm check

prepare_for_access_response() checks whether
group->fanotify_data.bypass_perm is set.  However this test can never be
true because prepare_for_access_response() is called only from
fanotify_read() which means fanotify group is alive with an active fd
while bypass_perm is set from fanotify_release() when all file descriptors
pointing to the group are closed and the group is going away.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN fs/notify/fanotify/fanotify_user.c~fanotify-remove-useless-bypass_perm-check fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fanotify-remove-useless-bypass_perm-check
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -211,14 +211,6 @@ static int prepare_for_access_response(s
 	re->fd = fd;
 
 	mutex_lock(&group->fanotify_data.access_mutex);
-
-	if (atomic_read(&group->fanotify_data.bypass_perm)) {
-		mutex_unlock(&group->fanotify_data.access_mutex);
-		kmem_cache_free(fanotify_response_event_cache, re);
-		FANOTIFY_E(event)->response = FAN_ALLOW;
-		return 0;
-	}
-		
 	list_add_tail(&re->list, &group->fanotify_data.access_list);
 	mutex_unlock(&group->fanotify_data.access_mutex);
 
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
fanotify-remove-useless-bypass_perm-check.patch
fanotify-use-fanotify-event-structure-for-permission-response-processing.patch
fanotify-remove-useless-test-from-event-initialization.patch
fanotify-convert-access_mutex-to-spinlock.patch
fanotify-reorganize-loop-in-fanotify_read.patch
fanotify-move-unrelated-handling-from-copy_event_to_user.patch
linux-next.patch
kernel-use-lockless-list-for-smp_call_function_single.patch
mm-add-strictlimit-knob-v2.patch

