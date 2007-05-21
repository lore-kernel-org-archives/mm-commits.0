From: akpm@linux-foundation.org
Subject: + add-pci_try_set_mwi-prism54pci.patch added to -mm tree
Date: Mon, 21 May 2007 15:22:30 -0700
Message-ID: <200705212222.l4LMMUMC021398@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40378 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758574AbXEUW0a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 18:26:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com


The patch titled
     add pci_try_set_mwi
has been added to the -mm tree.  Its filename is
     add-pci_try_set_mwi-prism54pci.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add pci_try_set_mwi
From: Randy Dunlap <randy.dunlap@oracle.com>

As suggested by Andrew, add pci_try_set_mwi(), which does not require
return-value checking.

- add pci_try_set_mwi() without __must_check
- make it return 0 on success, errno if the "try" failed or error
- review callers

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/mac80211/p54/prism54pci.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wireless/mac80211/p54/prism54pci.c~add-pci_try_set_mwi-prism54pci drivers/net/wireless/mac80211/p54/prism54pci.c
--- a/drivers/net/wireless/mac80211/p54/prism54pci.c~add-pci_try_set_mwi-prism54pci
+++ a/drivers/net/wireless/mac80211/p54/prism54pci.c
@@ -540,7 +540,7 @@ static int __devinit p54p_probe(struct p
 	}
 
 	pci_set_master(pdev);
-	pci_set_mwi(pdev);
+	pci_try_set_mwi(pdev);
 
 	pci_write_config_byte(pdev, 0x40, 0);
 	pci_write_config_byte(pdev, 0x41, 0);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
romfs-printk-format-warnings.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
add-pci_try_set_mwi-prism54pci.patch
git-ipwireless_cs.patch
documentation-fix-the-explanation-of-kconfig-files.patch
update-dontdiff-file.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-kstrndup.patch
add-argv_split.patch
add-argv_split-fix.patch
split-usermodehelper-setup-from-execution.patch
add-common-orderly_poweroff.patch
add-common-orderly_poweroff-fix.patch
tidy-up-usermode-helper-waiting-a-bit.patch
profile-likely-unlikely-macros.patch
