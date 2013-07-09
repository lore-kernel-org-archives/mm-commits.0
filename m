From: akpm@linux-foundation.org
Subject: [merged] fanotify-info-leak-in-copy_event_to_user.patch removed
 from -mm tree
Date: Tue, 09 Jul 2013 16:19:08 -0700
Message-ID: <51dc9a6c.w/Nl6X5ZNxGUErJt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38765 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab3GIXTI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:19:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, eparis@redhat.com, dan.carpenter@oracle.com

Subject: [merged] fanotify-info-leak-in-copy_event_to_user.patch removed from -mm tree
To: dan.carpenter@oracle.com,eparis@redhat.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:19:08 -0700


The patch titled
     Subject: fanotify: info leak in copy_event_to_user()
has been removed from the -mm tree.  Its filename was
     fanotify-info-leak-in-copy_event_to_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: fanotify: info leak in copy_event_to_user()

The ->reserved field isn't cleared so we leak one byte of stack
information to userspace.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/notify/fanotify/fanotify_user.c~fanotify-info-leak-in-copy_event_to_user fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fanotify-info-leak-in-copy_event_to_user
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -122,6 +122,7 @@ static int fill_event_metadata(struct fs
 	metadata->event_len = FAN_EVENT_METADATA_LEN;
 	metadata->metadata_len = FAN_EVENT_METADATA_LEN;
 	metadata->vers = FANOTIFY_METADATA_VERSION;
+	metadata->reserved = 0;
 	metadata->mask = event->mask & FAN_ALL_OUTGOING_EVENTS;
 	metadata->pid = pid_vnr(event->tgid);
 	if (unlikely(event->mask & FAN_Q_OVERFLOW))
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix.patch

