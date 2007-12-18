From: akpm@linux-foundation.org
Subject: + input-handle-ev_pwr-in-input_set_capability.patch added to -mm tree
Date: Tue, 18 Dec 2007 15:55:28 -0800
Message-ID: <200712182355.lBINtSEN028453@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40298 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753899AbXLRXzt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 18:55:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbaryshkov@gmail.com, dtor@mail.ru


The patch titled
     input: handle EV_PWR in input_set_capability
has been added to the -mm tree.  Its filename is
     input-handle-ev_pwr-in-input_set_capability.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: input: handle EV_PWR in input_set_capability
From: Dmitry Baryshkov <dbaryshkov@gmail.com>

Handle EV_PWR type of input caps.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/input.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/input/input.c~input-handle-ev_pwr-in-input_set_capability drivers/input/input.c
--- a/drivers/input/input.c~input-handle-ev_pwr-in-input_set_capability
+++ a/drivers/input/input.c
@@ -1332,6 +1332,10 @@ void input_set_capability(struct input_d
 		__set_bit(code, dev->ffbit);
 		break;
 
+	case EV_PWR:
+		/* do nothing */
+		break;
+
 	default:
 		printk(KERN_ERR
 			"input_set_capability: unknown type %u (code %u)\n",
_

Patches currently in -mm which might be from dbaryshkov@gmail.com are

input-handle-ev_pwr-in-input_set_capability.patch
