From: akpm@linux-foundation.org
Subject: + dell-studio-1555-eject-key-does-not-work-small-patch-to-fix-included.patch added to -mm tree
Date: Wed, 02 Jun 2010 14:27:03 -0700
Message-ID: <201006022127.o52LR3vU017946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758048Ab0FBV1j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jun 2010 17:27:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pharon@gmail.com, lenb@kernel.org, mjg@redhat.com


The patch titled
     drivers/platform/x86/dell-wmi.c: fix Dell Studio 1555 eject key
has been added to the -mm tree.  Its filename is
     dell-studio-1555-eject-key-does-not-work-small-patch-to-fix-included.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/platform/x86/dell-wmi.c: fix Dell Studio 1555 eject key
From: Islam Amer <pharon@gmail.com>

Pressing the eject key on my Dell Studio 1555 does not work and dmesg
produces this message :

dell-wmi: Unknown key 0 pressed

Adding a debugging printk in dell-wmi.c after line 222 like this :

printk(KERN_INFO "dell:wmi 0x%x , 0x%x \n", buffer_entry[1], buffer_entry[2]);

dmesg now shows :

dell:wmi 0x0 , 0xe009
dell-wmi: Unknown key 0 pressed

So for some reason buffer_entry[1] is used although it is empty.

Falling back to buffer_entry[2] in case buffer_entry[1] is 0x0 makes the
button work.

I suspect it might be better to fix the "dell_new_hk_type" logic though

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=16075

Cc: Matthew Garrett <mjg@redhat.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/dell-wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/platform/x86/dell-wmi.c~dell-studio-1555-eject-key-does-not-work-small-patch-to-fix-included drivers/platform/x86/dell-wmi.c
--- a/drivers/platform/x86/dell-wmi.c~dell-studio-1555-eject-key-does-not-work-small-patch-to-fix-included
+++ a/drivers/platform/x86/dell-wmi.c
@@ -221,7 +221,7 @@ static void dell_wmi_notify(u32 value, v
 			return;
 		}
 
-		if (dell_new_hk_type)
+		if (dell_new_hk_type || buffer_entry[1] == 0x0)
 			reported_key = (int)buffer_entry[2];
 		else
 			reported_key = (int)buffer_entry[1] & 0xffff;
_

Patches currently in -mm which might be from pharon@gmail.com are

dell-studio-1555-eject-key-does-not-work-small-patch-to-fix-included.patch

