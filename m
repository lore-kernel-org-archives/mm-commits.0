Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7546BC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiATVXG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:23:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34536 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377803AbiATVXE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:23:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 562DA61890
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC25C340E0;
        Thu, 20 Jan 2022 21:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713783;
        bh=heND0Bb6AyDvTWgycnvIIkGMRFtWBQaiSAcL7mczgt8=;
        h=Date:From:To:Subject:From;
        b=o605c2rtvIBNmh+mA9Bs+4Rg5FoS300M9joTz/DfnZmhXFjmNzkhviz50HpsrCC5b
         CBaOIdHyx+h/Of5PPBtVkjNxtwXDD6FfL2hIQnzSSyuXzaVXOWzwm/TMCIpq2aWfLQ
         xBOLf7OMeUqNg4v07XiAtl/AGLEaNoDvqT7K3Mik=
Date:   Thu, 20 Jan 2022 13:23:03 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, gregkh@linuxfoundation.org,
        mm-commits@vger.kernel.org, rppt@kernel.org
Subject:  [merged]
 ia64-topology-use-default_groups-in-kobj_type.patch removed from -mm tree
Message-ID: <20220120212303.p0BioIa6p%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: topology: use default_groups in kobj_type
has been removed from the -mm tree.  Its filename was
     ia64-topology-use-default_groups-in-kobj_type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


