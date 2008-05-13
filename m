From: akpm@linux-foundation.org
Subject: + usb-usbtest-comment-on-why-this-code-expects-negative-and-positive-errnos.patch added to -mm tree
Date: Tue, 13 May 2008 12:43:01 -0700
Message-ID: <200805131943.m4DJh1nJ028568@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755674AbYEMTqv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 15:46:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, david-b@pacbell.net, greg@kroah.com


The patch titled
     usb/usbtest: comment on why this code "expects" negative and positive errnos
has been added to the -mm tree.  Its filename is
     usb-usbtest-comment-on-why-this-code-expects-negative-and-positive-errnos.patch

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
Subject: usb/usbtest: comment on why this code "expects" negative and positive errnos
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Based on comment from David Brownell <david-b@pacbell.net>.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/usbtest.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/usb/misc/usbtest.c~usb-usbtest-comment-on-why-this-code-expects-negative-and-positive-errnos drivers/usb/misc/usbtest.c
--- a/drivers/usb/misc/usbtest.c~usb-usbtest-comment-on-why-this-code-expects-negative-and-positive-errnos
+++ a/drivers/usb/misc/usbtest.c
@@ -856,6 +856,11 @@ test_ctrl_queue (struct usbtest_dev *dev
 		struct urb		*u;
 		struct usb_ctrlrequest	req;
 		struct subcase		*reqp;
+
+		/* sign of this variable means:
+		 *  -: tested code must return this (negative) error code
+		 *  +: tested code may return this (negative too) error code
+		 */
 		int			expected = 0;
 
 		/* requests here are mostly expected to succeed on any
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

cifs-cifssmbposixlock-should-return-einval-on-error.patch
drm-radeon-radeon_enable_vblank-should-return-negative-error.patch
dlm-tcp_connect_to_sock-should-check-for-einval-not-einval.patch
isdn-capi-return-proper-errnos-on-module-init.patch
net-s2io-set_rxd_buffer_pointer-returns-enomem-not-enomem.patch
ntfs-le_add_cpu-conversion.patch
s390-char-vmlogrdr-module-initialization-function-should-return-negative-errors.patch
usb-usbtest-comment-on-why-this-code-expects-negative-and-positive-errnos.patch

