From: akpm@linux-foundation.org
Subject: + mark-net_ns-with-depends-on-namespaces.patch added to -mm tree
Date: Thu, 15 Nov 2007 16:03:12 -0800
Message-ID: <200711160003.lAG03C7g022780@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57309 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934252AbXKPAEH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 19:04:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, clg@fr.ibm.com, davem@davemloft.net, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, serue@us.ibm.com, sukadev@us.ibm.com


The patch titled
     namespaces: mark NET_NS with "depends on NAMESPACES"
has been added to the -mm tree.  Its filename is
     mark-net_ns-with-depends-on-namespaces.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: namespaces: mark NET_NS with "depends on NAMESPACES"
From: Pavel Emelyanov <xemul@openvz.org>

There's already an option controlling the net namespaces cloning code, so make
it work the same way as all the other namespaces' options.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: "David S. Miller" <davem@davemloft.net>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/Kconfig~mark-net_ns-with-depends-on-namespaces net/Kconfig
--- a/net/Kconfig~mark-net_ns-with-depends-on-namespaces
+++ a/net/Kconfig
@@ -30,7 +30,7 @@ menu "Networking options"
 config NET_NS
 	bool "Network namespace support"
 	default n
-	depends on EXPERIMENTAL && !SYSFS
+	depends on EXPERIMENTAL && !SYSFS && NAMESPACES
 	help
 	  Allow user space to create what appear to be multiple instances
 	  of the network stack.
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
git-net.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-memcgroup-fix-try_to_free-order.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcgroup-reinstate-swapoff-mod.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
add-the-namespaces-config-option.patch
move-the-uts-namespace-under-uts_ns-option.patch
move-the-ipc-namespace-under-ipc_ns-option.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
mark-net_ns-with-depends-on-namespaces.patch
reiser4.patch
