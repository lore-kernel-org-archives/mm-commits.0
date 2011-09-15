From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-ptic-give-comm-function-scope-in-pti_control_frame_built_and_sent.patch removed from -mm tree
Date: Thu, 15 Sep 2011 12:36:42 -0700
Message-ID: <201109151936.p8FJagKK014155@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:10571 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934580Ab1IOTg4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Sep 2011 15:36:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jj@chaosbits.net, gregkh@suse.de, james_p_freyensee@linux.intel.com, rocher.jeremy@gmail.com, slyfox@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     drivers/misc/pti.c: give 'comm' function scope in pti_control_frame_built_and_sent()
has been removed from the -mm tree.  Its filename was
     drivers-misc-ptic-give-comm-function-scope-in-pti_control_frame_built_and_sent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
