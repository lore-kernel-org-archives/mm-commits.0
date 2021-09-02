Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D48EEC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC7D060E8B
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347686AbhIBWAe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:00:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347671AbhIBWAd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 18:00:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDC4360F21;
        Thu,  2 Sep 2021 21:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619974;
        bh=wjraOeQQXMnJxUpXG1iz9hMtWFAXCBfA11q1OzYtYYk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZFhyZRb9b9RfpCMYt/icb+xuh/YyiZlaPSatMernZiMzSVYM8TlBzLVOM9bRbVGCr
         KZqwtkFdX/Wk3wC2SNgnwYRHt43uSFRce8Lgai9JcehuoSkGXiDzi5JUfBWNagm9Ta
         O4lWgz49ERW2MqXtAGyk3dzf5tkJbB6cAGxc6rsw=
Date:   Thu, 02 Sep 2021 14:59:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, david@redhat.com, gthelen@google.com,
        kbusch@kernel.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, rientjes@google.com,
        shy828301@gmail.com, torvalds@linux-foundation.org,
        weixugc@google.com, yang.shi@linux.alibaba.com,
        ying.huang@intel.com, ziy@nvidia.com
Subject:  [patch 181/212] mm/migrate: add sysfs interface to enable
 reclaim migration
Message-ID: <20210902215933.RKQ25QasP%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>
Subject: mm/migrate: add sysfs interface to enable reclaim migration

Some method is obviously needed to enable reclaim-based migration.

Just like traditional autonuma, there will be some workloads that will
benefit like workloads with more "static" configurations where hot pages
stay hot and cold pages stay cold.  If pages come and go from the hot and
cold sets, the benefits of this approach will be more limited.

The benefits are truly workload-based and *not* hardware-based.  We do not
believe that there is a viable threshold where certain hardware
configurations should have this mechanism enabled while others do not.

To be conservative, earlier work defaulted to disable reclaim- based
migration and did not include a mechanism to enable it.  This proposes add
a new sysfs file

  /sys/kernel/mm/numa/demotion_enabled

as a method to enable it.

We are open to any alternative that allows end users to enable this
mechanism or disable it if workload harm is detected (just like
traditional autonuma).

Once this is enabled page demotion may move data to a NUMA node that does
not fall into the cpuset of the allocating process.  This could be
construed to violate the guarantees of cpusets.  However, since this is an
opt-in mechanism, the assumption is that anyone enabling it is content to
relax the guarantees.

Link: https://lkml.kernel.org/r/20210721063926.3024591-9-ying.huang@intel.com
Link: https://lkml.kernel.org/r/20210715055145.195411-10-ying.huang@intel.com
Signed-off-by: Huang Ying <ying.huang@intel.com>
Originally-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-numa |   24 +++++
 include/linux/mempolicy.h                      |    4 
 mm/mempolicy.c                                 |   61 +++++++++++++++
 mm/vmscan.c                                    |    5 -
 4 files changed, 92 insertions(+), 2 deletions(-)

--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-numa
@@ -0,0 +1,24 @@
+What:		/sys/kernel/mm/numa/
+Date:		June 2021
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	Interface for NUMA
+
+What:		/sys/kernel/mm/numa/demotion_enabled
+Date:		June 2021
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	Enable/disable demoting pages during reclaim
+
+		Page migration during reclaim is intended for systems
+		with tiered memory configurations.  These systems have
+		multiple types of memory with varied performance
+		characteristics instead of plain NUMA systems where
+		the same kind of memory is found at varied distances.
+		Allowing page migration during reclaim enables these
+		systems to migrate pages from fast tiers to slow tiers
+		when the fast tier is under pressure.  This migration
+		is performed before swap.  It may move data to a NUMA
+		node that does not fall into the cpuset of the
+		allocating process which might be construed to violate
+		the guarantees of cpusets.  This should not be enabled
+		on systems which need strict cpuset location
+		guarantees.
--- a/include/linux/mempolicy.h~mm-migrate-add-sysfs-interface-to-enable-reclaim-migration
+++ a/include/linux/mempolicy.h
@@ -184,6 +184,8 @@ extern bool vma_migratable(struct vm_are
 extern int mpol_misplaced(struct page *, struct vm_area_struct *, unsigned long);
 extern void mpol_put_task_policy(struct task_struct *);
 
+extern bool numa_demotion_enabled;
+
 #else
 
 struct mempolicy {};
@@ -292,5 +294,7 @@ static inline nodemask_t *policy_nodemas
 {
 	return NULL;
 }
+
+#define numa_demotion_enabled	false
 #endif /* CONFIG_NUMA */
 #endif
--- a/mm/mempolicy.c~mm-migrate-add-sysfs-interface-to-enable-reclaim-migration
+++ a/mm/mempolicy.c
@@ -3021,3 +3021,64 @@ void mpol_to_str(char *buffer, int maxle
 		p += scnprintf(p, buffer + maxlen - p, ":%*pbl",
 			       nodemask_pr_args(&nodes));
 }
+
+bool numa_demotion_enabled = false;
+
+#ifdef CONFIG_SYSFS
+static ssize_t numa_demotion_enabled_show(struct kobject *kobj,
+					  struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%s\n",
+			  numa_demotion_enabled? "true" : "false");
+}
+
+static ssize_t numa_demotion_enabled_store(struct kobject *kobj,
+					   struct kobj_attribute *attr,
+					   const char *buf, size_t count)
+{
+	if (!strncmp(buf, "true", 4) || !strncmp(buf, "1", 1))
+		numa_demotion_enabled = true;
+	else if (!strncmp(buf, "false", 5) || !strncmp(buf, "0", 1))
+		numa_demotion_enabled = false;
+	else
+		return -EINVAL;
+
+	return count;
+}
+
+static struct kobj_attribute numa_demotion_enabled_attr =
+	__ATTR(demotion_enabled, 0644, numa_demotion_enabled_show,
+	       numa_demotion_enabled_store);
+
+static struct attribute *numa_attrs[] = {
+	&numa_demotion_enabled_attr.attr,
+	NULL,
+};
+
+static const struct attribute_group numa_attr_group = {
+	.attrs = numa_attrs,
+};
+
+static int __init numa_init_sysfs(void)
+{
+	int err;
+	struct kobject *numa_kobj;
+
+	numa_kobj = kobject_create_and_add("numa", mm_kobj);
+	if (!numa_kobj) {
+		pr_err("failed to create numa kobject\n");
+		return -ENOMEM;
+	}
+	err = sysfs_create_group(numa_kobj, &numa_attr_group);
+	if (err) {
+		pr_err("failed to register numa group\n");
+		goto delete_obj;
+	}
+	return 0;
+
+delete_obj:
+	kobject_put(numa_kobj);
+	return err;
+}
+subsys_initcall(numa_init_sysfs);
+#endif
--- a/mm/vmscan.c~mm-migrate-add-sysfs-interface-to-enable-reclaim-migration
+++ a/mm/vmscan.c
@@ -524,6 +524,8 @@ static long add_nr_deferred(long nr, str
 
 static bool can_demote(int nid, struct scan_control *sc)
 {
+	if (!numa_demotion_enabled)
+		return false;
 	if (sc) {
 		if (sc->no_demotion)
 			return false;
@@ -534,8 +536,7 @@ static bool can_demote(int nid, struct s
 	if (next_demotion_node(nid) == NUMA_NO_NODE)
 		return false;
 
-	// FIXME: actually enable this later in the series
-	return false;
+	return true;
 }
 
 static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
_
