From: akpm@linux-foundation.org
Subject: + documentation-update-include-path-for-mpssd.patch added to -mm
 tree
Date: Fri, 03 Oct 2014 12:11:26 -0700
Message-ID: <542ef4de.svRDzeRriRgcjA9e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaJCTL0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2014 15:11:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pefoley2@pefoley.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: update include path for mpssd
has been added to the -mm tree.  Its filename is
     documentation-update-include-path-for-mpssd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-update-include-path-for-mpssd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-update-include-path-for-mpssd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
documentation-update-include-path-for-mpssd.patch

