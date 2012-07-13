From: akpm@linux-foundation.org
Subject: + sysctl-suppress-kmemleak-messages.patch added to -mm tree
Date: Fri, 13 Jul 2012 15:54:33 -0700
Message-ID: <20120713225433.AE9661E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:50395 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877Ab2GMWye (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 18:54:34 -0400
Received: by qcqs25 with SMTP id s25so395296qcq.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 15:54:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, catalin.marinas@arm.com


The patch titled
     Subject: sysctl: suppress kmemleak messages
has been added to the -mm tree.  Its filename is
     sysctl-suppress-kmemleak-messages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Steven Rostedt <rostedt@goodmis.org>
Subject: sysctl: suppress kmemleak messages

register_sysctl_table() is a strange function, as it makes internal
allocations (a header) to register a sysctl_table.  This header is a
handle to the table that is created, and can be used to unregister the
table.  But if the table is permanent and never unregistered, the header
acts the same as a static variable.

Unfortunately, this allocation of memory that is never expected to be
freed fools kmemleak in thinking that we have leaked memory.  For those
sysctl tables that are never unregistered, and have no pointer referencing
them, kmemleak will think that these are memory leaks:

unreferenced object 0xffff880079fb9d40 (size 192):
  comm "swapper/0", pid 0, jiffies 4294667316 (age 12614.152s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8146b590>] kmemleak_alloc+0x73/0x98
    [<ffffffff8110a935>] kmemleak_alloc_recursive.constprop.42+0x16/0x18
    [<ffffffff8110b852>] __kmalloc+0x107/0x153
    [<ffffffff8116fa72>] kzalloc.constprop.8+0xe/0x10
    [<ffffffff811703c9>] __register_sysctl_paths+0xe1/0x160
    [<ffffffff81170463>] register_sysctl_paths+0x1b/0x1d
    [<ffffffff8117047d>] register_sysctl_table+0x18/0x1a
    [<ffffffff81afb0a1>] sysctl_init+0x10/0x14
    [<ffffffff81b05a6f>] proc_sys_init+0x2f/0x31
    [<ffffffff81b0584c>] proc_root_init+0xa5/0xa7
    [<ffffffff81ae5b7e>] start_kernel+0x3d0/0x40a
    [<ffffffff81ae52a7>] x86_64_start_reservations+0xae/0xb2
    [<ffffffff81ae53ad>] x86_64_start_kernel+0x102/0x111
    [<ffffffffffffffff>] 0xffffffffffffffff

The sysctl_base_table used by sysctl itself is one such instance that
registers the table to never be unregistered.

Use kmemleak_not_leak() to suppress the kmemleak false positive.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN kernel/sysctl.c~sysctl-suppress-kmemleak-messages kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-suppress-kmemleak-messages
+++ a/kernel/sysctl.c
@@ -30,6 +30,7 @@
 #include <linux/security.h>
 #include <linux/ctype.h>
 #include <linux/kmemcheck.h>
+#include <linux/kmemleak.h>
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -1554,7 +1555,10 @@ static struct ctl_table dev_table[] = {
 
 int __init sysctl_init(void)
 {
-	register_sysctl_table(sysctl_base_table);
+	struct ctl_table_header *hdr;
+
+	hdr = register_sysctl_table(sysctl_base_table);
+	kmemleak_not_leak(hdr);
 	return 0;
 }
 
_
Subject: Subject: sysctl: suppress kmemleak messages

Patches currently in -mm which might be from rostedt@goodmis.org are

linux-next.patch
sysctl-suppress-kmemleak-messages.patch

