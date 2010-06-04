From: akpm@linux-foundation.org
Subject: + floppy-make-controller-const.patch added to -mm tree
Date: Fri, 04 Jun 2010 13:59:45 -0700
Message-ID: <201006042059.o54KxjF5017444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37308 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756020Ab0FDU7z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jun 2010 16:59:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@vyatta.com, axboe@kernel.dk


The patch titled
     floppy: make controller const
has been added to the -mm tree.  Its filename is
     floppy-make-controller-const.patch

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
Subject: floppy: make controller const
From: Stephen Hemminger <shemminger@vyatta.com>

The struct cont_t is just a set of virtual function pointers.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/block/floppy.c~floppy-make-controller-const drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-make-controller-const
+++ a/drivers/block/floppy.c
@@ -539,7 +539,7 @@ static int max_buffer_sectors;
 
 static int *errors;
 typedef void (*done_f)(int);
-static struct cont_t {
+static const struct cont_t {
 	void (*interrupt)(void);
 				/* this is called after the interrupt of the
 				 * main command */
@@ -1995,14 +1995,14 @@ static void do_wakeup(void)
 	wake_up(&command_done);
 }
 
-static struct cont_t wakeup_cont = {
+static const struct cont_t wakeup_cont = {
 	.interrupt	= empty,
 	.redo		= do_wakeup,
 	.error		= empty,
 	.done		= (done_f)empty
 };
 
-static struct cont_t intr_cont = {
+static const struct cont_t intr_cont = {
 	.interrupt	= empty,
 	.redo		= process_fd_request,
 	.error		= empty,
@@ -2223,7 +2223,7 @@ static void redo_format(void)
 	debugt(__func__, "queue format request");
 }
 
-static struct cont_t format_cont = {
+static const struct cont_t format_cont = {
 	.interrupt	= format_interrupt,
 	.redo		= redo_format,
 	.error		= bad_flp_intr,
@@ -2921,7 +2921,7 @@ do_request:
 	return;
 }
 
-static struct cont_t rw_cont = {
+static const struct cont_t rw_cont = {
 	.interrupt	= rw_interrupt,
 	.redo		= redo_fd_request,
 	.error		= bad_flp_intr,
@@ -2960,7 +2960,7 @@ static void do_fd_request(struct request
 	is_alive(__func__, "");
 }
 
-static struct cont_t poll_cont = {
+static const struct cont_t poll_cont = {
 	.interrupt	= success_and_wakeup,
 	.redo		= floppy_ready,
 	.error		= generic_failure,
@@ -2991,7 +2991,7 @@ static void reset_intr(void)
 	pr_info("weird, reset interrupt called\n");
 }
 
-static struct cont_t reset_cont = {
+static const struct cont_t reset_cont = {
 	.interrupt	= reset_intr,
 	.redo		= success_and_wakeup,
 	.error		= generic_failure,
@@ -3096,7 +3096,7 @@ static void raw_cmd_done(int flag)
 	generic_done(flag);
 }
 
-static struct cont_t raw_cmd_cont = {
+static const struct cont_t raw_cmd_cont = {
 	.interrupt	= success_and_wakeup,
 	.redo		= floppy_start,
 	.error		= generic_failure,
_

Patches currently in -mm which might be from shemminger@vyatta.com are

origin.patch
linux-next.patch
floppy-make-controller-const.patch

