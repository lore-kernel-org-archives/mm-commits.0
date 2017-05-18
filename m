From: akpm@linux-foundation.org
Subject: +
 kexec-kdump-minor-documentation-updates-for-arm64-and-image.patch added to
 -mm tree
Date: Thu, 18 May 2017 13:08:28 -0700
Message-ID: <591dff3c.qJUHiDfwWINe2M0o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33556 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751442AbdERUI3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 May 2017 16:08:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Bharat.Bhushan@nxp.com, bhe@redhat.com, corbet@lwn.net, dyoung@redhat.com, panand@redhat.com, takahiro.akashi@linaro.org, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec/kdump: minor Documentation updates for arm64 and Image
has been added to the -mm tree.  Its filename is
     kexec-kdump-minor-documentation-updates-for-arm64-and-image.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-kdump-minor-documentation-updates-for-arm64-and-image.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-kdump-minor-documentation-updates-for-arm64-and-image.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from Bharat.Bhushan@nxp.com are

kexec-kdump-minor-documentation-updates-for-arm64-and-image.patch

