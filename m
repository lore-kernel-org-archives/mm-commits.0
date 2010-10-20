From: akpm@linux-foundation.org
Subject: + namespaces-kconfig-make-namespace-a-submenu.patch added to -mm tree
Date: Wed, 20 Oct 2010 16:28:20 -0700
Message-ID: <201010202328.o9KNSK6O010926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750915Ab0JTX2a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Oct 2010 19:28:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel.lezcano@free.fr, ebiederm@xmission.com, lizf@cn.fujitsu.com, menage@google.com, serue@us.ibm.com


The patch titled
     namespaces Kconfig: make namespace a submenu
has been added to the -mm tree.  Its filename is
     namespaces-kconfig-make-namespace-a-submenu.patch

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
Subject: namespaces Kconfig: make namespace a submenu
From: Daniel Lezcano <daniel.lezcano@free.fr>

Make the namespaces config option a submenu.

Signed-off-by: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN init/Kconfig~namespaces-kconfig-make-namespace-a-submenu init/Kconfig
--- a/init/Kconfig~namespaces-kconfig-make-namespace-a-submenu
+++ a/init/Kconfig
@@ -734,7 +734,7 @@ config RELAY
 
 	  If unsure, say N.
 
-config NAMESPACES
+menuconfig NAMESPACES
 	bool "Namespaces support" if EMBEDDED
 	default !EMBEDDED
 	help
@@ -743,9 +743,10 @@ config NAMESPACES
 	  or same user id or pid may refer to different tasks when used in
 	  different namespaces.
 
+if NAMESPACES
+
 config UTS_NS
 	bool "UTS namespace"
-	depends on NAMESPACES
 	default y
 	help
 	  In this namespace tasks see different info provided with the
@@ -753,7 +754,7 @@ config UTS_NS
 
 config IPC_NS
 	bool "IPC namespace"
-	depends on NAMESPACES && (SYSVIPC || POSIX_MQUEUE)
+	depends on (SYSVIPC || POSIX_MQUEUE)
 	default y
 	help
 	  In this namespace tasks work with IPC ids which correspond to
@@ -761,7 +762,7 @@ config IPC_NS
 
 config USER_NS
 	bool "User namespace (EXPERIMENTAL)"
-	depends on NAMESPACES && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	default y
 	help
 	  This allows containers, i.e. vservers, to use user namespaces
@@ -770,7 +771,6 @@ config USER_NS
 
 config PID_NS
 	bool "PID Namespaces"
-	depends on NAMESPACES
 	default y
 	help
 	  Support process id namespaces.  This allows having multiple
@@ -779,12 +779,14 @@ config PID_NS
 
 config NET_NS
 	bool "Network namespace"
-	depends on NAMESPACES && NET
+	depends on NET
 	default y
 	help
 	  Allow user space to create what appear to be multiple instances
 	  of the network stack.
 
+endif # NAMESPACES
+
 config BLK_DEV_INITRD
 	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
 	depends on BROKEN || !FRV
_

Patches currently in -mm which might be from daniel.lezcano@free.fr are

linux-next.patch
cgroup-add-clone_children-control-file.patch
cgroup-make-the-mount-options-parsing-more-accurate.patch
cgroup-notify-ns_cgroup-deprecated.patch
namespaces-remove-pid_ns-and-net_ns-experimental-status.patch
namespaces-default-all-the-namespaces-to-yes-when-config_namespaces-is-selected.patch
namespaces-kconfig-make-namespace-a-submenu.patch
namespaces-kconfig-remove-pointless-cgroup-dependency.patch
namespaces-kconfig-remove-the-cgroup-device-whitelist-experimental-tag.patch
namespaces-kconfig-move-namespace-menu-location-after-the-cgroup.patch

