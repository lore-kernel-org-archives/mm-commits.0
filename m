From: akpm@linux-foundation.org
Subject: - checkpatch-usb_free_urb-can-take-null.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:33:32 -0700
Message-ID: <200807242333.m6ONXWMQ011936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756871AbYGXXdm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:33:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gregkh@suse.de, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: usb_free_urb() can take NULL
has been removed from the -mm tree.  Its filename was
     checkpatch-usb_free_urb-can-take-null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
drivers-misc-hpiloc-needs-config_pci.patch
firmware-use-memory_read_from_buffer.patch
firmware-use-memory_read_from_buffer-fix.patch
edac-core-fix-to-use-dynamic-kobject.patch
vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter.patch

