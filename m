Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F19CC43334
	for <mm-commits@archiver.kernel.org>; Thu,  2 Jun 2022 18:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238235AbiFBSmQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Jun 2022 14:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238256AbiFBSmO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2022 14:42:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24596B7A
        for <mm-commits@vger.kernel.org>; Thu,  2 Jun 2022 11:42:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A045461737
        for <mm-commits@vger.kernel.org>; Thu,  2 Jun 2022 18:42:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00182C385A5;
        Thu,  2 Jun 2022 18:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654195332;
        bh=+Xn0k9hFSjYDR+VQI5gOgKBFcUIa5H6JFGVcrZ19cBU=;
        h=Date:To:From:Subject:From;
        b=WLtEtWn2Bl0+AI4a1DK36bAdwLt+laNZESGePH8tEsT2ELCGQaLoVV4GC3F+SXrqj
         TUai9tZpKsjqMvWger0bPAJUfZee8U7pQpKKGXMlQmuR40vjI5Q5c4vC0tEvuBl/iK
         1/RxkA5XS8HV2qigWgC1DPJJY/gshVcOoNRE6j1I=
Date:   Thu, 02 Jun 2022 11:42:11 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        kent.overstreet@gmail.com, hdanton@sina.com, dchinner@redhat.com,
        christophe.jaillet@wanadoo.fr, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix.patch added to mm-unstable branch
Message-Id: <20220602184212.00182C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix.patch

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
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix
Date: Wed, 1 Jun 2022 17:56:22 -0700

improve typing, fix arg count checking

Link: https://lkml.kernel.org/r/YpgKttTowT22mKPQ@carbon
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shrinker_debug.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/shrinker_debug.c~mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix
+++ a/mm/shrinker_debug.c
@@ -110,21 +110,21 @@ static ssize_t shrinker_debugfs_scan_wri
 					   size_t size, loff_t *pos)
 {
 	struct shrinker *shrinker = file->private_data;
-	unsigned long nr_to_scan = 0, ino;
+	unsigned long nr_to_scan = 0, ino, read_len;
 	struct shrink_control sc = {
 		.gfp_mask = GFP_KERNEL,
 	};
 	struct mem_cgroup *memcg = NULL;
 	int nid;
 	char kbuf[72];
-	int read_len = size < (sizeof(kbuf) - 1) ? size : (sizeof(kbuf) - 1);
 	ssize_t ret;
 
+	read_len = size < (sizeof(kbuf) - 1) ? size : (sizeof(kbuf) - 1);
 	if (copy_from_user(kbuf, buf, read_len))
 		return -EFAULT;
 	kbuf[read_len] = '\0';
 
-	if (sscanf(kbuf, "%lu %d %lu", &ino, &nid, &nr_to_scan) < 2)
+	if (sscanf(kbuf, "%lu %d %lu", &ino, &nid, &nr_to_scan) != 2)
 		return -EINVAL;
 
 	if (nid < 0 || nid >= nr_node_ids)
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcontrol-introduce-mem_cgroup_ino-and-mem_cgroup_get_from_ino.patch
mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers.patch
mm-shrinkers-provide-shrinkers-with-names.patch
mm-docs-document-shrinker-debugfs.patch
tools-add-memcg_shrinkerpy.patch
mm-shrinkers-add-scan-interface-for-shrinker-debugfs.patch
mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix.patch

