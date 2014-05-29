From: akpm@linux-foundation.org
Subject: + checkpatch-prefer-kstrtofoo-to-sscanfbuf-%lhuidx-bar.patch
 added to -mm tree
Date: Thu, 29 May 2014 12:52:04 -0700
Message-ID: <53878fe4.ESbWovSz+3/KedXL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44311 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205AbaE2TwG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 May 2014 15:52:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-prefer-kstrtofoo-to-sscanfbuf-%lhuidx-bar.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Thu, 29 May 2014 12:52:04 -0700


The patch titled
     Subject: checkpatch: prefer kstrto<foo> to sscanf(buf, "%<lhuidx>", &bar);
has been added to the -mm tree.  Its filename is
     checkpatch-prefer-kstrtofoo-to-sscanfbuf-%lhuidx-bar.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-prefer-kstrtofoo-to-sscanfbuf-%lhuidx-bar.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-prefer-kstrtofoo-to-sscanfbuf-%lhuidx-bar.patch

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
Subject: checkpatch: prefer kstrto<foo> to sscanf(buf, "%<lhuidx>", &bar);

Use the kstrto<foo> functions in preference to sscanf.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-prefer-kstrtofoo-to-sscanfbuf-%lhuidx-bar scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-prefer-kstrtofoo-to-sscanfbuf-%lhuidx-bar
+++ a/scripts/checkpatch.pl
@@ -4314,6 +4314,27 @@ sub process {
 			     "unchecked sscanf return value\n" . "$here\n$stat_real\n");
 		}
 
+# check for simple sscanf that should be kstrto<foo>
+		if ($^V && $^V ge 5.10.0 &&
+		    defined $stat &&
+		    $line =~ /\bsscanf\b/) {
+			my $lc = $stat =~ tr@\n@@;
+			$lc = $lc + $linenr;
+			my $stat_real = raw_line($linenr, 0);
+		        for (my $count = $linenr + 1; $count <= $lc; $count++) {
+				$stat_real = $stat_real . "\n" . raw_line($count, 0);
+			}
+			if ($stat_real =~ /\bsscanf\b\s*\(\s*$FuncArg\s*,\s*("[^"]+")/) {
+				my $format = $6;
+				my $count = $format =~ tr@%@%@;
+				if ($count == 1 &&
+				    $format =~ /^"\%(?i:ll[udxi]|[udxi]ll|ll|[hl]h?[udxi]|[udxi][hl]h?|[hl]h?|[udxi])"$/) {
+					WARN("SSCANF_TO_KSTRTO",
+					     "Prefer kstrto<type> to single variable sscanf\n" . "$here\n$stat_real\n");
+				}
+			}
+		}
+
 # check for new externs in .h files.
 		if ($realfile =~ /\.h$/ &&
 		    $line =~ /^\+\s*(extern\s+)$Type\s*$Ident\s*\(/s) {
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-add-me-as-the-get_maintainerpl-maintainer.patch
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
documentation-expand-clarify-debug-documentation.patch
printk-use-symbolic-defines-for-console-loglevels.patch
mm-utilc-add-kstrimdup.patch
checkpatch-fix-wildcard-dt-compatible-string-checking.patch
checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
checkpatch-improve-missing-blank-line-after-declarations-test.patch
checkpatch-make-strict-a-default-for-files-in-drivers-net-and-net.patch
checkpatch-warn-on-defines-ending-in-semicolon.patch
checkpatch-add-warning-for-kmalloc-kzalloc-with-multiply.patch
checkpatch-prefer-kstrtofoo-to-sscanfbuf-%lhuidx-bar.patch
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

