From: akpm@linux-foundation.org
Subject: [patch 2/9] kernel/acct.c: fix the acct->needcheck check in
 check_free_space()
Date: Thu, 04 Jan 2018 16:17:49 -0800
Message-ID: <5a4ec42d.0TPWNrv7D3ak40TI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35354 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751108AbeAEARu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 Jan 2018 19:17:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, oleg@redhat.com, stable@vger.kernel.org, tsukada@ascade.co.jp, viro@zeniv.linux.org.uk

From: Oleg Nesterov <oleg@redhat.com>
Subject: kernel/acct.c: fix the acct->needcheck check in check_free_space()

As Tsukada explains, the time_is_before_jiffies(acct->needcheck) check is
very wrong, we need time_is_after_jiffies() to make sys_acct() work.

Ignoring the overflows, the code should "goto out" if needcheck > jiffies,
while currently it checks "needcheck < jiffies" and thus in the likely
case check_free_space() does nothing until jiffies overflow.

In particular this means that sys_acct() is simply broken, acct_on() sets
acct->needcheck = jiffies and expects that check_free_space() should set
acct->active = 1 after the free-space check, but this won't happen if
jiffies increments in between.

This was broken by commit 32dc73086015 ("get rid of timer in kern/acct.c")
in 2011, then another (correct) commit 795a2f22a8ea ("acct() should honour
the limits from the very beginning") made the problem more visible.

Link: http://lkml.kernel.org/r/20171213133940.GA6554@redhat.com
Fixes: 32dc73086015 ("get rid of timer in kern/acct.c")
Reported-by: TSUKADA Koutaro <tsukada@ascade.co.jp>
Suggested-by: TSUKADA Koutaro <tsukada@ascade.co.jp>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/acct.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/acct.c~acct-fix-the-acct-needcheck-check-in-check_free_space kernel/acct.c
--- a/kernel/acct.c~acct-fix-the-acct-needcheck-check-in-check_free_space
+++ a/kernel/acct.c
@@ -102,7 +102,7 @@ static int check_free_space(struct bsd_a
 {
 	struct kstatfs sbuf;
 
-	if (time_is_before_jiffies(acct->needcheck))
+	if (time_is_after_jiffies(acct->needcheck))
 		goto out;
 
 	/* May block */
_
