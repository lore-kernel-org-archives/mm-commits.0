From: akpm@linux-foundation.org
Subject: + appletalk-fix-sysctl-warnings.patch added to -mm tree
Date: Mon, 22 Oct 2007 12:11:25 -0700
Message-ID: <200710221911.l9MJBPQD009015@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58383 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752481AbXJVTLa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Oct 2007 15:11:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, davem@davemloft.net, nix.or.die@googlemail.com


The patch titled
     appletalk: fix sysctl warnings
has been added to the -mm tree.  Its filename is
     appletalk-fix-sysctl-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: appletalk: fix sysctl warnings
From: "Eric W. Biederman" <ebiederm@xmission.com>

modprobing appletalk on current git gives a warning in dmesg =:

sysctl table check failed: /net/appletalk .3.7 procname does not match binary path procname

It appears I made a mistake when creating my table to check up on sysctl
values.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Gabriel C <nix.or.die@googlemail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl_check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sysctl_check.c~appletalk-fix-sysctl-warnings kernel/sysctl_check.c
--- a/kernel/sysctl_check.c~appletalk-fix-sysctl-warnings
+++ a/kernel/sysctl_check.c
@@ -731,7 +731,7 @@ static struct trans_ctl_table trans_net_
 	{ NET_UNIX,		"unix",		trans_net_unix_table },
 	{ NET_IPV4,		"ipv4",		trans_net_ipv4_table },
 	{ NET_IPX,		"ipx",		trans_net_ipx_table },
-	{ NET_ATALK,		"atalk",	trans_net_atalk_table },
+	{ NET_ATALK,		"appletalk",	trans_net_atalk_table },
 	{ NET_NETROM,		"netrom",	trans_net_netrom_table },
 	{ NET_AX25,		"ax25",		trans_net_ax25_table },
 	{ NET_BRIDGE,		"bridge",	trans_net_bridge_table },
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
update-boot-spec-to-207.patch
i386-paravirt-boot-sequence.patch
kexec-add-bss-to-resource-tree.patch
appletalk-fix-sysctl-warnings.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
