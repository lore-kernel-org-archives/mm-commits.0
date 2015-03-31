From: akpm@linux-foundation.org
Subject: +
 checkpatch-dont-ask-for-asm-fileh-to-linux-fileh-unconditionally.patch
 added to -mm tree
Date: Tue, 31 Mar 2015 13:26:25 -0700
Message-ID: <551b02f1.yl12mm9jR2rCqDM0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714AbbCaU00 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Mar 2015 16:26:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: don't ask for asm/file.h to linux/file.h unconditionally
has been added to the -mm tree.  Its filename is
     checkpatch-dont-ask-for-asm-fileh-to-linux-fileh-unconditionally.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-dont-ask-for-asm-fileh-to-linux-fileh-unconditionally.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-dont-ask-for-asm-fileh-to-linux-fileh-unconditionally.patch

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
Subject: checkpatch: don't ask for asm/file.h to linux/file.h unconditionally

Currently checkpatch warns when asm/file.h is included and linux/file.h
exists.  That conversion can be made when linux/file.h includes asm/file.h
which is not always the case.(See signal.h)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Andy Whitcroft <apw@canonical.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-dont-ask-for-asm-fileh-to-linux-fileh-unconditionally scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-dont-ask-for-asm-fileh-to-linux-fileh-unconditionally
+++ a/scripts/checkpatch.pl
@@ -4251,7 +4251,8 @@ sub process {
 			}
 		}
 
-#warn if <asm/foo.h> is #included and <linux/foo.h> is available (uses RAW line)
+# warn if <asm/foo.h> is #included and <linux/foo.h> is available and includes
+# itself <asm/foo.h> (uses RAW line)
 		if ($tree && $rawline =~ m{^.\s*\#\s*include\s*\<asm\/(.*)\.h\>}) {
 			my $file = "$1.h";
 			my $checkfile = "include/linux/$file";
@@ -4259,12 +4260,15 @@ sub process {
 			    $realfile ne $checkfile &&
 			    $1 !~ /$allowed_asm_includes/)
 			{
-				if ($realfile =~ m{^arch/}) {
-					CHK("ARCH_INCLUDE_LINUX",
-					    "Consider using #include <linux/$file> instead of <asm/$file>\n" . $herecurr);
-				} else {
-					WARN("INCLUDE_LINUX",
-					     "Use #include <linux/$file> instead of <asm/$file>\n" . $herecurr);
+				my $asminclude = `grep -Ec "#include\\s+<asm/$file>" $root/$checkfile`;
+				if ($asminclude > 0) {
+					if ($realfile =~ m{^arch/}) {
+						CHK("ARCH_INCLUDE_LINUX",
+						    "Consider using #include <linux/$file> instead of <asm/$file>\n" . $herecurr);
+					} else {
+						WARN("INCLUDE_LINUX",
+						     "Use #include <linux/$file> instead of <asm/$file>\n" . $herecurr);
+					}
 				}
 			}
 		}
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
mm-vmalloc-fix-possible-exhaustion-of-vmalloc-space-caused-by-vm_map_ram-allocator.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-vmalloc-get-rid-of-dirty-bitmap-inside-vmap_block-structure.patch
checkpatch-dont-ask-for-asm-fileh-to-linux-fileh-unconditionally.patch
befs-replace-typedef-befs_mount_options-by-structure.patch
befs-replace-typedef-befs_sb_info-by-structure.patch
befs-replace-typedef-befs_inode_info-by-structure.patch
fs-hfsplus-move-xattr_name-allocation-in-hfsplus_getxattr.patch
fs-hfsplus-move-xattr_name-allocation-in-hfsplus_setxattr.patch
fs-hfsplus-atomically-set-inode-i_flags.patch
fs-hfsplus-use-bool-instead-of-int-for-is_known_namespace-return-value.patch
fs-hfsplus-replace-if-bug-by-bug_on.patch
adfs-returning-correct-return-values.patch
fs-affs-use-affs_mount-prefix-for-mount-options.patch
fs-affs-affsh-add-mount-option-manipulation-macros.patch
fs-affs-superc-use-affs_set_opt.patch
fs-affs-use-affs_test_opt.patch
affs-kstrdup-memory-handling.patch
affs-kstrdup-memory-handling-fix.patch
linux-next.patch

