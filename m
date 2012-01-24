From: akpm@linux-foundation.org
Subject: + pcmcia-fix-socket-refcount-decrementing-on-each-resume.patch added to -mm tree
Date: Tue, 24 Jan 2012 14:20:16 -0800
Message-ID: <20120124222017.0FDC510140D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:49838 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab2AXWUS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2012 17:20:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rmk+kernel@arm.linux.org.uk, linux@dominikbrodowski.net, stable@vger.kernel.org


The patch titled
     Subject: pcmcia: fix socket refcount decrementing on each resume
has been added to the -mm tree.  Its filename is
     pcmcia-fix-socket-refcount-decrementing-on-each-resume.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: pcmcia: fix socket refcount decrementing on each resume

This fixes a memory-corrupting bug: not only does it cause the warning,
but as a result of dropping the refcount to zero, it causes the
pcmcia_socket0 device structure to be freed while it still has references,
causing slab caches corruption.  A fatal oops quickly follows this warning
- often even just a 'dmesg' following the warning causes the kernel to
oops.



While testing suspend/resume on an ARM device with PCMCIA support, and
a CF card inserted, I found that after five suspend and resumes, the
kernel would complain, and shortly die after with slab corruption.

WARNING: at include/linux/kref.h:41 kobject_get+0x28/0x50()

As the message doesn't give a clue about which kobject, and the built-in
debugging in drivers/base/power/main.c happens too late, this was added
right before each get_device():

printk("%s: %p [%s] %u\n", __func__, dev, kobject_name(&dev->kobj), atomic_read(&dev->kobj.kref.refcount));

and on the 3rd s2ram cycle, the following behaviour observed:

On the 3rd suspend/resume cycle:

dpm_prepare: c1a0d998 [pcmcia_socket0] 3
dpm_suspend: c1a0d998 [pcmcia_socket0] 3
dpm_suspend_noirq: c1a0d998 [pcmcia_socket0] 3
dpm_resume_noirq: c1a0d998 [pcmcia_socket0] 3
dpm_resume: c1a0d998 [pcmcia_socket0] 3
dpm_complete: c1a0d998 [pcmcia_socket0] 2

4th:

dpm_prepare: c1a0d998 [pcmcia_socket0] 2
dpm_suspend: c1a0d998 [pcmcia_socket0] 2
dpm_suspend_noirq: c1a0d998 [pcmcia_socket0] 2
dpm_resume_noirq: c1a0d998 [pcmcia_socket0] 2
dpm_resume: c1a0d998 [pcmcia_socket0] 2
dpm_complete: c1a0d998 [pcmcia_socket0] 1

5th:

dpm_prepare: c1a0d998 [pcmcia_socket0] 1
dpm_suspend: c1a0d998 [pcmcia_socket0] 1
dpm_suspend_noirq: c1a0d998 [pcmcia_socket0] 1
dpm_resume_noirq: c1a0d998 [pcmcia_socket0] 1
dpm_resume: c1a0d998 [pcmcia_socket0] 1
dpm_complete: c1a0d998 [pcmcia_socket0] 0
------------[ cut here ]------------
WARNING: at include/linux/kref.h:41 kobject_get+0x28/0x50()
Modules linked in: ucb1x00_core
Backtrace:
[<c0212090>] (dump_backtrace+0x0/0x110) from [<c04799dc>] (dump_stack+0x18/0x1c)
[<c04799c4>] (dump_stack+0x0/0x1c) from [<c021cba0>] (warn_slowpath_common+0x50/0x68)
[<c021cb50>] (warn_slowpath_common+0x0/0x68) from [<c021cbdc>] (warn_slowpath_null+0x24/0x28)
[<c021cbb8>] (warn_slowpath_null+0x0/0x28) from [<c0335374>] (kobject_get+0x28/0x50)
[<c033534c>] (kobject_get+0x0/0x50) from [<c03804f4>] (get_device+0x1c/0x24)
[<c0388c90>] (dpm_complete+0x0/0x1a0) from [<c0389cc0>] (dpm_resume_end+0x1c/0x20)
...

Looking at commit 7b24e7988263 ("pcmcia: split up central event handler"),
the following change was made to cs.c:

@@ -546,8 +524,8 @@ static int socket_late_resume(struct pcmcia_socket *skt)
                return 0;
        }
 #endif
-
-       send_event(skt, CS_EVENT_PM_RESUME, CS_EVENT_PRI_LOW);
+       if (!(skt->state & SOCKET_CARDBUS) && (skt->callback))
+               skt->callback->early_resume(skt);
        return 0;
 }

And the corresponding change in ds.c is from:

-static int ds_event(struct pcmcia_socket *skt, event_t event, int priority)
-{
-       struct pcmcia_socket *s = pcmcia_get_socket(skt);
...
-       switch (event) {
...
-       case CS_EVENT_PM_RESUME:
-               if (verify_cis_cache(skt) != 0) {
-                       dev_dbg(&skt->dev, "cis mismatch - different card\n");
-                       /* first, remove the card */
-                       ds_event(skt, CS_EVENT_CARD_REMOVAL, CS_EVENT_PRI_HIGH);
-                       mutex_lock(&s->ops_mutex);
-                       destroy_cis_cache(skt);
-                       kfree(skt->fake_cis);
-                       skt->fake_cis = NULL;
-                       s->functions = 0;
-                       mutex_unlock(&s->ops_mutex);
-                       /* now, add the new card */
-                       ds_event(skt, CS_EVENT_CARD_INSERTION,
-                                CS_EVENT_PRI_LOW);
-               }
-               break;
...
-    }

-    pcmcia_put_socket(s);

-    return 0;
-} /* ds_event */

to:

+static int pcmcia_bus_early_resume(struct pcmcia_socket *skt)
+{
+       if (!verify_cis_cache(skt)) {
+               pcmcia_put_socket(skt);
+               return 0;
+       }

+       dev_dbg(&skt->dev, "cis mismatch - different card\n");

+       /* first, remove the card */
+       pcmcia_bus_remove(skt);
+       mutex_lock(&skt->ops_mutex);
+       destroy_cis_cache(skt);
+       kfree(skt->fake_cis);
+       skt->fake_cis = NULL;
+       skt->functions = 0;
+       mutex_unlock(&skt->ops_mutex);

+       /* now, add the new card */
+       pcmcia_bus_add(skt);
+       return 0;
+}

As can be seen, the original function called pcmcia_get_socket() and
pcmcia_put_socket() around the guts, whereas the replacement code
calls pcmcia_put_socket() only in one path.  This creates an imbalance
in the refcounting.

Testing with pcmcia_put_socket() put removed shows that the bug is gone:

dpm_suspend: c1a10998 [pcmcia_socket0] 5
dpm_suspend_noirq: c1a10998 [pcmcia_socket0] 5
dpm_resume_noirq: c1a10998 [pcmcia_socket0] 5
dpm_resume: c1a10998 [pcmcia_socket0] 5
dpm_complete: c1a10998 [pcmcia_socket0] 5

Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/ds.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/pcmcia/ds.c~pcmcia-fix-socket-refcount-decrementing-on-each-resume drivers/pcmcia/ds.c
--- a/drivers/pcmcia/ds.c~pcmcia-fix-socket-refcount-decrementing-on-each-resume
+++ a/drivers/pcmcia/ds.c
@@ -1269,10 +1269,8 @@ static int pcmcia_bus_add(struct pcmcia_
 
 static int pcmcia_bus_early_resume(struct pcmcia_socket *skt)
 {
-	if (!verify_cis_cache(skt)) {
-		pcmcia_put_socket(skt);
+	if (!verify_cis_cache(skt))
 		return 0;
-	}
 
 	dev_dbg(&skt->dev, "cis mismatch - different card\n");
 
_
Subject: Subject: pcmcia: fix socket refcount decrementing on each resume

Patches currently in -mm which might be from rmk+kernel@arm.linux.org.uk are

linux-next.patch
pcmcia-fix-socket-refcount-decrementing-on-each-resume.patch
fix-long-term-regression-in-genirq-irq_set_irq_type-handling.patch
irqs-fix-handling-of-pending-irqs-at-request-time.patch

