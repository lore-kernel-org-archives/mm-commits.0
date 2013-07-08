From: akpm@linux-foundation.org
Subject: + ncpfs-fix-error-return-code-in-ncp_parse_options.patch added to -mm tree
Date: Mon, 08 Jul 2013 13:46:39 -0700
Message-ID: <51db252f.JHJ3Eiof7sb5/fd+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072Ab3GHUqk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 16:46:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, petr@vandrovec.name, yongjun_wei@trendmicro.com.cn

Subject: + ncpfs-fix-error-return-code-in-ncp_parse_options.patch added to -mm tree
To: yongjun_wei@trendmicro.com.cn,petr@vandrovec.name
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 13:46:39 -0700


The patch titled
     Subject: ncpfs: fix error return code in ncp_parse_options()
has been added to the -mm tree.  Its filename is
     ncpfs-fix-error-return-code-in-ncp_parse_options.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ncpfs-fix-error-return-code-in-ncp_parse_options.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ncpfs-fix-error-return-code-in-ncp_parse_options.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
ncpfs-fix-error-return-code-in-ncp_parse_options.patch

