From: akpm@linux-foundation.org
Subject: - evdev-fix-overflow-in-compat_ioctl.patch removed from -mm tree
Date: Fri, 11 May 2007 22:35:55 -0700
Message-ID: <200705120535.l4C5ZtKa002334@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755050AbXELFhZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:37:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kenichi3.nagai@toshiba.co.jp, dtor@mail.ru, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     evdev: fix overflow in compat_ioctl
has been removed from the -mm tree.  Its filename was
     evdev-fix-overflow-in-compat_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
