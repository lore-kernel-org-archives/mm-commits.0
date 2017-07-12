From: akpm@linux-foundation.org
Subject: [patch 08/96] kexec/kdump: minor Documentation updates for
 arm64 and Image
Date: Wed, 12 Jul 2017 14:33:24 -0700
Message-ID: <20170712213324.JGm8jwUkY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53148 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754351AbdGLVdZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:33:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Bharat.Bhushan@nxp.com, bhe@redhat.com, corbet@lwn.net, dyoung@redhat.com, mm-commits@vger.kernel.org, panand@redhat.com, takahiro.akashi@linaro.org, torvalds@linux-foundation.org, vgoyal@redhat.com

From: Bharat Bhushan <Bharat.Bhushan@nxp.com>
Subject: kexec/kdump: minor Documentation updates for arm64 and Image

Minor updates in Documentation for arm64 as relocatable kernel.  Also this
patch updates documentation for using uncompressed image "Image" which is
used for ARM64.

Link: http://lkml.kernel.org/r/1495104793-6563-1-git-send-email-Bharat.Bhushan@nxp.com
Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Pratyush Anand <panand@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kdump/kdump.txt |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN Documentation/kdump/kdump.txt~kexec-kdump-minor-documentation-updates-for-arm64-and-image Documentation/kdump/kdump.txt
--- a/Documentation/kdump/kdump.txt~kexec-kdump-minor-documentation-updates-for-arm64-and-image
+++ a/Documentation/kdump/kdump.txt
@@ -112,8 +112,8 @@ There are two possible methods of using
 2) Or use the system kernel binary itself as dump-capture kernel and there is
    no need to build a separate dump-capture kernel. This is possible
    only with the architectures which support a relocatable kernel. As
-   of today, i386, x86_64, ppc64, ia64 and arm architectures support relocatable
-   kernel.
+   of today, i386, x86_64, ppc64, ia64, arm and arm64 architectures support
+   relocatable kernel.
 
 Building a relocatable kernel is advantageous from the point of view that
 one does not have to build a second kernel for capturing the dump. But
@@ -339,7 +339,7 @@ For arm:
 For arm64:
 	- Use vmlinux or Image
 
-If you are using a uncompressed vmlinux image then use following command
+If you are using an uncompressed vmlinux image then use following command
 to load dump-capture kernel.
 
    kexec -p <dump-capture-kernel-vmlinux-image> \
@@ -361,6 +361,12 @@ to load dump-capture kernel.
    --dtb=<dtb-for-dump-capture-kernel> \
    --append="root=<root-dev> <arch-specific-options>"
 
+If you are using an uncompressed Image, then use following command
+to load dump-capture kernel.
+
+   kexec -p <dump-capture-kernel-Image> \
+   --initrd=<initrd-for-dump-capture-kernel> \
+   --append="root=<root-dev> <arch-specific-options>"
 
 Please note, that --args-linux does not need to be specified for ia64.
 It is planned to make this a no-op on that architecture, but for now
_
