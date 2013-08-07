From: akpm@linux-foundation.org
Subject: + memcg-reduce-function-dereference.patch added to -mm tree
Date: Wed, 07 Aug 2013 13:36:05 -0700
Message-ID: <5202afb5.WNu98LLJAbwcH+RL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39846 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933105Ab3HGUgG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Aug 2013 16:36:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, nishimura@mxp.nes.nec.co.jp, mhocko@suse.cz, jeff.liu@oracle.com, h.huangqiang@huawei.com, handai.szj@taobao.com

Subject: + memcg-reduce-function-dereference.patch added to -mm tree
To: handai.szj@taobao.com,h.huangqiang@huawei.com,jeff.liu@oracle.com,mhocko@suse.cz,nishimura@mxp.nes.nec.co.jp
From: akpm@linux-foundation.org
Date: Wed, 07 Aug 2013 13:36:05 -0700


The patch titled
     Subject: memcg: reduce function dereference
has been added to the -mm tree.  Its filename is
     memcg-reduce-function-dereference.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-reduce-function-dereference.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-reduce-function-dereference.patch

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
Subject: memcg: reduce function dereference

This function dereferences res far too often, so optimize it.

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
Signed-off-by: Qiang Huang <h.huangqiang@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Jeff Liu <jeff.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/res_counter.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff -puN kernel/res_counter.c~memcg-reduce-function-dereference kernel/res_counter.c
--- a/kernel/res_counter.c~memcg-reduce-function-dereference
+++ a/kernel/res_counter.c
@@ -178,27 +178,30 @@ u64 res_counter_read_u64(struct res_coun
 #endif
 
 int res_counter_memparse_write_strategy(const char *buf,
-					unsigned long long *res)
+					unsigned long long *resp)
 {
 	char *end;
+	unsigned long long res;
 
 	/* return RES_COUNTER_MAX(unlimited) if "-1" is specified */
 	if (*buf == '-') {
-		*res = simple_strtoull(buf + 1, &end, 10);
-		if (*res != 1 || *end != '\0')
+		res = simple_strtoull(buf + 1, &end, 10);
+		if (res != 1 || *end != '\0')
 			return -EINVAL;
-		*res = RES_COUNTER_MAX;
+		*resp = RES_COUNTER_MAX;
 		return 0;
 	}
 
-	*res = memparse(buf, &end);
+	res = memparse(buf, &end);
 	if (*end != '\0')
 		return -EINVAL;
 
-	if (PAGE_ALIGN(*res) >= *res)
-		*res = PAGE_ALIGN(*res);
+	if (PAGE_ALIGN(res) >= res)
+		res = PAGE_ALIGN(res);
 	else
-		*res = RES_COUNTER_MAX;
+		res = RES_COUNTER_MAX;
+
+	*resp = res;
 
 	return 0;
 }
_

Patches currently in -mm which might be from handai.szj@taobao.com are

memcg-correct-resource_max-to-ullong_max.patch
memcg-rename-resource_max-to-res_counter_max.patch
memcg-avoid-overflow-caused-by-page_align.patch
memcg-reduce-function-dereference.patch

