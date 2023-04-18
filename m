Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD8E2C77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbjDRXf3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbjDRXeq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:34:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEAFEAD13
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C849615E3
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E262EC433D2;
        Tue, 18 Apr 2023 23:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860859;
        bh=B5p8sLQCYdtUoktodkdONMVQFIUyOv897kPz7fHY4LE=;
        h=Date:To:From:Subject:From;
        b=S8u9kpZrB2FI3iU0Jc7TOFVlqKoFwbuoQ6p/EiqUvZ6pYjHHnYqilTaC17oacxe2V
         IkgaJIR3FHntKguhfq9A8i9n8t/rixv0mhf8h74p3l+6CbIQZxSGP5TO1b8MPdWAaW
         YbyrKpVltXWgiinL0Eg3DGjGiKdsWnlUKQRhgMFM=
Date:   Tue, 18 Apr 2023 16:34:18 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, flosch@nutanix.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-v1-provide-read-access-to-memorypressure_level.patch removed from -mm tree
Message-Id: <20230418233418.E262EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memcg v1: provide read access to memory.pressure_level
has been removed from the -mm tree.  Its filename was
     memcg-v1-provide-read-access-to-memorypressure_level.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Florian Schmidt <flosch@nutanix.com>
Subject: memcg v1: provide read access to memory.pressure_level
Date: Tue, 4 Apr 2023 10:58:59 +0000

cgroups v1 has a unique way of setting up memory pressure notifications:
the user opens "memory.pressure_level" of the cgroup they want to monitor
for pressure, then open "cgroup.event_control" and write the fd (among
other things) to that file.  memory.pressure_level has no other use,
specifically it does not support any read or write operations. 
Consequently, no handlers are provided, and cgroup_file_mode() sets the
permissions to 000.  However, to actually use the mechanism, the
subscribing user must have read access to the file and open the fd for
reading, see memcg_write_event_control().

This is all fine as long as the subscribing process runs as root and is
otherwise unconfined by further restrictions.  However, if you add strict
access controls such as selinux, the permission bits will be enforced, and
opening memory.pressure_level for reading will fail, preventing the
process from subscribing, even as root.

To work around this issue, introduce a dummy read handler.  When
memory.pressure_level is created, cgroup_file_mode() will notice the
existence of a handler, and therefore add read permissions to the file.

Link: https://lkml.kernel.org/r/20230404105900.2005-1-flosch@nutanix.com
Signed-off-by: Florian Schmidt <flosch@nutanix.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/memcontrol.c~memcg-v1-provide-read-access-to-memorypressure_level
+++ a/mm/memcontrol.c
@@ -3779,6 +3779,16 @@ static u64 mem_cgroup_read_u64(struct cg
 	}
 }
 
+/*
+ * This function doesn't do anything useful. Its only job is to provide a read
+ * handler for a file so that cgroup_file_mode() will add read permissions.
+ */
+static int mem_cgroup_dummy_seq_show(__always_unused struct seq_file *m,
+				     __always_unused void *v)
+{
+	return -EINVAL;
+}
+
 #ifdef CONFIG_MEMCG_KMEM
 static int memcg_online_kmem(struct mem_cgroup *memcg)
 {
@@ -5113,6 +5123,7 @@ static struct cftype mem_cgroup_legacy_f
 	},
 	{
 		.name = "pressure_level",
+		.seq_show = mem_cgroup_dummy_seq_show,
 	},
 #ifdef CONFIG_NUMA
 	{
_

Patches currently in -mm which might be from flosch@nutanix.com are


