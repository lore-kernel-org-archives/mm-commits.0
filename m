From: akpm@linux-foundation.org
Subject: + fanotify-fix-eoverflow-with-large-files-on-64-bit.patch added
 to -mm tree
Date: Fri, 02 May 2014 13:42:45 -0700
Message-ID: <53640345.dZ3skSRvOSmFjHnq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46246 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbaEBUmq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2014 16:42:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jack@suse.cz, eparis@redhat.com, wwoods@redhat.com

Subject: + fanotify-fix-eoverflow-with-large-files-on-64-bit.patch added to -mm tree
To: wwoods@redhat.com,eparis@redhat.com,jack@suse.cz
From: akpm@linux-foundation.org
Date: Fri, 02 May 2014 13:42:45 -0700


The patch titled
     Subject: fanotify: fix -EOVERFLOW with large files on 64-bit
has been added to the -mm tree.  Its filename is
     fanotify-fix-eoverflow-with-large-files-on-64-bit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fanotify-fix-eoverflow-with-large-files-on-64-bit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fanotify-fix-eoverflow-with-large-files-on-64-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Will Woods <wwoods@redhat.com>
Subject: fanotify: fix -EOVERFLOW with large files on 64-bit

On 64-bit systems, O_LARGEFILE is automatically added to flags inside the
open() syscall (also openat(), blkdev_open(), etc).  Userspace therefore
defines O_LARGEFILE to be 0 - you can use it, but it's a no-op. 
Everything should be O_LARGEFILE by default.

But: when fanotify does create_fd() it uses dentry_open(), which skips all
that.  And userspace can't set O_LARGEFILE in fanotify_init() because it's
defined to 0.  So if fanotify gets an event regarding a large file, the
read() will just fail with -EOVERFLOW.

This patch adds O_LARGEFILE to fanotify_init()'s event_f_flags on 64-bit
systems, using the same test as open()/openat()/etc.

Addresses https://bugzilla.redhat.com/show_bug.cgi?id=696821

Signed-off-by: Will Woods <wwoods@redhat.com>
Acked-by: Eric Paris <eparis@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/notify/fanotify/fanotify_user.c~fanotify-fix-eoverflow-with-large-files-on-64-bit fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fanotify-fix-eoverflow-with-large-files-on-64-bit
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -698,6 +698,8 @@ SYSCALL_DEFINE2(fanotify_init, unsigned
 	}
 	group->overflow_event = &oevent->fse;
 
+	if (force_o_largefile())
+		event_f_flags |= O_LARGEFILE;
 	group->fanotify_data.f_flags = event_f_flags;
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 	spin_lock_init(&group->fanotify_data.access_lock);
_

Patches currently in -mm which might be from wwoods@redhat.com are

fanotify-fix-eoverflow-with-large-files-on-64-bit.patch

