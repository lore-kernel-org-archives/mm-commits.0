From: akpm@linux-foundation.org
Subject: + console-keyboard-mapping-broken-by-04c71976.patch added to -mm tree
Date: Wed, 11 Jun 2008 18:41:32 -0700
Message-ID: <200806120141.m5C1fWXD028102@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539AbYFLBmB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jun 2008 21:42:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbohac@suse.cz, samuel.thibault@ens-lyon.org


The patch titled
     console keyboard mapping broken by 04c71976
has been added to the -mm tree.  Its filename is
     console-keyboard-mapping-broken-by-04c71976.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -679,12 +679,7 @@ static void k_deadunicode(struct vc_data
 
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

console-keyboard-mapping-broken-by-04c71976.patch

