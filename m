From: akpm@linux-foundation.org
Subject: - acpi-add-acpi-aliases-to-toshiba_acpi-module.patch removed from -mm tree
Date: Thu, 13 Mar 2008 11:59:17 -0700
Message-ID: <200803131859.m2DIxHQ6027943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41698 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754373AbYCMTDm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 15:03:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arvidjaar@mail.ru, blino@mandriva.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ACPI: add ACPI aliases to toshiba_acpi module
has been removed from the -mm tree.  Its filename was
     acpi-add-acpi-aliases-to-toshiba_acpi-module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ACPI: add ACPI aliases to toshiba_acpi module
From: Andrey Borzenkov < arvidjaar@mail.ru>

This adds aliases to enable autoloading of toishiba_acpi.  Two aliases are
defined - TOS6200 (for \\_SB_.VALD.GHCI) and TSO1900 (for \\_SB_.VALZ.GHCI). 
This allows toishiba_acpi to be autoloaded on systems that provide those
devices.

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Olivier Blin <blino@mandriva.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/toshiba_acpi.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/acpi/toshiba_acpi.c~acpi-add-acpi-aliases-to-toshiba_acpi-module drivers/acpi/toshiba_acpi.c
--- a/drivers/acpi/toshiba_acpi.c~acpi-add-acpi-aliases-to-toshiba_acpi-module
+++ a/drivers/acpi/toshiba_acpi.c
@@ -99,6 +99,13 @@ MODULE_LICENSE("GPL");
 #define HCI_VIDEO_OUT_CRT		0x2
 #define HCI_VIDEO_OUT_TV		0x4
 
+static const struct acpi_device_id toshiba_device_ids[] = {
+	{"TOS6200", 0},
+	{"TOS1900", 0},
+	{"", 0},
+};
+MODULE_DEVICE_TABLE(acpi, toshiba_device_ids);
+
 /* utility
  */
 
_

Patches currently in -mm which might be from arvidjaar@mail.ru are

git-acpi.patch

