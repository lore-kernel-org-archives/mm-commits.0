From: akpm@linux-foundation.org
Subject: - braille_console-only-register-notifiers-when-the-braille-console-is-used.patch removed from -mm tree
Date: Fri, 03 Oct 2008 14:28:44 -0700
Message-ID: <200810032128.m93LSiRW016638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753264AbYJCV3W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2008 17:29:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pterjan@mandriva.com, samuel.thibault@ens-lyon.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     braille_console: only register notifiers when the braille console is used
has been removed from the -mm tree.  Its filename was
     braille_console-only-register-notifiers-when-the-braille-console-is-used.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: braille_console: only register notifiers when the braille console is used
From: Pascal Terjan <pterjan@mandriva.com>

Only register the braille driver VT and keyboard notifiers when the
braille console is used.  Avoids eating insert or backspace keys.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=11242

Signed-off-by: Pascal Terjan <pterjan@mandriva.com>
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/accessibility/braille/braille_console.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff -puN drivers/accessibility/braille/braille_console.c~braille_console-only-register-notifiers-when-the-braille-console-is-used drivers/accessibility/braille/braille_console.c
--- a/drivers/accessibility/braille/braille_console.c~braille_console-only-register-notifiers-when-the-braille-console-is-used
+++ a/drivers/accessibility/braille/braille_console.c
@@ -376,6 +376,8 @@ int braille_register_console(struct cons
 	console->flags |= CON_ENABLED;
 	console->index = index;
 	braille_co = console;
+	register_keyboard_notifier(&keyboard_notifier_block);
+	register_vt_notifier(&vt_notifier_block);
 	return 0;
 }
 
@@ -383,15 +385,8 @@ int braille_unregister_console(struct co
 {
 	if (braille_co != console)
 		return -EINVAL;
+	unregister_keyboard_notifier(&keyboard_notifier_block);
+	unregister_vt_notifier(&vt_notifier_block);
 	braille_co = NULL;
 	return 0;
 }
-
-static int __init braille_init(void)
-{
-	register_keyboard_notifier(&keyboard_notifier_block);
-	register_vt_notifier(&vt_notifier_block);
-	return 0;
-}
