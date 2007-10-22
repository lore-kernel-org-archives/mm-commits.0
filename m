From: akpm@linux-foundation.org
Subject: + embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch added to -mm tree
Date: Mon, 22 Oct 2007 15:50:30 -0700
Message-ID: <200710222250.l9MMoUYN019927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50676 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751442AbXJVWwZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Oct 2007 18:52:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, agk@redhat.com, agruen@suse.de, arnd@arndb.de, benh@kernel.crashing.org, bfields@fieldses.org, bharata@linux.vnet.ibm.com, davem@davemloft.net, dgc@sgi.com, dhowells@redhat.com, dwmw2@infradead.org, hch@lst.de, ink@jurassic.park.msu.ru, jack@ucw.cz, jaharkes@cs.cmu.edu, jblunck@suse.de, jdike@addtoit.com, jmorris@namei.org, kyle@mcmartin.ca, mhalcrow@us.ibm.com, neilb@suse.de, paulus@samba.org, ralf@linux-mips.org, raven@themaw.net, rth@twiddle.net, sds@tycho.nsa.gov, swhiteho@redhat.com, tes@sgi.com, trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk


The patch titled
     embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#1261: FILE: fs/namei.c:2448:
+	error = vfs_link(old_nd.path.dentry, nd.path.dentry->d_inode, new_dentry);

ERROR: need spaces around that '=' (ctx:VxV)
#2696: FILE: net/unix/af_unix.c:748:
+		u=unix_find_socket_byinode(nd.path.dentry->d_inode);
 		 ^

total: 1 errors, 1 warnings, 2369 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "David S. Miller" <davem@davemloft.net>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Andreas Gruenbacher <agruen@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Chinner <dgc@sgi.com>
Cc: David Howells <dhowells@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Ian Kent <raven@themaw.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: James Morris <jmorris@namei.org>
Cc: Jan Blunck <jblunck@suse.de>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Jan Kara <jack@ucw.cz>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Timothy Shimmin <tes@sgi.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-ext4@vger.kernel.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/unix/af_unix.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/unix/af_unix.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes net/unix/af_unix.c
--- a/net/unix/af_unix.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes
+++ a/net/unix/af_unix.c
@@ -745,7 +745,7 @@ static struct sock *unix_find_other(stru
 		err = -ECONNREFUSED;
 		if (!S_ISSOCK(nd.path.dentry->d_inode->i_mode))
 			goto mnt_drop_write_fail;
-		u=unix_find_socket_byinode(nd.path.dentry->d_inode);
+		u = unix_find_socket_byinode(nd.path.dentry->d_inode);
 		if (!u)
 			goto mnt_drop_write_fail;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic.patch
capabilities-clean-up-file-capability-reading.patch
ext2-avoid-rec_len-overflow-with-64kb-block-size.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
kexec-add-bss-to-resource-tree.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-arm-hack.patch
nf_ct_alloc_hashtable-use-__gfp_nowarn.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd-fixup.patch
fix-build-breakage-if-sysfs-fix.patch
git-scsi-misc.patch
git-unionfs.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
documentation-watchdog-src-watchdog-simplec-improve-this-code-checkpatch-fixes.patch
git-wireless.patch
git-wireless-fixup.patch
git-x86.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-detect-duplicate-names.patch
kernel-printkc-concerns-about-the-console-handover.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
sync_sb_inodes-propagate-errors.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
