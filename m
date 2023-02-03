Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68472C636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:51:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbjBCGvO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:51:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbjBCGvC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C204522A
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:50:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 112CAB82987
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7164C433D2;
        Fri,  3 Feb 2023 06:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407055;
        bh=oXdtIjiLt9nVQq48jDCohAQzsPBpluB4KN9UZ0ZHw+M=;
        h=Date:To:From:Subject:From;
        b=hmXMY6NYaZZsp5KV0pukmu1iMIy82jjYTEZZTv48YnnG0ymSzcJoOyEyqcUuxRdgU
         nnilPr58eoz0tD39bRYlJn2+jXC5uTpnZSrAIhnA6Lp+iD0C/SU10qb93jhVBXhuCx
         dLKrbtcVxx3igx3XeK8WhnH/fW1q0G0mG0FOMgIY=
Date:   Thu, 02 Feb 2023 22:50:55 -0800
To:     mm-commits@vger.kernel.org, joe@perches.com,
        fmdefrancesco@gmail.com, apw@canonical.com, ira.weiny@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-mark-kunmap-and-kunmap_atomic-deprecated.patch removed from -mm tree
Message-Id: <20230203065055.A7164C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: checkpatch: mark kunmap() and kunmap_atomic() deprecated
has been removed from the -mm tree.  Its filename was
     checkpatch-mark-kunmap-and-kunmap_atomic-deprecated.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


