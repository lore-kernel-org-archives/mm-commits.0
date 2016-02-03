From: akpm@linux-foundation.org
Subject: + autofs-show-pipe-inode-in-mount-options.patch added to -mm tree
Date: Tue, 02 Feb 2016 19:42:19 -0800
Message-ID: <56b1771b.OVz94vqjutcKIu8L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59227 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932588AbcBCDmU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 22:42:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: skinsbursky@virtuozzo.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: show pipe inode in mount options
has been added to the -mm tree.  Its filename is
     autofs-show-pipe-inode-in-mount-options.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-show-pipe-inode-in-mount-options.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-show-pipe-inode-in-mount-options.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stanislav Kinsburskiy <skinsbursky@virtuozzo.com>
Subject: autofs: show pipe inode in mount options

This is required for CRIU (Checkpoint Restart In Userspace) to migrate a
mount point when write end in user space is closed.

Below is a brief description of the problem.

To migrate a non-catatonic autofs mount point, one has to restore the
control pipe between kernel and autofs master process.

One of the autofs masters is systemd, which closes pipe write end after
passing it to the kernel with mount call.

To be able to restore the systemd control pipe one has to know which read
pipe end in systemd corresponds to the write pipe end in the kernel.  The
pipe "fd" in mount options is not enough because it was closed and
probably replaced by some other descriptor.

Thus, some other attribute is required to be able to find the read pipe
end.  The best attribute to use to find the correct pipe end is inode
number becuase it's unique for the whole system and can't be reused while
the autofs mount exists.

This attribute can also be used to recognize a situation where an autofs
mount has no master (no process with specified "pgrp" or no file
descriptor with "pipe_ino", specified in autofs mount options).

Signed-off-by: Stanislav Kinsburskiy <skinsbursky@virtuozzo.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/inode.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/autofs4/inode.c~autofs-show-pipe-inode-in-mount-options fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~autofs-show-pipe-inode-in-mount-options
+++ a/fs/autofs4/inode.c
@@ -94,7 +94,12 @@ static int autofs4_show_options(struct s
 		seq_printf(m, ",direct");
 	else
 		seq_printf(m, ",indirect");
