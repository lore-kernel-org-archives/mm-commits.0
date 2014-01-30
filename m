From: akpm@linux-foundation.org
Subject: + fanotify-remove-useless-test-from-event-initialization.patch
 added to -mm tree
Date: Thu, 30 Jan 2014 14:01:32 -0800
Message-ID: <52eacbbc.OWJqVBhH5Ih3JNES%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbaA3WBd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Jan 2014 17:01:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, eparis@redhat.com, jack@suse.cz

Subject: + fanotify-remove-useless-test-from-event-initialization.patch added to -mm tree
To: jack@suse.cz,eparis@redhat.com
From: akpm@linux-foundation.org
Date: Thu, 30 Jan 2014 14:01:32 -0800


The patch titled
     Subject: fanotify: remove useless test from event initialization
has been added to the -mm tree.  Its filename is
     fanotify-remove-useless-test-from-event-initialization.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fanotify-remove-useless-test-from-event-initialization.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fanotify-remove-useless-test-from-event-initialization.patch

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
Subject: fanotify: remove useless test from event initialization

Fanotify processes only path events (fanotify_should_send_event() refuses
any other event) so checking whether event is a path event during
initialization makes no sense.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN fs/notify/fanotify/fanotify.c~fanotify-remove-useless-test-from-event-initialization fs/notify/fanotify/fanotify.c
--- a/fs/notify/fanotify/fanotify.c~fanotify-remove-useless-test-from-event-initialization
+++ a/fs/notify/fanotify/fanotify.c
@@ -166,13 +166,8 @@ static struct fanotify_event_info *alloc
 init: __maybe_unused
 	fsnotify_init_event(&event->fse, inode, mask);
 	event->tgid = get_pid(task_tgid(current));
-	if (data_type == FSNOTIFY_EVENT_PATH) {
-		event->path = *path;
-		path_get(&event->path);
-	} else {
-		event->path.mnt = NULL;
-		event->path.dentry = NULL;
-	}
+	event->path = *path;
+	path_get(&event->path);
 	return event;
 }
 
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

