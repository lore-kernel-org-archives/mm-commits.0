From: akpm@linux-foundation.org
Subject: + implement-file-posix-capabilities-fix.patch added to -mm tree
Date: Sat, 23 Jun 2007 09:52:29 -0700
Message-ID: <200706231652.l5NGqQtj019637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40097 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760726AbXFWQxP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 12:53:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, chrisw@sous-sol.org, jmorris@namei.org, sds@tycho.nsa.gov


The patch titled
     file capabilities: make file capabilities option EXPERIMENTAL
has been added to the -mm tree.  Its filename is
     implement-file-posix-capabilities-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: file capabilities: make file capabilities option EXPERIMENTAL
From: "Serge E. Hallyn" <serue@us.ibm.com>

Make file capabilities depend upon CONFIG_EXPERIMENTAL, as few people have
used them to date.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN security/Kconfig~implement-file-posix-capabilities-fix security/Kconfig
--- a/security/Kconfig~implement-file-posix-capabilities-fix
+++ a/security/Kconfig
@@ -81,8 +81,8 @@ config SECURITY_CAPABILITIES
 	  If you are unsure how to answer this question, answer Y.
 
 config SECURITY_FILE_CAPABILITIES
-	bool "File POSIX Capabilities"
-	depends on SECURITY=n || SECURITY_CAPABILITIES!=n
+	bool "File POSIX Capabilities (EXPERIMENTAL)"
+	depends on (SECURITY=n || SECURITY_CAPABILITIES!=n) && EXPERIMENTAL
 	default n
 	help
 	  This enables filesystem capabilities, allowing you to give
_

Patches currently in -mm which might be from serue@us.ibm.com are

implement-file-posix-capabilities.patch
implement-file-posix-capabilities-fix.patch
remove-config_uts_ns-and-config_ipc_ns.patch
user-namespace-add-the-framework.patch
user-namespace-add-unshare.patch
mm-fix-create_new_namespaces-return-value.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-basic-container-framework.patch
containersv10-basic-container-framework-fix.patch
containersv10-example-cpu-accounting-subsystem.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface.patch
containersv10-add-procfs-interface-fix.patch
containersv10-make-cpusets-a-client-of-containers.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
containersv10-simple-debug-info-subsystem.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
containersv10-support-for-automatic-userspace-release-agents.patch
