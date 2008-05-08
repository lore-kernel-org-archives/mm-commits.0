From: akpm@linux-foundation.org
Subject: + mark-res_counter_charge_locked-with-__must_check.patch added to -mm tree
Date: Thu, 08 May 2008 13:06:00 -0700
Message-ID: <200805082006.m48K60p6003320@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762312AbYEHUML (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 16:12:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com


The patch titled
     Mark res_counter_charge(_locked) with __must_check
has been added to the -mm tree.  Its filename is
     mark-res_counter_charge_locked-with-__must_check.patch

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
Subject: Mark res_counter_charge(_locked) with __must_check
From: Pavel Emelyanov <xemul@openvz.org>

Ignoring their return values may result in counter underflow in the future -
when the value charged will be uncharged (or in "leaks" - when the value is
not uncharged).

This also prevents from using charging routines to decrement the
counter value (i.e. uncharge it) ;)

(Current code works OK with res_counter, however :) )

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/res_counter.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/res_counter.h~mark-res_counter_charge_locked-with-__must_check include/linux/res_counter.h
--- a/include/linux/res_counter.h~mark-res_counter_charge_locked-with-__must_check
+++ a/include/linux/res_counter.h
@@ -95,8 +95,10 @@ void res_counter_init(struct res_counter
  * counter->limit _locked call expects the counter->lock to be taken
  */
 
-int res_counter_charge_locked(struct res_counter *counter, unsigned long val);
-int res_counter_charge(struct res_counter *counter, unsigned long val);
+int __must_check res_counter_charge_locked(struct res_counter *counter,
+		unsigned long val);
+int __must_check res_counter_charge(struct res_counter *counter,
+		unsigned long val);
 
 /*
  * uncharge - tell that some portion of the resource is released
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
mark-res_counter_charge_locked-with-__must_check.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

