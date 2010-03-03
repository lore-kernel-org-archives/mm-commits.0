From: akpm@linux-foundation.org
Subject: + i4l-silence-compiler-warnings-for-array-access-in-eicon-diva-isdn-driver.patch added to -mm tree
Date: Wed, 03 Mar 2010 14:57:22 -0800
Message-ID: <201003032257.o23MvM8Z003744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750880Ab0CCW5q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Mar 2010 17:57:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: imunsie@au.ibm.com, isdn@linux-pingi.de, mac@melware.de, sgayda2@uiuc.edu


The patch titled
     i4l: silence compiler warnings for array access in Eicon DIVA ISDN driver
has been added to the -mm tree.  Its filename is
     i4l-silence-compiler-warnings-for-array-access-in-eicon-diva-isdn-driver.patch

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
Subject: i4l: silence compiler warnings for array access in Eicon DIVA ISDN driver
From: Ian Munsie <imunsie@au.ibm.com>

When compiling this driver, the compiler throws the following warnings:

drivers/isdn/hardware/eicon/message.c:8426: warning: array subscript is above array bounds
drivers/isdn/hardware/eicon/message.c:8427: warning: array subscript is above array bounds
drivers/isdn/hardware/eicon/message.c:8434: warning: array subscript is above array bounds
drivers/isdn/hardware/eicon/message.c:8435: warning: array subscript is above array bounds
drivers/isdn/hardware/eicon/message.c:8436: warning: array subscript is above array bounds
drivers/isdn/hardware/eicon/message.c:8447: warning: array subscript is above array bounds

This arises from the particular semantics the driver is using to write to
the nlc array (static byte[256]).  The array has a length in byte 0
followed by a T30_INFO struct starting at byte 1.

The T30_INFO struct has a number of variable length strings after the
station_id entry, which cannot be explicitly defined in the struct and the
driver accesses them with an array index to station_id beyond the length
of station_id.

This patch merely changes the semantics that the driver uses to access the
entries after the station_id entry to use the original 256 byte nlc array
taking the offset and length of the station_id entry to calculate where to
write in the array, thereby silencing the warning.

Signed-off-by: Ian Munsie <imunsie@au.ibm.com>
Cc: Armin Schindler <mac@melware.de>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: Stoyan Gaydarov <sgayda2@uiuc.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/eicon/message.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN drivers/isdn/hardware/eicon/message.c~i4l-silence-compiler-warnings-for-array-access-in-eicon-diva-isdn-driver drivers/isdn/hardware/eicon/message.c
--- a/drivers/isdn/hardware/eicon/message.c~i4l-silence-compiler-warnings-for-array-access-in-eicon-diva-isdn-driver
+++ a/drivers/isdn/hardware/eicon/message.c
@@ -8423,17 +8423,17 @@ static word add_b23(PLCI *plci, API_PARS
             pos = 0;
           else
           {
-            ((T30_INFO *)&nlc[1])->station_id[20 + pos++] = ' ';
-            ((T30_INFO *)&nlc[1])->station_id[20 + pos++] = ' ';
+            nlc[1 + offsetof(T30_INFO, station_id) + 20 + pos++] = ' ';
+            nlc[1 + offsetof(T30_INFO, station_id) + 20 + pos++] = ' ';
             len = (byte)b3_config_parms[2].length;
             if (len > 20)
               len = 20;
             if (CAPI_MAX_DATE_TIME_LENGTH + 2 + len + 2 + b3_config_parms[3].length <= CAPI_MAX_HEAD_LINE_SPACE)
             {
               for (i = 0; i < len; i++)
-                ((T30_INFO *)&nlc[1])->station_id[20 + pos++] = ((byte   *)b3_config_parms[2].info)[1+i];
-              ((T30_INFO *)&nlc[1])->station_id[20 + pos++] = ' ';
-              ((T30_INFO *)&nlc[1])->station_id[20 + pos++] = ' ';
+                nlc[1 + offsetof(T30_INFO, station_id) + 20 + pos++] = ((byte   *)b3_config_parms[2].info)[1+i];
+              nlc[1 + offsetof(T30_INFO, station_id) + 20 + pos++] = ' ';
+              nlc[1 + offsetof(T30_INFO, station_id) + 20 + pos++] = ' ';
             }
           }
         }
@@ -8444,9 +8444,8 @@ static word add_b23(PLCI *plci, API_PARS
         ((T30_INFO *)&nlc[1])->head_line_len = (byte)(pos + len);
         nlc[0] += (byte)(pos + len);
         for (i = 0; i < len; i++)
-          ((T30_INFO *)&nlc[1])->station_id[20 + pos++] = ((byte   *)b3_config_parms[3].info)[1+i];
-        }
-      else
+          nlc[1 + offsetof(T30_INFO, station_id) + 20 + pos++] =  ((byte   *)b3_config_parms[3].info)[1+i];
+      } else
         ((T30_INFO *)&nlc[1])->head_line_len = 0;
 
       plci->nsf_control_bits = 0;
_

Patches currently in -mm which might be from imunsie@au.ibm.com are

i4l-silence-compiler-warnings-for-array-access-in-eicon-diva-isdn-driver.patch
i4l-change-magic-numbers-in-eicon-diva-isdn-driver-to-symbolic-names.patch

