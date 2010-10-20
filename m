From: akpm@linux-foundation.org
Subject: + namespaces-kconfig-move-namespace-menu-location-after-the-cgroup.patch added to -mm tree
Date: Wed, 20 Oct 2010 16:28:26 -0700
Message-ID: <201010202328.o9KNSQuf010935@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750975Ab0JTX2h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Oct 2010 19:28:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel.lezcano@free.fr, ebiederm@xmission.com, lizf@cn.fujitsu.com, menage@google.com, serue@us.ibm.com


The patch titled
     namespaces Kconfig: move namespace menu location after the cgroup
has been added to the -mm tree.  Its filename is
     namespaces-kconfig-move-namespace-menu-location-after-the-cgroup.patch

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
Subject: namespaces Kconfig: move namespace menu location after the cgroup
From: Daniel Lezcano <daniel.lezcano@free.fr>

We have the namespaces as a menuconfig like the cgroup.  The cgroup and
the namespace are two base bricks for the containers.

It is more logical to put the namespace menu right after the cgroup menu.

Signed-off-by: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |  104 ++++++++++++++++++++++++-------------------------
 1 file changed, 52 insertions(+), 52 deletions(-)

diff -puN init/Kconfig~namespaces-kconfig-move-namespace-menu-location-after-the-cgroup init/Kconfig
--- a/init/Kconfig~namespaces-kconfig-move-namespace-menu-location-after-the-cgroup
+++ a/init/Kconfig
@@ -675,58 +675,6 @@ config DEBUG_BLK_CGROUP
 
 endif # CGROUPS
 
-config MM_OWNER
-	bool
-
-config SYSFS_DEPRECATED
-	bool "enable deprecated sysfs features to support old userspace tools"
-	depends on SYSFS
-	default n
-	help
-	  This option adds code that switches the layout of the "block" class
-	  devices, to not show up in /sys/class/block/, but only in
-	  /sys/block/.
-
-	  This switch is only active when the sysfs.deprecated=1 boot option is
-	  passed or the SYSFS_DEPRECATED_V2 option is set.
-
-	  This option allows new kernels to run on old distributions and tools,
-	  which might get confused by /sys/class/block/. Since 2007/2008 all
-	  major distributions and tools handle this just fine.
-
-	  Recent distributions and userspace tools after 2009/2010 depend on
-	  the existence of /sys/class/block/, and will not work with this
-	  option enabled.
-
-	  Only if you are using a new kernel on an old distribution, you might
-	  need to say Y here.
-
-config SYSFS_DEPRECATED_V2
-	bool "enabled deprecated sysfs features by default"
-	default n
-	depends on SYSFS
-	depends on SYSFS_DEPRECATED
-	help
-	  Enable deprecated sysfs by default.
-
-	  See the CONFIG_SYSFS_DEPRECATED option for more details about this
-	  option.
-
-	  Only if you are using a new kernel on an old distribution, you might
-	  need to say Y here. Even then, odds are you would not need it
-	  enabled, you can always pass the boot option if absolutely necessary.
-
-config RELAY
-	bool "Kernel->user space relay support (formerly relayfs)"
-	help
-	  This option enables support for relay interface support in
-	  certain file systems (such as debugfs).
-	  It is designed to provide an efficient mechanism for tools and
-	  facilities to relay large amounts of data from kernel space to
-	  user space.
-
-	  If unsure, say N.
-
 menuconfig NAMESPACES
 	bool "Namespaces support" if EMBEDDED
 	default !EMBEDDED
@@ -780,6 +728,58 @@ config NET_NS
 
 endif # NAMESPACES
 
+config MM_OWNER
+	bool
+
+config SYSFS_DEPRECATED
+	bool "enable deprecated sysfs features to support old userspace tools"
+	depends on SYSFS
+	default n
+	help
+	  This option adds code that switches the layout of the "block" class
+	  devices, to not show up in /sys/class/block/, but only in
+	  /sys/block/.
+
+	  This switch is only active when the sysfs.deprecated=1 boot option is
+	  passed or the SYSFS_DEPRECATED_V2 option is set.
+
+	  This option allows new kernels to run on old distributions and tools,
+	  which might get confused by /sys/class/block/. Since 2007/2008 all
+	  major distributions and tools handle this just fine.
+
+	  Recent distributions and userspace tools after 2009/2010 depend on
+	  the existence of /sys/class/block/, and will not work with this
+	  option enabled.
+
+	  Only if you are using a new kernel on an old distribution, you might
+	  need to say Y here.
+
+config SYSFS_DEPRECATED_V2
+	bool "enabled deprecated sysfs features by default"
+	default n
+	depends on SYSFS
+	depends on SYSFS_DEPRECATED
+	help
+	  Enable deprecated sysfs by default.
+
+	  See the CONFIG_SYSFS_DEPRECATED option for more details about this
+	  option.
+
+	  Only if you are using a new kernel on an old distribution, you might
+	  need to say Y here. Even then, odds are you would not need it
+	  enabled, you can always pass the boot option if absolutely necessary.
+
+config RELAY
+	bool "Kernel->user space relay support (formerly relayfs)"
+	help
+	  This option enables support for relay interface support in
+	  certain file systems (such as debugfs).
+	  It is designed to provide an efficient mechanism for tools and
+	  facilities to relay large amounts of data from kernel space to
+	  user space.
+
+	  If unsure, say N.
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

