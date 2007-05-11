From: akpm@linux-foundation.org
Subject: + evdev-fix-overflow-in-compat_ioctl.patch added to -mm tree
Date: Thu, 10 May 2007 22:30:22 -0700
Message-ID: <200705110530.l4B5UM4m007215@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090AbXEKFcE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 01:32:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kenichi3.nagai@toshiba.co.jp, dtor@mail.ru, stable@kernel.org


The patch titled
     evdev: fix overflow in compat_ioctl
has been added to the -mm tree.  Its filename is
     evdev-fix-overflow-in-compat_ioctl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: evdev: fix overflow in compat_ioctl
From: Kenichi Nagai <kenichi3.nagai@toshiba.co.jp>

When exporting input device bitmaps via compat_ioctl on BIG_ENDIAN
platforms evdev calculates data size incorrectly.  This causes buffer
overflow if user specifies buffer smaller than maxlen.

Signed-off-by: Kenichi Nagai <kenichi3.nagai@toshiba.co.jp>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/evdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/evdev.c~evdev-fix-overflow-in-compat_ioctl drivers/input/evdev.c
--- a/drivers/input/evdev.c~evdev-fix-overflow-in-compat_ioctl
+++ a/drivers/input/evdev.c
@@ -336,7 +336,7 @@ static int bits_to_user(unsigned long *b
 
 	if (compat) {
 		len = NBITS_COMPAT(maxbit) * sizeof(compat_long_t);
-		if (len < maxlen)
+		if (len > maxlen)
 			len = maxlen;
 
 		for (i = 0; i < len / sizeof(compat_long_t); i++)
_

Patches currently in -mm which might be from kenichi3.nagai@toshiba.co.jp are

evdev-fix-overflow-in-compat_ioctl.patch
