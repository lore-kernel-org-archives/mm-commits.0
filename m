From: akpm@linux-foundation.org
Subject: - new-toplevel-target-headers_check_all.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:47:18 -0800
Message-ID: <200702150847.l1F8lI8e024971@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39899 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965348AbXBOIr2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:47:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, dwmw2@infradead.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     new toplevel target: headers_check_all
has been removed from the -mm tree.  Its filename was
     new-toplevel-target-headers_check_all.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN Makefile~new-toplevel-target-headers_check_all Makefile
--- a/Makefile~new-toplevel-target-headers_check_all
+++ a/Makefile
@@ -928,6 +928,12 @@ headers_install: include/linux/version.h
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
use-__u64-rather-than-u64-in-parisc-statfs-structs.patch
