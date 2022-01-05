Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37842C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  5 Jan 2022 23:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245368AbiAEXZb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Jan 2022 18:25:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245364AbiAEXZa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jan 2022 18:25:30 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9218DC061245
        for <mm-commits@vger.kernel.org>; Wed,  5 Jan 2022 15:25:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BA7F0CE206F
        for <mm-commits@vger.kernel.org>; Wed,  5 Jan 2022 23:25:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E45C36AE9;
        Wed,  5 Jan 2022 23:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1641425126;
        bh=Lmwk9ZAdI+OjRSwYQLIEo0YYIdJBSsKQgEbo8ieZZBE=;
        h=Date:From:To:Subject:From;
        b=Wd4R4jvmZqT/WjmxmXRCMmDo7QgQJ8mw0G7LFMoD8yfFTVPdXqKCtMUueE/vvO076
         ndK4w6H6s5h8zM0sI7LTStOk79vPASSD5qq3WKS6uaXXB6ar9eT4a0LYhdIDpw2vo4
         n6jNBnjhARTMLP0+4PEotWZqeM70xg5XWYyuKYFg=
Date:   Wed, 05 Jan 2022 15:25:26 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, gregkh@linuxfoundation.org,
        mm-commits@vger.kernel.org, rppt@kernel.org
Subject:  + ia64-topology-use-default_groups-in-kobj_type.patch
 added to -mm tree
Message-ID: <20220105232526.dl3Re3KeA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: topology: use default_groups in kobj_type
has been added to the -mm tree.  Its filename is
     ia64-topology-use-default_groups-in-kobj_type.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-topology-use-default_groups-in-kobj_type.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-topology-use-default_groups-in-kobj_type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from gregkh@linuxfoundation.org are

ia64-topology-use-default_groups-in-kobj_type.patch
ocfs2-use-default_groups-in-kobj_type.patch

