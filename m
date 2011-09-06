From: akpm@linux-foundation.org
Subject: + drivers-misc-ptic-give-comm-function-scope-in-pti_control_frame_built_and_sent.patch added to -mm tree
Date: Tue, 06 Sep 2011 14:25:44 -0700
Message-ID: <201109062125.p86LPiXY001707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751600Ab1IFVZx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 17:25:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jj@chaosbits.net, gregkh@suse.de, james_p_freyensee@linux.intel.com, rocher.jeremy@gmail.com, slyfox@gentoo.org


The patch titled
     drivers/misc/pti.c: give 'comm' function scope in pti_control_frame_built_and_sent()
has been added to the -mm tree.  Its filename is
     drivers-misc-ptic-give-comm-function-scope-in-pti_control_frame_built_and_sent.patch

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
Subject: drivers/misc/pti.c: give 'comm' function scope in pti_control_frame_built_and_sent()
From: Jesper Juhl <jj@chaosbits.net>

In drivers/misc/pti.c::pti_control_frame_built_and_sent() we assign 'comm'
to 'thread_name_p' if (!thread_name).  The problem is that 'comm' then
goes out of scope and later we use 'thread_name_p' which now refers to an
out-of-scope variable.  To fix that, simply move 'comm' up to have
function scope.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: J Freyensee <james_p_freyensee@linux.intel.com>
Cc: Jeremy Rocher <rocher.jeremy@gmail.com>
Cc: Sergei Trofimovich <slyfox@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/pti.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN drivers/misc/pti.c~drivers-misc-ptic-give-comm-function-scope-in-pti_control_frame_built_and_sent drivers/misc/pti.c
--- a/drivers/misc/pti.c~drivers-misc-ptic-give-comm-function-scope-in-pti_control_frame_built_and_sent
+++ a/drivers/misc/pti.c
@@ -165,6 +165,11 @@ static void pti_write_to_aperture(struct
 static void pti_control_frame_built_and_sent(struct pti_masterchannel *mc,
 					     const char *thread_name)
 {
+	/*
+	 * Since we access the comm member in current's task_struct, we only
+	 * need to be as large as what 'comm' in that structure is.
+	 */
+	char comm[TASK_COMM_LEN];
 	struct pti_masterchannel mccontrol = {.master = CONTROL_ID,
 					      .channel = 0};
 	const char *thread_name_p;
@@ -172,13 +177,6 @@ static void pti_control_frame_built_and_
 	u8 control_frame[CONTROL_FRAME_LEN];
 
 	if (!thread_name) {
-		/*
-		 * Since we access the comm member in current's task_struct,
-		 * we only need to be as large as what 'comm' in that
-		 * structure is.
-		 */
-		char comm[TASK_COMM_LEN];
