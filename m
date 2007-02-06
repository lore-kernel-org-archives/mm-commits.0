From: akpm@linux-foundation.org
Subject: + inotify-read-return-val-fix.patch added to -mm tree
Date: Tue, 06 Feb 2007 15:15:37 -0800
Message-ID: <200702062315.l16NFbH6032300@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54963 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030550AbXBFXPr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 18:15:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, john@johnmccutchan.com, wolf0403@hotmail.com


The patch titled
     inotify: read return val fix
has been added to the -mm tree.  Its filename is
     inotify-read-return-val-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: inotify: read return val fix
From: Nick Piggin <npiggin@suse.de>

Fix for inotify read bug (bugzilla.kernel.org #6999)

Problem Description:
When reading from an inotify device with an insufficient sized buffer, read(2)
will return 0 with no errno set. This is because of an logically incorrect
action from the user program thus should return an more logical value. My
suggestion is return -EINVAL as for bind(2).

This patch is based on the proposal from Ryan <wolf0403@hotmail.com>, and
feedback from John McCutchan <john@johnmccutchan.com>.

Return -EINVAL if we have not passed in enough buffer space to read a single
inotify event, rather than 0 which indicates that there is nothing to read.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: "John McCutchan" <john@johnmccutchan.com>
Cc: Ryan <wolf0403@hotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inotify_user.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletion(-)

diff -puN fs/inotify_user.c~inotify-read-return-val-fix fs/inotify_user.c
--- a/fs/inotify_user.c~inotify-read-return-val-fix
+++ a/fs/inotify_user.c
@@ -455,8 +455,16 @@ static ssize_t inotify_read(struct file 
 			break;
 
 		kevent = inotify_dev_get_event(dev);
-		if (event_size + kevent->event.len > count)
+		if (event_size + kevent->event.len > count) {
+			if (ret == 0 && count > 0) {
+				/*
+				 * could not get a single event because we
+				 * didn't have enough buffer space.
+				 */
+				ret = -EINVAL;
+			}
 			break;
+		}
 
 		if (copy_to_user(buf, &kevent->event, event_size)) {
 			ret = -EFAULT;
_

Patches currently in -mm which might be from npiggin@suse.de are

git-block.patch
mm-vm_insert_pfn.patch
mm-vm_insert_pfn-tidy.patch
buffer-memorder-fix.patch
fs-fix-__block_write_full_page-error-case-buffer-submission.patch
inotify-read-return-val-fix.patch
sched-avoid-div-in-rebalance_tick.patch
