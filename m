From: akpm@osdl.org
Subject: + new-toplevel-target-headers_check_all.patch added to -mm tree
Date: Mon, 29 Jan 2007 18:45:49 -0800
Message-ID: <200701300245.l0U2jn3w007295@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39015 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbXA3CqJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 21:46:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, dwmw2@infradead.org, sam@ravnborg.org


The patch titled
     new toplevel target: headers_check_all
has been added to the -mm tree.  Its filename is
     new-toplevel-target-headers_check_all.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: new toplevel target: headers_check_all
From: Mike Frysinger <vapier@gentoo.org>

Add new headers_check_all target for checking all arches in one go.

Useful for distros (and people with too much time on their hands) that support
a ton of architectures, headers_check_all is to headers_check as
headers_install_all is to headers_install

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Makefile |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN Makefile~new-toplevel-target-headers_check_all Makefile
--- a/Makefile~new-toplevel-target-headers_check_all
+++ a/Makefile
@@ -936,6 +936,12 @@ headers_install: include/linux/version.h
 	$(Q)$(MAKE) $(build)=scripts scripts/unifdef
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.headersinst obj=include
 
+PHONY += headers_check_all
+headers_check_all: headers_install_all
+	$(Q)for arch in $(HDRARCHES); do \
+	 $(MAKE) ARCH=$$arch -f $(srctree)/scripts/Makefile.headersinst obj=include BIASMDIR=-bi-$$arch HDRCHECK=1 ;\
+	 done
+
 PHONY += headers_check
 headers_check: headers_install
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.headersinst obj=include HDRCHECK=1
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
use-__u8-__u32-in-userspace-ioctl-defines-for-i2o.patch
use-__u8-rather-than-u8-in-userspace-size-defines-in-hdregh.patch
translate-dashes-in-filenames-for-headers-install.patch
search-a-little-harder-for-mkimage.patch
new-toplevel-target-headers_check_all.patch
use-__u64-rather-than-u64-in-parisc-statfs-structs.patch
use-__u32-rather-than-u32-in-userspace-ioctls-in-usbdevice_fsh.patch
use-__u32-in-asm-x86_64-msrh.patch
some-rtc-documentation-updates.patch
