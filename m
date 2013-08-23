From: akpm@linux-foundation.org
Subject: + block-support-embedded-device-command-line-partition-fix.patch
 added to -mm tree
Date: Fri, 23 Aug 2013 15:36:18 -0700
Message-ID: <5217e3e2.55MUb93CtoCA6b/g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60883 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab3HWWgT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Aug 2013 18:36:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, caizhiyong@huawei.com, yongjun_wei@trendmicro.com.cn

Subject: + block-support-embedded-device-command-line-partition-fix.patch added to -mm tree
To: yongjun_wei@trendmicro.com.cn,caizhiyong@huawei.com
From: akpm@linux-foundation.org
Date: Fri, 23 Aug 2013 15:36:18 -0700


The patch titled
     Subject: block: fix error return code in parse_parts()
has been added to the -mm tree.  Its filename is
     block-support-embedded-device-command-line-partition-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/block-support-embedded-device-command-line-partition-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/block-support-embedded-device-command-line-partition-fix.patch

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
block-support-embedded-device-command-line-partition-fix.patch
mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage-fix.patch
linux-next.patch

