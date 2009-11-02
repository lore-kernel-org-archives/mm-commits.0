From: akpm@linux-foundation.org
Subject: + swap_info-include-first_swap_extent-fix.patch added to -mm tree
Date: Mon, 02 Nov 2009 14:30:14 -0800
Message-ID: <200911022230.nA2MUELQ020814@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932548AbZKBWa3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2009 17:30:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com


The patch titled
     mm: swapfile, fix crash on double swapon
has been added to the -mm tree.  Its filename is
     swap_info-include-first_swap_extent-fix.patch

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
Subject: mm: swapfile, fix crash on double swapon
From: Jiri Slaby <jirislaby@gmail.com>

Double swapon on a device causes a crash:
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffff810af160>] sys_swapon+0x1f0/0xc60
PGD 1dc0b067 PUD 1dc09067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file:
CPU 1
Modules linked in:
Pid: 562, comm: swapon Tainted: G        W  2.6.32-rc5-mm1_64 #867
RIP: 0010:[<ffffffff810af160>]  [<ffffffff810af160>] sys_swapon+0x1f0/0xc60
...

It is due to swap_info_struct->first_swap_extent.list not being
initialized. ->next is NULL in such a situation and
destroy_swap_extents fails to iterate over the list with the BUG
above.

Introduced by swap_info-include-first_swap_extent.patch. Revert the
INIT_LIST_HEAD move.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/swapfile.c~swap_info-include-first_swap_extent-fix mm/swapfile.c
--- a/mm/swapfile.c~swap_info-include-first_swap_extent-fix
+++ a/mm/swapfile.c
@@ -1365,7 +1365,6 @@ add_swap_extent(struct swap_info_struct 
 	if (start_page == 0) {
 		se = &sis->first_swap_extent;
 		sis->curr_swap_extent = se;
-		INIT_LIST_HEAD(&se->list);
 		se->start_page = 0;
 		se->nr_pages = nr_pages;
 		se->start_block = start_block;
@@ -1818,6 +1817,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 		kfree(p);
 		goto out;
 	}
+	INIT_LIST_HEAD(&p->first_swap_extent.list);
 	if (type >= nr_swapfiles) {
 		p->type = type;
 		swap_info[type] = p;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
isdn-hisax-fix-lock-imbalance.patch
isdn-eicon-use-offsetof.patch
isdn-eicon-return-on-error.patch
swap_info-include-first_swap_extent-fix.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch
char-mxser-remove-unnecessary-tty-test.patch
isicomc-use-pr_fmt-and-pr_level.patch
reiser4.patch
fs-reiser4-add-parenths-around-x-y.patch

