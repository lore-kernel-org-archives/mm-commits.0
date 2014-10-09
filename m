From: akpm@linux-foundation.org
Subject: [merged] documentation-update-include-path-for-mpssd.patch
 removed from -mm tree
Date: Thu, 09 Oct 2014 11:21:58 -0700
Message-ID: <5436d246.QWqQniU8SwxEmv/V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaJISV6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 14:21:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pefoley2@pefoley.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: update include path for mpssd
has been removed from the -mm tree.  Its filename was
     documentation-update-include-path-for-mpssd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Foley <pefoley2@pefoley.com>
Subject: Documentation: update include path for mpssd

sysfs.c includes mpssd.h which includes virtio_ids.h.
sysfs.c doesn't have the proper include flags set to use the latest
headers, so this causes a build error if the system headers are too old.

Signed-off-by: Peter Foley <pefoley2@pefoley.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mic/mpssd/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/mic/mpssd/Makefile~documentation-update-include-path-for-mpssd Documentation/mic/mpssd/Makefile
--- a/Documentation/mic/mpssd/Makefile~documentation-update-include-path-for-mpssd
+++ a/Documentation/mic/mpssd/Makefile
@@ -6,7 +6,7 @@ mpssd-objs := mpssd.o sysfs.o
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
 
-HOSTCFLAGS_mpssd.o += -I$(objtree)/usr/include -I$(srctree)/tools/include
+HOSTCFLAGS += -I$(objtree)/usr/include -I$(srctree)/tools/include
 
 ifdef DEBUG
 HOSTCFLAGS += -DDEBUG=$(DEBUG)
_

Patches currently in -mm which might be from pefoley2@pefoley.com are

origin.patch
linux-next.patch

