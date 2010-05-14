From: akpm@linux-foundation.org
Subject: + ipmi-split-device-discovery-and-registration-fix-mutex-use.patch added to -mm tree
Date: Fri, 14 May 2010 10:39:55 -0700
Message-ID: <201005141739.o4EHdttm012726@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756760Ab0ENRki (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 May 2010 13:40:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thenzl@redhat.com, cminyard@mvista.com, mjg@redhat.com


The patch titled
     ipmi: fix mutex use
has been added to the -mm tree.  Its filename is
     ipmi-split-device-discovery-and-registration-fix-mutex-use.patch

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
Subject: ipmi: fix mutex use
From: Tomas Henzl <thenzl@redhat.com>

It looks like there is an unbalance with the mutexes after the latest IPMI
patchset applied.  For example in

static __devinit int init_ipmi_si(void)
....
	list_for_each_entry(e, &smi_infos, link) {
		if (!e->irq && (!type || e->addr_source == type)) {
			if (!try_smi_init(e)) {
				type = e->addr_source;
			}
		}
	}
	mutex_unlock(&smi_infos_lock);

we are calling mutex_unlock twice, because the
mutex_unlock(&smi_infos_lock) is also called from try_smi_init.

If the lock in try_smi_init is not needed this can be then solved by
removing the mutex_unlock(&smi_infos_lock) from try_smi_init.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Acked-by: Corey Minyard <cminyard@mvista.com>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-split-device-discovery-and-registration-fix-mutex-use drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-split-device-discovery-and-registration-fix-mutex-use
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -3203,8 +3203,6 @@ static int try_smi_init(struct smi_info 
 		goto out_err_stop_timer;
 	}
 
-	mutex_unlock(&smi_infos_lock);
-
 	printk(KERN_INFO "IPMI %s interface initialized\n",
 	       si_to_str[new_smi->si_type]);
 
@@ -3254,8 +3252,6 @@ static int try_smi_init(struct smi_info 
 		new_smi->dev_registered = 0;
 	}
 
-	mutex_unlock(&smi_infos_lock);
