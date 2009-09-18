From: akpm@linux-foundation.org
Subject: + pcmcia-fix-controller-printk-warnings.patch added to -mm tree
Date: Fri, 18 Sep 2009 14:35:24 -0700
Message-ID: <200909182135.n8ILZOrb001806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752068AbZIRVgI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Sep 2009 17:36:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, greg@kroah.com, w.sang@pengutronix.de


The patch titled
     pcmcia: fix controller printk warnings
has been added to the -mm tree.  Its filename is
     pcmcia-fix-controller-printk-warnings.patch

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
Subject: pcmcia: fix controller printk warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix new pcmcia printk format warnings:

drivers/pcmcia/i82365.c:1055: warning: format '%#x' expects type 'unsigned int', but argument 6 has type 'phys_addr_t'
drivers/pcmcia/i82365.c:1055: warning: format '%#x' expects type 'unsigned int', but argument 7 has type 'phys_addr_t'
drivers/pcmcia/tcic.c:734: warning: format '%#x' expects type 'unsigned int', but argument 6 has type 'phys_addr_t'
drivers/pcmcia/tcic.c:734: warning: format '%#x' expects type 'unsigned int', but argument 7 has type 'phys_addr_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/i82365.c |    4 ++--
 drivers/pcmcia/tcic.c   |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/pcmcia/i82365.c~pcmcia-fix-controller-printk-warnings drivers/pcmcia/i82365.c
--- a/drivers/pcmcia/i82365.c~pcmcia-fix-controller-printk-warnings
+++ a/drivers/pcmcia/i82365.c
@@ -1053,8 +1053,8 @@ static int i365_set_io_map(u_short sock,
     u_char map, ioctl;
     
     debug(1, "SetIOMap(%d, %d, %#2.2x, %d ns, "
-	  "%#x-%#x)\n", sock, io->map, io->flags,
-	  io->speed, io->start, io->stop);
+	  "%#llx-%#llx)\n", sock, io->map, io->flags, io->speed,
+	  (unsigned long long)io->start, (unsigned long long)io->stop);
     map = io->map;
     if ((map > 1) || (io->start > 0xffff) || (io->stop > 0xffff) ||
 	(io->stop < io->start)) return -EINVAL;
diff -puN drivers/pcmcia/tcic.c~pcmcia-fix-controller-printk-warnings drivers/pcmcia/tcic.c
--- a/drivers/pcmcia/tcic.c~pcmcia-fix-controller-printk-warnings
+++ a/drivers/pcmcia/tcic.c
@@ -732,8 +732,8 @@ static int tcic_set_io_map(struct pcmcia
     u_short base, len, ioctl;
     
     debug(1, "SetIOMap(%d, %d, %#2.2x, %d ns, "
-	  "%#x-%#x)\n", psock, io->map, io->flags,
-	  io->speed, io->start, io->stop);
+	  "%#llx-%#llx)\n", psock, io->map, io->flags, io->speed,
+	  (unsigned long long)io->start, (unsigned long long)io->stop);
     if ((io->map > 1) || (io->start > 0xffff) || (io->stop > 0xffff) ||
 	(io->stop < io->start)) return -EINVAL;
     tcic_setw(TCIC_ADDR+2, TCIC_ADR2_INDREG | (psock << TCIC_SS_SHFT));
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
kernel-hacking-move-strip_asm_syms-from-general.patch
isdn-fix-netjet-build-errors.patch
include-linux-credh-fix-build.patch
scsi-fix-func-names-in-kernel-doc.patch
cciss-fix-schedule_timeout-parameters.patch
wl12xx-fix-kconfig-link-errors.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
page_alloc-fix-kernel-doc-warning.patch
ksm-add-some-documentation.patch
pcmcia-fix-controller-printk-warnings.patch
flex_array-add-missing-kerneldoc-annotations.patch
lis3-add-power-management-functions-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
kcore-register-vmemmap-range-fix.patch
spih-add-missing-kernel-doc-for-struct-spi_master.patch
gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-fix.patch
doc-filesystems-remove-smount-program.patch
doc-filesystems-more-mount-cleanups.patch
documentation-update-stale-definition-of-file-nr-in-fstxt.patch
includecheck-fix-documentation-cfag12864b-examplec.patch
docs-fix-various-documentation-paths-in-header-files.patch
reiser4-export-remove_from_page_cache-fix.patch

