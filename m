From: akpm@linux-foundation.org
Subject: + 10-dots-braille-keyboards.patch added to -mm tree
Date: Tue, 21 Aug 2007 12:59:05 -0700
Message-ID: <200708211959.l7LJx5XS008105@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51584 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751423AbXHUT7t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Aug 2007 15:59:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samuel.thibault@ens-lyon.org, dtor@mail.ru, jkosina@suse.cz


The patch titled
     10-dots braille keyboards
has been added to the -mm tree.  Its filename is
     10-dots-braille-keyboards.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -553,6 +553,8 @@ struct input_absinfo {
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

keyboard-capsshift-lock.patch
10-dots-braille-keyboards.patch
unicode-diacritics-support.patch
unicode-diacritics-support-s390-fix.patch
