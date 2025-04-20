Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0359E1C32FF
	for <mm-commits@vger.kernel.org>; Sun, 20 Apr 2025 21:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745183299; cv=none; b=hsxyIcFNvTNTeOV80bQjuM6pFC+4A6bKp9zKnvz5/bTdbmlhlUif0ICdI7l7w1AApb6KeHmYXEs23W5nMUkVnth+mHs0cyI+GuARC6khE2qslrrwMu1FFr+plynbptyZcPAZc9rfUOpHdm3s+dgiwFvH8zzQrV8uxwR8rKuJ6/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745183299; c=relaxed/simple;
	bh=t4HYNJcCqPfBwzrpXkFPlJIzjyGiGTFEdR6ccsCgriQ=;
	h=Date:To:From:Subject:Message-Id; b=OpueXYwPboukj2uNviIdzNgVVAo3kSixrZ1CYta+Xre/DGvwVl8mSfQuqe7GtGf6a+O/ZyMT5GLqXHVKvqmJidzzL9nc1E0T+CgR1iAFy7DL1wKbwSms3cVm+sPlS16F0bNIhrqTvOoiNkf1EQZKNeaEG6LUyuEwQWGCjnw7Fsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HuDMPD8H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HuDMPD8H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BEF9C4CEE2;
	Sun, 20 Apr 2025 21:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745183295;
	bh=t4HYNJcCqPfBwzrpXkFPlJIzjyGiGTFEdR6ccsCgriQ=;
	h=Date:To:From:Subject:From;
	b=HuDMPD8H26oqewMyJD2T+aAPXqjUyUdKwBpqyjs9/kKJCsN/9EzLTqLDnwXuQOnoH
	 WPGOyv6ZUZJYv0aZhSSE13E27giqeQLkZb8kKAKFrhB0njRcYAyn1fjF13Bxcusotl
	 mpGCoPUbAkd4lKbVXXqYRpVUV0sCf7BCJtKA2p1I=
Date: Sun, 20 Apr 2025 14:08:14 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,corbet@lwn.net,axboe@kernel.dk,andriy.shevchenko@linux.intel.com,linux@treblig.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + relay-remove-unused-relay_late_setup_files.patch added to mm-nonmm-unstable branch
Message-Id: <20250420210815.4BEF9C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: relay: remove unused relay_late_setup_files
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     relay-remove-unused-relay_late_setup_files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/relay-remove-unused-relay_late_setup_files.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Dr. David Alan Gilbert" <linux@treblig.org>
Subject: relay: remove unused relay_late_setup_files
Date: Sat, 19 Apr 2025 00:49:32 +0100

The last use of relay_late_setup_files() was removed in 2018 by commit
2b47733045aa ("drm/i915/guc: Merge log relay file and channel creation")

Remove it and the helper it used.

relay_late_setup_files() was used for eventually registering 'buffer only'
channels.  With it gone, delete the docs that explain how to do that. 
Which suggests it should be possible to lose the 'has_base_filename'
flags.

(Are there any other uses??)

Link: https://lkml.kernel.org/r/20250418234932.490863-1-linux@treblig.org
Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/relay.rst |   10 --
 include/linux/relay.h               |    3 
 kernel/relay.c                      |  111 --------------------------
 3 files changed, 1 insertion(+), 123 deletions(-)

--- a/Documentation/filesystems/relay.rst~relay-remove-unused-relay_late_setup_files
+++ a/Documentation/filesystems/relay.rst
@@ -301,16 +301,6 @@ user-defined data with a channel, and is
 (including in create_buf_file()) via chan->private_data or
 buf->chan->private_data.
 
-Buffer-only channels
---------------------
-
-These channels have no files associated and can be created with
-relay_open(NULL, NULL, ...). Such channels are useful in scenarios such
-as when doing early tracing in the kernel, before the VFS is up. In these
-cases, one may open a buffer-only channel and then call
-relay_late_setup_files() when the kernel is ready to handle files,
-to expose the buffered data to the userspace.
-
 Channel 'modes'
 ---------------
 
--- a/include/linux/relay.h~relay-remove-unused-relay_late_setup_files
+++ a/include/linux/relay.h
@@ -159,9 +159,6 @@ struct rchan *relay_open(const char *bas
 			 size_t n_subbufs,
 			 const struct rchan_callbacks *cb,
 			 void *private_data);
-extern int relay_late_setup_files(struct rchan *chan,
-				  const char *base_filename,
-				  struct dentry *parent);
 extern void relay_close(struct rchan *chan);
 extern void relay_flush(struct rchan *chan);
 extern void relay_subbufs_consumed(struct rchan *chan,
--- a/kernel/relay.c~relay-remove-unused-relay_late_setup_files
+++ a/kernel/relay.c
@@ -452,7 +452,7 @@ int relay_prepare_cpu(unsigned int cpu)
 
 /**
  *	relay_open - create a new relay channel
- *	@base_filename: base name of files to create, %NULL for buffering only
+ *	@base_filename: base name of files to create
  *	@parent: dentry of parent directory, %NULL for root directory or buffer
  *	@subbuf_size: size of sub-buffers
  *	@n_subbufs: number of sub-buffers
@@ -465,10 +465,6 @@ int relay_prepare_cpu(unsigned int cpu)
  *	attributes specified.  The created channel buffer files
  *	will be named base_filename0...base_filenameN-1.  File
  *	permissions will be %S_IRUSR.
- *
- *	If opening a buffer (@parent = NULL) that you later wish to register
- *	in a filesystem, call relay_late_setup_files() once the @parent dentry
- *	is available.
  */
 struct rchan *relay_open(const char *base_filename,
 			 struct dentry *parent,
@@ -540,111 +536,6 @@ struct rchan_percpu_buf_dispatcher {
 	struct dentry *dentry;
 };
 
-/* Called in atomic context. */
-static void __relay_set_buf_dentry(void *info)
-{
-	struct rchan_percpu_buf_dispatcher *p = info;
-
-	relay_set_buf_dentry(p->buf, p->dentry);
-}
-
-/**
- *	relay_late_setup_files - triggers file creation
- *	@chan: channel to operate on
- *	@base_filename: base name of files to create
- *	@parent: dentry of parent directory, %NULL for root directory
- *
- *	Returns 0 if successful, non-zero otherwise.
- *
- *	Use to setup files for a previously buffer-only channel created
- *	by relay_open() with a NULL parent dentry.
- *
- *	For example, this is useful for perfomring early tracing in kernel,
- *	before VFS is up and then exposing the early results once the dentry
- *	is available.
- */
-int relay_late_setup_files(struct rchan *chan,
-			   const char *base_filename,
-			   struct dentry *parent)
-{
-	int err = 0;
-	unsigned int i, curr_cpu;
-	unsigned long flags;
-	struct dentry *dentry;
-	struct rchan_buf *buf;
-	struct rchan_percpu_buf_dispatcher disp;
-
-	if (!chan || !base_filename)
-		return -EINVAL;
-
-	strscpy(chan->base_filename, base_filename, NAME_MAX);
-
-	mutex_lock(&relay_channels_mutex);
-	/* Is chan already set up? */
-	if (unlikely(chan->has_base_filename)) {
-		mutex_unlock(&relay_channels_mutex);
-		return -EEXIST;
-	}
-	chan->has_base_filename = 1;
-	chan->parent = parent;
-
-	if (chan->is_global) {
-		err = -EINVAL;
-		buf = *per_cpu_ptr(chan->buf, 0);
-		if (!WARN_ON_ONCE(!buf)) {
-			dentry = relay_create_buf_file(chan, buf, 0);
-			if (dentry && !WARN_ON_ONCE(!chan->is_global)) {
-				relay_set_buf_dentry(buf, dentry);
-				err = 0;
-			}
-		}
-		mutex_unlock(&relay_channels_mutex);
-		return err;
-	}
-
-	curr_cpu = get_cpu();
-	/*
-	 * The CPU hotplug notifier ran before us and created buffers with
-	 * no files associated. So it's safe to call relay_setup_buf_file()
-	 * on all currently online CPUs.
-	 */
-	for_each_online_cpu(i) {
-		buf = *per_cpu_ptr(chan->buf, i);
-		if (unlikely(!buf)) {
-			WARN_ONCE(1, KERN_ERR "CPU has no buffer!\n");
-			err = -EINVAL;
-			break;
-		}
-
-		dentry = relay_create_buf_file(chan, buf, i);
-		if (unlikely(!dentry)) {
-			err = -EINVAL;
-			break;
-		}
-
-		if (curr_cpu == i) {
-			local_irq_save(flags);
-			relay_set_buf_dentry(buf, dentry);
-			local_irq_restore(flags);
-		} else {
-			disp.buf = buf;
-			disp.dentry = dentry;
-			smp_mb();
-			/* relay_channels_mutex must be held, so wait. */
-			err = smp_call_function_single(i,
-						       __relay_set_buf_dentry,
-						       &disp, 1);
-		}
-		if (unlikely(err))
-			break;
-	}
-	put_cpu();
-	mutex_unlock(&relay_channels_mutex);
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(relay_late_setup_files);
-
 /**
  *	relay_switch_subbuf - switch to a new sub-buffer
  *	@buf: channel buffer
_

Patches currently in -mm which might be from linux@treblig.org are

rapidio-remove-some-dead-defines.patch
rapidio-remove-unused-functions.patch
relay-remove-unused-relay_late_setup_files.patch

