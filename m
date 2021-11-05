Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26709C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:44:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E28261357
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:44:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbhKEUqu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:46:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:41714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233055AbhKEUqt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:46:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE0A96136F;
        Fri,  5 Nov 2021 20:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145049;
        bh=97KRsmTUQyuBTEoOSPs1/gYmy+83Xx9BulB9F8xEZGI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yQ3QgPXhl4Lv6Om0jUp7ZipHY9jOTmyDVk44pm+Zli0H+y2LzQuac27bL2Lx+DNQF
         8o8xHEXWaxe+bE5TZ45MPXFRqLozm/NL6BTY4bjRl70JvFwEx7b4BXkyL4zBf4L/1a
         2hcbDYyBvkbjcWgwa338+ZUFiwNKqsTxM3mVfa+U=
Date:   Fri, 05 Nov 2021 13:44:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        tangyizhou@huawei.com, torvalds@linux-foundation.org
Subject:  [patch 182/262] mm/memory_hotplug: add static qualifier
 for online_policy_to_str()
Message-ID: <20211105204408.3LUaERGDf%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Tang Yizhou <tangyizhou@huawei.com>
Subject: mm/memory_hotplug: add static qualifier for online_policy_to_str()

online_policy_to_str is only used in memory_hotplug.c and should be
defined as static.

Link: https://lkml.kernel.org/r/20210913024534.26161-1-tangyizhou@huawei.com
Signed-off-by: Tang Yizhou <tangyizhou@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-add-static-qualifier-for-online_policy_to_str
+++ a/mm/memory_hotplug.c
@@ -57,7 +57,7 @@ enum {
 	ONLINE_POLICY_AUTO_MOVABLE,
 };
 
-const char *online_policy_to_str[] = {
+static const char * const online_policy_to_str[] = {
 	[ONLINE_POLICY_CONTIG_ZONES] = "contig-zones",
 	[ONLINE_POLICY_AUTO_MOVABLE] = "auto-movable",
 };
_
