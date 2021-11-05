Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10CCDC4332F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED2DF61212
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbhKEUon (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:44:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233691AbhKEUol (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:44:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92D7561262;
        Fri,  5 Nov 2021 20:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144921;
        bh=2ID/AI5rqphJTJ7DPV8bsvOzveeYczPqGUWG3G1vemM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=k5Kkc13nw9hhpAiYr4+j0JWsfbRXNkc+0ODdEot8VVFVG/oX9PAlKb0Gel0N7T8Sd
         r2TcF2cwW7hI8IRasrG7jP+8IqzxUS8gmZMsZ7uG9ltLqA/sSzlStxBJsjlVNJzYsS
         5D+jDuoUZmCnZlh+qme2ib6TICzDHQewsQheBJWU=
Date:   Fri, 05 Nov 2021 13:42:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
        linux-mm@kvack.org, mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 141/262] hugetlb: remove redundant VM_BUG_ON() in
 add_reservation_in_range()
Message-ID: <20211105204201.Udvk59sOV%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: hugetlb: remove redundant VM_BUG_ON() in add_reservation_in_range()

When calling hugetlb_resv_map_add(), we've guaranteed that the parameter
'to' is always larger than 'from', so it never returns a negative value
from hugetlb_resv_map_add().  Thus remove the redundant VM_BUG_ON().

Link: https://lkml.kernel.org/r/2b565552f3d06753da1e8dda439c0d96d6d9a5a3.1634797639.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/hugetlb.c~hugetlb-remove-redundant-vm_bug_on-in-add_reservation_in_range
+++ a/mm/hugetlb.c
@@ -445,7 +445,6 @@ static long add_reservation_in_range(str
 		add += hugetlb_resv_map_add(resv, rg, last_accounted_offset,
 					    t, h, h_cg, regions_needed);
 
-	VM_BUG_ON(add < 0);
 	return add;
 }
 
_
