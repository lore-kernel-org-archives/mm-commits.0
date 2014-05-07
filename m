From: akpm@linux-foundation.org
Subject: [merged] fanotify-fix-eoverflow-with-large-files-on-64-bit.patch
 removed from -mm tree
Date: Wed, 07 May 2014 12:05:17 -0700
Message-ID: <536a83ed.8EI0rPG/hbDqx/Xt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56163 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaEGTFX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 15:05:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jack@suse.cz, eparis@redhat.com, wwoods@redhat.com

Subject: [merged] fanotify-fix-eoverflow-with-large-files-on-64-bit.patch removed from -mm tree
To: wwoods@redhat.com,eparis@redhat.com,jack@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 12:05:17 -0700


The patch titled
     Subject: fanotify: fix -EOVERFLOW with large files on 64-bit
has been removed from the -mm tree.  Its filename was
     fanotify-fix-eoverflow-with-large-files-on-64-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

