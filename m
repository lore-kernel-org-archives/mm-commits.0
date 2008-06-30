From: akpm@linux-foundation.org
Subject: + checkpatch-usb_free_urb-can-take-null.patch added to -mm tree
Date: Mon, 30 Jun 2008 15:19:48 -0700
Message-ID: <200806302219.m5UMJm1J028585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54508 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762544AbYF3WUA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 18:20:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gregkh@suse.de, apw@shadowen.org


The patch titled
     checkpatch: usb_free_urb() can take NULL
has been added to the -mm tree.  Its filename is
     checkpatch-usb_free_urb-can-take-null.patch

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
Subject: checkpatch: usb_free_urb() can take NULL
From: Greg Kroah-Hartman <gregkh@suse.de>

usb_free_urb() can take a NULL, so let's check and warn about that.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-usb_free_urb-can-take-null scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-usb_free_urb-can-take-null
+++ a/scripts/checkpatch.pl
@@ -2078,6 +2078,13 @@ sub process {
 				WARN("kfree(NULL) is safe this check is probabally not required\n" . $hereprev);
 			}
 		}
+# check for needless usb_free_urb() checks
+		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
+			my $expr = $1;
+			if ($line =~ /\busb_free_urb\(\Q$expr\E\);/) {
+				WARN("usb_free_urb(NULL) is safe this check is probably not required\n" . $hereprev);
+			}
+		}
 
 # warn about #ifdefs in C files
 #		if ($line =~ /^.\s*\#\s*if(|n)def/ && ($realfile =~ /\.c$/)) {
_

Patches currently in -mm which might be from gregkh@suse.de are

fix-kobject-fix-kobject_rename-and-config_sysfs.patch
usb-fix-possible-memory-leak-in-pxa27x_udc.patch
hugetlb-new-sysfs-interface.patch
checkpatch-usb_free_urb-can-take-null.patch
firmware-use-memory_read_from_buffer.patch
edac-core-fix-to-use-dynamic-kobject.patch

