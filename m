Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43A81C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 05:03:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DDEE619D3
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 05:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbhCaFC7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 01:02:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhCaFC1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 01:02:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A643D61998;
        Wed, 31 Mar 2021 05:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617166946;
        bh=ZWp2nrx5WiXGeksGG37fTtbzlOnQKtyojAV0FieiXQk=;
        h=Date:From:To:Subject:From;
        b=Hzgu/+WivClzIzp4T2cEHGQh2E7eGakrpkhAP4Q6uCBnn8Jc3RD6X6Su2LZqqfXtP
         Yr/nMyYul4yXCWT5dFFXyWfg+CHLoiXSo7z4DKXECzxKgCtwubhAHL3EpYzg8mTEo+
         WfS3IVV5RZATQ8AsOQfZXDf+eG2JB01FZytTv9h0=
Date:   Tue, 30 Mar 2021 22:02:26 -0700
From:   akpm@linux-foundation.org
To:     mhocko@suse.com, mm-commits@vger.kernel.org,
        songmuchun@bytedance.com, wanjiabing@vivo.com
Subject:  +
 linux-memcontrolh-remove-duplicate-struct-declaration.patch added to -mm
 tree
Message-ID: <20210331050226.5ullL5zvw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux/memcontrol.h: remove duplicate struct declaration
has been added to the -mm tree.  Its filename is
     linux-memcontrolh-remove-duplicate-struct-declaration.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-memcontrolh-remove-duplicate-struct-declaration.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-memcontrolh-remove-duplicate-struct-declaration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wan Jiabing <wanjiabing@vivo.com>
Subject: linux/memcontrol.h: remove duplicate struct declaration

struct mem_cgroup is declared twice.  One has been declared at forward
struct declaration.  Remove the duplicate.

Link: https://lkml.kernel.org/r/20210330020246.2265371-1-wanjiabing@vivo.com
Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/memcontrol.h~linux-memcontrolh-remove-duplicate-struct-declaration
+++ a/include/linux/memcontrol.h
@@ -1117,8 +1117,6 @@ unsigned long mem_cgroup_soft_limit_recl
 #define MEM_CGROUP_ID_SHIFT	0
 #define MEM_CGROUP_ID_MAX	0
 
-struct mem_cgroup;
-
 static inline struct mem_cgroup *page_memcg(struct page *page)
 {
 	return NULL;
_

Patches currently in -mm which might be from wanjiabing@vivo.com are

linux-memcontrolh-remove-duplicate-struct-declaration.patch

