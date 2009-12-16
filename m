From: akpm@linux-foundation.org
Subject: [merged] const-constify-remaining-pipe_buf_operations.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:36:48 -0800
Message-ID: <200912162036.nBGKam8Z013266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935471AbZLPUgu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:36:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     const: constify remaining pipe_buf_operations
has been removed from the -mm tree.  Its filename was
     const-constify-remaining-pipe_buf_operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: const: constify remaining pipe_buf_operations
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c       |    2 +-
 kernel/trace/trace.c |    4 ++--
 net/core/skbuff.c    |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

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
@@ -3133,7 +3133,7 @@ static void tracing_spd_release_pipe(str
 	__free_page(spd->pages[idx]);
 }
 
-static struct pipe_buf_operations tracing_pipe_buf_ops = {
+static const struct pipe_buf_operations tracing_pipe_buf_ops = {
 	.can_merge		= 0,
 	.map			= generic_pipe_buf_map,
 	.unmap			= generic_pipe_buf_unmap,
@@ -3617,7 +3617,7 @@ static void buffer_pipe_buf_get(struct p
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

origin.patch
linux-next.patch
asus_acpi-convert-to-seq_file.patch
toshiba_acpi-convert-to-seq_file.patch
thinkpad_acpi-convert-to-seq_file.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
arm-convert-proc-cpu-aligment-to-seq_file-fix.patch
iseries-convert-to-proc_fops.patch
proc_fops-convert-av7110.patch
proc_fops-convert-drivers-isdn-to-seq_file.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch
mpt-fusion-convert-to-seq_file.patch
uml-irq-register-race-condition.patch

