Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ED60C43381
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31E2164F26
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhBZBRg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:17:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:48524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229946AbhBZBRa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:17:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0398E64EE3;
        Fri, 26 Feb 2021 01:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302235;
        bh=2Y4hsfLQLzdLM0QkS/ziilhnLN07QRaX4qp/MWYRwg4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zrWv7uZg1C+nraXhzJP5hzuptWUsX0SeGdy0v9g6dN6PZ2uz54oVDuocHKfLY+QYW
         S/1uxIBncjrhAqspMNgzMRItwNozwok210kvawIk0FGunScNeO+ph8CSoscshAWT8U
         fHllGRPCf2z8be5EjVvGSQ2wsx1KDzeqbfpR3+28=
Date:   Thu, 25 Feb 2021 17:17:13 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        david@redhat.com, gregkh@linuxfoundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rafael@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 030/118] mm/memory_hotplug: rename all existing
 'memhp' into 'mhp'
Message-ID: <20210226011713.7M8i_VxrX%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/memory_hotplug: rename all existing 'memhp' into 'mhp'

This renames all 'memhp' instances to 'mhp' except for memhp_default_state
for being a kernel command line option.  This is just a clean up and
should not cause a functional change.  Let's make it consistent rater than
mixing the two prefixes.  In preparation for more users of the 'mhp'
terminology.

Link: https://lkml.kernel.org/r/1611554093-27316-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c          |   10 +++++-----
 include/linux/memory_hotplug.h |    4 ++--
 mm/memory_hotplug.c            |   12 ++++++------
 3 files changed, 13 insertions(+), 13 deletions(-)

--- a/drivers/base/memory.c~mm-memory_hotplug-rename-all-existing-memhp-into-mhp
+++ a/drivers/base/memory.c
@@ -35,7 +35,7 @@ static const char *const online_type_to_
 	[MMOP_ONLINE_MOVABLE] = "online_movable",
 };
 
-int memhp_online_type_from_str(const char *str)
+int mhp_online_type_from_str(const char *str)
 {
 	int i;
 
@@ -253,7 +253,7 @@ static int memory_subsys_offline(struct
 static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 			   const char *buf, size_t count)
 {
-	const int online_type = memhp_online_type_from_str(buf);
+	const int online_type = mhp_online_type_from_str(buf);
 	struct memory_block *mem = to_memory_block(dev);
 	int ret;
 
@@ -387,19 +387,19 @@ static ssize_t auto_online_blocks_show(s
 				       struct device_attribute *attr, char *buf)
 {
 	return sysfs_emit(buf, "%s\n",
-			  online_type_to_str[memhp_default_online_type]);
+			  online_type_to_str[mhp_default_online_type]);
 }
 
 static ssize_t auto_online_blocks_store(struct device *dev,
 					struct device_attribute *attr,
 					const char *buf, size_t count)
 {
-	const int online_type = memhp_online_type_from_str(buf);
+	const int online_type = mhp_online_type_from_str(buf);
 
 	if (online_type < 0)
 		return -EINVAL;
 
-	memhp_default_online_type = online_type;
+	mhp_default_online_type = online_type;
 	return count;
 }
 
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-rename-all-existing-memhp-into-mhp
+++ a/include/linux/memory_hotplug.h
@@ -116,10 +116,10 @@ extern int arch_add_memory(int nid, u64
 			   struct mhp_params *params);
 extern u64 max_mem_size;
 
-extern int memhp_online_type_from_str(const char *str);
+extern int mhp_online_type_from_str(const char *str);
 
 /* Default online_type (MMOP_*) when new memory blocks are added. */
-extern int memhp_default_online_type;
+extern int mhp_default_online_type;
 /* If movable_node boot option specified */
 extern bool movable_node_enabled;
 static inline bool movable_node_is_enabled(void)
--- a/mm/memory_hotplug.c~mm-memory_hotplug-rename-all-existing-memhp-into-mhp
+++ a/mm/memory_hotplug.c
@@ -67,17 +67,17 @@ void put_online_mems(void)
 bool movable_node_enabled = false;
 
 #ifndef CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE
-int memhp_default_online_type = MMOP_OFFLINE;
+int mhp_default_online_type = MMOP_OFFLINE;
 #else
-int memhp_default_online_type = MMOP_ONLINE;
+int mhp_default_online_type = MMOP_ONLINE;
 #endif
 
 static int __init setup_memhp_default_state(char *str)
 {
-	const int online_type = memhp_online_type_from_str(str);
+	const int online_type = mhp_online_type_from_str(str);
 
 	if (online_type >= 0)
-		memhp_default_online_type = online_type;
+		mhp_default_online_type = online_type;
 
 	return 1;
 }
@@ -1076,7 +1076,7 @@ static int check_hotplug_memory_range(u6
 
 static int online_memory_block(struct memory_block *mem, void *arg)
 {
-	mem->online_type = memhp_default_online_type;
+	mem->online_type = mhp_default_online_type;
 	return device_online(&mem->dev);
 }
 
@@ -1157,7 +1157,7 @@ int __ref add_memory_resource(int nid, s
 		merge_system_ram_resource(res);
 
 	/* online pages if requested */
-	if (memhp_default_online_type != MMOP_OFFLINE)
+	if (mhp_default_online_type != MMOP_OFFLINE)
 		walk_memory_blocks(start, size, NULL, online_memory_block);
 
 	return ret;
_
