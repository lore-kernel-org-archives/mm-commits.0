From: akpm@linux-foundation.org
Subject: + add-reset_devices-to-the-recommended-parameters.patch added to -mm tree
Date: Sat, 15 Sep 2007 01:18:43 -0700
Message-ID: <200709150818.l8F8Ihmf025011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51216 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752425AbXIOISw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 15 Sep 2007 04:18:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, ebiederm@xmission.com, hbabu@us.ibm.com, rdunlap@xenotime.net, vgoyal@in.ibm.com


The patch titled
     Add reset_devices to the recommended parameters
has been added to the -mm tree.  Its filename is
     add-reset_devices-to-the-recommended-parameters.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add reset_devices to the recommended parameters
From: Bernhard Walle <bwalle@suse.de>

This patch adds the "reset_devices" option (that's used only by one device
driver for now) to the recommended list of command line parameters for kdump.

Meaning (Documentation/kernel-parameters.txt):
    reset_devices   [KNL] Force drivers to reset the underlying device
                    during initialization.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Haren Myneni <hbabu@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kdump/kdump.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/kdump/kdump.txt~add-reset_devices-to-the-recommended-parameters Documentation/kdump/kdump.txt
--- a/Documentation/kdump/kdump.txt~add-reset_devices-to-the-recommended-parameters
+++ a/Documentation/kdump/kdump.txt
@@ -292,10 +292,10 @@ Following are the arch specific command 
 loading dump-capture kernel.
 
 For i386, x86_64 and ia64:
-	"1 irqpoll maxcpus=1"
+	"1 irqpoll maxcpus=1 reset_devices"
 
 For ppc64:
-	"1 maxcpus=1 noirqdistrib"
+	"1 maxcpus=1 noirqdistrib reset_devices"
 
 
 Notes on loading the dump-capture kernel:
_

Patches currently in -mm which might be from bwalle@suse.de are

add-vmcoreinfo.patch
express-relocatability-of-kernel-on-x86_64-in-documentation.patch
express-relocatability-of-kernel-on-x86_64-in.patch
express-new-elf32-mechanisms-in-documentation.patch
add-reset_devices-to-the-recommended-parameters.patch
