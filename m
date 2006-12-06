From: akpm@osdl.org
Subject: - s390-update-cio-documentation.patch removed from -mm tree
Date: Wed, 06 Dec 2006 14:23:44 -0800
Message-ID: <200612062223.kB6MNivO018554@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48256 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937728AbWLFWX5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 17:23:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cornelia.huck@de.ibm.com, greg@kroah.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     s390: update cio documentation
has been removed from the -mm tree.  Its filename was
     s390-update-cio-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: s390: update cio documentation
From: Cornelia Huck <cornelia.huck@de.ibm.com>

Update documentation for dynamic subchannel mapping.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/s390/driver-model.txt |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN Documentation/s390/driver-model.txt~s390-update-cio-documentation Documentation/s390/driver-model.txt
--- a/Documentation/s390/driver-model.txt~s390-update-cio-documentation
+++ a/Documentation/s390/driver-model.txt
@@ -18,11 +18,18 @@ devices/
 	   - 0.0.0002/
 	   - 0.1.0000/0.1.1234/
 	   ...
+	   - defunct/
 
 In this example, device 0815 is accessed via subchannel 0 in subchannel set 0,
 device 4711 via subchannel 1 in subchannel set 0, and subchannel 2 is a non-I/O
 subchannel. Device 1234 is accessed via subchannel 0 in subchannel set 1.
 
+The subchannel named 'defunct' does not represent any real subchannel on the
+system; it is a pseudo subchannel where disconnnected ccw devices are moved to
+if they are displaced by another ccw device becoming operational on their
+former subchannel. The ccw devices will be moved again to a proper subchannel
+if they become operational again on that subchannel.
+
 You should address a ccw device via its bus id (e.g. 0.0.4711); the device can
 be found under bus/ccw/devices/.
 
_

Patches currently in -mm which might be from cornelia.huck@de.ibm.com are

origin.patch
driver-core-per-subsystem-multithreaded-probing.patch
driver-core-dont-fail-attaching-the-device-if-it.patch
git-s390.patch
tty-switch-to-ktermios-sclp-fix.patch

