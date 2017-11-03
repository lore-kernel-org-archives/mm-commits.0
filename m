From: akpm@linux-foundation.org
Subject: + autofs-dont-fail-mount-for-transient-error.patch added to -mm
 tree
Date: Fri, 03 Nov 2017 11:05:40 -0700
Message-ID: <59fcaff4.neiELIcLaqj1knKq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38106 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751381AbdKCSFl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Nov 2017 14:05:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.com, raven@themaw.net, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: don't fail mount for transient error
has been added to the -mm tree.  Its filename is
     autofs-dont-fail-mount-for-transient-error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-dont-fail-mount-for-transient-error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-dont-fail-mount-for-transient-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: NeilBrown <neilb@suse.com>
Subject: autofs: don't fail mount for transient error

Currently if the autofs kernel module gets an error when writing to the
pipe which links to the daemon, then it marks the whole moutpoint as
catatonic, and it will stop working.

It is possible that the error is transient.  This can happen if the daemon
is slow and more than 16 requests queue up.  If a subsequent process tries
to queue a request, and is then signalled, the write to the pipe will
return -ERESTARTSYS and autofs will take that as total failure.

So change the code to assess -ERESTARTSYS and -ENOMEM as transient
failures which only abort the current request, not the whole mountpoint.

It isn't a crash or a data corruption, but having autofs mountpoints
suddenly stop working is rather inconvenient.

Ian said:

: And given the problems with a half dozen (or so) user space applications
: consuming large amounts of CPU under heavy mount and umount activity this
: could happen more easily than we expect.


Link: http://lkml.kernel.org/r/87y3norvgp.fsf@notabene.neil.brown.name
Signed-off-by: NeilBrown <neilb@suse.com>
Acked-by: Ian Kent <raven@themaw.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/waitq.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN fs/autofs4/waitq.c~autofs-dont-fail-mount-for-transient-error fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs-dont-fail-mount-for-transient-error
+++ a/fs/autofs4/waitq.c
@@ -81,7 +81,8 @@ static int autofs4_write(struct autofs_s
 		spin_unlock_irqrestore(&current->sighand->siglock, flags);
 	}
 
-	return (bytes > 0);
+	/* if 'wr' returned 0 (impossible) we assume -EIO (safe) */
+	return bytes == 0 ? 0 : wr < 0 ? wr : -EIO;
 }
 
 static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
@@ -95,6 +96,7 @@ static void autofs4_notify_daemon(struct
 	} pkt;
 	struct file *pipe = NULL;
 	size_t pktsz;
+	int ret;
 
 	pr_debug("wait id = 0x%08lx, name = %.*s, type=%d\n",
 		 (unsigned long) wq->wait_queue_token,
@@ -169,7 +171,18 @@ static void autofs4_notify_daemon(struct
 	mutex_unlock(&sbi->wq_mutex);
 
 	if (autofs4_write(sbi, pipe, &pkt, pktsz))
+	switch (ret = autofs4_write(sbi, pipe, &pkt, pktsz)) {
+	case 0:
+		break;
+	case -ENOMEM:
+	case -ERESTARTSYS:
+		/* Just fail this one */
+		autofs4_wait_release(sbi, wq->wait_queue_token, ret);
+		break;
+	default:
 		autofs4_catatonic_mode(sbi);
+		break;
+	}
 	fput(pipe);
 }
 
_

Patches currently in -mm which might be from neilb@suse.com are

autofs-dont-fail-mount-for-transient-error.patch

