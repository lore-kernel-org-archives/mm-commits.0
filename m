From: akpm@linux-foundation.org
Subject: [merged]
 fseventpoll-dont-test-for-bitfield-with-stack-value.patch removed from -mm
 tree
Date: Tue, 28 Feb 2017 12:50:14 -0800
Message-ID: <58b5e286.t80DA2Lanm9/GKTO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52752 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751786AbdB1Uvc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:51:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, avagin@virtuozzo.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs,eventpoll: don't test for bitfield with stack value
has been removed from the -mm tree.  Its filename was
     fseventpoll-dont-test-for-bitfield-with-stack-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: fs,eventpoll: don't test for bitfield with stack value

In case if epoll_ctl is called with operation EPOLL_CTL_DEL then
@epds.events variable allocated on stack may contain random bits which
we test then for EPOLLEXCLUSIVE. Since currently the test look
like

	if (epds.events & EPOLLEXCLUSIVE) {
		if (op == EPOLL_CTL_MOD)
			goto error_tgt_fput;
		if (op == EPOLL_CTL_ADD && (is_file_epoll(tf.file) ||
				(epds.events & ~EPOLLEXCLUSIVE_OK_BITS)))
			goto error_tgt_fput;
	}

Nothing serious will happen even if epds.events has this bit set,
still better to be on safe side and make sure that we're to test
this bit at all.

Link: http://lkml.kernel.org/r/20170214154935.GG1850@uranus.lan
Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrey Vagin <avagin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/eventpoll.c~fseventpoll-dont-test-for-bitfield-with-stack-value fs/eventpoll.c
--- a/fs/eventpoll.c~fseventpoll-dont-test-for-bitfield-with-stack-value
+++ a/fs/eventpoll.c
@@ -1895,7 +1895,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
 	 * so EPOLLEXCLUSIVE is not allowed for a EPOLL_CTL_MOD operation.
 	 * Also, we do not currently supported nested exclusive wakeups.
 	 */
-	if (epds.events & EPOLLEXCLUSIVE) {
+	if (ep_op_has_event(op) && (epds.events & EPOLLEXCLUSIVE)) {
 		if (op == EPOLL_CTL_MOD)
 			goto error_tgt_fput;
 		if (op == EPOLL_CTL_ADD && (is_file_epoll(tf.file) ||
_

Patches currently in -mm which might be from gorcunov@gmail.com are


