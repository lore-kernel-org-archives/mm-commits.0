From: akpm@linux-foundation.org
Subject: - broken-lilo-check-on-make-install.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:58:08 -0700
Message-ID: <200707312358.l6VNw8XB029527@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52021 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760515AbXHAAQ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:16:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nix.or.die@googlemail.com, ak@suse.de, hpa@zytor.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     broken lilo check on make install
has been removed from the -mm tree.  Its filename was
     broken-lilo-check-on-make-install.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: broken lilo check on make install
From: Gabriel C <nix.or.die@googlemail.com>

On make install I get the this error:

...

sh /work/crazy/linux-git/linux-2.6/arch/i386/boot/install.sh
2.6.22-g4eb6bf6b arch/i386/boot/bzImage System.map "/boot"
/work/crazy/linux-git/linux-2.6/arch/i386/boot/install.sh: line 54:
/etc/lilo/install: No such file or directory
make[1]: *** [install] Error 127

...

I don't use and don't have lilo installed on this system. The attached
patch fixes the problem for me.

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/boot/install.sh |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN arch/i386/boot/install.sh~broken-lilo-check-on-make-install arch/i386/boot/install.sh
--- a/arch/i386/boot/install.sh~broken-lilo-check-on-make-install
+++ a/arch/i386/boot/install.sh
@@ -51,4 +51,11 @@ fi
 cat $2 > $4/vmlinuz
 cp $3 $4/System.map
 
-if [ -x /sbin/lilo ]; then /sbin/lilo; else /etc/lilo/install; fi
+if [ -x /sbin/lilo ]; then
+       /sbin/lilo
+elif [ -x /etc/lilo/install ]; then
+       /etc/lilo/install
+else
+       sync
+       echo "Cannot find LILO."
+fi
_

Patches currently in -mm which might be from nix.or.die@googlemail.com are

origin.patch
fix-libata-warnings-with-config_pm=n.patch
drivers-scsi-g_ncr5380c-ncr53c400_pseudo_dma-is-not.patch
fix-drivers-scsi-fdomainc-config_pci=n-warnings.patch
