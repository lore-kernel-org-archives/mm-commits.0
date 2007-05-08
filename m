From: akpm@linux-foundation.org
Subject: - uml-aio-deadlock-avoidance.patch removed from -mm tree
Date: Mon, 07 May 2007 17:07:31 -0700
Message-ID: <200705080007.l4807Vo1009293@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56544 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967462AbXEHAKd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:10:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: aIO deadlock avoidance
has been removed from the -mm tree.  Its filename was
     uml-aio-deadlock-avoidance.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: aIO deadlock avoidance
From: Jeff Dike <jdike@addtoit.com>

Allow deadlocks to be avoided in the AIO code by setting the pipe to the I/O
thread non-blocking.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/aio.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN arch/um/os-Linux/aio.c~uml-aio-deadlock-avoidance arch/um/os-Linux/aio.c
--- a/arch/um/os-Linux/aio.c~uml-aio-deadlock-avoidance
+++ a/arch/um/os-Linux/aio.c
@@ -221,6 +221,11 @@ static int init_aio_24(void)
 
 	aio_req_fd_w = fds[0];
 	aio_req_fd_r = fds[1];
+
+	err = os_set_fd_block(aio_req_fd_w, 0);
+	if(err)
+		goto out_close_pipe;
+
 	err = run_helper_thread(not_aio_thread, NULL,
 				CLONE_FILES | CLONE_VM | SIGCHLD, &stack, 0);
 	if(err < 0)
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
