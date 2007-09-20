From: akpm@linux-foundation.org
Subject: - mac_hid-fix-build-error-if-mac_emumousebtn-input.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:17:28 -0700
Message-ID: <200709202117.l8KLHSUw003084@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43755 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752089AbXITV3M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 17:29:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aherrman@arcor.de, dtor@mail.ru, jikos@jikos.cz, mm-commits@vger.kernel.org


The patch titled
     mac_hid: fix build error if MAC_EMUMOUSEBTN && !INPUT
has been removed from the -mm tree.  Its filename was
     mac_hid-fix-build-error-if-mac_emumousebtn-input.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mac_hid: fix build error if MAC_EMUMOUSEBTN && !INPUT
From: Andreas Herrmann <aherrman@arcor.de>

Build error if MAC_EMUMOUSEBTN && !INPUT:

  LD      .tmp_vmlinux1
drivers/built-in.o: In function `input_report_key':
include/linux/input.h:1158: undefined reference to `input_event'
    ...

Auto-select INPUT for MAC_EMUMOUSEBTN option.

Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
Cc: Jiri Kosina <jikos@jikos.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/macintosh/Kconfig~mac_hid-fix-build-error-if-mac_emumousebtn-input drivers/macintosh/Kconfig
--- a/drivers/macintosh/Kconfig~mac_hid-fix-build-error-if-mac_emumousebtn-input
+++ a/drivers/macintosh/Kconfig
@@ -172,6 +172,7 @@ config INPUT_ADBHID
 
 config MAC_EMUMOUSEBTN
 	bool "Support for mouse button 2+3 emulation"
+	select INPUT
 	help
 	  This provides generic support for emulating the 2nd and 3rd mouse
 	  button with keypresses.  If you say Y here, the emulation is still
_

Patches currently in -mm which might be from aherrman@arcor.de are

git-input.patch
9p-fix-compile-error-if-config_sysctl.patch
