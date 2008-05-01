From: akpm@linux-foundation.org
Subject: - ptrace-ptrace_attach-use-send_sig_info-instead-force_sig_specific.patch removed from -mm tree
Date: Thu, 01 May 2008 02:27:39 -0700
Message-ID: <200805010927.m419RdLV030436@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757842AbYEAJ2n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: ptrace_attach: use send_sig_info() instead force_sig_specific()
has been removed from the -mm tree.  Its filename was
     ptrace-ptrace_attach-use-send_sig_info-instead-force_sig_specific.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: ptrace_attach: use send_sig_info() instead force_sig_specific()
From: Oleg Nesterov <oleg@tv-sign.ru>

Nobody can block/ignore SIGSTOP, no need to use force_sig_specific() in
ptrace_attach.  Use the "regular" send_sig_info().

With this patch stracing of /sbin/init doesn't clear its SIGNAL_UNKILLABLE,
but not that this makes ptracing of init safe.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/ptrace.c~ptrace-ptrace_attach-use-send_sig_info-instead-force_sig_specific kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-ptrace_attach-use-send_sig_info-instead-force_sig_specific
+++ a/kernel/ptrace.c
@@ -208,8 +208,7 @@ repeat:
 
 	__ptrace_link(task, current);
 
-	force_sig_specific(SIGSTOP, task);
