From: akpm@linux-foundation.org
Subject: + asiliantfb-fix-cmap-memory-leaks-fix.patch added to -mm tree
Date: Thu, 19 Feb 2009 13:52:41 -0800
Message-ID: <200902192152.n1JLqfCU025373@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757684AbZBSVxl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 16:53:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, dilinger@debian.org, krzysztof.h1@wp.pl


The patch titled
     asiliantfb: fix ISO declaration/code warning
has been added to the -mm tree.  Its filename is
     asiliantfb-fix-cmap-memory-leaks-fix.patch

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
Subject: asiliantfb: fix ISO declaration/code warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Move data declaration before any code:

drivers/video/asiliantfb.c:515: warning: ISO C90 forbids mixed declarations and code

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Andres Salomon <dilinger@debian.org>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/asiliantfb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/asiliantfb.c~asiliantfb-fix-cmap-memory-leaks-fix drivers/video/asiliantfb.c
--- a/drivers/video/asiliantfb.c~asiliantfb-fix-cmap-memory-leaks-fix
+++ a/drivers/video/asiliantfb.c
@@ -507,12 +507,13 @@ static struct fb_var_screeninfo asiliant
 
 static int __devinit init_asiliant(struct fb_info *p, unsigned long addr)
 {
+	int err;
+
 	p->fix			= asiliantfb_fix;
 	p->fix.smem_start	= addr;
 	p->var			= asiliantfb_var;
 	p->fbops		= &asiliantfb_ops;
 	p->flags		= FBINFO_DEFAULT;
-	int err;
 
 	err = fb_alloc_cmap(&p->cmap, 256, 0);
 	if (err) {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
x86-oqo-depends-on-input_polldev.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
input-ad7879-touchscreen-driver.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
esp-fix-section-mismatch-warning.patch
vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch
vfs-further-changes-from-macro-to-inline-function-in-fsh.patch
max3100-spi-uart-driver.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems-99.patch
atyfb-fix-header-file-trailing-whitespace.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-fix.patch
asiliantfb-fix-cmap-memory-leaks-fix.patch
documentation-ignore-byproducts-from-latex.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
linuxpps-core-support.patch
linuxpps-core-support-v2.patch
reiser4-export-remove_from_page_cache-fix.patch

