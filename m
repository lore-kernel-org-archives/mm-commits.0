From: akpm@linux-foundation.org
Subject: + fs-9p-fix-menu-presentation.patch added to -mm tree
Date: Mon, 03 Jan 2011 11:58:01 -0800
Message-ID: <201101031958.p03Jw1Ja025689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752425Ab1ACT6O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jan 2011 14:58:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, ericvh@gmail.com, lucho@ionkov.net, rminnich@sandia.gov


The patch titled
     fs/9p: fix menu presentation
has been added to the -mm tree.  Its filename is
     fs-9p-fix-menu-presentation.patch

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
Subject: fs/9p: fix menu presentation
From: Randy Dunlap <randy.dunlap@oracle.com>

Make the 9P_FS kconfig options subordinate to the 9P_FS kconfig symbol in
the menu presentation instead of them all being at the same level.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/9p/Kconfig |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/9p/Kconfig~fs-9p-fix-menu-presentation fs/9p/Kconfig
--- a/fs/9p/Kconfig~fs-9p-fix-menu-presentation
+++ a/fs/9p/Kconfig
@@ -9,6 +9,8 @@ config 9P_FS
 
 	  If unsure, say N.
 
+if 9P_FS
+
 config 9P_FSCACHE
 	bool "Enable 9P client caching support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
@@ -20,7 +22,6 @@ config 9P_FSCACHE
 
 config 9P_FS_POSIX_ACL
 	bool "9P POSIX Access Control Lists"
-	depends on 9P_FS
 	select FS_POSIX_ACL
 	help
 	  POSIX Access Control Lists (ACLs) support permissions for users and
@@ -30,3 +31,5 @@ config 9P_FS_POSIX_ACL
 	  Linux website <http://acl.bestbits.at/>.
 
 	  If you don't know what Access Control Lists are, say N
+
+endif
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
backlight-fix-88pm860x_bl-macro-collision.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
fs-9p-fix-menu-presentation.patch
uml-mmapper_kern-needs-module_license.patch
name_to_dev_t-must-not-call-__init-code.patch
kernel-clean-up-use_generic_smp_helpers.patch
kptr_restrict-fix-build-when-printk-not-enabled.patch
fs-fs_posix_acl-does-not-depend-on-block.patch
gpio_rdc321x-select-mfd_support-to-squelch-kconfig-warning.patch
gpio_vx855-eliminate-kconfig-dependency-warning.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix.patch
w1-ds2423-counter-driver-and-documentation-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

