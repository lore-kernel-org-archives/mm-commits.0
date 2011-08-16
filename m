From: akpm@linux-foundation.org
Subject: + docs-sysfs-specify-abi-documentation-requirements.patch added to -mm tree
Date: Tue, 16 Aug 2011 12:56:29 -0700
Message-ID: <201108161956.p7GJuTTi021775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751734Ab1HPUF6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 16:05:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bvanassche@acm.org, gregkh@suse.de, rdunlap@xenotime.net


The patch titled
     docs/sysfs: specify ABI documentation requirements
has been added to the -mm tree.  Its filename is
     docs-sysfs-specify-abi-documentation-requirements.patch

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
Subject: docs/sysfs: specify ABI documentation requirements
From: Bart Van Assche <bvanassche@acm.org>

Although it is expected nowadays that every new sysfs attribute is
documented under Documentation/ABI, this is not yet mentioned in the
kernel documentation.  This patch adds a note in the sysfs documentation
about that requirement.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/sysfs.txt |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN Documentation/filesystems/sysfs.txt~docs-sysfs-specify-abi-documentation-requirements Documentation/filesystems/sysfs.txt
--- a/Documentation/filesystems/sysfs.txt~docs-sysfs-specify-abi-documentation-requirements
+++ a/Documentation/filesystems/sysfs.txt
@@ -4,7 +4,7 @@ sysfs - _The_ filesystem for exporting k
 Patrick Mochel	<mochel@osdl.org>
 Mike Murphy <mamurph@cs.clemson.edu>
 
-Revised:    15 July 2010
+Revised:    16 August 2011
 Original:   10 January 2003
 
 
@@ -370,3 +370,11 @@ int driver_create_file(struct device_dri
 void driver_remove_file(struct device_driver *, const struct driver_attribute *);
 
 
+Documentation
+~~~~~~~~~~~~~
+
+The sysfs directory structure and the attributes in each directory define an
+ABI between the kernel and user space. As for any ABI, it is important that
+this ABI is stable and properly documented. All new sysfs attributes must be
+documented in Documentation/ABI. See also Documentation/ABI/README for more
+information.
_

Patches currently in -mm which might be from bvanassche@acm.org are

docs-sysfs-specify-abi-documentation-requirements.patch

