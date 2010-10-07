From: akpm@linux-foundation.org
Subject: + namespaces-default-all-the-namespaces-to-yes-when-config_namespaces-is-selected.patch added to -mm tree
Date: Thu, 07 Oct 2010 15:45:31 -0700
Message-ID: <201010072245.o97MjV5U028908@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752943Ab0JGWpe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Oct 2010 18:45:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel.lezcano@free.fr, davem@davemloft.net, ebiederm@xmission.com


The patch titled
     namespaces: default all the namespaces to 'yes' when CONFIG_NAMESPACES is selected
has been added to the -mm tree.  Its filename is
     namespaces-default-all-the-namespaces-to-yes-when-config_namespaces-is-selected.patch

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
Subject: namespaces: default all the namespaces to 'yes' when CONFIG_NAMESPACES is selected
From: Daniel Lezcano <daniel.lezcano@free.fr>

As the different namespaces depend on 'CONFIG_NAMESPACES', it is logical
to enable all the namespaces when we enable NAMESPACES.

Signed-off-by: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN init/Kconfig~namespaces-default-all-the-namespaces-to-yes-when-config_namespaces-is-selected init/Kconfig
--- a/init/Kconfig~namespaces-default-all-the-namespaces-to-yes-when-config_namespaces-is-selected
+++ a/init/Kconfig
@@ -739,6 +739,7 @@ config NAMESPACES
 config UTS_NS
 	bool "UTS namespace"
 	depends on NAMESPACES
+	default y
 	help
 	  In this namespace tasks see different info provided with the
 	  uname() system call
@@ -746,6 +747,7 @@ config UTS_NS
 config IPC_NS
 	bool "IPC namespace"
 	depends on NAMESPACES && (SYSVIPC || POSIX_MQUEUE)
+	default y
 	help
 	  In this namespace tasks work with IPC ids which correspond to
 	  different IPC objects in different namespaces.
@@ -753,6 +755,7 @@ config IPC_NS
 config USER_NS
 	bool "User namespace (EXPERIMENTAL)"
 	depends on NAMESPACES && EXPERIMENTAL
+	default y
 	help
 	  This allows containers, i.e. vservers, to use user namespaces
 	  to provide different user info for different servers.
@@ -760,8 +763,8 @@ config USER_NS
 
 config PID_NS
 	bool "PID Namespaces"
-	default n
 	depends on NAMESPACES
+	default y
 	help
 	  Support process id namespaces.  This allows having multiple
 	  processes with the same pid as long as they are in different
@@ -769,8 +772,8 @@ config PID_NS
 
 config NET_NS
 	bool "Network namespace"
-	default n
 	depends on NAMESPACES && NET
+	default y
 	help
 	  Allow user space to create what appear to be multiple instances
 	  of the network stack.
_

Patches currently in -mm which might be from daniel.lezcano@free.fr are

linux-next.patch
cgroup-add-clone_children-control-file.patch
cgroup-make-the-mount-options-parsing-more-accurate.patch
cgroup-notify-ns_cgroup-deprecated.patch
namespaces-remove-pid_ns-and-net_ns-experimental-status.patch
namespaces-default-all-the-namespaces-to-yes-when-config_namespaces-is-selected.patch

