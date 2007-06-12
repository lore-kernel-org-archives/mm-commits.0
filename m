From: akpm@linux-foundation.org
Subject: + add-werror-implicit-function-declaration.patch added to -mm tree
Date: Tue, 12 Jun 2007 15:40:48 -0700
Message-ID: <200706122244.l5CMiTaA022905@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47898 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753295AbXFLWop (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 18:44:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com, sam@ravnborg.org


The patch titled
     Add -Werror-implicit-function-declaration
has been added to the -mm tree.  Its filename is
     add-werror-implicit-function-declaration.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add -Werror-implicit-function-declaration
From: Dave Jones <davej@redhat.com>

Add -Werror-implicit-function-declaration
This makes builds fail sooner if something is implicitly defined instead
of having to wait half an hour for it to fail at the linking stage.

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN Makefile~add-werror-implicit-function-declaration Makefile
--- a/Makefile~add-werror-implicit-function-declaration
+++ a/Makefile
@@ -313,7 +313,8 @@ LINUXINCLUDE    := -Iinclude \
 CPPFLAGS        := -D__KERNEL__ $(LINUXINCLUDE)
 
 CFLAGS          := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
-                   -fno-strict-aliasing -fno-common
+		   -fno-strict-aliasing -fno-common \
+		   -Werror-implicit-function-declaration
 AFLAGS          := -D__ASSEMBLY__
 
 # Read KERNELRELEASE from include/config/kernel.release (if it exists)
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
git-alsa.patch
git-cpufreq.patch
git-netdev-all.patch
i386-remove-support-for-the-rise-cpu.patch
fix-up-codingstyle-in-isofs.patch
undeprecate-raw-driver.patch
fix-typo-in-prefetchh.patch
allow-softlockup-to-be-runtime-disabled.patch
add-werror-implicit-function-declaration.patch
