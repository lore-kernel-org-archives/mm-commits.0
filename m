From: akpm@linux-foundation.org
Subject: - keyboard-capsshift-lock.patch removed from -mm tree
Date: Fri, 12 Oct 2007 15:24:06 -0700
Message-ID: <200710122224.l9CMO67p006507@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47218 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932739AbXJLWYS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Oct 2007 18:24:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samuel.thibault@ens-lyon.org, dtor@mail.ru, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Keyboard CapsShift Lock
has been removed from the -mm tree.  Its filename was
     keyboard-capsshift-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 3 insertions(+), 1 deletion(-)

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

git-input.patch
console-keyboard-events-and-accessibility.patch
unicode-diacritics-support.patch
unicode-diacritics-support-s390-fix.patch
console-events-and-accessibility.patch
console-events-and-accessibility-fix.patch
add-config_vt_unicode.patch
