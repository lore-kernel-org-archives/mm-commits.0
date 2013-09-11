From: akpm@linux-foundation.org
Subject: [folded-merged]
 block-support-embedded-device-command-line-partition-fix.patch removed from -mm tree
Date: Wed, 11 Sep 2013 13:51:21 -0700
Message-ID: <5230d7c9.TBAH6T/McCmO5qyU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628Ab3IKUvW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 16:51:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, caizhiyong@huawei.com, yongjun_wei@trendmicro.com.cn

Subject: [folded-merged] block-support-embedded-device-command-line-partition-fix.patch removed from -mm tree
To: yongjun_wei@trendmicro.com.cn,caizhiyong@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 13:51:21 -0700


The patch titled
     Subject: block: fix error return code in parse_parts()
has been removed from the -mm tree.  Its filename was
     block-support-embedded-device-command-line-partition-fix.patch

This patch was dropped because it was folded into block-support-embedded-device-command-line-partition.patch

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: block: fix error return code in parse_parts()

Fix to return -EINVAL in the parts parse error handling case instead of
0(may overwrite to 0 by parse_subpart()), as done elsewhere in this
function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Cai Zhiyong <caizhiyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/cmdline-parser.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN block/cmdline-parser.c~block-support-embedded-device-command-line-partition-fix block/cmdline-parser.c
--- a/block/cmdline-parser.c~block-support-embedded-device-command-line-partition-fix
+++ a/block/cmdline-parser.c
@@ -135,6 +135,7 @@ static int parse_parts(struct cmdline_pa
 
 	if (!newparts->subpart) {
 		pr_warn("cmdline partition has no valid partition.");
+		ret = -EINVAL;
 		goto fail;
 	}
 
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

origin.patch
block-support-embedded-device-command-line-partition.patch
mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage-fix.patch

