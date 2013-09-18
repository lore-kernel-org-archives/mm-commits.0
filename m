From: akpm@linux-foundation.org
Subject: + cramfs-mark-as-obsolete.patch added to -mm tree
Date: Wed, 18 Sep 2013 14:02:05 -0700
Message-ID: <523a14cd.Ng/VNiKB1yDL7dnE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab3IRVCG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Sep 2013 17:02:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, michael.opdenacker@free-electrons.com

Subject: + cramfs-mark-as-obsolete.patch added to -mm tree
To: michael.opdenacker@free-electrons.com
From: akpm@linux-foundation.org
Date: Wed, 18 Sep 2013 14:02:05 -0700


The patch titled
     Subject: cramfs: mark as obsolete
has been added to the -mm tree.  Its filename is
     cramfs-mark-as-obsolete.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cramfs-mark-as-obsolete.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cramfs-mark-as-obsolete.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: cramfs: mark as obsolete

Who needs cramfs when you have squashfs?  At least, we should warn people
that cramfs is obsolete.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS       |    2 +-
 fs/cramfs/Kconfig |    5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~cramfs-mark-as-obsolete MAINTAINERS
--- a/MAINTAINERS~cramfs-mark-as-obsolete
+++ a/MAINTAINERS
@@ -2355,7 +2355,7 @@ F:	kernel/cpuset.c
 
 CRAMFS FILESYSTEM
 W:	http://sourceforge.net/projects/cramfs/
-S:	Orphan
+S:	Orphan / Obsolete
 F:	Documentation/filesystems/cramfs.txt
 F:	fs/cramfs/
 
diff -puN fs/cramfs/Kconfig~cramfs-mark-as-obsolete fs/cramfs/Kconfig
--- a/fs/cramfs/Kconfig~cramfs-mark-as-obsolete
+++ a/fs/cramfs/Kconfig
@@ -1,5 +1,5 @@
 config CRAMFS
-	tristate "Compressed ROM file system support (cramfs)"
+	tristate "Compressed ROM file system support (cramfs) (OBSOLETE)"
 	depends on BLOCK
 	select ZLIB_INFLATE
 	help
@@ -16,4 +16,7 @@ config CRAMFS
 	  cramfs.  Note that the root file system (the one containing the
 	  directory /) cannot be compiled as a module.
 
+	  This filesystem is obsoleted by SquashFS, which is much better
+  	  in terms of performance and features.
+
 	  If unsure, say N.
_

Patches currently in -mm which might be from michael.opdenacker@free-electrons.com are

linux-next.patch
cramfs-mark-as-obsolete.patch

