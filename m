From: akpm@linux-foundation.org
Subject: + net-ipv4-ip_outputc-ip_send_check-mustnt-be-inline.patch added to -mm tree
Date: Tue, 29 Apr 2008 16:37:54 -0700
Message-ID: <200804292337.m3TNbsmx016008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754654AbYD2XiO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 19:38:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, davem@davemloft.net


The patch titled
     net/ipv4/ip_output.c:ip_send_check() mustn't be inline
has been added to the -mm tree.  Its filename is
     net-ipv4-ip_outputc-ip_send_check-mustnt-be-inline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net/ipv4/ip_output.c:ip_send_check() mustn't be inline
From: Adrian Bunk <bunk@kernel.org>

Fix the following build error with UML and gcc 4.3:

/home/bunk/linux/kernel-2.6/git/linux-2.6/net/ipv4/ip_output.c: In function `__ip_local_out':
/home/bunk/linux/kernel-2.6/git/linux-2.6/net/ipv4/ip_output.c:89: sorry, unimplemented: inlining failed in call to `ip_send_check': function body not available
/home/bunk/linux/kernel-2.6/git/linux-2.6/net/ipv4/ip_output.c:99: sorry, unimplemented: called from here

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/ip_output.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/ipv4/ip_output.c~net-ipv4-ip_outputc-ip_send_check-mustnt-be-inline net/ipv4/ip_output.c
--- a/net/ipv4/ip_output.c~net-ipv4-ip_outputc-ip_send_check-mustnt-be-inline
+++ a/net/ipv4/ip_output.c
@@ -85,7 +85,7 @@
 int sysctl_ip_default_ttl __read_mostly = IPDEFTTL;
 
 /* Generate a checksum for an outgoing IP datagram. */
-__inline__ void ip_send_check(struct iphdr *iph)
+void ip_send_check(struct iphdr *iph)
 {
 	iph->check = 0;
 	iph->check = ip_fast_csum((unsigned char *)iph, iph->ihl);
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
fs-ramfs-extern-cleanup.patch
fs-hfsplus-proper-externs.patch
fs-freevxfs-proper-externs.patch
make-__put_super-static.patch
make-vfs_ioctl-static.patch
fs-fs-writeback-make-2-functions-static.patch
fs-drop_cachesc-make-2-functions-static.patch
fs-aioc-make-3-functions-static.patch
let-log_buf_shift-default-to-17.patch
fs-timerfdc-should-include-linux-syscallsh.patch
remove-generic_commit_write.patch
make-fs-bufferccont_expand_zero-static.patch
make-binfmt_flat-a-bool.patch
remove-mca_is_adapter_used.patch
ipwireless-remove-dead-code.patch
proper-__do_softirq-prototype.patch
proper-extern-for-late_time_init.patch
remove-ecryptfs_header_cache_0.patch
make-cgroup_enable_task_cg_lists-static.patch
cgroups-kernel-ns_cgroupc-should-include-linux-nsproxyh.patch
kernel-cpusetc-make-3-functions-static.patch
ipmi-make-alloc_recv_msg-static.patch
ipmi-fix-return-from-atca_oem_poweroff_hook.patch
include-linux-sysctlh-remove-empty-else.patch
remove-aoedev_isbusy.patch
edac-remove-unneeded-functions-and-add-static-accessor.patch
mm-filemapc-generic_write_checks-mustnt-be-inline.patch
fs-block_devc-i_bdev-mustnt-be-inline.patch
block-blk-barrierc-blk_ordered_cur_seq-mustnt-be-inline.patch
git-acpi.patch
arch-x86-video-fbdevc-add-module_license.patch
git-m32r.patch
net-ipv4-ip_outputc-ip_send_check-mustnt-be-inline.patch
git-nfsd.patch
git-ocfs2.patch
git-pci.patch
show_schedstat-fix-memleak.patch
git-sh.patch
if-0-ses_match_host.patch
git-watchdog.patch
make-marker_debug-static.patch
reiser4.patch

