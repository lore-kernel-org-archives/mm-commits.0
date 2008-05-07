From: akpm@linux-foundation.org
Subject: + hostap-procfs-fix-for-hostap_fwc.patch added to -mm tree
Date: Wed, 07 May 2008 15:11:29 -0700
Message-ID: <200805072211.m47MBT6T019143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55073 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932494AbYEGWMW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 18:12:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mchouque@free.fr, jkmaline@cc.hut.fi, linville@tuxdriver.com


The patch titled
     hostap: procfs fix for hostap_fw.c
has been added to the -mm tree.  Its filename is
     hostap-procfs-fix-for-hostap_fwc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hostap: procfs fix for hostap_fw.c
From: Mathieu Chouquet-Stringer <mchouque@free.fr>

I've been toying with hostap_pci and found a bug that is triggered when you
unload/reload the module.

If you don't have PRISM2_NO_PROCFS_DEBUG defined (which is the default, as per
hostap_config.h), the driver creates a "registers" file in /proc used to dump
PRISM registers (function prism2_init_local_data):

#ifndef PRISM2_NO_PROCFS_DEBUG
        create_proc_read_entry("registers", 0, local->proc,
                               prism2_registers_proc_read, local);
#endif /* PRISM2_NO_PROCFS_DEBUG */

Note that create_proc_read_entry is being called with local->proc which isn't
defined at the time: "registers" ends up being created as /proc/registers.

When hostap_pci is done initializing the hardware, it calls hostap_hw_ready
which in turns creates all the files in /proc through hostap_init_proc
(hostap_proc.c):

        local->proc = NULL;

        if (hostap_proc == NULL) {
                printk(KERN_WARNING "%s: hostap proc directory not created\n",
                       local->dev->name);
                return;
        }

        local->proc = proc_mkdir(local->ddev->name, hostap_proc);

So far so good, well sort of...  When you unload the module,
prism2_free_local_data does this:

#ifndef PRISM2_NO_PROCFS_DEBUG
        if (local->proc != NULL)
                remove_proc_entry("registers", local->proc);
#endif /* PRISM2_NO_PROCFS_DEBUG */
        hostap_remove_proc(local);

Problem is local->proc has now been overwritten by hostap_init_proc meaning
"registers" isn't removed.  When you reload the module you get an error
telling you "registers" already exists (and you then get duplicate "registers"
files in /proc).

So in a nutshell "registers" should be created after calling hostap_init_proc
(this way it'll be created where it belongs - /proc/net/hostap/%s) making it
removable at module unload.

Signed-off-by: Mathieu Chouquet-Stringer <mchouque@free.fr>
Cc: Jouni Malinen <jkmaline@cc.hut.fi>
Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/hostap/hostap_hw.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/net/wireless/hostap/hostap_hw.c~hostap-procfs-fix-for-hostap_fwc drivers/net/wireless/hostap/hostap_hw.c
--- a/drivers/net/wireless/hostap/hostap_hw.c~hostap-procfs-fix-for-hostap_fwc
+++ a/drivers/net/wireless/hostap/hostap_hw.c
@@ -3276,11 +3276,6 @@ while (0)
 	}
 	printk(KERN_INFO "%s: Registered netdevice %s\n", dev_info, dev->name);
 
-#ifndef PRISM2_NO_PROCFS_DEBUG
-	create_proc_read_entry("registers", 0, local->proc,
-			       prism2_registers_proc_read, local);
-#endif /* PRISM2_NO_PROCFS_DEBUG */
