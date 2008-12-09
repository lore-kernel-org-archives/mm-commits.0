From: akpm@linux-foundation.org
Subject: + inotify-fix-in_oneshot-unmount-event-watcher.patch added to -mm tree
Date: Mon, 08 Dec 2008 16:26:57 -0800
Message-ID: <200812090026.mB90QvKU012217@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753693AbYLIA1H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 19:27:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@openvz.org, rlove@google.com, ttb@tentacle.dhs.org, ulissesf@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     inotify: fix IN_ONESHOT unmount event watcher
has been added to the -mm tree.  Its filename is
     inotify-fix-in_oneshot-unmount-event-watcher.patch

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
Subject: inotify: fix IN_ONESHOT unmount event watcher
From: Dmitri Monakhov <dmonakhov@openvz.org>

On umount two event will be dispatched to watcher:

1: inotify_dev_queue_event(.., IN_UNMOUNT,..)
2: remove_watch(watch, dev)
    ->inotify_dev_queue_event(.., IN_IGNORED, ..)

But if watcher has IN_ONESHOT bit set then the watcher will be released
inside first event.  Which result in accessing invalid object later.  IMHO
it is not pure regression.  This bug wasn't triggered while initial
inotify interface testing phase because of another bug in IN_ONESHOT
handling logic :)

  commit ac74c00e499ed276a965e5b5600667d5dc04a84a
  Author: Ulisses Furquim <ulissesf@gmail.com>
  Date:   Fri Feb 8 04:18:16 2008 -0800
    inotify: fix check for one-shot watches before destroying them
    As the IN_ONESHOT bit is never set when an event is sent we must check it
    in the watch's mask and not in the event's mask.

TESTCASE:
mkdir mnt
mount -ttmpfs none mnt
mkdir mnt/d
./inotify mnt/d&
umount mnt ## << lockup or crash here

TESTSOURCE:
/* gcc -oinotify inotify.c */
#include <stdio.h>
#include <stdlib.h>
#include <sys/inotify.h>

int main(int argc, char **argv)
{
        char buf[1024];
        struct inotify_event *ie;
        char *p;
        int i;
        ssize_t l;

        p = argv[1];
        i = inotify_init();
        inotify_add_watch(i, p, ~0);

        l = read(i, buf, sizeof(buf));
        printf("read %d bytes\n", l);
        ie = (struct inotify_event *) buf;
        printf("event mask: %d\n", ie->mask);
	return 0;
}

Signed-off-by: Dmitri Monakhov <dmonakhov@openvz.org>
Cc: John McCutchan <ttb@tentacle.dhs.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Robert Love <rlove@google.com>
Cc: Ulisses Furquim <ulissesf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inotify.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/inotify.c~inotify-fix-in_oneshot-unmount-event-watcher fs/inotify.c
--- a/fs/inotify.c~inotify-fix-in_oneshot-unmount-event-watcher
+++ a/fs/inotify.c
@@ -428,11 +428,13 @@ void inotify_unmount_inodes(struct list_
 		watches = &inode->inotify_watches;
 		list_for_each_entry_safe(watch, next_w, watches, i_list) {
 			struct inotify_handle *ih= watch->ih;
+			get_inotify_watch(watch);
 			mutex_lock(&ih->mutex);
 			ih->in_ops->handle_event(watch, watch->wd, IN_UNMOUNT, 0,
 						 NULL, NULL);
 			inotify_remove_watch_locked(ih, watch);
 			mutex_unlock(&ih->mutex);
+			put_inotify_watch(watch);
 		}
 		mutex_unlock(&inode->inotify_mutex);
 		iput(inode);		
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

inotify-fix-in_oneshot-unmount-event-watcher.patch
kill-suid-bit-only-for-regular-files.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error-fix.patch

