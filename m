From: akpm@linux-foundation.org
Subject: + memcg-avoid-overflow-caused-by-page_align.patch added to -mm
 tree
Date: Wed, 07 Aug 2013 13:36:04 -0700
Message-ID: <5202afb4.h4ve012Snv5myhYA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39840 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933023Ab3HGUgF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Aug 2013 16:36:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, nishimura@mxp.nes.nec.co.jp, mhocko@suse.cz, jeff.liu@oracle.com, h.huangqiang@huawei.com, handai.szj@taobao.com

Subject: + memcg-avoid-overflow-caused-by-page_align.patch added to -mm tree
To: handai.szj@taobao.com,h.huangqiang@huawei.com,jeff.liu@oracle.com,mhocko@suse.cz,nishimura@mxp.nes.nec.co.jp
From: akpm@linux-foundation.org
Date: Wed, 07 Aug 2013 13:36:04 -0700


The patch titled
     Subject: memcg: avoid overflow caused by PAGE_ALIGN
has been added to the -mm tree.  Its filename is
     memcg-avoid-overflow-caused-by-page_align.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-avoid-overflow-caused-by-page_align.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-avoid-overflow-caused-by-page_align.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sha Zhengju <handai.szj@taobao.com>
Subject: memcg: avoid overflow caused by PAGE_ALIGN

Since PAGE_ALIGN is aligning up(the next page boundary), so after
PAGE_ALIGN, the value might be overflow, such as write the MAX value to
*.limit_in_bytes.

$ cat /cgroup/memory/memory.limit_in_bytes
18446744073709551615

# echo 18446744073709551615 > /cgroup/memory/memory.limit_in_bytes
bash: echo: write error: Invalid argument

Some user programs might depend on such behaviours(like libcg, we read the
value in snapshot, then use the value to reset cgroup later), and that
will cause confusion.  So we need to fix it.

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
Signed-off-by: Qiang Huang <h.huangqiang@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Jeff Liu <jeff.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/res_counter.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN kernel/res_counter.c~memcg-avoid-overflow-caused-by-page_align kernel/res_counter.c
--- a/kernel/res_counter.c~memcg-avoid-overflow-caused-by-page_align
+++ a/kernel/res_counter.c
@@ -195,6 +195,10 @@ int res_counter_memparse_write_strategy(
 	if (*end != '\0')
 		return -EINVAL;
 
-	*res = PAGE_ALIGN(*res);
+	if (PAGE_ALIGN(*res) >= *res)
+		*res = PAGE_ALIGN(*res);
+	else
+		*res = RES_COUNTER_MAX;
+
 	return 0;
 }
_

Patches currently in -mm which might be from handai.szj@taobao.com are

memcg-correct-resource_max-to-ullong_max.patch
memcg-rename-resource_max-to-res_counter_max.patch
memcg-avoid-overflow-caused-by-page_align.patch
memcg-reduce-function-dereference.patch

