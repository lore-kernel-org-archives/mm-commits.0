Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C8A1C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:51:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbjBCGva (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:51:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbjBCGvM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B174B754
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C76CB82982
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3BEC433D2;
        Fri,  3 Feb 2023 06:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407062;
        bh=gNkXZLWz5P+a8+jEhuIWB7FdJWvMe94QTl6k2vB9ic0=;
        h=Date:To:From:Subject:From;
        b=XkUC6l1pYZGALIvQRE/Vwh7Dllmm4lSfCiRoFKLcSCPGkAaieEpoUhbatMULbDJir
         vtkN/6u0fwDIDKg6Ngf6IU/oY7DtouUU3ifCheN9R7GacNkLmAqpsnKW0m4fy0Xkt+
         jS3Rm4pxOdpGrO621VX5nWkeRGsYp0uZO0yX50Gw=
Date:   Thu, 02 Feb 2023 22:51:01 -0800
To:     mm-commits@vger.kernel.org, paul.gortmaker@windriver.com,
        nborisov@suse.com, apantykhin@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-bloat-o-meter-use-the-reverse-flag-for-sort.patch removed from -mm tree
Message-Id: <20230203065102.0A3BEC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/bloat-o-meter: use the reverse flag for sort
has been removed from the -mm tree.  Its filename was
     scripts-bloat-o-meter-use-the-reverse-flag-for-sort.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Pantyukhin <apantykhin@gmail.com>
Subject: scripts/bloat-o-meter: use the reverse flag for sort
Date: Fri, 6 Jan 2023 14:13:19 +0500

The sort function has the inbuilt reversal option.  We can use it to save
some time.

Link: https://lkml.kernel.org/r/20230106091319.3824-1-apantykhin@gmail.com
Signed-off-by: Alexander Pantyukhin <apantykhin@gmail.com>
Cc: Nikolay Borisov <nborisov@suse.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/scripts/bloat-o-meter~scripts-bloat-o-meter-use-the-reverse-flag-for-sort
+++ a/scripts/bloat-o-meter
@@ -80,8 +80,7 @@ def calc(oldfile, newfile, format):
         if d<0: shrink, down = shrink+1, down-d
         delta.append((d, name))
 
-    delta.sort()
-    delta.reverse()
+    delta.sort(reverse=True)
     return grow, shrink, add, remove, up, down, delta, old, new, otot, ntot
 
 def print_result(symboltype, symbolformat):
_

Patches currently in -mm which might be from apantykhin@gmail.com are


