From: akpm@linux-foundation.org
Subject: [merged] fanotify-remove-useless-bypass_perm-check.patch removed
 from -mm tree
Date: Fri, 04 Apr 2014 12:29:36 -0700
Message-ID: <533f0820.a1r70WlkjO7oFdwG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42651 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbaDDT3h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:29:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, eparis@redhat.com, jack@suse.cz

Subject: [merged] fanotify-remove-useless-bypass_perm-check.patch removed from -mm tree
To: jack@suse.cz,eparis@redhat.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:29:36 -0700


The patch titled
     Subject: fanotify: remove useless bypass_perm check
has been removed from the -mm tree.  Its filename was
     fanotify-remove-useless-bypass_perm-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Al Viro <viro@zeniv.linux.org.uk>
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
