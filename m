Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C8DC5479D
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 01:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjAJBGJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Jan 2023 20:06:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjAJBGJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2023 20:06:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA35BF55
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 17:06:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85C83B810A8
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 01:06:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23FCFC433D2;
        Tue, 10 Jan 2023 01:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673312763;
        bh=g6jLJDOGOMXwdJURB+V2I78ayhf/XAjil1GMOJigQeY=;
        h=Date:To:From:Subject:From;
        b=k7cT0JUWz9UggC3NXooSrjua9fKp5eMhflXjuN7nWswUeuAIxJWpjVedbkdyQHDGQ
         //fT2Ld9kH/94yRsyBA7IGYPy633aZatVi38JvpVIwnAWEaYDu8WxDW3Nt+hn1dnB7
         zJ5KtwshOkeevGMPBKCIybjX04kHi7Fup3BL5OVU=
Date:   Mon, 09 Jan 2023 17:06:02 -0800
To:     mm-commits@vger.kernel.org, roman.gushchin@linux.dev,
        apantykhin@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-cgroup-memcg_shrinker-remove-redundant-import.patch added to mm-unstable branch
Message-Id: <20230110010603.23FCFC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools:cgroup:memcg_shrinker remove redundant import
has been added to the -mm mm-unstable branch.  Its filename is
     tools-cgroup-memcg_shrinker-remove-redundant-import.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-cgroup-memcg_shrinker-remove-redundant-import.patch

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

tools-cgroup-memcg_shrinker-remove-redundant-import.patch
scripts-bloat-o-meter-use-the-reverse-flag-for-sort.patch

