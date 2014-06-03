From: akpm@linux-foundation.org
Subject: + checkpatch-check-stable-email-address.patch added to -mm tree
Date: Tue, 03 Jun 2014 15:22:46 -0700
Message-ID: <538e4ab6.fjsxhfJgjurpjoP2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54095 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934167AbaFCWWr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2014 18:22:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-check-stable-email-address.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Tue, 03 Jun 2014 15:22:46 -0700


The patch titled
     Subject: checkpatch: check stable email address
has been added to the -mm tree.  Its filename is
     checkpatch-check-stable-email-address.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-check-stable-email-address.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-check-stable-email-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: check stable email address

It should be stable@vger.kernel.org, not stable@kernel.org.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-check-stable-email-address scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-check-stable-email-address
+++ a/scripts/checkpatch.pl
@@ -1944,6 +1944,12 @@ sub process {
 			}
 		}
 
+# Check for old stable address
+		if ($line =~ /^\s*cc:\s*.*<?\bstable\@kernel\.org\b>?.*$/i) {
+			ERROR("STABLE_ADDRESS",
+			      "The 'stable' address should be 'stable\@vger.kernel.org'\n" . $herecurr);
+		}
+
 # Check for unwanted Gerrit info
 		if ($in_commit_log && $line =~ /^\s*change-id:/i) {
 			ERROR("GERRIT_CHANGE_ID",
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
maintainers-add-me-as-the-get_maintainerpl-maintainer.patch
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
documentation-expand-clarify-debug-documentation.patch
printk-use-symbolic-defines-for-console-loglevels.patch
lib-bugc-convert-printk-to-pr_foo.patch
mm-utilc-add-kstrimdup.patch
checkpatch-fix-wildcard-dt-compatible-string-checking.patch
checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
checkpatch-improve-missing-blank-line-after-declarations-test.patch
checkpatch-make-strict-a-default-for-files-in-drivers-net-and-net.patch
checkpatch-warn-on-defines-ending-in-semicolon.patch
checkpatch-add-warning-for-kmalloc-kzalloc-with-multiply.patch
checkpatch-prefer-kstrtofoo-to-sscanfbuf-%lhuidx-bar.patch
checkpatch-warn-on-unnecessary-void-function-return-statements.patch
checkpatch-check-stable-email-address.patch
fs-efs-convert-printk-to-pr_foo.patch
fs-efs-add-pr_fmt-use-__func__.patch
fs-efs-convert-printkkern_debug-to-pr_debug.patch
init-mainc-dont-use-pr_debug.patch
fs-isofs-logging-clean-up.patch
fs-coda-replace-printk-by-pr_foo.patch
fs-coda-logging-prefix-uniformization.patch
fs-coda-use-__func__.patch
fs-hfsplus-wrapperc-replace-shift-loop-by-ilog2.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
fs-devpts-inodec-convert-printk-to-pr_foo.patch
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
ipc-semc-add-a-printk_once-for-semctlgetncnt-getzcnt.patch
linux-next.patch
arm-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ia64-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
tile-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
cdrom-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
random-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
parport-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
scsi-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
coda-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
fscache-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
lockd-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
nfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
inotify-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ntfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
fs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
key-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ipc-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
sysctl-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
mm-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
maintainers-add-linux-api-for-review-of-api-abi-changes.patch

