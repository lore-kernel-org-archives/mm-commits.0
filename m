From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-dont-ask-for-asm-fileh-to-linux-fileh-unconditionally.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:17:03 -0700
Message-ID: <553550af.eQx9cOGau8yvqXw+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40098 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbbDTTKm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:10:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: don't ask for asm/file.h to linux/file.h unconditionally
has been removed from the -mm tree.  Its filename was
     checkpatch-dont-ask-for-asm-fileh-to-linux-fileh-unconditionally.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -4242,7 +4242,8 @@ sub process {
 			}
 		}
 
-#warn if <asm/foo.h> is #included and <linux/foo.h> is available (uses RAW line)
+# warn if <asm/foo.h> is #included and <linux/foo.h> is available and includes
+# itself <asm/foo.h> (uses RAW line)
 		if ($tree && $rawline =~ m{^.\s*\#\s*include\s*\<asm\/(.*)\.h\>}) {
 			my $file = "$1.h";
 			my $checkfile = "include/linux/$file";
@@ -4250,12 +4251,15 @@ sub process {
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

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
linux-next.patch

