From: akpm@linux-foundation.org
Subject: + idr_remove_all-kill-unused-variable.patch added to -mm tree
Date: Fri, 20 Jul 2007 11:07:18 -0700
Message-ID: <200707201807.l6KI7IOq009266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43308 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754216AbXGTSIA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 14:08:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru


The patch titled
     idr_remove_all: kill unused variable
has been added to the -mm tree.  Its filename is
     idr_remove_all-kill-unused-variable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: idr_remove_all: kill unused variable
From: Oleg Nesterov <oleg@tv-sign.ru>

"error" is always equal to 0.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/idr.c~idr_remove_all-kill-unused-variable lib/idr.c
--- a/lib/idr.c~idr_remove_all-kill-unused-variable
+++ a/lib/idr.c
@@ -405,7 +405,7 @@ EXPORT_SYMBOL(idr_remove);
  */
 void idr_remove_all(struct idr *idp)
 {
-	int n, id, max, error = 0;
+	int n, id, max;
 	struct idr_layer *p;
 	struct idr_layer *pa[MAX_LEVEL];
 	struct idr_layer **paa = &pa[0];
@@ -415,7 +415,7 @@ void idr_remove_all(struct idr *idp)
 	max = 1 << n;
 
 	id = 0;
-	while (id < max && !error) {
+	while (id < max) {
 		while (n > IDR_BITS && p) {
 			n -= IDR_BITS;
 			*paa++ = p;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
i386-remove-unnecessary-code.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
sys_time-use-barrier-instead-of-smp_rmb.patch
do_sys_poll-simplify-playing-with-on-stack-data.patch
do_poll-return-eintr-when-signalled.patch
idr_remove_all-kill-unused-variable.patch
