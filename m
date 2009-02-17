From: akpm@linux-foundation.org
Subject: + usb-fix-ehci-printk-formats.patch added to -mm tree
Date: Tue, 17 Feb 2009 15:38:28 -0800
Message-ID: <200902172338.n1HNcS6b009780@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755049AbZBQXih (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Feb 2009 18:38:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     usb: fix ehci printk formats
has been added to the -mm tree.  Its filename is
     usb-fix-ehci-printk-formats.patch

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
Subject: usb: fix ehci printk formats
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix ehci printk formats:

drivers/usb/host/ehci-q.c:351: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
drivers/usb/host/ehci-q.c:351: warning: format '%d' expects type 'int', but argument 5 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/ehci-q.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/host/ehci-q.c~usb-fix-ehci-printk-formats drivers/usb/host/ehci-q.c
--- a/drivers/usb/host/ehci-q.c~usb-fix-ehci-printk-formats
+++ a/drivers/usb/host/ehci-q.c
@@ -349,7 +349,7 @@ qh_completions (struct ehci_hcd *ehci, s
 						--qh->xacterrs > 0 &&
 						!urb->unlinked) {
 					ehci_dbg(ehci,
-	"detected XactErr len %d/%d retry %d\n",
+	"detected XactErr len %zu/%zu retry %d\n",
 	qtd->length - QTD_LENGTH(token), qtd->length,
 	QH_XACTERR_MAX - qh->xacterrs);
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
input-ad7879-touchscreen-driver.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
esp-fix-section-mismatch-warning.patch
cciss-pci-power-management-reset-for-kexec.patch
usb-fix-ehci-printk-formats.patch
vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch
vfs-further-changes-from-macro-to-inline-function-in-fsh.patch
x86-dell-laptop-depends-on-power_supply.patch
x86-oqo-depends-on-input_polldev.patch
max3100-spi-uart-driver.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch
atyfb-fix-header-file-trailing-whitespace.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-fix.patch
documentation-ignore-byproducts-from-latex.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
linuxpps-core-support.patch
linuxpps-core-support-v2.patch
reiser4-export-remove_from_page_cache-fix.patch

