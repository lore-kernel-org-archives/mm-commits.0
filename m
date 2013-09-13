From: akpm@linux-foundation.org
Subject: [merged] memcg-reduce-function-dereference.patch removed from -mm tree
Date: Fri, 13 Sep 2013 13:02:40 -0700
Message-ID: <52336f60.GRLOAY3lU/8W6d4o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38002 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab3IMUCl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 16:02:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, nishimura@mxp.nes.nec.co.jp, mhocko@suse.cz, jeff.liu@oracle.com, h.huangqiang@huawei.com, handai.szj@taobao.com

Subject: [merged] memcg-reduce-function-dereference.patch removed from -mm tree
To: handai.szj@taobao.com,h.huangqiang@huawei.com,jeff.liu@oracle.com,mhocko@suse.cz,nishimura@mxp.nes.nec.co.jp,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 13:02:40 -0700


The patch titled
     Subject: memcg: reduce function dereference
has been removed from the -mm tree.  Its filename was
     memcg-reduce-function-dereference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

