Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AE0BC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiANWDZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:03:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57384 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiANWDZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:03:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59F6CB8262F
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:03:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB793C36AE9;
        Fri, 14 Jan 2022 22:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197803;
        bh=n5C8xwI8l8pZqI3rdPSbxUwmk06mCoSvKTRrF5aI3to=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oTNs1KRYHo+JW9/JLodVYuPrbxgd1LFuX7WWP2mwgFVAFVC3hg78pCIMEueTY12/t
         cSN62kAYir/hm95vmLiCb9FFVK5ZInfzJPgveuVFUAkHGYJIDR7CsW0YH+xtHOHlGv
         z8uPWEiAh0PY1L+4ynhF6wu3nFolx5+Wgr0hxTbw=
Date:   Fri, 14 Jan 2022 14:03:22 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        gregkh@linuxfoundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rppt@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 010/146] ia64: topology: use default_groups in
 kobj_type
Message-ID: <20220114220322.BAnKJNfcw%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: ia64: topology: use default_groups in kobj_type

There are currently 2 ways to create a set of sysfs files for a kobj_type,
through the default_attrs field, and the default_groups field.  Move the
ia64 topology sysfs code to use default_groups field which has been the
preferred way since aa30f47cf666 ("kobject: Add support for default
attribute groups to kobj_type") so that we can soon get rid of the
obsolete default_attrs field.

Link: https://lkml.kernel.org/r/20220104154800.1287947-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/topology.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/ia64/kernel/topology.c~ia64-topology-use-default_groups-in-kobj_type
+++ a/arch/ia64/kernel/topology.c
@@ -264,6 +264,7 @@ static struct attribute * cache_default_
 	&shared_cpu_map.attr,
 	NULL
 };
+ATTRIBUTE_GROUPS(cache_default);
 
 #define to_object(k) container_of(k, struct cache_info, kobj)
 #define to_attr(a) container_of(a, struct cache_attr, attr)
@@ -284,7 +285,7 @@ static const struct sysfs_ops cache_sysf
 
 static struct kobj_type cache_ktype = {
 	.sysfs_ops	= &cache_sysfs_ops,
-	.default_attrs	= cache_default_attrs,
+	.default_groups	= cache_default_groups,
 };
 
 static struct kobj_type cache_ktype_percpu_entry = {
_
