From: akpm@linux-foundation.org
Subject: + broken-lilo-check-on-make-install.patch added to -mm tree
Date: Thu, 19 Jul 2007 16:49:56 -0700
Message-ID: <200707192349.l6JNnvgI029260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49590 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758830AbXGSXuI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 19:50:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nix.or.die@googlemail.com, ak@suse.de, hpa@zytor.com, sam@ravnborg.org


The patch titled
     broken lilo check on make install
has been added to the -mm tree.  Its filename is
     broken-lilo-check-on-make-install.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 8 insertions(+), 1 deletion(-)

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
broken-lilo-check-on-make-install.patch
