From: akpm@linux-foundation.org
Subject: + proc-vmcore-use-kzalloc-in-get_new_element.patch added to -mm tree
Date: Thu, 11 Jun 2009 15:19:11 -0700
Message-ID: <200906112219.n5BMJB5L031555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751536AbZFKWT7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jun 2009 18:19:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, gorcunov@openvz.org, vgoyal@redhat.com, xiyou.wangcong@gmail.com


The patch titled
     proc: vmcore - use kzalloc in get_new_element
has been added to the -mm tree.  Its filename is
     proc-vmcore-use-kzalloc-in-get_new_element.patch

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
Subject: proc: vmcore - use kzalloc in get_new_element
From: Cyrill Gorcunov <gorcunov@gmail.com>

Instead of kmalloc+memset better use straight kzalloc

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN fs/proc/vmcore.c~proc-vmcore-use-kzalloc-in-get_new_element fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~proc-vmcore-use-kzalloc-in-get_new_element
+++ a/fs/proc/vmcore.c
@@ -166,12 +166,7 @@ static const struct file_operations proc
 
 static struct vmcore* __init get_new_element(void)
 {
-	struct vmcore *p;
