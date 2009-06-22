From: akpm@linux-foundation.org
Subject: [merged] dell-wmi-dont-generate-errors-on-empty-messages.patch removed from -mm tree
Date: Mon, 22 Jun 2009 10:01:02 -0700
Message-ID: <200906221701.n5MH12YN010395@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752641AbZFVRLM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jun 2009 13:11:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mjg@redhat.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     dell-wmi: don't generate errors on empty messages
has been removed from the -mm tree.  Its filename was
     dell-wmi-dont-generate-errors-on-empty-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

