Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 868D7C3DA79
	for <mm-commits@archiver.kernel.org>; Fri, 30 Dec 2022 00:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiL3A63 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Dec 2022 19:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiL3A62 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Dec 2022 19:58:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2196513F91
        for <mm-commits@vger.kernel.org>; Thu, 29 Dec 2022 16:58:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C42D1B81A7C
        for <mm-commits@vger.kernel.org>; Fri, 30 Dec 2022 00:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569A8C433EF;
        Fri, 30 Dec 2022 00:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672361904;
        bh=hXu0/v/CD5OgF7wGAW5oNXiACnt+PwkCGM+zILYhdFI=;
        h=Date:To:From:Subject:From;
        b=xHwJBarRhCwGnBNOGkXO6wtNZaEIl7q9nA4TbT33obSfH/KB7AKiEmp3Tj6XiovHu
         6yxgFqshjCzRWEyt0EpqkJmQ567FiIf+xOn30s9iBpDpRR3x52XliSlUOeX//hayCn
         WpI+UI/Y1Agdc4X4S5VuP1BqA8joCr1F9iIJL9og=
Date:   Thu, 29 Dec 2022 16:58:23 -0800
To:     mm-commits@vger.kernel.org, joe@perches.com,
        fmdefrancesco@gmail.com, apw@canonical.com, ira.weiny@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-mark-kunmap-and-kunmap_atomic-deprecated.patch added to mm-nonmm-unstable branch
Message-Id: <20221230005824.569A8C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: mark kunmap() and kunmap_atomic() deprecated
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-mark-kunmap-and-kunmap_atomic-deprecated.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-mark-kunmap-and-kunmap_atomic-deprecated.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Ira Weiny <ira.weiny@intel.com>
Subject: checkpatch: mark kunmap() and kunmap_atomic() deprecated
Date: Thu, 29 Dec 2022 14:17:15 -0800

It was suggested by Fabio that kunmap() be marked deprecated in
checkpatch.[1] This did not seem necessary until an invalid conversion of
kmap_local_page() appeared in mainline.[2][3] The introduction of this bug
would have been flagged with kunmap() being marked deprecated.

Add kunmap() and kunmap_atomic() to checkpatch to help prevent further
confusion.

[1] https://lore.kernel.org/all/1884934.6tgchFWduM@suse/
[2] d406d26745ab ("cifs: skip alloc when request has no pages")
[3] https://lore.kernel.org/r/20221229-cifs-kmap-v1-1-c70d0e9a53eb@intel.com

Link: https://lkml.kernel.org/r/20221229-kmap-checkpatch-v2-1-919fc4d4e3c2@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Suggested-by: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/scripts/checkpatch.pl~checkpatch-mark-kunmap-and-kunmap_atomic-deprecated
+++ a/scripts/checkpatch.pl
@@ -823,7 +823,9 @@ our %deprecated_apis = (
 	"get_state_synchronize_sched"		=> "get_state_synchronize_rcu",
 	"cond_synchronize_sched"		=> "cond_synchronize_rcu",
 	"kmap"					=> "kmap_local_page",
+	"kunmap"				=> "kunmap_local",
 	"kmap_atomic"				=> "kmap_local_page",
+	"kunmap_atomic"				=> "kunmap_local",
 );
 
 #Create a search pattern for all these strings to speed up a loop below
_

Patches currently in -mm which might be from ira.weiny@intel.com are

checkpatch-mark-kunmap-and-kunmap_atomic-deprecated.patch

