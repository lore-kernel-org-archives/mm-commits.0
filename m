Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C18C0C677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:22:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjASBWN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjASBUF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:20:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A19C4CE4D
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD11C61B0B
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BA1C433F0;
        Thu, 19 Jan 2023 01:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674091014;
        bh=ao0sTo/XmolSG6rcxaogzlL9l8JNBip2zPqE/sNnFmo=;
        h=Date:To:From:Subject:From;
        b=TPxr3sdszMVtvNhymfqjjxC/Dn37ZJKKolIC1CPlQ0kHwmoPlOBKUXQDOvCI8PHKC
         f9GUN6a06AVrmZDHFm4FIB3263r4o1TDH+AeQ3Lxu9M2sIyMC4CQe/VCW6dNGwMKxh
         p7w0ZmfTR3xDFah7d/yMGWC+ITHMoq9omoxyHLpc=
Date:   Wed, 18 Jan 2023 17:16:53 -0800
To:     mm-commits@vger.kernel.org, roman.gushchin@linux.dev,
        apantykhin@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-cgroup-memcg_shrinker-remove-redundant-import.patch removed from -mm tree
Message-Id: <20230119011654.39BA1C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tools:cgroup:memcg_shrinker remove redundant import
has been removed from the -mm tree.  Its filename was
     tools-cgroup-memcg_shrinker-remove-redundant-import.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Pantyukhin <apantykhin@gmail.com>
Subject: tools:cgroup:memcg_shrinker remove redundant import
Date: Sun, 8 Jan 2023 15:50:23 +0500

Remove redundant import of the sys module.

Also use the sort function instead of sorted.  It sorts the direct array
without create the new one in memory.

Link: https://lkml.kernel.org/r/20230108105023.4289-1-apantykhin@gmail.com
Signed-off-by: Alexander Pantyukhin <apantykhin@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/cgroup/memcg_shrinker.py |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/tools/cgroup/memcg_shrinker.py~tools-cgroup-memcg_shrinker-remove-redundant-import
+++ a/tools/cgroup/memcg_shrinker.py
@@ -5,7 +5,6 @@
 
 import os
 import argparse
-import sys
 
 
 def scan_cgroups(cgroup_root):
@@ -44,7 +43,7 @@ def main():
 
     cgroups = scan_cgroups("/sys/fs/cgroup/")
     shrinkers = scan_shrinkers("/sys/kernel/debug/shrinker/")
-    shrinkers = sorted(shrinkers, reverse = True, key = lambda x: x[0])
+    shrinkers.sort(reverse = True, key = lambda x: x[0])
 
     n = 0
     for s in shrinkers:
_

Patches currently in -mm which might be from apantykhin@gmail.com are

scripts-bloat-o-meter-use-the-reverse-flag-for-sort.patch

