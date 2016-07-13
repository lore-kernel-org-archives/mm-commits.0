From: akpm@linux-foundation.org
Subject: + relay-add-global-mode-support-for-buffer-only-channels.patch
 added to -mm tree
Date: Wed, 13 Jul 2016 13:46:07 -0700
Message-ID: <5786a88f.Iu4ZgQpPwQuxD8zW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbcGMUqI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2016 16:46:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akash.goel@intel.com, chris@chris-wilson.co.uk, eduard.munteanu@linux360.ro, tzanussi@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: relay: add global mode support for buffer-only channels
has been added to the -mm tree.  Its filename is
     relay-add-global-mode-support-for-buffer-only-channels.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/relay-add-global-mode-support-for-buffer-only-channels.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/relay-add-global-mode-support-for-buffer-only-channels.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akash Goel <akash.goel@intel.com>
Subject: relay: add global mode support for buffer-only channels

The following patch added support to use channels with no associated files.
	commit 20d8b67c06fa5e74f44e80b0a0fd68c8327f7c6a
	Author: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
	Date:   Fri Jul 25 19:45:12 2008 -0700

		relay: add buffer-only channels; useful for early logging

This is useful when the exact location of relay file is not known or the
the parent directory of relay file is not available, while creating the
channel and the logging has to start right from the boot.

But there was no provision to use global mode with buffer-only channels,
which is added by this patch, without modifying the interface where
initially there will be a dummy invocation of create_buf_file callback
through which kernel client can convey the need of a global buffer.

For the use case where drivers/kernel clients want a simple interface for
the userspace, which enables them to capture data/logs from relay file
inorder & without any post processing, support of Global buffer mode is
warranted.

Modules, like i915, using relay_open() in early init would have to later
register their buffer-only relays, once debugfs is available, by calling
relay_late_setup_files().  Hence relay_late_setup_files() symbol also
needs to be exported.

Link: http://lkml.kernel.org/r/1468404563-11653-1-git-send-email-akash.goel@intel.com
Signed-off-by: Akash Goel <akash.goel@intel.com>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |   34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff -puN kernel/relay.c~relay-add-global-mode-support-for-buffer-only-channels kernel/relay.c
--- a/kernel/relay.c~relay-add-global-mode-support-for-buffer-only-channels
+++ a/kernel/relay.c
@@ -451,6 +451,13 @@ static struct rchan_buf *relay_open_buf(
 		if (!dentry)
 			goto free_buf;
 		relay_set_buf_dentry(buf, dentry);
+	} else {
+		/* Only retrieve global info, nothing more, nothing less */
+		dentry = chan->cb->create_buf_file(NULL, NULL,
+						   S_IRUSR, buf,
+						   &chan->is_global);
+		if (WARN_ON(dentry))
+			goto free_buf;
 	}
 
  	buf->cpu = cpu;
@@ -562,6 +569,10 @@ static int relay_hotcpu_callback(struct
  *	attributes specified.  The created channel buffer files
  *	will be named base_filename0...base_filenameN-1.  File
  *	permissions will be %S_IRUSR.
+ *
+ *	If opening a buffer (@parent = NULL) that you later wish to register
+ *	in a filesystem, call relay_late_setup_files() once the @parent dentry
+ *	is available.
  */
 struct rchan *relay_open(const char *base_filename,
 			 struct dentry *parent,
@@ -640,8 +651,12 @@ static void __relay_set_buf_dentry(void
  *
  *	Returns 0 if successful, non-zero otherwise.
  *
- *	Use to setup files for a previously buffer-only channel.
- *	Useful to do early tracing in kernel, before VFS is up, for example.
+ *	Use to setup files for a previously buffer-only channel created
+ *	by relay_open() with a NULL parent dentry.
+ *
+ *	For example, this is useful for perfomring early tracing in kernel,
+ *	before VFS is up and then exposing the early results once the dentry
+ *	is available.
  */
 int relay_late_setup_files(struct rchan *chan,
 			   const char *base_filename,
@@ -666,6 +681,20 @@ int relay_late_setup_files(struct rchan
 	}
 	chan->has_base_filename = 1;
 	chan->parent = parent;
+
+	if (chan->is_global) {
+		err = -EINVAL;
+		if (!WARN_ON_ONCE(!chan->buf[0])) {
+			dentry = relay_create_buf_file(chan, chan->buf[0], 0);
+			if (dentry && !WARN_ON_ONCE(!chan->is_global)) {
+				relay_set_buf_dentry(chan->buf[0], dentry);
+				err = 0;
+			}
+		}
+		mutex_unlock(&relay_channels_mutex);
+		return err;
+	}
+
 	curr_cpu = get_cpu();
 	/*
 	 * The CPU hotplug notifier ran before us and created buffers with
@@ -706,6 +735,7 @@ int relay_late_setup_files(struct rchan
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(relay_late_setup_files);
 
 /**
  *	relay_switch_subbuf - switch to a new sub-buffer
_

Patches currently in -mm which might be from akash.goel@intel.com are

relay-add-global-mode-support-for-buffer-only-channels.patch

