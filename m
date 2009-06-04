From: akpm@linux-foundation.org
Subject: + dell-wmi-dont-generate-errors-on-empty-messages.patch added to -mm tree
Date: Thu, 04 Jun 2009 14:07:16 -0700
Message-ID: <200906042107.n54L7GDC004362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752292AbZFDVIc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Jun 2009 17:08:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg@redhat.com, lenb@kernel.org


The patch titled
     dell-wmi: don't generate errors on empty messages
has been added to the -mm tree.  Its filename is
     dell-wmi-dont-generate-errors-on-empty-messages.patch

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
Subject: dell-wmi: don't generate errors on empty messages
From: Matthew Garrett <mjg@redhat.com>

There's no point in generating kernel messages if we didn't receive a
parsable keyboard event - only do so if there appeared to be a scancode.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/dell-wmi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/platform/x86/dell-wmi.c~dell-wmi-dont-generate-errors-on-empty-messages drivers/platform/x86/dell-wmi.c
--- a/drivers/platform/x86/dell-wmi.c~dell-wmi-dont-generate-errors-on-empty-messages
+++ a/drivers/platform/x86/dell-wmi.c
@@ -176,9 +176,9 @@ static void dell_wmi_notify(u32 value, v
 			input_sync(dell_wmi_input_dev);
 			input_report_key(dell_wmi_input_dev, key->keycode, 0);
 			input_sync(dell_wmi_input_dev);
-		} else
+		} else if (buffer[1] & 0xFFFF)
 			printk(KERN_INFO "dell-wmi: Unknown key %x pressed\n",
-			       buffer[1]);
+			       buffer[1] & 0xFFFF);
 	}
 }
 
_

Patches currently in -mm which might be from mjg@redhat.com are

linux-next.patch
dell-wmi-mask-off-upper-bytes-of-event-response.patch
dell-wmi-add-additional-keyboard-events.patch
dell-wmi-dont-generate-errors-on-empty-messages.patch
hp-wmi-add-support-for-reporting-tablet-state.patch

