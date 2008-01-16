From: akpm@linux-foundation.org
Subject: - input-handle-ev_pwr-in-input_set_capability.patch removed from -mm tree
Date: Tue, 15 Jan 2008 23:44:24 -0800
Message-ID: <200801160752.m0G7qkwa027054@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43562 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896AbYAPHw5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jan 2008 02:52:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbaryshkov@gmail.com, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: handle EV_PWR in input_set_capability
has been removed from the -mm tree.  Its filename was
     input-handle-ev_pwr-in-input_set_capability.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-alsa.patch
input-handle-ev_pwr-in-input_set_capability.patch
git-battery.patch
