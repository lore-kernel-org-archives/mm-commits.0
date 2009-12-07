From: akpm@linux-foundation.org
Subject: + ip2-remove-ifdef-module-from-ip2mainc-fix-2.patch added to -mm tree
Date: Mon, 07 Dec 2009 11:56:33 -0800
Message-ID: <200912071956.nB7JuXsc020324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933589AbZLGT45 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Dec 2009 14:56:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com, akpm@linux-foundation.org, mhw@WittsEnd.com


The patch titled
     ip2-remove-ifdef-module-from-ip2mainc-fix-2
has been added to the -mm tree.  Its filename is
     ip2-remove-ifdef-module-from-ip2mainc-fix-2.patch

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
Subject: ip2-remove-ifdef-module-from-ip2mainc-fix-2
From: Rakib Mullick <rakib.mullick@gmail.com>

On 12/4/09, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 1 Dec 2009 15:02:56 +0600 Rakib Mullick <rakib.mullick@gmail.com> wrote:
>
> x86_64 allmodconfig:
>
>  drivers/char/ip2/ip2main.c: In function 'ip2_loadmain':
>
> drivers/char/ip2/ip2main.c:657: error: 'pdev' undeclared (first use in this function)
>  drivers/char/ip2/ip2main.c:657: error: (Each undeclared identifier is reported only once
>  drivers/char/ip2/ip2main.c:657: error: for each function it appears in.)
>
Yes, I've also notice that pci_dev_put was outside of the #ifdef CONFIG_PCI
 context.  I was about to make patch for this.
>
>  I suppose this:
>
>  but it needs checking - does pci_get_device() need a balancing pci_dev_put()?

I thinks - yes. Otherwise we've to face ref counting problem.
And when pci_enable_device fails we need to make sure that we're
calling pci_dev_put.

So.. please checkout the following patch. Following patch has
been made without applying 'ip2-remove-ifdef-module-from-ip2mainc-fix' patch.
Please just check is it okay or not.

Cc: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Michael H. Warfield <mhw@WittsEnd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ip2/ip2main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/char/ip2/ip2main.c~ip2-remove-ifdef-module-from-ip2mainc-fix-2 drivers/char/ip2/ip2main.c
--- a/drivers/char/ip2/ip2main.c~ip2-remove-ifdef-module-from-ip2mainc-fix-2
+++ a/drivers/char/ip2/ip2main.c
@@ -624,7 +624,7 @@ static int __init ip2_loadmain(void)
 
 			if (pci_enable_device(pdev)) {
 				dev_err(&pdev->dev, "can't enable device\n");
-				break;
+				goto out;
 			}
 			ip2config.type[i] = PCI;
 			ip2config.pci_dev[i] = pci_dev_get(pdev);
@@ -636,6 +636,8 @@ static int __init ip2_loadmain(void)
 				dev_err(&pdev->dev, "I/O address error\n");
 
 			ip2config.irq[i] = pdev->irq;
+out:
+			pci_dev_put(pdev);
 		}
 #else
 			printk(KERN_ERR "IP2: PCI card specified but PCI "
@@ -654,7 +656,6 @@ static int __init ip2_loadmain(void)
 			break;
 		}	/* switch */
 	}	/* for */
-	pci_dev_put(pdev);
 
 	for (i = 0; i < IP2_MAX_BOARDS; ++i) {
 		if (ip2config.addr[i]) {
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

linux-next.patch
mm-fix-section-mismatch-in-memory_hotplugc.patch
moxa-remove-ifdef-module-completely.patch
ip2-remove-ifdef-module-from-ip2mainc.patch
ip2-remove-ifdef-module-from-ip2mainc-fix-2.patch
ip2-remove-ifdef-module-from-ip2mainc-fix.patch

