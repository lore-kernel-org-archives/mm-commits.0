Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 452B9C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 01:47:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiJUBrq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Oct 2022 21:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiJUBro (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Oct 2022 21:47:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2B422C618
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 18:47:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 294DD61D8E
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 01:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB28C433C1;
        Fri, 21 Oct 2022 01:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666316861;
        bh=IJDqw9e+DIF71G58tT//dvXleS5dCfmng+FrXn8sADc=;
        h=Date:To:From:Subject:From;
        b=Pkdw+wdyYkI8/DgFSTCwY54XUZwKeVTx4Ix+57DQN/QQXpYXQE/0pCNVLT3vEWhQr
         KROj2Goh2aL5067ugOsHWVp3y38MlP3ApaMzHYoNjzCLH82uQeLuELbIutal77MI/L
         wP9QxNfxVK8BFC45qPVngr+Rqk6/l27Qe8Cr1evk=
Date:   Thu, 20 Oct 2022 18:47:40 -0700
To:     mm-commits@vger.kernel.org, weixugc@google.com,
        tim.c.chen@intel.com, shy828301@gmail.com, mhocko@kernel.org,
        jvgediya.oss@gmail.com, Jonathan.Cameron@huawei.com,
        hesham.almatary@huawei.com, hannes@cmpxchg.org, dave@stgolabs.net,
        dave.hansen@intel.com, dan.j.williams@intel.com, bharata@amd.com,
        apopple@nvidia.com, aneesh.kumar@linux.ibm.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-tier-sysfs-rename-attribute-nodes-to-nodelist.patch added to mm-hotfixes-unstable branch
Message-Id: <20221021014741.7FB28C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memory tier, sysfs: rename attribute "nodes" to "nodelist"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     memory-tier-sysfs-rename-attribute-nodes-to-nodelist.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory-tier-sysfs-rename-attribute-nodes-to-nodelist.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: memory tier, sysfs: rename attribute "nodes" to "nodelist"
Date: Thu, 20 Oct 2022 09:51:22 +0800

In sysfs, we use attribute name "cpumap" or "cpus" for cpu mask and
"cpulist" or "cpus_list" for cpu list.  For example, in my system,

 $ cat /sys/devices/system/node/node0/cpumap
 f,ffffffff
 $ cat /sys/devices/system/cpu/cpu2/topology/core_cpus
 0,00100004
 $ cat cat /sys/devices/system/node/node0/cpulist
 0-35
 $ cat /sys/devices/system/cpu/cpu2/topology/core_cpus_list
 2,20

It looks reasonable to use "nodemap" for node mask and "nodelist" for
node list.  So, rename the attribute to follow the naming convention.

Link: https://lkml.kernel.org/r/20221020015122.290097-1-ying.huang@intel.com
Fixes: 9832fb87834e2b ("mm/demotion: expose memory tier details via sysfs")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Wei Xu <weixugc@google.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hesham Almatary <hesham.almatary@huawei.com>
Cc: Jagdish Gediya <jvgediya.oss@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tim Chen <tim.c.chen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers |    4 ++--
 mm/memory-tiers.c                                      |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers~memory-tier-sysfs-rename-attribute-nodes-to-nodelist
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
@@ -10,7 +10,7 @@ Description:	A collection of all the mem
 
 
 What:		/sys/devices/virtual/memory_tiering/memory_tierN/
-		/sys/devices/virtual/memory_tiering/memory_tierN/nodes
+		/sys/devices/virtual/memory_tiering/memory_tierN/nodelist
 Date:		August 2022
 Contact:	Linux memory management mailing list <linux-mm@kvack.org>
 Description:	Directory with details of a specific memory tier
@@ -21,5 +21,5 @@ Description:	Directory with details of a
 		A smaller value of N implies a higher (faster) memory tier in the
 		hierarchy.
 
-		nodes: NUMA nodes that are part of this memory tier.
+		nodelist: NUMA nodes that are part of this memory tier.
 
--- a/mm/memory-tiers.c~memory-tier-sysfs-rename-attribute-nodes-to-nodelist
+++ a/mm/memory-tiers.c
@@ -131,8 +131,8 @@ static void memory_tier_device_release(s
 	kfree(tier);
 }
 
-static ssize_t nodes_show(struct device *dev,
-			  struct device_attribute *attr, char *buf)
+static ssize_t nodelist_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
 {
 	int ret;
 	nodemask_t nmask;
@@ -143,10 +143,10 @@ static ssize_t nodes_show(struct device
 	mutex_unlock(&memory_tier_lock);
 	return ret;
 }
-static DEVICE_ATTR_RO(nodes);
+static DEVICE_ATTR_RO(nodelist);
 
 static struct attribute *memtier_dev_attrs[] = {
-	&dev_attr_nodes.attr,
+	&dev_attr_nodelist.attr,
 	NULL
 };
 
_

Patches currently in -mm which might be from ying.huang@intel.com are

memory-tier-sysfs-rename-attribute-nodes-to-nodelist.patch

