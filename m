From: akpm@linux-foundation.org
Subject: - 10-dots-braille-keyboards.patch removed from -mm tree
Date: Thu, 06 Sep 2007 17:42:19 -0700
Message-ID: <200709070042.l870gJg3016032@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36898 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964832AbXIGAmh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Sep 2007 20:42:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samuel.thibault@ens-lyon.org, dtor@mail.ru, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     10-dots braille keyboards
has been removed from the -mm tree.  Its filename was
     10-dots-braille-keyboards.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: 10-dots braille keyboards
From: Samuel Thibault <samuel.thibault@ens-lyon.org>

Some braille keyboards have 10 dots, so extend the Input braille keys
definitions.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/input.h    |    2 ++
 include/linux/keyboard.h |    4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN include/linux/input.h~10-dots-braille-keyboards include/linux/input.h
--- a/include/linux/input.h~10-dots-braille-keyboards
+++ a/include/linux/input.h
@@ -559,6 +559,8 @@ struct input_absinfo {
 #define KEY_BRL_DOT6		0x1f6
 #define KEY_BRL_DOT7		0x1f7
 #define KEY_BRL_DOT8		0x1f8
+#define KEY_BRL_DOT9		0x1f9
+#define KEY_BRL_DOT10		0x1fa
 
 /* We avoid low common keys in module aliases so they don't get huge. */
 #define KEY_MIN_INTERESTING	KEY_MUTE
diff -puN include/linux/keyboard.h~10-dots-braille-keyboards include/linux/keyboard.h
--- a/include/linux/keyboard.h~10-dots-braille-keyboards
+++ a/include/linux/keyboard.h
@@ -439,8 +439,10 @@ extern unsigned short plain_map[NR_KEYS]
 #define K_BRL_DOT6      K(KT_BRL, 6)
 #define K_BRL_DOT7      K(KT_BRL, 7)
 #define K_BRL_DOT8      K(KT_BRL, 8)
+#define K_BRL_DOT9      K(KT_BRL, 9)
+#define K_BRL_DOT10     K(KT_BRL, 10)
 
-#define NR_BRL		9
+#define NR_BRL		11
 
 #define MAX_DIACR	256
 #endif
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

git-input.patch
keyboard-capsshift-lock.patch
console-keyboard-events-and-accessibility.patch
console-keyboard-events-and-accessibility-fix.patch
console-keyboard-events-and-accessibility-fix-2.patch
unicode-diacritics-support.patch
unicode-diacritics-support-s390-fix.patch
console-events-and-accessibility.patch
console-events-and-accessibility-fix.patch
