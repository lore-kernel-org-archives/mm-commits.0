From: akpm@linux-foundation.org
Subject: + const-constify-remaining-pipe_buf_operations.patch added to -mm tree
Date: Fri, 16 Oct 2009 14:44:40 -0700
Message-ID: <200910162144.n9GLieIG021095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750822AbZJPVoh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Oct 2009 17:44:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     const: constify remaining pipe_buf_operations
has been added to the -mm tree.  Its filename is
     const-constify-remaining-pipe_buf_operations.patch

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
Subject: const: constify remaining pipe_buf_operations
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN kernel/relay.c~const-constify-remaining-pipe_buf_operations kernel/relay.c
--- a/kernel/relay.c~const-constify-remaining-pipe_buf_operations
+++ a/kernel/relay.c
@@ -1198,7 +1198,7 @@ static void relay_pipe_buf_release(struc
 	relay_consume_bytes(rbuf, buf->private);
 }
 
-static struct pipe_buf_operations relay_pipe_buf_ops = {
+static const struct pipe_buf_operations relay_pipe_buf_ops = {
 	.can_merge = 0,
 	.map = generic_pipe_buf_map,
 	.unmap = generic_pipe_buf_unmap,
diff -puN kernel/trace/trace.c~const-constify-remaining-pipe_buf_operations kernel/trace/trace.c
--- a/kernel/trace/trace.c~const-constify-remaining-pipe_buf_operations
+++ a/kernel/trace/trace.c
@@ -3103,7 +3103,7 @@ static void tracing_spd_release_pipe(str
 	__free_page(spd->pages[idx]);
 }
 
-static struct pipe_buf_operations tracing_pipe_buf_ops = {
+static const struct pipe_buf_operations tracing_pipe_buf_ops = {
 	.can_merge		= 0,
 	.map			= generic_pipe_buf_map,
 	.unmap			= generic_pipe_buf_unmap,
@@ -3589,7 +3589,7 @@ static void buffer_pipe_buf_get(struct p
 }
 
 /* Pipe buffer operations for a buffer. */
-static struct pipe_buf_operations buffer_pipe_buf_ops = {
+static const struct pipe_buf_operations buffer_pipe_buf_ops = {
 	.can_merge		= 0,
 	.map			= generic_pipe_buf_map,
 	.unmap			= generic_pipe_buf_unmap,
diff -puN net/core/skbuff.c~const-constify-remaining-pipe_buf_operations net/core/skbuff.c
--- a/net/core/skbuff.c~const-constify-remaining-pipe_buf_operations
+++ a/net/core/skbuff.c
@@ -93,7 +93,7 @@ static int sock_pipe_buf_steal(struct pi
 
 
 /* Pipe buffer operations for a socket. */
-static struct pipe_buf_operations sock_pipe_buf_ops = {
+static const struct pipe_buf_operations sock_pipe_buf_ops = {
 	.can_merge = 0,
 	.map = generic_pipe_buf_map,
 	.unmap = generic_pipe_buf_unmap,
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
revert-mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
loop-fix-null-dereference-if-mount-fails.patch
sysctl-fix-false-positives-when-proc_sysctl=n.patch
const-constify-remaining-pipe_buf_operations.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch

