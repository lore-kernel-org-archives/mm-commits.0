From: akpm@linux-foundation.org
Subject: - console-keyboard-mapping-broken-by-04c71976.patch removed from -mm tree
Date: Sun, 15 Jun 2008 23:04:02 -0700
Message-ID: <200806160604.m5G642u7010647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751929AbYFPGEn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jun 2008 02:04:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbohac@suse.cz, samuel.thibault@ens-lyon.org, mm-commits@vger.kernel.org


The patch titled
     console keyboard mapping broken by 04c71976
has been removed from the -mm tree.  Its filename was
     console-keyboard-mapping-broken-by-04c71976.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: console keyboard mapping broken by 04c71976
From: Jiri Bohac <jbohac@suse.cz>

Several console keyboard maps are broken since

commit 04c71976500352d02f60616d2b960267d8c5fe24
Author: Samuel Thibault <samuel.thibault@ens-lyon.org>
Date:   Tue Oct 16 23:27:04 2007 -0700

    unicode diacritics support
    

because that changeset made k_self consider the value as a latin1
character when in Unicode mode, which is wrong; k_self should still take
the console map into account.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/keyboard.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN drivers/char/keyboard.c~console-keyboard-mapping-broken-by-04c71976 drivers/char/keyboard.c
--- a/drivers/char/keyboard.c~console-keyboard-mapping-broken-by-04c71976
+++ a/drivers/char/keyboard.c
@@ -677,12 +677,7 @@ static void k_deadunicode(struct vc_data
 
 static void k_self(struct vc_data *vc, unsigned char value, char up_flag)
 {
-	unsigned int uni;
-	if (kbd->kbdmode == VC_UNICODE)
-		uni = value;
-	else
-		uni = conv_8bit_to_uni(value);
-	k_unicode(vc, uni, up_flag);
+	k_unicode(vc, conv_8bit_to_uni(value), up_flag);
 }
 
 static void k_dead2(struct vc_data *vc, unsigned char value, char up_flag)
_

Patches currently in -mm which might be from jbohac@suse.cz are

origin.patch

