From: akpm@linux-foundation.org
Subject: + um-call-free_irq-only-on-enabled-channels.patch added to -mm tree
Date: Mon, 14 Jun 2010 15:45:47 -0700
Message-ID: <201006142245.o5EMjlpC003324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751469Ab0FNWqE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jun 2010 18:46:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at, jdike@addtoit.com


The patch titled
     um: call free_irq() only on enabled channels
has been added to the -mm tree.  Its filename is
     um-call-free_irq-only-on-enabled-channels.patch

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
Subject: um: call free_irq() only on enabled channels
From: Richard Weinberger <richard@nod.at>

When I use OpenSUSE-11.2 on UML (> 2.6.25)
I get lots of such errors:

Registering fd 1 twice
Irqs : 3, 3
Ids : 0x09cb41a0, 0x09cb4120
------------[ cut here ]------------
WARNING: at kernel/irq/manage.c:896 __free_irq+0x79/0x11a()
Trying to free already-free IRQ 3
Modules linked in:
09dadc6c:  [<081b2edb>] dump_stack+0x1c/0x20
09dadc84:  [<080716da>] warn_slowpath_common+0x49/0x77
09dadc9c:  [<08071772>] warn_slowpath_fmt+0x26/0x2a
09dadcb4:  [<08094e08>] __free_irq+0x79/0x11a
09dadce4:  [<08094ed6>] free_irq+0x2d/0x49
09dadcf4:  [<0805b4bc>] close_one_chan+0x70/0x9c
09dadd0c:  [<0805b833>] close_chan+0x17/0x22
09dadd1c:  [<0805bdda>] enable_chan+0x70/0x7c
09dadd3c:  [<0805cbb7>] line_open+0x34/0x9f
09dadd54:  [<0805b21e>] con_open+0x13/0x35
09dadd6c:  [<0814dc89>] tty_open+0x285/0x384
09dadda0:  [<080b754e>] chrdev_open+0xe0/0xf9
09daddc0:  [<080b3fb2>] __dentry_open+0xf3/0x1e2
09dadde4:  [<080b4142>] nameidata_to_filp+0x35/0x49
09daddfc:  [<080bd270>] do_last+0x409/0x50e
09dade28:  [<080bea04>] do_filp_open+0x175/0x446
09dadecc:  [<080b3d89>] do_sys_open+0x4a/0x128
09dadf04:  [<080b3ea2>] sys_open+0x19/0x21
09dadf28:  [<0805ab5a>] handle_syscall+0x7a/0x98
09dadf78:  [<08068441>] userspace+0x2c9/0x370
09dadfe0:  [<08058bb3>] fork_handler+0x53/0x5b
09dadffc:  [<00766564>] 0x766564

---[ end trace 9ebc1094aaf4bded ]---

This patch fixes the issue.

Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/chan_kern.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/um/drivers/chan_kern.c~um-call-free_irq-only-on-enabled-channels arch/um/drivers/chan_kern.c
--- a/arch/um/drivers/chan_kern.c~um-call-free_irq-only-on-enabled-channels
+++ a/arch/um/drivers/chan_kern.c
@@ -210,9 +210,9 @@ void free_irqs(void)
 	list_for_each(ele, &list) {
 		chan = list_entry(ele, struct chan, free_list);
 
-		if (chan->input)
+		if (chan->input && chan->enabled)
 			free_irq(chan->line->driver->read_irq, chan);
-		if (chan->output)
+		if (chan->output && chan->enabled)
 			free_irq(chan->line->driver->write_irq, chan);
 		chan->enabled = 0;
 	}
@@ -231,9 +231,9 @@ static void close_one_chan(struct chan *
 		spin_unlock_irqrestore(&irqs_to_free_lock, flags);
 	}
 	else {
-		if (chan->input)
+		if (chan->input && chan->enabled)
 			free_irq(chan->line->driver->read_irq, chan);
-		if (chan->output)
+		if (chan->output && chan->enabled)
 			free_irq(chan->line->driver->write_irq, chan);
 		chan->enabled = 0;
 	}
_

Patches currently in -mm which might be from richard@nod.at are

um-call-free_irq-only-on-enabled-channels.patch
char-remove-unused-variable.patch

