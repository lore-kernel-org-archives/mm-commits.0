From: akpm@linux-foundation.org
Subject: + keyboard-capsshift-lock.patch added to -mm tree
Date: Thu, 16 Aug 2007 12:37:26 -0700
Message-ID: <200708161937.l7GJbQpv003413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47336 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757117AbXHPTiK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 15:38:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samuel.thibault@ens-lyon.org, dtor@mail.ru, jkosina@suse.cz


The patch titled
     Keyboard CapsShift Lock
has been added to the -mm tree.  Its filename is
     keyboard-capsshift-lock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Keyboard CapsShift Lock
From: Samuel Thibault <samuel.thibault@ens-lyon.org>

There exists a CapsShift lock called KG_CAPSSHIFT, but no associated
lock/slock, here is a patch which adds CapsShift lock and slock.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/keyboard.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/keyboard.h~keyboard-capsshift-lock include/linux/keyboard.h
--- a/include/linux/keyboard.h~keyboard-capsshift-lock
+++ a/include/linux/keyboard.h
@@ -416,6 +416,7 @@ extern unsigned short plain_map[NR_KEYS]
 #define K_SHIFTRLOCK	K(KT_LOCK,KG_SHIFTR)
 #define K_CTRLLLOCK	K(KT_LOCK,KG_CTRLL)
 #define K_CTRLRLOCK	K(KT_LOCK,KG_CTRLR)
+#define K_CAPSSHIFTLOCK	K(KT_LOCK,KG_CAPSSHIFT)
 
 #define K_SHIFT_SLOCK	K(KT_SLOCK,KG_SHIFT)
 #define K_CTRL_SLOCK	K(KT_SLOCK,KG_CTRL)
@@ -425,8 +426,9 @@ extern unsigned short plain_map[NR_KEYS]
 #define K_SHIFTR_SLOCK	K(KT_SLOCK,KG_SHIFTR)
 #define K_CTRLL_SLOCK	K(KT_SLOCK,KG_CTRLL)
 #define K_CTRLR_SLOCK	K(KT_SLOCK,KG_CTRLR)
+#define K_CAPSSHIFT_SLOCK	K(KT_SLOCK,KG_CAPSSHIFT)
 
-#define NR_LOCK		8
+#define NR_LOCK		9
 
 #define K_BRL_BLANK     K(KT_BRL, 0)
 #define K_BRL_DOT1      K(KT_BRL, 1)
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

keyboard-capsshift-lock.patch
unicode-diacritics-support.patch
unicode-diacritics-support-s390-fix.patch
