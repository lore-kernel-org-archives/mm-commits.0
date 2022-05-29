Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70F0CC433F5
	for <mm-commits@archiver.kernel.org>; Sun, 29 May 2022 23:36:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbiE2XgD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 29 May 2022 19:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiE2XgC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 29 May 2022 19:36:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93AA71EAE5
        for <mm-commits@vger.kernel.org>; Sun, 29 May 2022 16:36:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D78260F68
        for <mm-commits@vger.kernel.org>; Sun, 29 May 2022 23:36:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7784DC385A9;
        Sun, 29 May 2022 23:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653867360;
        bh=53yD9Sv8kOYlcc1O+Zkgjqg48LsqqJrZM8XCYUEsxLs=;
        h=Date:To:From:Subject:From;
        b=1bOdEFDQs6u/L2AwSZGkGLwys/2f3+c3vzVPvGmkkgrlzANB7lTdXShru8PYQ2bJJ
         uuvz4/cNL3rfhj+8hqm64QeP/1Fjej33kfRCmjRFK27nccf3RUomW6VkBVSqanVRfK
         rw2ErdEi+4kbeG+airzCgvNb0waRuyZ9tbfKjElw=
Date:   Sun, 29 May 2022 16:35:59 -0700
To:     mm-commits@vger.kernel.org, tobin@kernel.org,
        songyuanzheng@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-vm-slabinfo-use-alphabetic-order-when-two-values-are-equal.patch added to mm-unstable branch
Message-Id: <20220529233600.7784DC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/slabinfo: use alphabetic order when two values are equal
has been added to the -mm mm-unstable branch.  Its filename is
     tools-vm-slabinfo-use-alphabetic-order-when-two-values-are-equal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-vm-slabinfo-use-alphabetic-order-when-two-values-are-equal.patch

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
From: Yuanzheng Song <songyuanzheng@huawei.com>
Subject: tools/vm/slabinfo: use alphabetic order when two values are equal
Date: Sat, 28 May 2022 06:31:17 +0000

When the number of partial slabs in each cache is the same (e.g., the
value are 0), the results of the `slabinfo -X -N5` and `slabinfo -P -N5`
are different.

/ # slabinfo -X -N5
...
Slabs sorted by number of partial slabs
---------------------------------------
Name                   Objects Objsize           Space Slabs/Part/Cpu  O/S O %Fr %Ef Flg
inode_cache              15180     392         6217728        758/0/1   20 1   0  95 a
kernfs_node_cache        22494      88         2002944        488/0/1   46 0   0  98
shmem_inode_cache          663     464          319488         38/0/1   17 1   0  96
biovec-max                  50    3072          163840          4/0/1   10 3   0  93 A
dentry                   19050     136         2600960        633/0/2   30 0   0  99 a

/ # slabinfo -P -N5
Name                   Objects Objsize           Space Slabs/Part/Cpu  O/S O %Fr %Ef Flg
bdev_cache                  32     984           32.7K          1/0/1   16 2   0  96 Aa
ext4_inode_cache            42     752           32.7K          1/0/1   21 2   0  96 a
dentry                   19050     136            2.6M        633/0/2   30 0   0  99 a
TCPv6                       17    1840           32.7K          0/0/1   17 3   0  95 A
RAWv6                       18     856           16.3K          0/0/1   18 2   0  94 A

This problem is caused by the sort_slabs().  So let's use alphabetic order
when two values are equal in the sort_slabs().

By the way, the content of the `slabinfo -h` is not aligned because the

`-P|--partial Sort by number of partial slabs`

uses tabs instead of spaces.  So let's use spaces instead of tabs to fix
it.

Link: https://lkml.kernel.org/r/20220528063117.935158-1-songyuanzheng@huawei.com
Fixes: 1106b205a3fe ("tools/vm/slabinfo: add partial slab listing to -X")
Signed-off-by: Yuanzheng Song <songyuanzheng@huawei.com>
Cc: "Tobin C. Harding" <tobin@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/slabinfo.c |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

--- a/tools/vm/slabinfo.c~tools-vm-slabinfo-use-alphabetic-order-when-two-values-are-equal
+++ a/tools/vm/slabinfo.c
@@ -125,7 +125,7 @@ static void usage(void)
 		"-n|--numa              Show NUMA information\n"
 		"-N|--lines=K           Show the first K slabs\n"
 		"-o|--ops               Show kmem_cache_ops\n"
-		"-P|--partial		Sort by number of partial slabs\n"
+		"-P|--partial           Sort by number of partial slabs\n"
 		"-r|--report            Detailed report on single slabs\n"
 		"-s|--shrink            Shrink slabs\n"
 		"-S|--Size              Sort by size\n"
@@ -1045,15 +1045,27 @@ static void sort_slabs(void)
 		for (s2 = s1 + 1; s2 < slabinfo + slabs; s2++) {
 			int result;
 
-			if (sort_size)
-				result = slab_size(s1) < slab_size(s2);
-			else if (sort_active)
-				result = slab_activity(s1) < slab_activity(s2);
-			else if (sort_loss)
-				result = slab_waste(s1) < slab_waste(s2);
-			else if (sort_partial)
-				result = s1->partial < s2->partial;
-			else
+			if (sort_size) {
+				if (slab_size(s1) == slab_size(s2))
+					result = strcasecmp(s1->name, s2->name);
+				else
+					result = slab_size(s1) < slab_size(s2);
+			} else if (sort_active) {
+				if (slab_activity(s1) == slab_activity(s2))
+					result = strcasecmp(s1->name, s2->name);
+				else
+					result = slab_activity(s1) < slab_activity(s2);
+			} else if (sort_loss) {
+				if (slab_waste(s1) == slab_waste(s2))
+					result = strcasecmp(s1->name, s2->name);
+				else
+					result = slab_waste(s1) < slab_waste(s2);
+			} else if (sort_partial) {
+				if (s1->partial == s2->partial)
+					result = strcasecmp(s1->name, s2->name);
+				else
+					result = s1->partial < s2->partial;
+			} else
 				result = strcasecmp(s1->name, s2->name);
 
 			if (show_inverted)
_

Patches currently in -mm which might be from songyuanzheng@huawei.com are

tools-vm-slabinfo-use-alphabetic-order-when-two-values-are-equal.patch

