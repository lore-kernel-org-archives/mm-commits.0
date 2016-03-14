From: akpm@linux-foundation.org
Subject: + ocfs2-dlm-fix-a-variable-overflow-problem-in-dlmdomainc.patch
 added to -mm tree
Date: Mon, 14 Mar 2016 12:42:21 -0700
Message-ID: <56e7141d.Ckip012Velzrdi7M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47748 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbcCNTmW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Mar 2016 15:42:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: piaojun@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: fix a variable overflow problem in dlmdomain.c
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-fix-a-variable-overflow-problem-in-dlmdomainc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-fix-a-variable-overflow-problem-in-dlmdomainc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-fix-a-variable-overflow-problem-in-dlmdomainc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: piaojun <piaojun@huawei.com>
Subject: ocfs2/dlm: fix a variable overflow problem in dlmdomain.c

In dlm_send_join_cancels(), node is defined with type unsigned int, but
initialized with -1, this will lead variable overflow. Although this
won't cause any runtime problem, the code looks a little uncoordinated.

Signed-off-by: Jun Piao <piaojun@huawei.com>
---
 1 file changed, 1 insertion(+), 1 deletion(-)

index 2ee7fe7..8cbf6e8 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdomain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/dlm/dlmdomain.c~ocfs2-dlm-fix-a-variable-overflow-problem-in-dlmdomainc fs/ocfs2/dlm/dlmdomain.c
--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-dlm-fix-a-variable-overflow-problem-in-dlmdomainc
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -1399,7 +1399,7 @@ static int dlm_send_join_cancels(struct
 				 unsigned int map_size)
 {
 	int status, tmpstat;
-	unsigned int node;
+	int node;
 
 	if (map_size != (BITS_TO_LONGS(O2NM_MAX_NODES) *
 			 sizeof(unsigned long))) {
_

Patches currently in -mm which might be from piaojun@huawei.com are

ocfs2-dlm-fix-a-variable-overflow-problem-in-dlmdomainc.patch

