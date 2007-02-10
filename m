From: akpm@linux-foundation.org
Subject: + mm-shrink-parent-dentries-when-shrinking-slab.patch added to -mm tree
Date: Fri, 09 Feb 2007 16:05:45 -0800
Message-ID: <200702100005.l1A05jBP030487@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56320 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423361AbXBJAFu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 19:05:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mszeredi@suse.cz


The patch titled
     mm: shrink parent dentries when shrinking slab
has been added to the -mm tree.  Its filename is
     mm-shrink-parent-dentries-when-shrinking-slab.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: shrink parent dentries when shrinking slab
From: Andrew Morton <akpm@linux-foundation.org>

Teach the dentry slab shrinker to aggressively shrink parent dentries when
shrinking the dentry cache.

This is done to attempt to improve the situation where the dentry slab cache
gets a lot of internal fragmentation due to pages containing directory
dentries.  It is expected that this change will cause some of those dentries
to be reaped earlier, and with less scanning.

Needs careful testing.

Cc: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/dcache.c~mm-shrink-parent-dentries-when-shrinking-slab fs/dcache.c
--- a/fs/dcache.c~mm-shrink-parent-dentries-when-shrinking-slab
+++ a/fs/dcache.c
@@ -880,7 +880,7 @@ static int shrink_dcache_memory(int nr, 
 	if (nr) {
 		if (!(gfp_mask & __GFP_FS))
 			return -1;
-		prune_dcache(nr, NULL, 0);
+		prune_dcache(nr, NULL, 1);
 	}
 	return (dentry_stat.nr_unused / 100) * sysctl_vfs_cache_pressure;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
acpi-bay-driver-warning-fix.patch
git-cifs-fix.patch
fix-warning-in-device_add_attrs.patch
git-drm.patch
git-dvb.patch
kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch
git-infiniband.patch
git-libata-all.patch
sis-warning-fixes.patch
git-libata-all-lib-iomapc-fix-for-config_pci=n.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-net.patch
git-backlight-acpi-fix.patch
git-backlight-asus-fix.patch
git-backlight-sony-fix.patch
git-sh.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block.patch
revert-x86_64-mm-msr-on-cpu.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
mm-vm_insert_pfn-tidy.patch
swiotlb-uninlinings.patch
kprobes-list-all-active-probes-in-the-system-tidy.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
revert-x86_64-mm-putreg-check.patch
fix-utrace-utrace-ptrace-compat.patch
deprecate-sa_interrupt-and-friends.patch
git-gccbug-fixup.patch
