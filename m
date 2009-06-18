From: akpm@linux-foundation.org
Subject: [merged] proc-vmcore-use-kzalloc-in-get_new_element.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:43:56 -0700
Message-ID: <200906182243.n5IMhuEc002948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758017AbZFRWoN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:44:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, gorcunov@openvz.org, vgoyal@redhat.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     proc: vmcore - use kzalloc in get_new_element()
has been removed from the -mm tree.  Its filename was
     proc-vmcore-use-kzalloc-in-get_new_element.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: vmcore - use kzalloc in get_new_element()
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
