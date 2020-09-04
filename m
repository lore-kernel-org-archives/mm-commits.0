Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43220C43461
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:36:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EB21208FE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599262575;
	bh=olm94k9c3GwjlR3dQtODcMdhzVRxCIADhzzyHjWm5ok=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=XeP0SlXfK99li98ylBm2cUL+efzIRwaEKPqcFITp2x/x+tjvj7bzDdGZDkBrbZimE
	 SFAWZO/ZoNFi1z8CueiAeBzKOXPXPFkQKxditpJmj4gq4POY22RvjLQ/qQI+5xq/5Q
	 iX5zN2spyGI3FOTn036052gV4DZXUeBq7MA/sOWc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbgIDXgO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 19:36:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:39282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgIDXgO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 19:36:14 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69D5A2084D;
        Fri,  4 Sep 2020 23:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599262573;
        bh=olm94k9c3GwjlR3dQtODcMdhzVRxCIADhzzyHjWm5ok=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yy7TRwLTGKMXeiLKhaoAlAGC05oWplqkCKj7htKpNmpDtzpuO+DKxUrjXhI874hh7
         RQJPWk3OFJfLHiXh7HWsRZJWZ88UFKj1TcIuj5FYIxFWTk88d9szgd0V2MSZ5Nz+RB
         BkfZVK3xAsDckJH2oyH54gxMhQHbLAVYlUq88DFQ=
Date:   Fri, 04 Sep 2020 16:36:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     ak@linux.intel.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        songmuchun@bytedance.com, torvalds@linux-foundation.org
Subject:  [patch 17/19] mm/hugetlb: fix a race between hugetlb
 sysctl handlers
Message-ID: <20200904233613.MaCSNiMVj%akpm@linux-foundation.org>
In-Reply-To: <20200904163454.4db0e6ce0c4584d2653678a3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/hugetlb: fix a race between hugetlb sysctl handlers

There is a race between the assignment of `table->data` and write value to
the pointer of `table->data` in the __do_proc_doulongvec_minmax() on the
other thread.

CPU0:                                 CPU1:
                                      proc_sys_write
hugetlb_sysctl_handler                  proc_sys_call_handler
hugetlb_sysctl_handler_common             hugetlb_sysctl_handler
  table->data = &tmp;                       hugetlb_sysctl_handler_common
                                              table->data = &tmp;
    proc_doulongvec_minmax
      do_proc_doulongvec_minmax           sysctl_head_finish
        __do_proc_doulongvec_minmax         unuse_table
          i = table->data;
          *i = val;  // corrupt CPU1's stack

Fix this by duplicating the `table`, and only update the duplicate of
it. And introduce a helper of proc_hugetlb_doulongvec_minmax() to
simplify the code.

The following oops was seen:

    BUG: kernel NULL pointer dereference, address: 0000000000000000
    #PF: supervisor instruction fetch in kernel mode
    #PF: error_code(0x0010) - not-present page
    Code: Bad RIP value.
    ...
    Call Trace:
     ? set_max_huge_pages+0x3da/0x4f0
     ? alloc_pool_huge_page+0x150/0x150
     ? proc_doulongvec_minmax+0x46/0x60
     ? hugetlb_sysctl_handler_common+0x1c7/0x200
     ? nr_hugepages_store+0x20/0x20
     ? copy_fd_bitmaps+0x170/0x170
     ? hugetlb_sysctl_handler+0x1e/0x20
     ? proc_sys_call_handler+0x2f1/0x300
     ? unregister_sysctl_table+0xb0/0xb0
     ? __fd_install+0x78/0x100
     ? proc_sys_write+0x14/0x20
     ? __vfs_write+0x4d/0x90
     ? vfs_write+0xef/0x240
     ? ksys_write+0xc0/0x160
     ? __ia32_sys_read+0x50/0x50
     ? __close_fd+0x129/0x150
     ? __x64_sys_write+0x43/0x50
     ? do_syscall_64+0x6c/0x200
     ? entry_SYSCALL_64_after_hwframe+0x44/0xa9

Link: http://lkml.kernel.org/r/20200828031146.43035-1-songmuchun@bytedance.com
Fixes: e5ff215941d5 ("hugetlb: multiple hstates for multiple page sizes")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-a-race-between-hugetlb-sysctl-handlers
+++ a/mm/hugetlb.c
@@ -3465,6 +3465,22 @@ static unsigned int allowed_mems_nr(stru
 }
 
 #ifdef CONFIG_SYSCTL
+static int proc_hugetlb_doulongvec_minmax(struct ctl_table *table, int write,
+					  void *buffer, size_t *length,
+					  loff_t *ppos, unsigned long *out)
+{
+	struct ctl_table dup_table;
+
+	/*
+	 * In order to avoid races with __do_proc_doulongvec_minmax(), we
+	 * can duplicate the @table and alter the duplicate of it.
+	 */
+	dup_table = *table;
+	dup_table.data = out;
+
+	return proc_doulongvec_minmax(&dup_table, write, buffer, length, ppos);
+}
+
 static int hugetlb_sysctl_handler_common(bool obey_mempolicy,
 			 struct ctl_table *table, int write,
 			 void *buffer, size_t *length, loff_t *ppos)
@@ -3476,9 +3492,8 @@ static int hugetlb_sysctl_handler_common
 	if (!hugepages_supported())
 		return -EOPNOTSUPP;
 
-	table->data = &tmp;
-	table->maxlen = sizeof(unsigned long);
-	ret = proc_doulongvec_minmax(table, write, buffer, length, ppos);
+	ret = proc_hugetlb_doulongvec_minmax(table, write, buffer, length, ppos,
+					     &tmp);
 	if (ret)
 		goto out;
 
@@ -3521,9 +3536,8 @@ int hugetlb_overcommit_handler(struct ct
 	if (write && hstate_is_gigantic(h))
 		return -EINVAL;
 
-	table->data = &tmp;
-	table->maxlen = sizeof(unsigned long);
-	ret = proc_doulongvec_minmax(table, write, buffer, length, ppos);
+	ret = proc_hugetlb_doulongvec_minmax(table, write, buffer, length, ppos,
+					     &tmp);
 	if (ret)
 		goto out;
 
_
