From: akpm@linux-foundation.org
Subject: - usb-usbtest-comment-on-why-this-code-expects-negative-and-positive-errnos.patch removed from -mm tree
Date: Wed, 14 May 2008 14:22:13 -0700
Message-ID: <200805142122.m4ELMD0h021579@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752407AbYENVWT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 May 2008 17:22:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, david-b@pacbell.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb/usbtest: comment on why this code "expects" negative and positive errnos
has been removed from the -mm tree.  Its filename was
     usb-usbtest-comment-on-why-this-code-expects-negative-and-positive-errnos.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
drm-radeon-radeon_enable_vblank-should-return-negative-error.patch
git-jfs.patch
isdn-capi-return-proper-errnos-on-module-init.patch
net-s2io-set_rxd_buffer_pointer-returns-enomem-not-enomem.patch
ntfs-le_add_cpu-conversion.patch
tty_check_change-avoid-taking-tasklist_lock-while-holding-tty-ctrl_lock.patch

