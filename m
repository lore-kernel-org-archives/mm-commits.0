From: akpm@linux-foundation.org
Subject: +
 scripts-coccinelle-misc-bugoncocci-update-bug_on-conversion-warning.patch
 added to -mm tree
Date: Thu, 09 Apr 2015 14:02:14 -0700
Message-ID: <5526e8d6.9veB54x9Dk0hD9Xt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421AbbDIVCP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2015 17:02:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, Julia.Lawall@lip6.fr, bfields@fieldses.org, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/coccinelle/misc/bugon.cocci: update bug_on conversion warning
has been added to the -mm tree.  Its filename is
     scripts-coccinelle-misc-bugoncocci-update-bug_on-conversion-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-coccinelle-misc-bugoncocci-update-bug_on-conversion-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-coccinelle-misc-bugoncocci-update-bug_on-conversion-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: scripts/coccinelle/misc/bugon.cocci: update bug_on conversion warning

if()/BUG conversion to BUG_ON must be avoided when there's side effect in
condition.  The reason being BUG_ON won't execute the condition when
CONFIG_BUG is not defined.

With inspiration from Bruce Fields.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Suggested-by: Julia Lawall <Julia.Lawall@lip6.fr>
Acked-by: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: J. Bruce Fields <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/coccinelle/misc/bugon.cocci |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/coccinelle/misc/bugon.cocci~scripts-coccinelle-misc-bugoncocci-update-bug_on-conversion-warning scripts/coccinelle/misc/bugon.cocci
--- a/scripts/coccinelle/misc/bugon.cocci~scripts-coccinelle-misc-bugoncocci-update-bug_on-conversion-warning
+++ a/scripts/coccinelle/misc/bugon.cocci
@@ -57,6 +57,6 @@ coccilib.org.print_todo(p[0], "WARNING u
 p << r.p;
 @@
 
-msg="WARNING: Use BUG_ON"
+msg="WARNING: Use BUG_ON instead of if condition followed by BUG.\nPlease make sure the condition has no side effects (see conditional BUG_ON definition in include/asm-generic/bug.h)"
 coccilib.report.print_report(p[0], msg)
 
_

Patches currently in -mm which might be from fabf@skynet.be are

scripts-coccinelle-misc-bugoncocci-update-bug_on-conversion-warning.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
slob-statify-slob_alloc_node-and-remove-symbol.patch
mm-vmalloc-fix-possible-exhaustion-of-vmalloc-space-caused-by-vm_map_ram-allocator.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-vmalloc-get-rid-of-dirty-bitmap-inside-vmap_block-structure.patch
mm-memblock-add-debug-output-for-the-memblock_add.patch
mm-memblock-add-debug-output-for-the-memblock_add-fix.patch
envctrl-ignore-orderly_poweroff-return-value.patch
kernel-rebootc-add-orderly_reboot-for-graceful-reboot.patch
powerpc-powernv-reboot-when-requested-by-firmware.patch
checkpatch-dont-ask-for-asm-fileh-to-linux-fileh-unconditionally.patch
befs-replace-typedef-befs_mount_options-by-structure.patch
befs-replace-typedef-befs_sb_info-by-structure.patch
befs-replace-typedef-befs_inode_info-by-structure.patch
fs-hfsplus-move-xattr_name-allocation-in-hfsplus_getxattr.patch
fs-hfsplus-move-xattr_name-allocation-in-hfsplus_setxattr.patch
fs-hfsplus-atomically-set-inode-i_flags.patch
fs-hfsplus-use-bool-instead-of-int-for-is_known_namespace-return-value.patch
fs-hfsplus-replace-if-bug-by-bug_on.patch
hfsplus-dont-store-special-osx-xattr-prefix-on-disk.patch
adfs-returning-correct-return-values.patch
fs-affs-use-affs_mount-prefix-for-mount-options.patch
fs-affs-affsh-add-mount-option-manipulation-macros.patch
fs-affs-superc-use-affs_set_opt.patch
fs-affs-use-affs_test_opt.patch
affs-kstrdup-memory-handling.patch
affs-kstrdup-memory-handling-fix.patch
linux-next.patch

