From: akpm@linux-foundation.org
Subject: [merged] ncpfs-fix-error-return-code-in-ncp_parse_options.patch
 removed from -mm tree
Date: Tue, 09 Jul 2013 14:04:40 -0700
Message-ID: <51dc7ae8.1zFhGT9Aj6rSPu/g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab3GIVEl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 17:04:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, petr@vandrovec.name, yongjun_wei@trendmicro.com.cn

Subject: [merged] ncpfs-fix-error-return-code-in-ncp_parse_options.patch removed from -mm tree
To: yongjun_wei@trendmicro.com.cn,petr@vandrovec.name,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 14:04:40 -0700


The patch titled
     Subject: ncpfs: fix error return code in ncp_parse_options()
has been removed from the -mm tree.  Its filename was
     ncpfs-fix-error-return-code-in-ncp_parse_options.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: ncpfs: fix error return code in ncp_parse_options()

Fix to return -EINVAL from the option parse error handling case instead of
0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Petr Vandrovec <petr@vandrovec.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/inode.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN fs/ncpfs/inode.c~ncpfs-fix-error-return-code-in-ncp_parse_options fs/ncpfs/inode.c
--- a/fs/ncpfs/inode.c~ncpfs-fix-error-return-code-in-ncp_parse_options
+++ a/fs/ncpfs/inode.c
@@ -403,18 +403,24 @@ static int ncp_parse_options(struct ncp_
 		switch (optval) {
 			case 'u':
 				data->uid = make_kuid(current_user_ns(), optint);
-				if (!uid_valid(data->uid))
+				if (!uid_valid(data->uid)) {
+					ret = -EINVAL;
 					goto err;
+				}
 				break;
 			case 'g':
 				data->gid = make_kgid(current_user_ns(), optint);
-				if (!gid_valid(data->gid))
+				if (!gid_valid(data->gid)) {
+					ret = -EINVAL;
 					goto err;
+				}
 				break;
 			case 'o':
 				data->mounted_uid = make_kuid(current_user_ns(), optint);
-				if (!uid_valid(data->mounted_uid))
+				if (!uid_valid(data->mounted_uid)) {
+					ret = -EINVAL;
 					goto err;
+				}
 				break;
 			case 'm':
 				data->file_mode = optint;
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

origin.patch
linux-next.patch

