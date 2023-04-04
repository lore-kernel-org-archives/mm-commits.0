Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7FCBC6FD1D
	for <mm-commits@archiver.kernel.org>; Tue,  4 Apr 2023 19:49:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235857AbjDDTtY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Apr 2023 15:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjDDTtX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Apr 2023 15:49:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0A2A8
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 12:49:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38D08633E3
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 19:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908BDC433D2;
        Tue,  4 Apr 2023 19:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680637761;
        bh=biFN+09AJ6nMaOmwcVHRCqE/Da8ZWnMqK6sYJJmw5Ng=;
        h=Date:To:From:Subject:From;
        b=zRUBnx03YIm8WtZ8yQr78WKsLwZiQ/o3aD+Bq67dfZn336I3LbEexgJb1BAjAYv3R
         YADZInKrlVJzye3DgJW8nQwKD9go6cCeQFmgunbR5oE6DpW+j1j5Anlk9e2WvFl5W2
         FuRYP5gaZ0in9R8eKlONlk7ypU44qiPtgr0PYGco=
Date:   Tue, 04 Apr 2023 12:49:21 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, flosch@nutanix.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-v1-provide-read-access-to-memorypressure_level.patch added to mm-unstable branch
Message-Id: <20230404194921.908BDC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg v1: provide read access to memory.pressure_level
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-v1-provide-read-access-to-memorypressure_level.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-v1-provide-read-access-to-memorypressure_level.patch

This patch will later appear in the mm-unstable branch at
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

memcg-v1-provide-read-access-to-memorypressure_level.patch

