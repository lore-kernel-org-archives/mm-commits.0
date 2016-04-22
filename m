From: akpm@linux-foundation.org
Subject: + kprobes-add-the-tls-argument-for-j_do_fork.patch added to -mm
 tree
Date: Fri, 22 Apr 2016 13:58:17 -0700
Message-ID: <571a9069.IF9NMZs4rbP4hqhv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33967 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbcDVU6S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2016 16:58:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie.huang@arm.com, josh@joshtriplett.org, luto@kernel.org, masami.hiramatsu.pt@hitachi.com, steve.capper@arm.com, thiago.macieira@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kprobes: add the "tls" argument for j_do_fork
has been added to the -mm tree.  Its filename is
     kprobes-add-the-tls-argument-for-j_do_fork.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kprobes-add-the-tls-argument-for-j_do_fork.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kprobes-add-the-tls-argument-for-j_do_fork.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Shijie <shijie.huang@arm.com>
Subject: kprobes: add the "tls" argument for j_do_fork

3033f14a ("clone: support passing tls argument via C rather than pt_regs
magic") added the tls argument for _do_fork().  This patch adds the "tls"
argument for j_do_fork to make it match _do_fork().

Signed-off-by: Huang Shijie <shijie.huang@arm.com>
Acked-by: Steve Capper <steve.capper@arm.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Josh Triplett <josh@joshtriplett.org>
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

kprobes-add-the-tls-argument-for-j_do_fork.patch

