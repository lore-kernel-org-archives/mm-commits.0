From: akpm@linux-foundation.org
Subject: [merged] kprobes-add-the-tls-argument-for-j_do_fork.patch removed from -mm tree
Date: Mon, 23 May 2016 12:51:54 -0700
Message-ID: <57435f5a.m2S8yceDOvolQNyn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38239 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbcEWTvz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:51:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie.huang@arm.com, josh@joshtriplett.org, luto@kernel.org, masami.hiramatsu.pt@hitachi.com, steve.capper@arm.com, thiago.macieira@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kprobes: add the "tls" argument for j_do_fork
has been removed from the -mm tree.  Its filename was
     kprobes-add-the-tls-argument-for-j_do_fork.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Shijie <shijie.huang@arm.com>
Subject: kprobes: add the "tls" argument for j_do_fork

3033f14a ("clone: support passing tls argument via C rather than pt_regs
magic") added the tls argument for _do_fork().  This patch adds the "tls"
argument for j_do_fork to make it match _do_fork().

Signed-off-by: Huang Shijie <shijie.huang@arm.com>
Acked-by: Steve Capper <steve.capper@arm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Thiago Macieira <thiago.macieira@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/kprobes/jprobe_example.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN samples/kprobes/jprobe_example.c~kprobes-add-the-tls-argument-for-j_do_fork samples/kprobes/jprobe_example.c
--- a/samples/kprobes/jprobe_example.c~kprobes-add-the-tls-argument-for-j_do_fork
+++ a/samples/kprobes/jprobe_example.c
@@ -25,7 +25,7 @@
 /* Proxy routine having the same arguments as actual _do_fork() routine */
 static long j_do_fork(unsigned long clone_flags, unsigned long stack_start,
 	      unsigned long stack_size, int __user *parent_tidptr,
-	      int __user *child_tidptr)
+	      int __user *child_tidptr, unsigned long tls)
 {
 	pr_info("jprobe: clone_flags = 0x%lx, stack_start = 0x%lx "
 		"stack_size = 0x%lx\n", clone_flags, stack_start, stack_size);
_

Patches currently in -mm which might be from shijie.huang@arm.com are

kprobes-add-a-new-module-parameter.patch
kprobes-print-out-the-symbol-name-for-the-hooks.patch

