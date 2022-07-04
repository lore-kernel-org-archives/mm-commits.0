Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26190C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 00:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbiGDAAy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 20:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbiGDAAx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 20:00:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96CF5FAD
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 17:00:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80AFF6124B
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 00:00:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF29C341C6;
        Mon,  4 Jul 2022 00:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656892850;
        bh=EB1xrrU4nzQrTEgfEKQUM/5IlR5SOEyi94m1ubLTXgE=;
        h=Date:To:From:Subject:From;
        b=Jqe6/WVTdfRFkm7Pl2ao4Dy9MGJPhYYA6wo2D0lArRY9D+SXLdqLCI/WlztE8Ulae
         AzOMZa8Hn9gflqFXsnE1L0iH2PT6Lyz9+M2vgEWzW+Jjmzsos+2Yfe6f334SDvdPeo
         h9HDVlRDIsgjYulws9cTXrtwWw7GpfMY9TLRCPr0=
Date:   Sun, 03 Jul 2022 17:00:50 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        kent.overstreet@gmail.com, hdanton@sina.com, dchinner@redhat.com,
        christophe.jaillet@wanadoo.fr, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix.patch removed from -mm tree
Message-Id: <20220704000050.CFF29C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix
has been removed from the -mm tree.  Its filename was
     mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix.patch

This patch was dropped because it was folded into mm-shrinkers-add-scan-interface-for-shrinker-debugfs.patch

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
mm-memcontrol-do-not-miss-memcg_max-events-for-enforced-allocations.patch

