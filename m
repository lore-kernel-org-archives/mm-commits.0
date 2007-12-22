From: akpm@linux-foundation.org
Subject: + aoe-clean-up-udev-configuration-example.patch added to -mm tree
Date: Fri, 21 Dec 2007 22:03:46 -0800
Message-ID: <200712220603.lBM63kWb020113@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49204 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752407AbXLVGDt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Dec 2007 01:03:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com, greg@kroah.com


The patch titled
     aoe: clean up udev configuration example
has been added to the -mm tree.  Its filename is
     aoe-clean-up-udev-configuration-example.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aoe: clean up udev configuration example
From: "Ed L. Cashin" <ecashin@coraid.com>

This patch adds a known default location for the udev configuration file and
uses the more recent "==" syntax for SUBSYSTEM and KERNEL.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/aoe/udev-install.sh |    5 ++++-
 Documentation/aoe/udev.txt        |   15 ++++++++-------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff -puN Documentation/aoe/udev-install.sh~aoe-clean-up-udev-configuration-example Documentation/aoe/udev-install.sh
--- a/Documentation/aoe/udev-install.sh~aoe-clean-up-udev-configuration-example
+++ a/Documentation/aoe/udev-install.sh
@@ -23,7 +23,10 @@ fi
 # /etc/udev/rules.d
 #
 rules_d="`sed -n '/^udev_rules=/{ s!udev_rules=!!; s!\"!!g; p; }' $conf`"
-if test -z "$rules_d" || test ! -d "$rules_d"; then
+if test -z "$rules_d" ; then
+	rules_d=/etc/udev/rules.d
+fi
+if test ! -d "$rules_d"; then
 	echo "$me Error: cannot find udev rules directory" 1>&2
 	exit 1
 fi
diff -puN Documentation/aoe/udev.txt~aoe-clean-up-udev-configuration-example Documentation/aoe/udev.txt
--- a/Documentation/aoe/udev.txt~aoe-clean-up-udev-configuration-example
+++ a/Documentation/aoe/udev.txt
@@ -1,6 +1,7 @@
 # These rules tell udev what device nodes to create for aoe support.
-# They may be installed along the following lines (adjusted to what
-# you see on your system).
+# They may be installed along the following lines.  Check the section
+# 8 udev manpage to see whether your udev supports SUBSYSTEM, and
+# whether it uses one or two equal signs for SUBSYSTEM and KERNEL.
 # 
 #   ecashin@makki ~$ su
 #   Password:
@@ -15,10 +16,10 @@
 #  
 
 # aoe char devices
-SUBSYSTEM="aoe", KERNEL="discover",	NAME="etherd/%k", GROUP="disk", MODE="0220"
-SUBSYSTEM="aoe", KERNEL="err",		NAME="etherd/%k", GROUP="disk", MODE="0440"
-SUBSYSTEM="aoe", KERNEL="interfaces",	NAME="etherd/%k", GROUP="disk", MODE="0220"
-SUBSYSTEM="aoe", KERNEL="revalidate",	NAME="etherd/%k", GROUP="disk", MODE="0220"
+SUBSYSTEM=="aoe", KERNEL=="discover",	NAME="etherd/%k", GROUP="disk", MODE="0220"
+SUBSYSTEM=="aoe", KERNEL=="err",	NAME="etherd/%k", GROUP="disk", MODE="0440"
+SUBSYSTEM=="aoe", KERNEL=="interfaces",	NAME="etherd/%k", GROUP="disk", MODE="0220"
+SUBSYSTEM=="aoe", KERNEL=="revalidate",	NAME="etherd/%k", GROUP="disk", MODE="0220"
 
 # aoe block devices     
-KERNEL="etherd*",       NAME="%k", GROUP="disk"
+KERNEL=="etherd*",       NAME="%k", GROUP="disk"
_

Patches currently in -mm which might be from ecashin@coraid.com are

aoe-bring-driver-version-number-to-47.patch
aoe-handle-multiple-network-paths-to-aoe-device.patch
aoe-mac_addr-avoid-64-bit-arch-compiler-warnings.patch
aoe-clean-up-udev-configuration-example.patch
aoe-eliminate-goto-and-improve-readability.patch
aoe-user-can-ask-driver-to-forget-previously-detected-devices.patch
aoe-dynamically-allocate-a-capped-number-of-skbs-when-necessary.patch
aoe-only-install-new-aoe-device-once.patch
aoe-add-module-parameter-for-users-who-need-more-outstanding-i-o.patch
aoe-the-aoeminor-doesnt-need-a-long-format.patch
aoe-make-error-messages-more-specific.patch
aoe-update-copyright-date.patch
aoe-statically-initialise-devlist_lock.patch
