From: akpm@linux-foundation.org
Subject: + lib-add-on-off-support-to-kstrtobool.patch added to -mm tree
Date: Thu, 04 Feb 2016 13:40:44 -0800
Message-ID: <56b3c55c.cpFJ36k6MUE4rNCr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56631 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965629AbcBDVkp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 16:40:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, akarwar@marvell.com, benh@kernel.crashing.org, heiko.carstens@de.ibm.com, hpa@zytor.com, kvalo@codeaurora.org, mingo@elte.hu, mpe@ellerman.id.au, nishants@marvell.com, sfrench@samba.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: add "on"/"off" support to kstrtobool
has been added to the -mm tree.  Its filename is
     lib-add-on-off-support-to-kstrtobool.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-add-on-off-support-to-kstrtobool.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-add-on-off-support-to-kstrtobool.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: lib: add "on"/"off" support to kstrtobool

Add support for "on" and "off" when converting to boolean.

Signed-off-by: Kees Cook <keescook@chromium.org>
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

lib-move-strtobool-to-kstrtobool.patch
lib-update-single-char-callers-of-strtobool.patch
lib-add-on-off-support-to-kstrtobool.patch
param-convert-some-on-off-users-to-strtobool.patch

