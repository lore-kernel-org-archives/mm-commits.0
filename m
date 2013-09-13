From: akpm@linux-foundation.org
Subject: [merged] memcg-correct-resource_max-to-ullong_max.patch removed
 from -mm tree
Date: Fri, 13 Sep 2013 13:02:34 -0700
Message-ID: <52336f5a.vgs4A6mZLusCwVs1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37982 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab3IMUCf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 16:02:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, nishimura@mxp.nes.nec.co.jp, mhocko@suse.cz, jeff.liu@oracle.com, h.huangqiang@huawei.com, handai.szj@taobao.com

Subject: [merged] memcg-correct-resource_max-to-ullong_max.patch removed from -mm tree
To: handai.szj@taobao.com,h.huangqiang@huawei.com,jeff.liu@oracle.com,mhocko@suse.cz,nishimura@mxp.nes.nec.co.jp,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 13:02:34 -0700


The patch titled
     Subject: memcg: correct RESOURCE_MAX to ULLONG_MAX
has been removed from the -mm tree.  Its filename was
     memcg-correct-resource_max-to-ullong_max.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sha Zhengju <handai.szj@taobao.com>
Subject: memcg: correct RESOURCE_MAX to ULLONG_MAX

Current RESOURCE_MAX is ULONG_MAX, but the value we used to set resource
limit is unsigned long long, so we can set bigger value than that which is
strange.  The XXX_MAX should be reasonable max value, bigger than that
should be overflow.

Notice that this change will affect user output of default *.limit_in_bytes:
before change:
$ cat /cgroup/memory/memory.limit_in_bytes
9223372036854775807

after change:
$ cat /cgroup/memory/memory.limit_in_bytes
18446744073709551615

But it doesn't alter the API in term of input - we can still use "echo -1
> *.limit_in_bytes" to reset the numbers to "unlimited".

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
Signed-off-by: Qiang Huang <h.huangqiang@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Jeff Liu <jeff.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/res_counter.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/res_counter.h~memcg-correct-resource_max-to-ullong_max include/linux/res_counter.h
--- a/include/linux/res_counter.h~memcg-correct-resource_max-to-ullong_max
+++ a/include/linux/res_counter.h
@@ -54,7 +54,7 @@ struct res_counter {
 	struct res_counter *parent;
 };
 
-#define RESOURCE_MAX (unsigned long long)LLONG_MAX
+#define RESOURCE_MAX ULLONG_MAX
 
 /**
  * Helpers to interact with userspace
_

Patches currently in -mm which might be from handai.szj@taobao.com are

origin.patch

