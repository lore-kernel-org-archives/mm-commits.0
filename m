From: akpm@linux-foundation.org
Subject: [to-be-updated] lib-add-on-off-support-to-kstrtobool.patch
 removed from -mm tree
Date: Fri, 05 Feb 2016 15:00:09 -0800
Message-ID: <56b52979.9t93SAPtAfFiQfyw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35578 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbcBEXAK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2016 18:00:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, akarwar@marvell.com, andy.shevchenko@gmail.com, benh@kernel.crashing.org, heiko.carstens@de.ibm.com, hpa@zytor.com, kvalo@codeaurora.org, mingo@elte.hu, mpe@ellerman.id.au, nishants@marvell.com, sfrench@samba.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: add "on"/"off" support to kstrtobool
has been removed from the -mm tree.  Its filename was
     lib-add-on-off-support-to-kstrtobool.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: lib: add "on"/"off" support to kstrtobool

Add support for "on" and "off" when converting to boolean.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nishant Sarmukadam <nishants@marvell.com>
Cc: Steve French <sfrench@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kstrtox.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN lib/kstrtox.c~lib-add-on-off-support-to-kstrtobool lib/kstrtox.c
--- a/lib/kstrtox.c~lib-add-on-off-support-to-kstrtobool
+++ a/lib/kstrtox.c
@@ -347,6 +347,20 @@ int kstrtobool(const char *s, unsigned i
 	case '0':
 		*res = false;
 		return 0;
+	case 'o':
+	case 'O':
+		switch (s[1]) {
+		case 'n':
+		case 'N':
+			*res = true;
+			return 0;
+		case 'f':
+		case 'F':
+			*res = false;
+			return 0;
+		default:
+			break;
+		}
 	default:
 		break;
 	}
_

Patches currently in -mm which might be from keescook@chromium.org are

lib-add-on-off-support-to-kstrtobool-fix.patch
param-convert-some-on-off-users-to-strtobool.patch

